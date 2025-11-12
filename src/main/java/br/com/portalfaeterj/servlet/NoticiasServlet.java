package br.com.portalfaeterj.servlet;

import br.com.portalfaeterj.dao.NoticiasDAO;
import br.com.portalfaeterj.model.Noticia;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/noticia")
public class NoticiasServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);

        // 1) Verifica se está logado
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp?redirect=painel.jsp");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        // 2) ALUNO não pode publicar
        if (role == null || role.equalsIgnoreCase("ALUNO")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Você não tem permissão para publicar avisos.");
            return;
        }

        // 3) Lê parâmetros
        String titulo   = req.getParameter("titulo");
        String conteudo = req.getParameter("conteudo");
        String autor    = (String) session.getAttribute("userName");

        if (titulo == null || conteudo == null ||
                titulo.isBlank() || conteudo.isBlank()) {
            resp.sendRedirect("painel.jsp?erro=campos");
            return;
        }

        try {
            Noticia n = new Noticia();
            n.setTitulo(titulo.trim());
            n.setConteudo(conteudo.trim());
            n.setAutor(autor != null ? autor : "Secretaria");

            new NoticiasDAO().inserir(n);

            resp.sendRedirect("index.jsp?ok=1");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("painel.jsp?erro=geral");
        }
    }
}
