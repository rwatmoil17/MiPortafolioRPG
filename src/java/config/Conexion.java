package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    // Datos de conexión a tu base de datos de XAMPP
    private static final String URL = "mysql://root:fTbofCzCfSoHdHqVfZhHtcnUyycPXHtd@mysql.railway.internal:3306/railway";
    private static final String USER = "root";
    private static final String PASSWORD = "fTbofCzCfSoHdHqVfZhHtcnUyycPXHtd"; // Por defecto en XAMPP viene vacío

    public static Connection getConexion() {
        Connection con = null;
        try {
            // Cargar el driver de MySQL que acabas de instalar
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("¡CONEXIÓN EXITOSA AL MUNDO DE MYSQL!");
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("ERROR DE CONEXIÓN: " + e.getMessage());
        }
        return con;
    }
}