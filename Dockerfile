FROM debian:bullseye

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y curl socat netcat gnupg

# Instalar Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Copiar script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Exponer ambos puertos
EXPOSE 11434
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
