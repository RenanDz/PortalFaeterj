<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.*,java.time.format.DateTimeFormatter,br.com.portalfaeterj.dao.NoticiasDAO,br.com.portalfaeterj.model.Noticia" %>
<%
  request.setCharacterEncoding("UTF-8");
  String sid = request.getParameter("id");
  Noticia n = null;
  if (sid != null && sid.matches("\\d+")) {
    try { n = new NoticiasDAO().buscarPorId(Integer.parseInt(sid)); } catch (Exception ignore) {}
  }
  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").withZone(ZoneId.systemDefault());
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<title><%= (n!=null? n.getTitulo() : "Notícia") %> — FAETERJ Hub</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="assets/css/custom.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg bg-white">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">FAETERJ Hub</a>
    <div class="ms-auto d-flex gap-2">
      <a class="btn btn-outline-secondary" href="mapa.jsp">Mapa</a>
      <a class="btn btn-outline-primary" href="eventos.jsp">Eventos</a>
      <a class="btn btn-outline-secondary" href="index.jsp">Notícias</a>
      <a class="btn btn-primary" href="painel.jsp">+ Publicar</a>
    </div>
  </div>
</nav>

<div class="container my-4">
  <% if (n==null) { %>
    <div class="card p-4">Notícia não encontrada.</div>
  <% } else { %>
    <div class="card">
      <div class="card-body">
        <h2 class="card-title"><%= n.getTitulo() %></h2>
        <div class="meta mb-3">Autor: <%= n.getAutor() %>
          <% if (n.getDataPublicacao()!=null) { %> • <%= fmt.format(n.getDataPublicacao()) %><% } %>
        </div>
        <p class="lead"><%= n.getConteudo().replace("\n","<br/>") %></p>
      </div>
    </div>
  <% } %>
</div>

<footer class="footer text-center my-4">FAETERJ Hub</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>