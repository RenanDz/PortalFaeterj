<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    Integer userId   = (Integer) session.getAttribute("userId");
    String  userName = (String) session.getAttribute("userName");
    String  userRole = (String) session.getAttribute("userRole");
    boolean logado   = (userId != null);
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mapa de Ocorrências • FAETERJ Hub</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Leaflet sem integrity/crossorigin para não dar warning no Eclipse -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

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
            /* Seu estilo original era body { background: #eef1f5; } */
            background: var(--bg-principal);
            color: var(--texto-principal);
            transition: background-color 0.3s, color 0.3s;
        }

        .navbar {
            /* Seu estilo original era navbar-light bg-white */
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
        
        /* Estilos específicos do mapa */
        #map {
            height: 480px;
            border-radius: 14px;
            box-shadow: 0 8px 20px rgba(15,23,42,.08);
        }

        /* Ajuste para o popup do Leaflet (opcional, mas recomendado) */
        .dark-mode .leaflet-popup-content-wrapper,
        .dark-mode .leaflet-popup-tip {
            background: var(--bg-secundario);
            color: var(--texto-principal);
        }
        .dark-mode .leaflet-container {
            /* Borda clara no modo escuro para o mapa */
            border: 1px solid var(--borda-card);
        }
    </style>
</head>
<body>

<%-- NAVBAR --%>
<nav class="navbar shadow-sm px-4 mb-4">
    <div class="container-fluid">
        <a href="index.jsp" class="navbar-brand text-decoration-none">
            <i class="bi bi-fire"></i> FAETERJ Hub
        </a>

        <div class="d-flex align-items-center gap-3">

            <!-- PONTO DE INSERÇÃO B: BOTÃO DE ALTERNAR TEMA -->
            <button id="theme-toggle" class="btn btn-outline-dark btn-sm" aria-label="Alternar Tema">
                <i class="bi bi-moon-stars"></i>
            </button>
            
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
                    <span class="badge bg-secondary">
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
        <div class="col-lg-8">
            <div id="map"></div>
        </div>
        <div class="col-lg-4">
            <div class="card mb-3">
                <div class="card-body">
                    <h5><i class="bi bi-geo-alt"></i> Sobre o mapa</h5>
                    <p class="text-muted mb-2">
                        O mapa mostra a FAETERJ-Rio no centro e as ocorrências de tiroteio
                        recentes em um raio de alguns quilômetros, usando dados da API
                        (Fogo Cruzado / Crossfire).
                    </p>
                    <p class="small text-muted mb-0">
                        As posições são aproximadas e servem apenas como referência de risco na região.
                    </p>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <h6 class="mb-2"><i class="bi bi-cloud-sun"></i> Clima rápido</h6>
                    <p id="clima" class="text-muted small mb-0">
                        Carregando previsão de tempo para Quintino...
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Coordenadas FAETERJ-Rio
    const faeterjLat = -22.89365;
    const faeterjLng = -43.32045;

    const map = L.map('map').setView([faeterjLat, faeterjLng], 14);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19
    }).addTo(map);

    // Marcador da FAETERJ
    L.marker([faeterjLat, faeterjLng])
        .addTo(map)
        .bindPopup('FAETERJ-Rio<br>Rua Clarimundo de Melo, 847');

    // Busca ocorrências da sua API
    fetch('api/tiroteios')
        .then(r => r.json())
        .then(data => {
            const incidents = data.incidentesFiltrados || data.incidents || [];

            incidents.forEach(i => {
                if (!i.lat || !i.lng) return;

                L.circleMarker([i.lat, i.lng], {
                    radius: 8,
                    color: '#b91c1c',
                    fillColor: '#ef4444',
                    fillOpacity: 0.8
                }).addTo(map).bindPopup(
                    (i.descricao || 'Ocorrência de tiroteio') +
                    '<br><small>' + (i.dataHora || '') + '</small>'
                );
            });
        })
        .catch(err => {
            console.error(err);
        });

    // Clima simplificado (Open-Meteo)
    fetch('https://api.open-meteo.com/v1/forecast?latitude=-22.89&longitude=-43.32&current_weather=true&timezone=America%2FSao_Paulo')
        .then(r => r.json())
        .then(data => {
            const el = document.getElementById('clima');
            if (!el) return;
            if (!data || !data.current_weather) {
                el.textContent = 'Não foi possível carregar o clima agora.';
                return;
            }
            const t = data.current_weather.temperature;
            const w = data.current_weather.windspeed;
            el.textContent = `Temperatura atual: ${t}°C • Vento: ${w} km/h (dados Open-Meteo)`;
        })
        .catch(() => {
            const el = document.getElementById('clima');
            if (el) el.textContent = 'Não foi possível carregar o clima agora.';
        });
</script>

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