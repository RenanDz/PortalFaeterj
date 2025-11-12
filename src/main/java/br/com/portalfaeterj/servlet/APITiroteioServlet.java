package br.com.portalfaeterj.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URI;
import java.net.http.*;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/api/tiroteios")
public class APITiroteioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Endpoints oficiais v2
    private static final String LOGIN_URL = "https://api-service.fogocruzado.org.br/api/v2/auth/login";
    private static final String OCC_URL   = "https://api-service.fogocruzado.org.br/api/v2/occurrences";

    // Cache simples do token
    private static volatile String cachedToken = null;
    private static volatile Instant tokenIssuedAt = Instant.EPOCH;
    private static final Duration TOKEN_TTL = Duration.ofMinutes(50); // margem conservadora

    // HTTP client
    private final HttpClient http = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET,OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type,Authorization");
        resp.setCharacterEncoding("UTF-8");

        // janela padrão: 12h (pode passar ?hours=3, ?hours=24 etc.)
        String hoursStr = req.getParameter("hours");
        int hours = 12;
        try { if (hoursStr != null && !hoursStr.isBlank()) hours = Math.max(1, Math.min(168, Integer.parseInt(hoursStr.replaceAll("\\D","")))); } catch (Exception ignore) {}

        // monta initialdate/finaldate em fuso do Rio (-03:00)
        ZoneId tz = ZoneId.of("America/Sao_Paulo");
        ZonedDateTime end   = ZonedDateTime.now(tz);
        ZonedDateTime start = end.minusHours(hours);
        DateTimeFormatter ISO = DateTimeFormatter.ISO_OFFSET_DATE_TIME; // ex: 2025-11-12T13:05:00-03:00

        String initial = ISO.format(start);
        String fin     = ISO.format(end);

        // parâmetros úteis (pode ajustar take/paginação; aqui pegamos as primeiras 50)
        String url = OCC_URL + "?initialdate=" + encode(initial) + "&finaldate=" + encode(fin) + "&take=50";

        try {
            String token = ensureToken();

            HttpRequest req1 = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .timeout(Duration.ofSeconds(15))
                    .header("Authorization", "Bearer " + token)
                    .GET()
                    .build();

            HttpResponse<String> r1 = http.send(req1, HttpResponse.BodyHandlers.ofString());

            // se o token expirou, tenta 1x renovar e refazer
            if (r1.statusCode() == 401) {
                invalidateToken();
                token = ensureToken();
                HttpRequest req2 = HttpRequest.newBuilder()
                        .uri(URI.create(url))
                        .timeout(Duration.ofSeconds(15))
                        .header("Authorization", "Bearer " + token)
                        .GET()
                        .build();
                r1 = http.send(req2, HttpResponse.BodyHandlers.ofString());
            }

            resp.setStatus(r1.statusCode());
            resp.setContentType(r1.headers().firstValue("content-type").orElse("application/json; charset=UTF-8"));
            resp.getWriter().write(r1.body());
        } catch (Exception e) {
            resp.setStatus(502);
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write("{\"error\":\"upstream_unreachable\",\"detail\":\"" + safe(e.getMessage()) + "\"}");
        }
    }

    /** Garante um token válido no cache (login se necessário). */
    private String ensureToken() throws Exception {
        if (cachedToken != null && Instant.now().isBefore(tokenIssuedAt.plus(TOKEN_TTL))) {
            return cachedToken;
        }
        String user = System.getenv("FOGO_USER");
        String pass = System.getenv("FOGO_PASS");
        if (user == null || user.isBlank() || pass == null || pass.isBlank()) {
            throw new IllegalStateException("Variáveis de ambiente FOGO_USER/FOGO_PASS não configuradas");
        }

        String body = "{\"email\":\"" + escapeJson(user) + "\",\"password\":\"" + escapeJson(pass) + "\"}";
        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(LOGIN_URL))
                .timeout(Duration.ofSeconds(15))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> resp = http.send(req, HttpResponse.BodyHandlers.ofString());
        if (resp.statusCode() / 100 != 2) {
            throw new RuntimeException("Login falhou: HTTP " + resp.statusCode());
        }

        // Extrai data.accessToken do JSON sem depender de lib externa
        // Ex.: {"data":{"accessToken":"<JWT>","refreshToken":"..."}}
        String token = extractAccessToken(resp.body());
        if (token == null || token.isBlank()) {
            throw new RuntimeException("Não foi possível extrair accessToken do login");
        }

        cachedToken = token;
        tokenIssuedAt = Instant.now();
        return cachedToken;
    }

    private void invalidateToken() { cachedToken = null; tokenIssuedAt = Instant.EPOCH; }

    private static String extractAccessToken(String json) {
        // Regex simples e resiliente a espaços
        Pattern p = Pattern.compile("\"accessToken\"\\s*:\\s*\"([^\"]+)\"");
        Matcher m = p.matcher(json);
        return m.find() ? m.group(1) : null;
    }

    private static String encode(String s) {
        try { return java.net.URLEncoder.encode(s, java.nio.charset.StandardCharsets.UTF_8); }
        catch (Exception e) { return s; }
    }

    private static String safe(String s) {
        if (s == null) return "";
        return s.replace("\"","'").replace("\\","/");
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"");
    }
}
