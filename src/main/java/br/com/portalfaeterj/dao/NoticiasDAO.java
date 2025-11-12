package br.com.portalfaeterj.dao;

import br.com.portalfaeterj.Conexao;
import br.com.portalfaeterj.model.Noticia;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class NoticiasDAO {

    // INSERT recebendo o objeto Noticia
    public void inserir(Noticia n) throws Exception {
        String sql = "INSERT INTO noticias (titulo, conteudo, autor) VALUES (?, ?, ?)";

        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, n.getTitulo());
            ps.setString(2, n.getConteudo());
            ps.setString(3, n.getAutor());

            ps.executeUpdate();
        }
    }

    // Lista todas as notícias (mais recentes primeiro)
    public List<Noticia> listar() throws Exception {
        String sql = "SELECT id, titulo, conteudo, autor, data_publicacao " +
                     "FROM noticias " +
                     "ORDER BY data_publicacao DESC";

        List<Noticia> lista = new ArrayList<>();

        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        }

        return lista;
    }

    // Lista com limite (para index.jsp)
    public List<Noticia> listarRecentes(int limite) throws Exception {
        String sql = "SELECT id, titulo, conteudo, autor, data_publicacao " +
                     "FROM noticias " +
                     "ORDER BY data_publicacao DESC " +
                     "LIMIT ?";

        List<Noticia> lista = new ArrayList<>();

        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limite);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapRow(rs));
                }
            }
        }

        return lista;
    }

    // Busca 1 notícia por ID
    public Noticia buscarPorId(int id) throws Exception {
        String sql = "SELECT id, titulo, conteudo, autor, data_publicacao " +
                     "FROM noticias WHERE id = ?";

        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    // Busca por termo (título ou conteúdo)
    public List<Noticia> buscarPorTermo(String termo) throws Exception {
        String sql = "SELECT id, titulo, conteudo, autor, data_publicacao " +
                     "FROM noticias " +
                     "WHERE titulo LIKE ? OR conteudo LIKE ? " +
                     "ORDER BY data_publicacao DESC";

        List<Noticia> lista = new ArrayList<>();

        String pattern = "%" + termo + "%";

        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, pattern);
            ps.setString(2, pattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapRow(rs));
                }
            }
        }

        return lista;
    }

    // Total de comentários de uma notícia
    public int countComentariosByNoticia(int noticiaId) throws Exception {
        String sql = "SELECT COUNT(*) FROM comentarios WHERE noticia_id = ?";

        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, noticiaId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // Total de leituras de uma notícia (se você criou a tabela leituras)
    public int countLeiturasByNoticia(int noticiaId) throws Exception {
        String sql = "SELECT COUNT(*) FROM leituras WHERE noticia_id = ?";

        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, noticiaId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // Mapeia uma linha do ResultSet para objeto Noticia
    private Noticia mapRow(ResultSet rs) throws SQLException {
        Noticia n = new Noticia();
        n.setId(rs.getInt("id"));
        n.setTitulo(rs.getString("titulo"));
        n.setConteudo(rs.getString("conteudo"));
        n.setAutor(rs.getString("autor"));

        Timestamp ts = rs.getTimestamp("data_publicacao");
        if (ts != null) {
            LocalDateTime ldt = ts.toLocalDateTime();
            n.setDataPublicacao(ldt);
        }

        return n;
    }
}
