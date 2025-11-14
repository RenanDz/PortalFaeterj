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
<!-- TENTATIVA DE CORREÇÃO DE EXIBIÇÃO: LINHA ADICIONAL DE COMENTÁRIO -->
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= (n!=null? n.getTitulo() : "Notícia") %> — FAETERJ Hub</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="assets/css/custom.css" rel="stylesheet">

<!-- PONTO DE INSERÇÃO A: ESTILOS DO DARK MODE E CSS ESPECÍFICO -->
<style>
    /* -------------------------------------- */
    /* 1. VARIÁVEIS DE COR: TEMA CLARO (PADRÃO) */
    /* -------------------------------------- */
    :root {
        --bg-principal: #f4f6fb; /* Fundo da página */
        --bg-secundario: #ffffff; /* Fundo dos cards/navbar */
        --bg-alerta-padrao: #e9ecef;
        --texto-principal: #1f1f1f;
        --texto-secundario: #6c757d; /* text-muted */
        --borda-card: #e9ecef;
    }

    /* -------------------------------------- */
    /* 2. VARIÁVEIS DE COR: TEMA ESCURO */
    /* -------------------------------------- */
    body.dark-mode {
        --bg-principal: #121212;
        --bg-secundario: #1e1e1e;
        --bg-alerta-padrao: #343a40;
        --texto-principal: #e0e0e0;
        --texto-secundario: #b0b0b0;
        --borda-card: #2c2c2c;
    }

    /* -------------------------------------- */
    /* 3. APLICAÇÃO E AJUSTES DE ESTILO */
    /* -------------------------------------- */
    body {
        /* Define a cor de fundo e a cor de texto padrão */
        background: var(--bg-principal);
        color: var(--texto-principal);
        transition: background-color 0.3s, color 0.3s;
    }
    
    .navbar {
        background-color: var(--bg-secundario) !important;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
    }
    
    .navbar-brand, .d-flex a.btn {
        /* Garante que links no navbar não fiquem brancos/cinzas */
        color: var(--texto-principal);
    }

    .card {
        border-radius: 14px;
        border: 1px solid var(--borda-card);
        background-color: var(--bg-secundario);
        transition: background-color 0.3s, border-color 0.3s;
    }
    
    /* Regra de alta especificidade para o conteúdo da notícia */
    body.dark-mode .card-body p {
        color: var(--texto-principal) !important;
    }

    /* Exceção: Ajustando o texto secundário (muted) */
    .dark-mode .text-muted, .meta {
        color: var(--texto-secundario) !important;
    }
    
    /* Exceção: Footer */
    .footer {
        color: var(--texto-secundario) !important;
    }
    
    /* Estilo para o conteúdo principal da notícia */
    .card-body .lead {
        white-space: pre-wrap; /* Mantém quebras de linha JSP */
        font-size: 1.1rem;
    }
</style>
</head>
<body>
<nav class="navbar navbar-expand-lg shadow-sm px-4">
  <div class="container-fluid">
    <a class="navbar-brand text-decoration-none" href="index.jsp"><i class="bi bi-fire"></i> FAETERJ Hub</a>
    
    <div class="ms-auto d-flex gap-2 align-items-center">
      
      <!-- PONTO DE INSERÇÃO B: BOTÃO DE ALTERNAR TEMA -->
      <button id="theme-toggle" class="btn btn-outline-dark btn-sm" aria-label="Alternar Tema">
          <i class="bi bi-moon-stars"></i>
      </button>

      <a class="btn btn-outline-secondary btn-sm" href="mapa.jsp">
          <i class="bi bi-geo-alt"></i> Mapa
      </a>
      <a class="btn btn-outline-primary btn-sm" href="eventos.jsp">
          <i class="bi bi-calendar2-week"></i> Eventos
      </a>
      <a class="btn btn-outline-secondary btn-sm" href="index.jsp">
          <i class="bi bi-newspaper"></i> Notícias
      </a>
      <a class="btn btn-primary btn-sm" href="painel.jsp">
          <i class="bi bi-megaphone"></i> Publicar
      </a>
    </div>
  </div>
</nav>

<div class="container my-5">
  <% if (n==null) { %>
    <div class="card p-4">Notícia não encontrada.</div>
  <% } else { %>
    <div class="card">
      <div class="card-body p-4 p-md-5">
        <h2 class="card-title mb-3"><%= n.getTitulo() %></h2>
        <div class="meta mb-4 small text-muted">
            <i class="bi bi-person-circle"></i> <%= n.getAutor() %>
          <% if (n.getDataPublicacao()!=null) { %>
             • <i class="bi bi-calendar3"></i> <%= fmt.format(n.getDataPublicacao()) %>
          <% } %>
        </div>
        <p class="lead"><%= n.getConteudo() %></p>
      </div>
    </div>
  <% } %>
</div>

<footer class="footer text-center my-4 small">FAETERJ Hub</footer>

<!-- PONTO DE INSERÇÃO C: LÓGICA JAVASCRIPT DO DARK MODE -->
<script>
document.addEventListener('DOMContentLoaded', () => {
    const toggleButton = document.getElementById('theme-toggle');
    const body = document.body;
    const THEME_KEY = 'site-theme';
    const darkIcon = '<i class="bi bi-moon-stars"></i>';
    const lightIcon = '<i class="bi bi-sun"></i>';
    
    // Função para aplicar o tema e atualizar o botão
    function applyTheme(theme) {
        if (theme === 'dark') {
            body.classList.add('dark-mode');
            localStorage.setItem(THEME_KEY, 'dark');
            if (toggleButton) {
                toggleButton.innerHTML = lightIcon;
                toggleButton.classList.remove('btn-outline-dark');
                toggleButton.classList.add('btn-outline-warning');
            }
        } else {
            body.classList.remove('dark-mode');
            localStorage.setItem(THEME_KEY, 'light');
            if (toggleButton) {
                toggleButton.innerHTML = darkIcon;
                toggleButton.classList.remove('btn-outline-warning');
                toggleButton.classList.add('btn-outline-dark');
            }
        }
    }

    // 1. Carregar tema salvo ou detectar preferência do sistema
    const savedTheme = localStorage.getItem(THEME_KEY);
    const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    
    if (savedTheme) {
        applyTheme(savedTheme);
    } else if (prefersDark) {
        applyTheme('dark');
    } else {
        applyTheme('light'); // Padrão
    }

    // 2. Evento de clique para alternar
    if (toggleButton) {
        toggleButton.addEventListener('click', () => {
            const isDark = body.classList.contains('dark-mode');
            const newTheme = isDark ? 'light' : 'dark';
            applyTheme(newTheme);
        });
    }
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
