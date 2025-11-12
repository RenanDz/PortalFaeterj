<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<title>Sobre — FAETERJ Hub</title>
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
      <a class="btn btn-primary" href="painel.jsp">+ Publicar</a>
    </div>
  </div>
</nav>

<div class="container my-5">
  <h3>Sobre o projeto</h3>
  <p>Portal de notícias e eventos do campus, com integração a API externa para alerta de segurança.</p>
  <ul>
    <li>3 Servlets: Notícias, Eventos, API (alerta)</li>
    <li>Padrão: DAO + Singleton</li>
    <li>Banco: MySQL</li>
    <li>Interface responsiva (Bootstrap 5)</li>
  </ul>
</div>

<footer class="text-center my-4">FAETERJ Hub — projeto acadêmico</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>