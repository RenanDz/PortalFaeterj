package br.com.portalfaeterj.servlet;

import br.com.portalfaeterj.dao.ComentarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/comentario")
public class ComentariosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        String sid = req.getParameter("noticiaId");
        String texto = req.getParameter("texto");

        if (sid == null || texto == null || texto.trim().isEmpty()) {
            resp.sendRedirect("index.jsp");
            return;
        }

        int noticiaId = Integer.parseInt(sid);

        if (userId == null) {
            // se não está logado, manda para login e volta pra notícia depois
            String redirect = "detalheNoticia.jsp?id=" + noticiaId + "#comentarios";
            resp.sendRedirect("login.jsp?redirect=" + redirect);
            return;
        }

        try {
            new ComentarioDAO().inserir(noticiaId, userId, texto.trim());
            resp.sendRedirect("detalheNoticia.jsp?id=" + noticiaId + "#comentarios");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("detalheNoticia.jsp?id=" + noticiaId + "&cerr=1#comentarios");
        }
    }
}
