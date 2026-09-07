package controladores;

import config.Conexion;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MisionesServlet", urlPatterns = {"/MisionesServlet"})
public class MisionesServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Capturar en qué Mundo (Unidad) hizo clic el usuario (por defecto Unidad 1)
        String unidadParam = request.getParameter("unidad");
        int unidad = (unidadParam != null) ? Integer.parseInt(unidadParam) : 1;
        
        // 2. Capturar en qué Fase (Subunidad) hizo clic el usuario (por defecto Subunidad 1)
        String subunidadParam = request.getParameter("subunidad");
        int subunidad = (subunidadParam != null) ? Integer.parseInt(subunidadParam) : 1;
        
        // 3. Definir el título dinámico según el mundo seleccionado
        String nombreMundo = "";
        switch(unidad) {
            case 1: nombreMundo = "MUNDO 1: FUNDAMENTOS DE PROGRAMACIÓN"; break;
            case 2: nombreMundo = "MUNDO 2: ESTRUCTURAS DE CONTROL Y ARRAYS"; break;
            case 3: nombreMundo = "MUNDO 3: PROGRAMACIÓN ORIENTADA A OBJETOS"; break;
            case 4: nombreMundo = "MUNDO 4: EL JEFE FINAL (PROYECTO INTEGRADOR)"; break;
            default: nombreMundo = "ZONA DESCONOCIDA";
        }

        // Estructura para almacenar las misiones que traigamos de XAMPP
        List<Map<String, Object>> listaMisiones = new ArrayList<>();
        
        // 🛰️ CONSULTA SQL A TU BASE DE DATOS DE XAMPP
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = Conexion.getConexion(); // Abre conexión con MySQL
            
            // Filtramos estrictamente por la Unidad GRANDE y la Subunidad seleccionada
            String sql = "SELECT * FROM misiones WHERE unidad = ? AND subunidad = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, unidad);
            ps.setInt(2, subunidad);
            rs = ps.executeQuery();
            
            while(rs.next()) {
                Map<String, Object> mision = new HashMap<>();
                mision.put("titulo", rs.getString("titulo"));
                mision.put("descripcion", rs.getString("descripcion"));
                mision.put("url_github", rs.getString("url_github"));
                mision.put("recompensa_xp", rs.getInt("recompensa_xp"));
                listaMisiones.add(mision);
            }
        } catch (Exception e) {
            System.out.println("Error al consultar misiones en MySQL: " + e.getMessage());
        } finally {
            // Cerrar conexiones abiertas por seguridad y rendimiento
            try { if(rs != null) rs.close(); if(ps != null) ps.close(); if(con != null) con.close(); } catch(Exception e){}
        }
        
        // 4. Enviar todas las variables necesarias a la vista lista_misiones.jsp
        request.setAttribute("numeroUnidad", unidad);
        request.setAttribute("nombreMundo", nombreMundo);
        request.setAttribute("listaMisiones", listaMisiones);
        
        // Redireccionar el flujo hacia la pantalla del mapa de misiones
        request.getRequestDispatcher("lista_misiones.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }
}