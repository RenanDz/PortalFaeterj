<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    Integer userId   = (Integer) session.getAttribute("userId");
    String  userName = (String) session.getAttribute("userName");
    String  userRole = (String) session.getAttribute("userRole");
    boolean logado   = (userId != null);

    if (!logado) {
        response.sendRedirect("login.jsp?redirect=painel.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Painel de Publicação • FAETERJ Hub</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #eef1f5;
        }
        .card {
            border-radius: 14px;
            border: none;
            box-shadow: 0 8px 20px rgba(15,23,42,.08);
        }
        .badge-role {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .04em;
        }
    </style>
</head>
<body>

<%-- NAVBAR --%>
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

            <div class="text-end small d-none d-md-block">
                <div><i class="bi bi-person-circle"></i> <%= userName %></div>
                <span class="badge bg-secondary badge-role">
                    <%= userRole %>
                </span>
            </div>

            <a href="logout" class="btn btn-outline-danger btn-sm">
                <i class="bi bi-box-arrow-right"></i> Sair
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">

    <%
        // BLOQUEIO: aluno não publica
        if (userRole == null || userRole.equalsIgnoreCase("ALUNO")) {
    %>
        <div class="alert alert-warning">
            <i class="bi bi-exclamation-triangle"></i>
            Este painel é exclusivo para <b>professores</b> e <b>secretaria</b> publicarem avisos.
            <br>
            Você está logado como: <b><%= userRole != null ? userRole : "ALUNO" %></b>.
        </div>
    <%
            return;
        }

        String erro = request.getParameter("erro");
        String ok   = request.getParameter("ok");
    %>

    <% if ("campos".equals(erro)) { %>
        <div class="alert alert-warning">
            Preencha <b>título</b> e <b>conteúdo</b> antes de publicar.
        </div>
    <% } else if ("geral".equals(erro)) { %>
        <div class="alert alert-danger">
            Ocorreu um erro ao salvar o aviso. Tente novamente.
        </div>
    <% } else if ("1".equals(ok)) { %>
        <div class="alert alert-success">
            Aviso publicado com sucesso!
        </div>
    <% } %>

    <div class="card p-4">
        <div class="card-body">
            <h3 class="mb-1">
                <i class="bi bi-megaphone"></i> Publicar aviso para o campus
            </h3>
            <p class="text-muted mb-4">
                Use este painel para avisos importantes da FAETERJ-Rio:
                mudanças de horário, suspensão de aula por tiroteio, eventos, comunicados da secretaria, etc.
            </p>

            <form action="noticia" method="post">
                <div class="mb-3">
                    <label class="form-label">Título do aviso</label>
                    <input type="text" name="titulo" class="form-control"
                           placeholder="Ex.: Aulas suspensas no turno da noite" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Conteúdo detalhado</label>
                    <textarea name="conteudo" rows="5" class="form-control"
                              placeholder="Explique o que está acontecendo, para quais turmas, horários, prazos..."
                              required></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Assinatura</label>
                    <input type="text" class="form-control" value="<%= userName != null ? userName : "" %>"
                           disabled>
                    <div class="form-text">
                        O aviso será publicado em nome de <b><%= userName %></b>
                        (<%= userRole %>).
                    </div>
                </div>

                <input type="hidden" name="autor" value="<%= userName %>">

                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-lg"></i> Publicar aviso
                </button>
                <a href="index.jsp" class="btn btn-link">
                    Voltar para página inicial
                </a>
            </form>
        </div>
    </div>

</div>

</body>
</html>
