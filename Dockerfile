# IMAGEN BASE DE JAVA 23
FROM eclipse-temurin:23.0.1_11-jdk

# DEFINIR DIRECTORIO RAÍZ DE TRABAJO DENTRO DEL CONTENEDOR
WORKDIR /root

# COPIAR Y PEGAR ARCHIVOS AL CONTENEDOR
COPY ./pom.xml /root
COPY ./.mvn /root/.mvn
COPY ./mvnw /root
COPY ./.env /root

# DESCARGAR DEPENDENCIAS DENTRO DEL CONTENEDOR (VERSION 1)
#RUN ./mvnw dependency:go-offline
#Descarga todas las bibliotecas y plugins necesarios, el proyecto ya no necesitará conectarse a internet para ser construido.

# DESCARGAR DEPENDENCIAS DENTRO DEL CONTENEDOR (VERSION 2)
RUN ./mvnw -DoutputFile=target/mvn-dependency-list.log
# -D: Se usa para definir propiedades en Maven.
# outputFile: Es el nombre de la propiedad que estamos estableciendo.
# target/mvn-dependency-list.log: Es la ruta donde se guardará la lista de dependencias del proyecto.

# COPIAR CÓDIGO FUENTE DENTRO DEL CONTENEDOR
COPY ./src /root/src

# CONSTRUIR APLICACIÓN (VERSION 1)
#RUN ./mvnw clean install -DskipTests

# CONSTRUIR APLICACIÓN (VERSION 2)
RUN ./mvnw -B -DskipTests clean dependency:list install
# -B: Activa el modo batch, lo que hace que Maven ejecute las tareas de forma más silenciosa y sin interacciones con el usuario.
# -DskipTests: Le indica a Maven que omita la ejecución de las pruebas durante la construcción.
# clean: Limpia el directorio de salida (target) eliminando archivos generados en compilaciones anteriores.
# dependency:list: Genera una lista de todas las dependencias del proyecto y las escribe en el archivo especificado por outputFile.
# install: Construye el proyecto y lo instala en el repositorio local de Maven, lo que permite que otros proyectos puedan usarlo como dependencia.

# CAMBIAR NOMBRE DE LA APLICACION JAR CREADA A APP.JAR
RUN mv -f target/*.jar target/app.jar

# EJECUTAR APLICACIÓN AL INICIAR CONTENEDOR
ENTRYPOINT [ "java","-jar", "/root/target/app.jar"]