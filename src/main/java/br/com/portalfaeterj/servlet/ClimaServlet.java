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

@WebServlet("/api/clima")
public class ClimaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json; charset=UTF-8");

        // Agora pedimos clima atual + previsão horária (temperatura + vento)
        String urlApi =
            "https://api.open-meteo.com/v1/forecast"
            + "?latitude=-22.88797&longitude=-43.29632"
            + "&current_weather=true"
            + "&hourly=temperature_2m,windspeed_10m"
            + "&timezone=America/Sao_Paulo";

        try {
            URL url = new URL(urlApi);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(
                new InputStreamReader(con.getInputStream(), "UTF-8")
            );

            StringBuilder sb = new StringBuilder();
            String linha;

            while ((linha = br.readLine()) != null) {
                sb.append(linha);
            }

            br.close();
            con.disconnect();

            resp.getWriter().write(sb.toString());

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"erro\": \"falha\"}");
        }
    }
}
