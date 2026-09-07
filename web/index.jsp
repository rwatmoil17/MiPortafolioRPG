<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>👾 Portafolio de Misiones - Dev 👾</title>
    <style>
        /* Estilos globales */
        body { background-color: #0b0b16; color: #00ffcc; font-family: 'Courier New', Courier, monospace; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; overflow: hidden; }
        .pantalla-arcade { border: 4px solid #3d0066; box-shadow: 0 0 20px #ff007f, inset 0 0 15px #3d0066; background-color: #000; padding: 40px; width: 80%; max-width: 700px; text-align: center; border-radius: 10px; position: relative; }
        h1 { font-size: 2.2rem; text-transform: uppercase; letter-spacing: 4px; text-shadow: 2px 2px #ff007f; margin-bottom: 5px; }
        .subtitulo { color: #ffb703; font-size: 1rem; margin-bottom: 40px; text-transform: uppercase; }
        .menu-juego { list-style: none; padding: 0; margin: 0 auto; max-width: 450px; }
        .menu-juego li { margin: 15px 0; }
        .menu-juego a { display: block; background: #121212; color: #fff; padding: 15px; text-decoration: none; font-size: 1.1rem; font-weight: bold; border: 2px solid #00ffcc; border-radius: 5px; transition: all 0.3s ease; position: relative; }
        .menu-juego a:hover { background: #00ffcc; color: #000; box-shadow: 0 0 15px #00ffcc; transform: scale(1.03); cursor: pointer; }
        .menu-juego a:hover::before { content: "▶ "; color: #ff007f; position: absolute; left: 15px; }
        .player-hud { margin-top: 40px; border-top: 1px dashed #333; padding-top: 20px; display: flex; justify-content: space-around; font-size: 0.9rem; color: #888; }
        .player-hud span { color: #ffb703; }

        /* 🎵 Botón de Audio Flotante */
        .control-audio {
            position: absolute;
            top: 20px;
            right: 20px;
            background: #121212;
            border: 2px solid #ff007f;
            color: #ff007f;
            padding: 8px 12px;
            cursor: pointer;
            font-family: monospace;
            font-weight: bold;
            border-radius: 5px;
            box-shadow: 0 0 8px #ff007f;
            transition: all 0.3s ease;
        }
        .control-audio:hover {
            background: #ff007f;
            color: #000;
            box-shadow: 0 0 15px #ff007f;
        }
    </style>
</head>
<body>

    <div class="pantalla-arcade">
        <!-- 🔊 BOTÓN MUTE/UNMUTE -->
        <button id="btn-musica" class="control-audio">🎵 MÚSICA: OFF</button>

        <h1>⚔️ DEV QUEST I ⚔️</h1>
        <div class="subtitulo">Selecciona una Unidad / Mundo</div>

        <ul class="menu-juego">
            <li><a href="MisionesServlet?unidad=1" class="btn-rpg">👾 MUNDO 1: UNIDAD I (Fundamentos)</a></li>
            <li><a href="MisionesServlet?unidad=2" class="btn-rpg">🛡️ MUNDO 2: UNIDAD II (Estructuras)</a></li>
            <li><a href="MisionesServlet?unidad=3" class="btn-rpg">🔮 MUNDO 3: UNIDAD III (Objetos)</a></li>
            <li><a href="MisionesServlet?unidad=4" class="btn-rpg">👑 FINAL BOSS: PROYECTO WEB</a></li>
        </ul>

        <div class="player-hud">
            <div>JUGADOR: <span>ESTUDIANTE_DEV</span></div>
            <div>CLASE: <span>PROGRAMADOR</span></div>
            <div>NIVEL XP: <span>99%</span></div>
        </div>
    </div>

    <!-- 🔊 REPRODUCTORES DE AUDIO -->
    <audio id="snd-select" src="sonidos/select.mp3" preload="auto"></audio>
    <audio id="snd-click" src="sonidos/click.mp3" preload="auto"></audio>
    <!-- Atributo 'loop' para que la canción vuelva a empezar al terminar -->
    <audio id="bg-music" src="sonidos/musica_fondo.mp3" preload="auto" loop></audio>

    <!-- 🕹️ SISTEMA DE LOGICA DE AUDIO -->
    <script>
        const sonidoSeleccion = document.getElementById('snd-select');
        const sonidoClick = document.getElementById('snd-click');
        const musicaFondo = document.getElementById('bg-music');
        const btnMusica = document.getElementById('btn-musica');
        const botones = document.querySelectorAll('.btn-rpg');

        // Bajar el volumen de la música para que no opaque los efectos de sonido
        musicaFondo.volume = 0.3; 

        // Controlar encendido y apagado manual de la música
        btnMusica.addEventListener('click', () => {
            if (musicaFondo.paused) {
                musicaFondo.play();
                btnMusica.textContent = "🎵 MÚSICA: ON";
                btnMusica.style.borderColor = "#00ffcc";
                btnMusica.style.color = "#00ffcc";
                btnMusica.style.boxShadow = "0 0 15px #00ffcc";
            } else {
                musicaFondo.pause();
                btnMusica.textContent = "🎵 MÚSICA: OFF";
                btnMusica.style.borderColor = "#ff007f";
                btnMusica.style.color = "#ff007f";
                btnMusica.style.boxShadow = "0 0 15px #ff007f";
            }
        });

        // Intentar reproducir música automáticamente al primer clic del usuario en la pantalla
        document.body.addEventListener('click', () => {
            if (musicaFondo.paused && btnMusica.textContent === "🎵 MÚSICA: OFF") {
                // Descomenta la línea de abajo si quieres que inicie sola al primer clic en cualquier zona
                // musicaFondo.play(); btnMusica.textContent = "🎵 MÚSICA: ON";
            }
        }, { once: true }); // Se ejecuta solo una vez

        // Efectos de sonido del Menú
        botones.forEach(boton => {
            boton.addEventListener('mouseenter', () => {
                sonidoSeleccion.currentTime = 0;
                sonidoSeleccion.play().catch(e => {});
            });

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