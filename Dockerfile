FROM debian:bullseye

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y curl socat gnupg

# Instalar Ollama (desde el script oficial)
RUN curl -fsSL https://ollama.com/install.sh | sh

# Copiar el script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Exponer el puerto que usa Ollama
EXPOSE 11434

# Ejecutar el script
ENTRYPOINT ["/entrypoint.sh"]
