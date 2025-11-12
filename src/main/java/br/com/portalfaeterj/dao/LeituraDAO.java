package br.com.portalfaeterj.dao;

import br.com.portalfaeterj.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class LeituraDAO {

    public void marcarLeitura(int noticiaId, int usuarioId) throws Exception {
        String sql = """
                INSERT INTO leituras (noticia_id, usuario_id, data_leitura)
                VALUES (?, ?, NOW())
                ON DUPLICATE KEY UPDATE data_leitura = VALUES(data_leitura)
                """;

        try (Connection con = Conexao.get();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, noticiaId);
            ps.setInt(2, usuarioId);

            ps.executeUpdate();
        }
    }
}
