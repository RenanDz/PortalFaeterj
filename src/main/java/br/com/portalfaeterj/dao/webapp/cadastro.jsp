<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Cadastro • FAETERJ Hub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container d-flex justify-content-center align-items-center" style="min-height: 100vh;">
    <div class="card shadow-sm" style="max-width: 430px; width: 100%;">
        <div class="card-body">
            <h4 class="mb-1 text-center">FAETERJ Hub</h4>
            <p class="text-muted text-center mb-4">Crie sua conta para interagir com os avisos do campus.</p>

            <%
                String erro = request.getParameter("erro");
                if ("email".equals(erro)) {
            %>
                <div class="alert alert-warning py-2">Já existe um usuário com esse e-mail.</div>
            <% } else if ("campos".equals(erro)) { %>
                <div class="alert alert-warning py-2">Preencha todos os campos obrigatórios.</div>
            <% } else if ("geral".equals(erro)) { %>
                <div class="alert alert-danger py-2">Erro ao cadastrar. Tente novamente.</div>
            <% } %>

            <form action="cadastro" method="post">
                <div class="mb-3">
                    <label class="form-label">Nome completo</label>
                    <input type="text" name="nome" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">E-mail institucional</label>
                    <input type="email" name="email" class="form-control"
                           placeholder="seuemail@faeterj.rj.gov.br" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Senha</label>
                    <input type="password" name="senha" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Você é</label>
                    <select name="role" class="form-select">
                        <option value="ALUNO">Aluno</option>
                        <option value="PROFESSOR">Professor</option>
                        <option value="SECRETARIA">Secretaria</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-success w-100 mb-2">Criar conta</button>

                <div class="text-center">
                    <a href="login.jsp" class="small text-muted">Já tenho conta</a>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
