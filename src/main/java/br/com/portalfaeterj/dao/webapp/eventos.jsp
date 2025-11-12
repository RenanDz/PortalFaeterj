<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="br.com.portalfaeterj.dao.EventosDAO" %>
<%@ page import="br.com.portalfaeterj.model.Evento" %>

<%
    request.setCharacterEncoding("UTF-8");

    Integer userId   = (Integer) session.getAttribute("userId");
    String  userName = (String) session.getAttribute("userName");
    String  userRole = (String) session.getAttribute("userRole");
    boolean logado   = (userId != null);

    List<Evento> eventos = Collections.emptyList();
    EventosDAO eventosDAO = new EventosDAO();

    try {
        eventos = eventosDAO.listar();
    } catch (Exception e) {
        eventos = Collections.emptyList();
    }

    DateTimeFormatter fmtOut = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Eventos • FAETERJ Hub</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #eef1f5;
        }
        .card {
            border-radius: 14px;
            border: none;
        }
        .card-hover:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(15,23,42,.08);
            transition: .2s;
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

    <div class="row g-4">

        <!-- LISTA DE EVENTOS -->
        <div class="col-lg-7">
            <h3 class="mb-3">
                <i class="bi bi-calendar2-week"></i> Próximos eventos
            </h3>

            <%
                if (eventos.isEmpty()) {
            %>
                <div class="alert alert-info">
                    Nenhum evento cadastrado ainda.
                </div>
            <%
                } else {
                    for (Evento ev : eventos) {

                        Object rawData = ev.getDataHora();
                        String dataTexto = "";
                        try {
                            if (rawData instanceof LocalDateTime) {
                                dataTexto = ((LocalDateTime) rawData).format(fmtOut);
                            } else if (rawData instanceof java.sql.Timestamp) {
                                LocalDateTime ldt = ((java.sql.Timestamp) rawData).toLocalDateTime();
                                dataTexto = ldt.format(fmtOut);
                            } else if (rawData != null) {
                                dataTexto = rawData.toString();
                            }
                        } catch (Exception ignore) { dataTexto = ""; }
            %>

                <div class="card card-hover mb-3">
                    <div class="card-body">
                        <h5 class="card-title mb-1">
                            <i class="bi bi-dot"></i> <%= ev.getTitulo() %>
                        </h5>
                        <small class="text-muted d-block mb-2">
                            <i class="bi bi-clock"></i> <%= dataTexto %>
                        </small>
                        <p class="text-muted mb-0"><%= ev.getDescricao() %></p>
                    </div>
                </div>

            <%
                    } // fim for
                } // fim else
            %>
        </div>

        <!-- FORMULÁRIO DE NOVO EVENTO (SÓ PROFESSOR/SECRETARIA) -->
        <div class="col-lg-5">
            <h3 class="mb-3">
                <i class="bi bi-plus-circle"></i> Novo evento
            </h3>

            <%
                String erro = request.getParameter("erro");
                String ok   = request.getParameter("ok");

                if ("campos".equals(erro)) {
            %>
                <div class="alert alert-warning">
                    Preencha todos os campos para cadastrar o evento.
                </div>
            <%
                } else if ("geral".equals(erro)) {
            %>
                <div class="alert alert-danger">
                    Erro ao salvar o evento. Tente novamente.
                </div>
            <%
                } else if ("1".equals(ok)) {
            %>
                <div class="alert alert-success">
                    Evento cadastrado com sucesso!
                </div>
            <%
                }

                boolean podeCadastrarEvento = logado &&
                        userRole != null &&
                        !userRole.equalsIgnoreCase("ALUNO");

                if (!podeCadastrarEvento) {
            %>

                <div class="alert alert-info">
                    <i class="bi bi-info-circle"></i>
                    Apenas <b>professores</b> e <b>secretaria</b> podem cadastrar novos eventos.
                    <br>
                    <%
                        if (!logado) {
                    %>
                        Você está navegando como <b>visitante</b>. 
                        <a href="login.jsp?redirect=eventos.jsp" class="alert-link">Entre aqui</a>.
                    <%
                        } else {
                    %>
                        Você está logado como: <b><%= userRole %></b>.
                    <%
                        }
                    %>
                </div>

            <%
                } else {
            %>

                <div class="card shadow-sm">
                    <div class="card-body">
                        <form action="evento" method="post">
                            <div class="mb-3">
                                <label class="form-label">Título do evento</label>
                                <input type="text" name="titulo" class="form-control"
                                       placeholder="Ex.: Palestra sobre Segurança no Campus" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Data e horário</label>
                                <input type="datetime-local" name="dataHora" class="form-control" required>
                                <div class="form-text">
                                    Use o horário aproximado que o evento vai acontecer.
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Descrição</label>
                                <textarea name="descricao" class="form-control" rows="4"
                                          placeholder="Descreva o objetivo do evento, local, público-alvo..." required></textarea>
                            </div>

                            <button type="submit" class="btn btn-success w-100">
                                <i class="bi bi-check-lg"></i> Cadastrar evento
                            </button>
                        </form>
                    </div>
                </div>

            <%
                } // fim podeCadastrarEvento
            %>
        </div>

    </div>

</div>

</body>
</html>
