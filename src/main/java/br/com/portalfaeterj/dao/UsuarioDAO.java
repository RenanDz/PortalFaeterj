package br.com.portalfaeterj.dao;

import br.com.portalfaeterj.Conexao;
import br.com.portalfaeterj.model.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsuarioDAO {

    // LOGIN
    public Usuario autenticar(String email, String senha) throws Exception {

        if (email == null || senha == null) {
            return null;
        }

        email = email.trim();
        senha = senha.trim();

        String sql = "SELECT id, nome, email, senha, role " +
                     "FROM usuarios " +
                     "WHERE email = ? AND senha = ?";

        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, senha);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setNome(rs.getString("nome"));
                    u.setEmail(rs.getString("email"));
                    u.setSenha(rs.getString("senha"));
                    u.setRole(rs.getString("role"));
                    return u;
                }
            }
        }
        return null;
    }

    // CADASTRO – verifica se e-mail já existe
    public boolean emailExiste(String email) throws Exception {
        String sql = "SELECT 1 FROM usuarios WHERE email = ?";
        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // CADASTRO – insere novo usuário
    public void inserir(Usuario u) throws Exception {
        String sql = "INSERT INTO usuarios (nome, email, senha, role) VALUES (?, ?, ?, ?)";
        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getNome());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getSenha());
            ps.setString(4, u.getRole());
            ps.executeUpdate();
        }
    }
}
