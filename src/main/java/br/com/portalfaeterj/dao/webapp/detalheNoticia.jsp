<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.*" %>
<%@ page import="br.com.portalfaeterj.Conexao" %>
<%@ page import="br.com.portalfaeterj.dao.ComentarioDAO, br.com.portalfaeterj.model.Comentario" %>

<%
    request.setCharacterEncoding("UTF-8");

    String sid = request.getParameter("id");
    if (sid == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    int noticiaId = Integer.parseInt(sid);

    String titulo = "";
    String conteudo = "";
    String autor = "";
    String dataFmt = "";

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    try (Connection con = Conexao.get();
         PreparedStatement ps = con.prepareStatement("SELECT * FROM noticias WHERE id = ?")) {

        ps.setInt(1, noticiaId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                titulo = rs.getString("titulo");
                conteudo = rs.getString("conteudo");
                autor = rs.getString("autor");
                Timestamp ts = rs.getTimestamp("data_publicacao");
                if (ts != null) dataFmt = sdf.format(new java.util.Date(ts.getTime()));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // comentários
    List<Comentario> comentarios = Collections.emptyList();
    try {
        comentarios = new ComentarioDAO().listarPorNoticia(noticiaId);
    } catch (Exception e) {
        comentarios = Collections.emptyList();
    }

    Integer sessionUserId = (Integer) session.getAttribute("userId");
    String sessionUserName = (String) session.getAttribute("userName");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title><%= titulo %> • FAETERJ Hub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-light bg-white shadow-sm px-4 mb-4">
    <div class="container-fluid">
        <a href="index.jsp" class="navbar-brand text-decoration-none">
            <i class="bi bi-arrow-left"></i> Voltar
        </a>
        <span class="navbar-text">
            <i class="bi bi-fire"></i> FAETERJ Hub
        </span>
    </div>
</nav>

<div class="container mb-5">

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <h3 class="mb-1"><%= titulo %></h3>
            <div class="d-flex justify-content-between text-muted mb-3">
                <small><i class="bi bi-person"></i> <%= autor %></small>
                <small><i class="bi bi-calendar3"></i> <%= dataFmt %></small>
            </div>
            <p class="mb-0"><%= conteudo %></p>
        </div>
    </div>

    <!-- Comentários -->
    <div class="card shadow-sm" id="comentarios">
        <div class="card-body">
            <h5 class="mb-3"><i class="bi bi-chat-dots"></i> Comentários</h5>
			<%
    		String cerr = request.getParameter("cerr");
    		if ("1".equals(cerr)) {
			%>
    	<div class="alert alert-danger py-2">
        Ocorreu um erro ao gravar seu comentário.
    	</div>
			<% } %>
            <% if (sessionUserId != null) { %>
                <form action="comentario" method="post" class="mb-3">
                    <input type="hidden" name="noticiaId" value="<%= noticiaId %>">
                    <div class="mb-2">
                        <textarea name="texto" class="form-control" rows="3"
                                  maxlength="1000" placeholder="Escreva um comentário..." required></textarea>
                    </div>
                    <button class="btn btn-primary btn-sm">
                        <i class="bi bi-send"></i> Comentar
                    </button>
                    <small class="text-muted ms-2">
                        Logado como <b><%= sessionUserName != null ? sessionUserName : "usuário" %></b>
                    </small>
                </form>
            <% } else { %>
                <div class="alert alert-info">
                    <a href="login.jsp?redirect=detalheNoticia.jsp?id=<%= noticiaId %>#comentarios" class="alert-link">
                        Entre para comentar
                    </a>.
                </div>
            <% } %>

            <% if (comentarios.isEmpty()) { %>
                <p class="text-muted mb-0">Nenhum comentário ainda.</p>
            <% } else { %>
                <div class="list-group">
                    <% for (Comentario c : comentarios) { %>
                        <div class="list-group-item">
                            <div class="d-flex justify-content-between">
                                <strong><i class="bi bi-person-circle"></i> <%= c.getUsuarioNome() %></strong>
                                <small class="text-muted">
                                    <%= c.getCriadoEm() != null ? sdf.format(c.getCriadoEm()) : "" %>
                                </small>
                            </div>
                            <div class="mt-1">
                                <%= c.getTexto()
                                    .replaceAll("<", "&lt;")
                                    .replaceAll(">", "&gt;") %>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>
