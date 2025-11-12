package br.com.portalfaeterj.dao;

import br.com.portalfaeterj.Conexao;
import br.com.portalfaeterj.model.Comentario;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComentarioDAO {

    public void inserir(int noticiaId, int usuarioId, String texto) throws Exception {
        String sql = "INSERT INTO comentarios (noticia_id, usuario_id, texto) VALUES (?, ?, ?)";
        try (Connection c = Conexao.get();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, noticiaId);
            ps.setInt(2, usuarioId);
            ps.setString(3, texto);
            ps.executeUpdate();
        }
    }

    public List<Comentario> listarPorNoticia(int noticiaId) throws Exception {
        String sql = """
            SELECT c.id, c.noticia_id, c.usuario_id, c.texto, c.criado_em, u.nome
            FROM comentarios c
            JOIN usuarios u ON u.id = c.usuario_id
            WHERE c.noticia_id = ?
            ORDER BY c.criado_em DESC
        """;

        List<Comentario> lista = new ArrayList<>();

        try (Connection c = Conexao.get();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, noticiaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Comentario cm = new Comentario();
                    cm.setId(rs.getInt("id"));
                    cm.setNoticiaId(rs.getInt("noticia_id"));
                    cm.setUsuarioId(rs.getInt("usuario_id"));
                    cm.setUsuarioNome(rs.getString("nome"));
                    cm.setTexto(rs.getString("texto"));
                    Timestamp ts = rs.getTimestamp("criado_em");
                    cm.setCriadoEm(ts != null ? new java.util.Date(ts.getTime()) : null);
                    lista.add(cm);
                }
            }
        }
        return lista;
    }

    public int countByNoticia(int noticiaId) throws Exception {
        String sql = "SELECT COUNT(*) FROM comentarios WHERE noticia_id=?";
        try (Connection c = Conexao.get();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, noticiaId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}
