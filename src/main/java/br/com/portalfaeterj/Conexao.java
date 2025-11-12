package br.com.portalfaeterj;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Singleton simples de conexão (padrão de projeto). */
public final class Conexao {
	private static final String URL =
		    "jdbc:mysql://localhost:3306/portal_faeterj"
		  + "?useUnicode=true&characterEncoding=UTF-8"
		  + "&serverTimezone=America/Sao_Paulo"
		  + "&useSSL=false&allowPublicKeyRetrieval=true";

		private static final String USUARIO = "faeterj";
		private static final String SENHA   = "112615rrr";

    private Conexao() {}

    public static Connection get() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }
}