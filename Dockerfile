# 1. Usamos una imagen oficial de Tomcat que tenga Java 21 o compatible
FROM tomcat:10-jdk21-openjdk

# 2. Borramos los archivos por defecto que trae Tomcat para que no estorben
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# 3. Copiamos tu carpeta 'web' (donde están tus JSPs, CSS y sonidos) directo al inicio del servidor
COPY web/ /usr/local/tomcat/webapps/ROOT/

# 4. Copiamos tus clases compuestas de Java (servlets) si las metes en la estructura correcta, 
# pero para asegurar tus JSPs y diseño con sonidos, esto levantará la interfaz de inmediato.
EXPOSE 8080

CMD ["catalina.sh", "run"]
