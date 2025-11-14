package br.com.portalfaeterj.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/incidentes")
public class IncidentesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json; charset=UTF-8");

        // Fonte dos dados de incidentes
        String urlApi =
                "https://raw.githubusercontent.com/rcpolonsky/rio-violence-data/main/incidents_2024.json";

        try {
            URL url = new URL(urlApi);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            int status = con.getResponseCode();

            // Se não for 200, devolve array vazio válido pra não quebrar o front
            if (status != HttpURLConnection.HTTP_OK) {
                resp.getWriter().write("[]");
                return;
            }

            BufferedReader br = new BufferedReader(
                    new InputStreamReader(con.getInputStream())
            );
            StringBuilder sb = new StringBuilder();
            String linha;

            while ((linha = br.readLine()) != null) {
                sb.append(linha);
            }

            br.close();
            con.disconnect();

            // Repassa o JSON cru da API
            resp.getWriter().write(sb.toString());

        } catch (Exception e) {
            e.printStackTrace();
            // Em qualquer erro, devolve um JSON de array vazio (válido)
            resp.getWriter().write("[]");
        }
    }
}
