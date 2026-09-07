# === ETAPA 1: COMPILACIÓN DEL PROYECTO JAVA ===
FROM alpine/git AS clone
WORKDIR /app

# Usamos una imagen oficial de Java con Ant para compilar proyectos tradicionales de NetBeans
FROM frekele/ant:1.10.3-jdk8 AS build
WORKDIR /app

# Copiamos todo el código fuente que ya tienes subido en GitHub
COPY . .

# Compilamos los archivos Java (.java a .class) usando el motor Ant de NetBeans
RUN ant compile

# === ETAPA 2: SERVIDOR TOMCAT EN PRODUCCIÓN ===
FROM tomcat:10-jdk21-openjdk
WORKDIR /usr/local/tomcat

# Limpiamos los archivos por defecto de Tomcat
RUN rm -rf webapps/ROOT

# Copiamos la carpeta web (JSPs, CSS, sonidos)
COPY web/ webapps/ROOT/

# Copiamos las clases compiladas automáticamente en la etapa anterior a la ruta exacta que Tomcat necesita
COPY --from=build /app/build/web/WEB-INF/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
CMD ["catalina.sh", "run"]
