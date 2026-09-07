<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>⚔️ Mapa de Subunidades ⚔️</title>
    <style>
        body { background-color: #0b0b16; color: #fff; font-family: 'Courier New', monospace; padding: 30px; }
        .panel-rpg { max-width: 800px; margin: 0 auto; border: 3px solid #ff007f; background: #000; padding: 25px; border-radius: 8px; box-shadow: 0 0 15px #ff007f; }
        h2 { color: #ffb703; text-shadow: 1px 1px #000; margin-top: 0; text-align: center;}
        
        /* Contenedor del mapa de subniveles */
        .mapa-subunidades { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin: 30px 0; }
        .subunidad-card { background: #121212; border: 2px solid #00ffcc; padding: 15px; text-align: center; border-radius: 5px; text-decoration: none; color: #fff; font-weight: bold; transition: all 0.3s ease; position: relative; }
        .subunidad-card:hover { background: #00ffcc; color: #000; box-shadow: 0 0 15px #00ffcc; transform: scale(1.02); cursor: pointer; }
        .subunidad-card:hover::before { content: "▶ "; color: #ff007f; position: absolute; left: 10px; }
        
        /* Tarjetas de misiones individuales */
        .mision-card { border-left: 4px solid #ff007f; background: #151525; padding: 15px; margin: 15px 0; border-radius: 4px; }
        .mision-titulo { font-size: 1.2rem; color: #00ffcc; font-weight: bold; margin-bottom: 5px; }
        .xp-tag { color: #ff007f; font-weight: bold; float: right; }
        
        /* Botón Volver */
        .btn-volver { display: inline-block; margin-top: 20px; color: #000; background: #ffb703; padding: 10px 20px; text-decoration: none; font-weight: bold; border-radius: 4px; box-shadow: 0 0 8px #ffb703; transition: all 0.3s ease; }
        .btn-volver:hover { background: #ff007f; color: #fff; box-shadow: 0 0 15px #ff007f; transform: scale(1.03); cursor: pointer; }
    </style>
</head>
<body>

    <div class="panel-rpg">
        <h2>🗺️ MAPA DEL MUNDO: ${requestScope.numeroUnidad}</h2>
        <h3 style="text-align: center; color: #ff007f;">${requestScope.nombreMundo}</h3>
        <hr style="border-color: #333;">
        
        <!-- 🧭 MENÚ DE LAS 4 SUBUNIDADES -->
        <h4 style="color: #ffb703;">Selecciona una Subunidad (Fase):</h4>
        <div class="mapa-subunidades">
            <!-- Agregamos la clase 'btn-rpg' a cada botón interactivo -->
            <a href="MisionesServlet?unidad=${requestScope.numeroUnidad}&subunidad=1" class="subunidad-card btn-rpg">🚩 Fase 1: Subunidad I</a>
            <a href="MisionesServlet?unidad=${requestScope.numeroUnidad}&subunidad=2" class="subunidad-card btn-rpg">🚩 Fase 2: Subunidad II</a>
            <a href="MisionesServlet?unidad=${requestScope.numeroUnidad}&subunidad=3" class="subunidad-card btn-rpg">🚩 Fase 3: Subunidad III</a>
            <a href="MisionesServlet?unidad=${requestScope.numeroUnidad}&subunidad=4" class="subunidad-card btn-rpg">👑 Fase 4: Evaluación</a>
        </div>

        <!-- 📜 DESPLIEGUE DE MISIONES DE LA SUBUNIDAD SELECCIONADA -->
        <%
            String subunidadSeleccionada = request.getParameter("subunidad");
            if (subunidadSeleccionada != null) {
        %>
                <hr style="border-color: #333; margin-top: 30px;">
                <h3 style="color: #00ffcc;">⚔️ Misiones de la Fase <%= subunidadSeleccionada %>:</h3>
        <%
                List<Map<String, Object>> misiones = (List<Map<String, Object>>) request.getAttribute("listaMisiones");
                if (misiones != null && !misiones.isEmpty()) {
                    for (Map<String, Object> mision : misiones) {
        %>
                        <div class="mision-card">
                            <span class="xp-tag">+<%= mision.get("recompensa_xp") %> XP</span>
                            <div class="mision-titulo">🔹 <%= mision.get("titulo") %></div>
                            <p><%= mision.get("descripcion") %></p>
                            <a href="<%= mision.get("url_github") %>" target="_blank" style="color: #ffb703; text-decoration: none; font-weight: bold;">🔗 Código GitHub</a>
                        </div>
        <%
                    }
                } else {
        %>
                    <p style="color: #888; font-style: italic;">❌ No hay misiones registradas para esta subunidad aún.</p>
        <%
                }
            }
        %>

        <br>
        <!-- Agregamos también la clase 'btn-rpg' al botón de regreso -->
        <a href="index.jsp" class="btn-volver btn-rpg">◀ Regresar al Menú Principal</a>
    </div>

    <!-- 🔊 REPRODUCTORES DE AUDIO INVISIBLES -->
    <audio id="snd-select" src="sonidos/select.mp3" preload="auto"></audio>
    <audio id="snd-click" src="sonidos/click.mp3" preload="auto"></audio>

    <!-- 🕹️ LÓGICA DE AUDIO INTERACTIVA -->
    <script>
        const sonidoSeleccion = document.getElementById('snd-select');
        const sonidoClick = document.getElementById('snd-click');
        
        // Captura tanto las tarjetas de las fases como el botón de regresar
        const botonesInteractivos = document.querySelectorAll('.btn-rpg');

        botonesInteractivos.forEach(boton => {
            // 1. Sonido al pasar el cursor (Hover)
            boton.addEventListener('mouseenter', () => {
                sonidoSeleccion.currentTime = 0;
                sonidoSeleccion.play().catch(e => {});
            });

            // 2. Sonido al hacer clic con retardo de 800ms para que suene completo
            boton.addEventListener('click', (e) => {
                e.preventDefault(); 
                sonidoClick.currentTime = 0;
                sonidoClick.play();

                setTimeout(() => {
                    window.location.href = boton.href;
                }, 1500); 
            });
        });
    </script>

</body>
</html>