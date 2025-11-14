package br.com.portalfaeterj.dao;

import br.com.portalfaeterj.model.Evento;
import br.com.portalfaeterj.util.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventosDAO {

    public void inserir(Evento e) {
        String sql = "INSERT INTO eventos (titulo, descricao, data_hora) VALUES (?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, e.getTitulo());
            ps.setString(2, e.getDescricao());
            ps.setTimestamp(3, Timestamp.valueOf(e.getDataHora()));

            ps.executeUpdate();

        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Erro ao salvar evento");
        }
    }

    public List<Evento> listar() {
        List<Evento> lista = new ArrayList<>();

        String sql = "SELECT id, titulo, descricao, data_hora FROM eventos ORDER BY data_hora DESC";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Evento e = new Evento();
                e.setId(rs.getInt("id"));
                e.setTitulo(rs.getString("titulo"));
                e.setDescricao(rs.getString("descricao"));
                e.setDataHora(rs.getTimestamp("data_hora").toLocalDateTime());
                lista.add(e);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return lista;
    }
}
