<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String mensagem = (String) request.getAttribute("mensagem");
    if (mensagem == null) mensagem = "";

    String status = request.getParameter("status"); // opcional: ?status=ok / ?status=erro
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Recuperar senha • FAETERJ Hub</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap 5 -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
        crossorigin="anonymous">

    <!-- Seu CSS customizado -->
    <link rel="stylesheet" href="assets/css/custom.css">

    <style>
        .auth-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg, #f6f8fc);
            padding: 24px 12px;
        }
        .auth-card {
            border-radius: 18px;
            box-shadow: var(--shadow, 0 10px 30px rgba(16,24,40,.08));
            background: var(--card, #ffffff);
        }
        .brand-badge {
            display: inline-flex;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: .75rem;
            background: var(--ring, rgba(13,110,253,.08));
            color: var(--brand, #0d6efd);
            text-transform: uppercase;
            letter-spacing: .08em;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="auth-wrapper">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-5">
                <div class="card auth-card border-0">
                    <div class="card-body p-4 p-md-5">

                        <!-- Cabeçalho -->
                        <div class="mb-4 text-center">
                            <span class="brand-badge mb-2 d-inline-block">
                                FAETERJ Hub
                            </span>
                            <h1 class="h4 fw-bold mb-1">Recuperar senha</h1>
                            <p class="text-muted mb-0">
                                Informe seu e-mail institucional para receber as instruções
                                de redefinição de senha.
                            </p>
                        </div>

                        <!-- Mensagens de feedback -->
                        <% if (!mensagem.isEmpty()) { %>
                            <div class="alert alert-info py-2" role="alert">
                                <%= mensagem %>
                            </div>
                        <% } else if ("ok".equals(status)) { %>
                            <div class="alert alert-success py-2" role="alert">
                                Se existir uma conta com este e-mail, enviaremos as instruções
                                de recuperação em alguns instantes.
                            </div>
                        <% } else if ("erro".equals(status)) { %>
                            <div class="alert alert-danger py-2" role="alert">
                                Não foi possível processar sua solicitação. Tente novamente.
                            </div>
                        <% } %>

                        <!-- Formulário -->
                        <form action="RecuperarSenhaServlet" method="post" class="mt-3">
                            <div class="mb-3">
                                <label for="email" class="form-label">E-mail institucional</label>
                                <input
                                    type="email"
                                    class="form-control input"
                                    id="email"
                                    name="email"
                                    placeholder="nome.sobrenome@faeterj.rj.gov.br"
                                    required>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 mt-2">
                                Enviar instruções
                            </button>
                        </form>

                        <!-- Links de navegação -->
                        <div class="mt-4 text-center">
                            <a href="login.jsp" class="d-block mb-1">
                                &larr; Voltar para o login
                            </a>
                            <small class="text-muted">
                                Lembrou a senha?
                                <a href="login.jsp" class="fw-semibold">Acesse o FAETERJ Hub</a>
                            </small>
                        </div>

                    </div>
                </div>

                <!-- Rodapé pequeno -->
                <p class="text-center text-muted mt-3 mb-0" style="font-size: .8rem;">
                    Portal acadêmico experimental • POO Avançada
                </p>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS (opcional, só se você usar componentes que precisam de JS) -->
<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
    crossorigin="anonymous"></script>

</body>
</html>
