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

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Leaflet -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

    <style>
        :root {
            --bg-principal: #f4f6fb;
            --bg-secundario: #ffffff;
            --bg-alerta-padrao: #f8f9fa;
            --texto-principal: #1f1f1f;
            --texto-secundario: #6c757d;
            --borda-card: #e9ecef;
        }

        body.dark-mode {
            --bg-principal: #121212;
            --bg-secundario: #1e1e1e;
            --bg-alerta-padrao: #343a40;
            --texto-principal: #e0e0e0;
            --texto-secundario: #b0b0b0;
            --borda-card: #2c2c2c;
        }

        body {
            background: var(--bg-principal);
            color: var(--texto-principal);
        }

        .navbar {
            background-color: var(--bg-secundario) !important;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.1);
        }

        .card {
            border-radius: 14px;
            border: 1px solid var(--borda-card);
            background-color: var(--bg-secundario);
        }

        #map {
            height: 480px;
            border-radius: 14px;
            box-shadow: 0 8px 20px rgba(15,23,42,.08);
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar shadow-sm px-4 mb-4">
    <div class="container-fluid">
        <a href="index.jsp" class="navbar-brand text-decoration-none">
            <i class="bi bi-fire"></i> FAETERJ Hub
        </a>

        <div class="d-flex align-items-center gap-3">

            <!-- Botão tema -->
            <button id="theme-toggle" class="btn btn-outline-dark btn-sm" aria-label="Alternar Tema">
                <i class="bi bi-moon-stars"></i>
            </button>

            <a href="mapa.jsp" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-geo-alt"></i> Mapa
            </a>

            <a href="eventos.jsp" class="btn btn-outline-primary btn-sm">
                <i class="bi bi-calendar2-week"></i> Eventos
            </a>

            <% if (logado && userRole != null && !userRole.equalsIgnoreCase("ALUNO")) { %>
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
                    <span class="badge bg-secondary"><%= userRole %></span>
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

        <!-- MAPA -->
        <div class="col-lg-8">
            <div id="map"></div>
        </div>

        <!-- LATERAL -->
        <div class="col-lg-4">
            <div class="card mb-3">
                <div class="card-body">
                    <h5><i class="bi bi-geo-alt"></i> Sobre o mapa</h5>
                    <p class="text-muted mb-2">
                        O mapa mostra a FAETERJ-Rio no centro e as ocorrências de tiroteio
                        recentes em um raio de alguns quilômetros.
                    </p>
                    <p class="small text-muted mb-0">
                        As posições são aproximadas e servem apenas como referência de risco na região.
                    </p>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <h6 class="mb-2"><i class="bi bi-cloud-sun"></i> Clima rápido</h6>
                    <p class="text-muted small mb-0">
                        Temperatura: <span id="temp">--</span>°C •
                        Vento: <span id="wind">--</span> km/h
                    </p>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    // Coordenadas FAETERJ Quintino
    const LAT = -22.88797;
    const LNG = -43.29632;

    // MAPA
    const map = L.map('map').setView([LAT, LNG], 16);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19
    }).addTo(map);

    L.marker([LAT, LNG])
        .addTo(map)
        .bindPopup('<b>FAETERJ-Rio</b><br>Campus Quintino<br>Rua Clarimundo de Melo, 847');

    // INCIDENTES (se quiser manter)
    fetch('api/incidentes')
        .then(r => r.json())
        .then(lista => {
            (lista || []).forEach(i => {
                if (!i.lat || !i.lng) return;

                L.circleMarker([i.lat, i.lng], {
                    radius: 8,
                    color: '#b91c1c',
                    fillColor: '#ef4444',
                    fillOpacity: 0.8
                })
                .addTo(map)
                .bindPopup(
                    `<b>${i.type || 'Ocorrência'}</b><br>${i.date || ''}`
                );
            });
        })
        .catch(err => console.error('Erro incidentes:', err));

    // CLIMA – APENAS ATUAL
    fetch('api/clima')
        .then(r => r.json())
        .then(data => {
            console.log('CLIMA:', data);
            const spanTemp = document.getElementById('temp');
            const spanWind = document.getElementById('wind');

            if (!data || !data.current_weather) {
                spanTemp.textContent = '--';
                spanWind.textContent = '--';
                return;
            }

            spanTemp.textContent = data.current_weather.temperature;
            spanWind.textContent = data.current_weather.windspeed;
        })
        .catch(err => {
            console.error('Erro clima:', err);
            document.getElementById('temp').textContent = '--';
            document.getElementById('wind').textContent = '--';
        });

    // DARK MODE
    document.addEventListener('DOMContentLoaded', () => {
        const toggle = document.getElementById('theme-toggle');
        const body = document.body;
        const THEME_KEY = 'theme';

        const apply = theme => {
            if (theme === 'dark') {
                body.classList.add('dark-mode');
                toggle.innerHTML = '<i class="bi bi-sun"></i>';
                toggle.classList.remove('btn-outline-dark');
                toggle.classList.add('btn-outline-warning');
            } else {
                body.classList.remove('dark-mode');
                toggle.innerHTML = '<i class="bi bi-moon-stars"></i>';
                toggle.classList.remove('btn-outline-warning');
                toggle.classList.add('btn-outline-dark');
            }
            localStorage.setItem(THEME_KEY, theme);
        };

        apply(localStorage.getItem(THEME_KEY) || 'light');

        toggle.addEventListener('click', () => {
            const isDark = body.classList.contains('dark-mode');
            apply(isDark ? 'light' : 'dark');
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
