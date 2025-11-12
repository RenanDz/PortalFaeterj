package br.com.portalfaeterj.servlet;

import br.com.portalfaeterj.dao.UsuarioDAO;
import br.com.portalfaeterj.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String nome  = req.getParameter("nome");
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");
        String role  = req.getParameter("role"); // ALUNO / PROFESSOR / SECRETARIA

        // validação básica
        if (nome == null || email == null || senha == null ||
                nome.trim().isEmpty() || email.trim().isEmpty() || senha.trim().isEmpty()) {

            resp.sendRedirect("cadastro.jsp?erro=campos");
            return;
        }

        if (role == null || role.isBlank()) {
            role = "ALUNO";
        }

        try {
            UsuarioDAO dao = new UsuarioDAO();

            // se já tiver e-mail, volta com erro
            if (dao.emailExiste(email)) {
                resp.sendRedirect("cadastro.jsp?erro=email");
                return;
            }

            Usuario u = new Usuario();
            u.setNome(nome.trim());
            u.setEmail(email.trim());
            u.setSenha(senha.trim());   // em projeto real seria hash :)
            u.setRole(role);

            dao.inserir(u);

            // depois de cadastrar, manda pra tela de login com mensagem de sucesso
            resp.sendRedirect("login.jsp?cadok=1");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("cadastro.jsp?erro=geral");
        }
    }
}
