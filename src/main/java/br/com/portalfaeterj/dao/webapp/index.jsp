<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="br.com.portalfaeterj.dao.NoticiasDAO" %>
<%@ page import="br.com.portalfaeterj.model.Noticia" %>

<%
    request.setCharacterEncoding("UTF-8");

    Integer userId   = (Integer) session.getAttribute("userId");
    String  userName = (String) session.getAttribute("userName");
    String  userRole = (String) session.getAttribute("userRole");
    boolean logado   = (userId != null);

    List<Noticia> noticias = Collections.emptyList();
    NoticiasDAO dao = new NoticiasDAO();

    try {
        noticias = dao.listarRecentes(20);   // últimas 20 notícias
    } catch (Exception e) {
        noticias = Collections.emptyList();
    }

    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>FAETERJ Hub • Avisos e Notícias</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #f4f6fb;
        }
        .card {
            border-radius: 14px;
            border: none;
        }
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
<nav class="navbar navbar-light bg-white shadow-sm px-4 mb-4">
    <div class="container-fluid">
        <a href="index.jsp" class="navbar-brand text-decoration-none">
            <i class="bi bi-fire"></i> FAETERJ Hub
        </a>

        <div class="d-flex align-items-center gap-3">

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

</body>
</html>
