package br.com.portalfaeterj.dao;

import java.sql.*;
import br.com.portalfaeterj.Conexao;

public class AckDAO {

    public boolean hasAck(int noticiaId, int usuarioId) throws Exception {
        String sql = "SELECT 1 FROM noticia_acks WHERE noticia_id=? AND usuario_id=?";
        try (Connection c = Conexao.get(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, noticiaId); ps.setInt(2, usuarioId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    public void mark(int noticiaId, int usuarioId) throws Exception {
        String sql = "INSERT IGNORE INTO noticia_acks (noticia_id, usuario_id) VALUES (?, ?)";
        try (Connection c = Conexao.get(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, noticiaId); ps.setInt(2, usuarioId); ps.executeUpdate();
        }
    }

    public int countByNoticia(int noticiaId) throws Exception {
        String sql = "SELECT COUNT(*) FROM noticia_acks WHERE noticia_id=?";
        try (Connection c = Conexao.get(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, noticiaId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getInt(1) : 0; }
        }
    }
}
