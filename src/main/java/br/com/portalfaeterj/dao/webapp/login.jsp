<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // Estas variáveis são úteis para manter a navegação consistente
    Integer userId  = (Integer) session.getAttribute("userId");
    String  userName = (String) session.getAttribute("userName");
    String  userRole = (String) session.getAttribute("userRole");
    boolean logado   = (userId != null);

    // Variável para mensagens de erro/sucesso (se existirem na sua implementação)
    String mensagem = (String) request.getAttribute("mensagem");
    if (mensagem == null) mensagem = "";
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAETERJ Hub • Login</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- PONTO DE INSERÇÃO A: ESTILOS DO DARK MODE -->
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
            background: var(--bg-principal);
            color: var(--texto-principal);
            transition: background-color 0.3s, color 0.3s;
        }

        .navbar {
            background-color: var(--bg-secundario) !important;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
        }
        
        .navbar-brand, .d-flex a.btn {
            color: var(--texto-principal);
        }
        
        .h3, h3, h5, h6 {
            color: var(--texto-principal);
        }

        .card {
            border-radius: 14px;
            border: 1px solid var(--borda-card);
            background-color: var(--bg-secundario);
            color: var(--texto-principal);
            transition: background-color 0.3s, border-color 0.3s;
        }

        /* Ajustando o Bootstrap para o Dark Mode */
        .dark-mode .text-muted {
            color: var(--texto-secundario) !important;
        }
        
        .dark-mode .alert-secondary, .dark-mode .text-bg-light {
            background-color: var(--bg-alerta-padrao) !important;
            color: var(--texto-principal) !important;
        }

        .dark-mode .form-control {
            background-color: #2c2c2c;
            border-color: #444;
            color: #e0e0e0;
        }
        
        .dark-mode .form-control::placeholder {
            color: #b0b0b0;
        }

        /* Estilos específicos da tela de Login */
        .login-container {
            max-width: 400px;
            margin-top: 50px;
        }
    </style>
</head>
<body>

<%-- NAVBAR PADRÃO --%>
<nav class="navbar shadow-sm px-4 mb-4">
    <div class="container-fluid">
        <a href="index.jsp" class="navbar-brand text-decoration-none">
            <i class="bi bi-fire"></i> FAETERJ Hub
        </a>

        <div class="d-flex align-items-center gap-2">
            
            <!-- PONTO DE INSERÇÃO B: BOTÃO DE ALTERNAR TEMA -->
            <button id="theme-toggle" class="btn btn-outline-dark btn-sm" aria-label="Alternar Tema">
                <i class="bi bi-moon-stars"></i>
            </button>
            
            <a href="index.jsp" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-house"></i> Início
            </a>
            
            <%-- Se precisar de outros links na tela de login, adicione aqui --%>

        </div>
    </div>
</nav>

<div class="container login-container">
    <div class="card p-4 shadow-lg">
        <div class="card-body">
            <h4 class="card-title text-center mb-4">
                <i class="bi bi-box-arrow-in-right"></i> Entrar no FAETERJ Hub
            </h4>

            <% if (!mensagem.isEmpty()) { %>
                <div class="alert alert-danger" role="alert">
                    <%= mensagem %>
                </div>
            <% } %>

            <form action="login" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label text-muted">E-mail Institucional</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-at"></i></span>
                        <input type="email" class="form-control" id="email" name="email" required
                               placeholder="seu.nome@aluno.faeterj.edu.br">
                    </div>
                </div>

                <div class="mb-4">
                    <label for="senha" class="form-label text-muted">Senha</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <input type="password" class="form-control" id="senha" name="senha" required>
                    </div>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-success btn-lg">
                        <i class="bi bi-check-circle"></i> Fazer Login
                    </button>
                </div>
            </form>

            <div class="mt-3 text-center">
    <a href="recuperar_senha.jsp" style="font-size: 0.9rem; text-decoration: underline;">
        Esqueceu a senha?
    </a>
</div>

<div class="mt-1 text-center" style="font-size: 0.9rem;">
    <span>Ainda não tem conta? </span>
    <a href="cadastro.jsp" style="text-decoration: underline; color: #0d6efd;">
        Cadastre-se
    </a>
</div>


        </div>
    </div>
</div>

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
</html>