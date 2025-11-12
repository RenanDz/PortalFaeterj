package br.com.portalfaeterj.servlet;

import br.com.portalfaeterj.dao.AckDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;

@WebServlet("/ack")
public class AckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) { resp.sendError(401); return; }

        String sid = req.getParameter("noticiaId");
        if (sid == null) { resp.sendError(400); return; }

        try {
            int noticiaId = Integer.parseInt(sid);
            new AckDAO().mark(noticiaId, userId);
            resp.sendRedirect("detalheNoticia.jsp?id=" + noticiaId + "&ack=1");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("detalheNoticia.jsp?id=" + sid + "&ack=0");
        }
    }
}
