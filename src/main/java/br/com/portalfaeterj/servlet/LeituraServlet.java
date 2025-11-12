package br.com.portalfaeterj.servlet;

import br.com.portalfaeterj.dao.LeituraDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LeituraServlet", urlPatterns = {"/leitura"})
public class LeituraServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        // se não estiver logado
        if (userId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String noticiaIdStr = req.getParameter("noticiaId");
        if (noticiaIdStr == null || noticiaIdStr.isBlank()) {
            resp.sendRedirect("index.jsp");
            return;
        }

        try {
            int noticiaId = Integer.parseInt(noticiaIdStr);

            LeituraDAO dao = new LeituraDAO();
            dao.marcarLeitura(noticiaId, userId);

            resp.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("index.jsp?erro=leitura");
        }
    }
}
