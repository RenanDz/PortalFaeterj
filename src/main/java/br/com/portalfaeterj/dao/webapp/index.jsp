<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="br.com.portalfaeterj.dao.NoticiasDAO" %>
<%@ page import="br.com.portalfaeterj.model.Noticia" %>

<%
    request.setCharacterEncoding("UTF-8");

    Integer userId  = (Integer) session.getAttribute("userId");
    String  userName = (String) session.getAttribute("userName");
    String  userRole = (String) session.getAttribute("userRole");
    boolean logado   = (userId != null);

    List<Noticia> noticias = Collections.emptyList();
    NoticiasDAO dao = new NoticiasDAO();

    try {
        noticias = dao.listarRecentes(20);    // últimas 20 notícias
    } catch (Exception e) {
        noticias = Collections.emptyList();
    }

    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAETERJ Hub • Avisos e Notícias</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        /* -------------------------------------- */
        /* 1. VARIÁVEIS DE COR: TEMA CLARO (PADRÃO) */
        /* -------------------------------------- */
        :root {
            --bg-principal: #f4f6fb; /* Fundo da página */
            --bg-secundario: #ffffff; /* Fundo dos cards/navbar */
            --bg-alerta-padrao: #e9ecef; /* Cor do alerta de segurança */
            --texto-principal: #1f1f1f;
            --texto-secundario: #6c757d; /* text-muted */
            --borda-card: #e9ecef; /* Borda sutil */
        }

        /* -------------------------------------- */
        /* 2. VARIÁVEIS DE COR: TEMA ESCURO */
        /* -------------------------------------- */
        body.dark-mode {
            /* Sobrescreve as cores para o tema escuro */
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
            background: var(--bg-principal);
            color: var(--texto-principal);
            transition: background-color 0.3s, color 0.3s;
        }

        .navbar {
            background-color: var(--bg-secundario) !important;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); /* Mantém sombra sutil */
        }
        
        /* Ajuste para o texto dentro da navbar */
        .navbar-brand, .d-flex a.btn {
            color: var(--texto-principal); /* Garante que o texto seja legível */
        }
        
        /* Ajuste para cores de texto específicas */
        .h3, h3 {
            color: var(--texto-principal);
        }

        .card {
            border-radius: 14px;
            border: 1px solid var(--borda-card); /* Borda dinâmica */
            background-color: var(--bg-secundario);
            color: var(--texto-principal);
            transition: background-color 0.3s, border-color 0.3s;
        }

        /* Ajustando o Bootstrap para o Dark Mode */
        .dark-mode .text-muted {
            color: var(--texto-secundario) !important;
        }
        
        .dark-mode .text-bg-light {
            background-color: var(--bg-alerta-padrao) !important;
            color: var(--texto-principal) !important;
        }
        
        .dark-mode .alert-secondary {
            background-color: var(--bg-alerta-padrao) !important;
            color: var(--texto-secundario) !important;
        }
        
        .dark-mode .alert-info {
            background-color: #0c4273 !important; /* Azul escuro */
            color: #d1ecf1 !important;
        }
        
        .dark-mode .form-control {
            background-color: #2c2c2c;
            border-color: #444;
            color: #e0e0e0;
        }
        
        .dark-mode .form-control::placeholder {
            color: #b0b0b0;
        }
        
        /* Estilos de hover originais (mantidos) */
        .card-hover:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(15,23,42,.08);
            transition: .18s;
        }
        .badge-role {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .04em;
        }
    </style>
</head>
<body>

<%-- NAVBAR COM ENTRAR / SAIR --%>
<nav class="navbar shadow-sm px-4 mb-4">
    <div class="container-fluid">
        <a href="index.jsp" class="navbar-brand text-decoration-none">
            <i class="bi bi-fire"></i> FAETERJ Hub
        </a>

        <div class="d-flex align-items-center gap-3">
            
            <%-- NOVO BOTÃO DE ALTERNAR TEMA --%>
            <button id="theme-toggle" class="btn btn-outline-dark btn-sm" aria-label="Alternar Tema">
                <i class="bi bi-moon-stars"></i>
            </button>
            <%-- FIM NOVO BOTÃO --%>

            <a href="mapa.jsp" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-geo-alt"></i> Mapa
            </a>

            <a href="eventos.jsp" class="btn btn-outline-primary btn-sm">
                <i class="bi bi-calendar2-week"></i> Eventos
            </a>

            <%
                boolean podePublicarTopo = logado &&
                        userRole != null &&
                        !userRole.equalsIgnoreCase("ALUNO");
                if (podePublicarTopo) {
            %>
                <a href="painel.jsp" class="btn btn-primary btn-sm">
                    <i class="bi bi-megaphone"></i> Publicar aviso
                </a>
            <% } %>

            <% if (!logado) { %>
                <a href="login.jsp" class="btn btn-outline-success btn-sm">
                    <i class="bi bi-box-arrow-in-right"></i> Entrar
                </a>
            <% } else { %>
                <div class="text-end small d-none d-md-block">
                    <div><i class="bi bi-person-circle"></i> <%= userName %></div>
                    <span class="badge bg-secondary badge-role">
                        <%= userRole %>
                    </span>
                </div>

                <a href="logout" class="btn btn-outline-danger btn-sm">
                    <i class="bi bi-box-arrow-right"></i> Sair
                </a>
            <% } %>

        </div>
    </div>
</nav>

<div class="container mb-5">

    <%-- BANNER DE SITUAÇÃO (TIROTEIO / CLIMA SIMPLIFICADO) --%>
    <div id="alert-tiroteio" class="alert alert-secondary mb-4">
        Carregando situação de segurança nas proximidades da FAETERJ-Rio...
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <h3 class="mb-3">
                <i class="bi bi-newspaper"></i> Últimas notícias
            </h3>

            <%
                if (noticias.isEmpty()) {
            %>
                <div class="alert alert-info">
                    Nenhum aviso publicado ainda.
                </div>
            <%
                } else {
                    for (Noticia n : noticias) {

                        int totalComentarios = 0;
                        int totalLeituras    = 0;

                        try {
                            totalComentarios = dao.countComentariosByNoticia(n.getId());
                            totalLeituras    = dao.countLeiturasByNoticia(n.getId());
                        } catch (Exception ignore) {}

                        String dataTexto = "";
                        try {
                            if (n.getDataPublicacao() != null) {
                                dataTexto = n.getDataPublicacao().format(fmt);
                            }
                        } catch (Exception ignore) {}
            %>

                <div class="card card-hover mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-1">
                            <h5 class="card-title mb-1"><%= n.getTitulo() %></h5>
                            <span class="badge text-bg-light">
                                <i class="bi bi-person"></i> <%= n.getAutor() %>
                            </span>
                        </div>

                        <p class="text-muted mb-2"><%= n.getConteudo() %></p>

                        <small class="text-muted d-block mb-2">
                            <i class="bi bi-calendar3"></i>
                            <%= dataTexto %>
                        </small>

                        <div class="d-flex justify-content-between align-items-center">

                            <div class="d-flex gap-3 align-items-center">
                                <span class="text-muted small">
                                    <i class="bi bi-eye"></i> <%= totalLeituras %> visualizações
                                </span>
                                <span class="text-muted small">
                                    <i class="bi bi-chat-dots"></i> <%= totalComentarios %> comentários
                                </span>
                            </div>

                            <% if (logado) { %>
    						<form action="<%= request.getContextPath() %>/leitura" method="post" class="d-inline">
        					<input type="hidden" name="noticiaId" value="<%= n.getId() %>">
        					<button class="btn btn-outline-success btn-sm">
        	 					<i class="bi bi-check2-circle"></i> Marcar como lido
        					</button>
    						</form>
							<% } %>
                        </div>

                        <% if (logado) { %>
                            <hr>
                            <form action="comentario" method="post" class="mt-2">
                                <input type="hidden" name="noticiaId" value="<%= n.getId() %>">
                                <div class="input-group input-group-sm">
                                    <input type="text" name="texto" class="form-control"
                                        placeholder="Escreva um comentário...">
                                    <button class="btn btn-outline-primary">
                                        <i class="bi bi-send"></i>
                                    </button>
                                </div>
                            </form>
                        <% } %>

                    </div>
                </div>

            <%
                    } // fim for
                } // fim else
            %>

        </div>

        <div class="col-lg-4">
            <div class="card mb-3">
                <div class="card-body">
                    <h5><i class="bi bi-info-circle"></i> Sobre o projeto</h5>
                    <p class="text-muted mb-0">
                        Portal acadêmico para centralizar avisos, notícias e eventos
                        importantes do campus FAETERJ-Rio, com foco em segurança
                        (tiroteios na região), clima e comunicação entre secretaria,
                        professores e alunos.
                    </p>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <h6 class="text-muted mb-1">Dica</h6>
                    <p class="small mb-2">
                        Faça login com seu e-mail institucional para comentar e marcar
                        avisos como lidos.
                    </p>
                    <a href="login.jsp" class="btn btn-outline-primary btn-sm w-100">
                        <i class="bi bi-box-arrow-in-right"></i> Entrar com e-mail FAETERJ
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// --- LÓGICA DO TEMA ESCURO ---
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
            toggleButton.innerHTML = lightIcon;
            toggleButton.classList.remove('btn-outline-dark');
            toggleButton.classList.add('btn-outline-warning');
        } else {
            body.classList.remove('dark-mode');
            localStorage.setItem(THEME_KEY, 'light');
            toggleButton.innerHTML = darkIcon;
            toggleButton.classList.remove('btn-outline-warning');
            toggleButton.classList.add('btn-outline-dark');
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
// ------------------------------


// --- LÓGICA ORIGINAL DO TIROTEIO ---
fetch('api/tiroteios')
  .then(r => r.json())
  .then(data => {
      const box = document.getElementById('alert-tiroteio');
      if (!box) return;

      const total = data.totalFiltradas ?? data.total ?? 0;

      if (total === 0) {
          box.className = 'alert alert-success mb-4';
          box.innerHTML = '✅ Sem relatos de tiroteio nas últimas horas nas proximidades do campus.';
      } else {
          box.className = 'alert alert-danger mb-4';
          box.innerHTML = '⚠ ' + total + ' ocorrência(s) recente(s) de tiroteio na região próxima ao campus. Evite deslocamentos se possível.';
      }
  })
  .catch(() => {
      const box = document.getElementById('alert-tiroteio');
      if (!box) return;
      box.className = 'alert alert-secondary mb-4';
      box.innerHTML = 'Não foi possível carregar a situação de segurança no momento.';
  });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>