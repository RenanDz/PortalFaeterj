<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Login • FAETERJ Hub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container d-flex justify-content-center align-items-center" style="min-height: 100vh;">
    <div class="card shadow-sm" style="max-width: 430px; width: 100%;">
        <div class="card-body">
            <h4 class="mb-1 text-center">FAETERJ Hub</h4>
            <p class="text-muted text-center mb-4">Entre para comentar e marcar avisos como lidos.</p>

            <%
                String erro = request.getParameter("erro");
                String cadok = request.getParameter("cadok");
                if ("1".equals(erro)) {
            %>
                <div class="alert alert-danger py-2">E-mail ou senha inválidos.</div>
            <% } else if ("1".equals(cadok)) { %>
                <div class="alert alert-success py-2">Cadastro realizado com sucesso! Faça login.</div>
            <% } %>

            <form action="login" method="post">
                <%
                    String redirect = request.getParameter("redirect");
                    if (redirect == null || redirect.isBlank()) redirect = "index.jsp";
                %>
                <input type="hidden" name="redirect" value="<%= redirect %>">

                <div class="mb-3">
                    <label class="form-label">E-mail institucional</label>
                    <input type="email" name="email" class="form-control"
                           placeholder="seuemail@faeterj.rj.gov.br" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Senha</label>
                    <input type="password" name="senha" class="form-control" required>
                </div>

                <button type="submit" class="btn btn-primary w-100 mb-2">Entrar</button>

                <div class="text-center mb-2">
                    <a href="cadastro.jsp" class="small">Não tem conta? Criar cadastro</a>
                </div>

                <div class="mt-2 text-muted small">
                    Para teste rápido: aluno@faeterj.rj.gov.br / 123
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
