package br.com.portalfaeterj.servlet;

import br.com.portalfaeterj.dao.UsuarioDAO;
import br.com.portalfaeterj.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String senha = req.getParameter("senha");
        String redirect = req.getParameter("redirect");

        if (redirect == null || redirect.isBlank()) {
            redirect = "index.jsp";
        }

        Usuario u = null;

        try {
            UsuarioDAO dao = new UsuarioDAO();
            u = dao.autenticar(email, senha);
        } catch (Exception e) {
            e.printStackTrace(); // aparece no console do Tomcat
        }

        // Fallback hardcoded para garantir login de demonstração
        if (u == null) {
            if ("aluno@faeterj.rj.gov.br".equalsIgnoreCase(email != null ? email.trim() : "")
                    && "123".equals(senha != null ? senha.trim() : "")) {

                u = new Usuario();
                u.setId(1);
                u.setNome("Aluno Teste");
                u.setEmail("aluno@faeterj.rj.gov.br");
                u.setRole("ALUNO");
            }
        }

        if (u == null) {
            // não autenticou
            resp.sendRedirect("login.jsp?erro=1&redirect=" + redirect);
            return;
        }

        // autenticado – guarda na sessão
        HttpSession session = req.getSession();
        session.setAttribute("userId", u.getId());
        session.setAttribute("userName", u.getNome());
        session.setAttribute("userRole", u.getRole());
        session.setAttribute("userEmail", u.getEmail());

        resp.sendRedirect(redirect);
    }
}
