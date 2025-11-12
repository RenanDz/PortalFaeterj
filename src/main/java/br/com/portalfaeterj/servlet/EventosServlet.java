package br.com.portalfaeterj.servlet;

import br.com.portalfaeterj.dao.EventosDAO;
import br.com.portalfaeterj.model.Evento;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/evento")
public class EventosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp?redirect=eventos.jsp");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        if (role == null || role.equalsIgnoreCase("ALUNO")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Você não tem permissão para cadastrar eventos.");
            return;
        }

        String titulo   = req.getParameter("titulo");
        String descricao = req.getParameter("descricao");
        String dataHoraStr = req.getParameter("dataHora");

        if (titulo == null || descricao == null || dataHoraStr == null ||
                titulo.isBlank() || descricao.isBlank() || dataHoraStr.isBlank()) {
            resp.sendRedirect("eventos.jsp?erro=campos");
            return;
        }

        try {
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime dataHora = LocalDateTime.parse(dataHoraStr, fmt);

            Evento e = new Evento();
            e.setTitulo(titulo.trim());
            e.setDescricao(descricao.trim());
            e.setDataHora(dataHora);

            new EventosDAO().inserir(e);

            resp.sendRedirect("eventos.jsp?ok=1");
        } catch (Exception ex) {
            ex.printStackTrace();
            resp.sendRedirect("eventos.jsp?erro=geral");
        }
    }
}
