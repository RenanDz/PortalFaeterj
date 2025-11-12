package br.com.portalfaeterj.dao;

import br.com.portalfaeterj.Conexao;
import br.com.portalfaeterj.model.Evento;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import java.time.LocalDateTime;

public class EventosDAO {

    // INSERT de novo evento
    public void inserir(Evento e) throws Exception {
        String sql = "INSERT INTO eventos (titulo, descricao, data_hora) VALUES (?, ?, ?)";

        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, e.getTitulo());
            ps.setString(2, e.getDescricao());
            ps.setTimestamp(3, Timestamp.valueOf(e.getDataHora()));

            ps.executeUpdate();
        }
    }

    // Lista todos os eventos ordenados pela data/hora
    public List<Evento> listar() throws Exception {
        String sql = "SELECT id, titulo, descricao, data_hora " +
                     "FROM eventos " +
                     "ORDER BY data_hora ASC";

        List<Evento> lista = new ArrayList<>();

        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Evento e = new Evento();
                e.setId(rs.getInt("id"));
                e.setTitulo(rs.getString("titulo"));
                e.setDescricao(rs.getString("descricao"));

                Timestamp ts = rs.getTimestamp("data_hora");
                if (ts != null) {
                    LocalDateTime ldt = ts.toLocalDateTime();
                    e.setDataHora(ldt);
                }

                lista.add(e);
            }
        }

        return lista;
    }
}
