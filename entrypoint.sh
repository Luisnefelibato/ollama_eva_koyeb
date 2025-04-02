#!/bin/bash

# Iniciar Ollama
ollama serve &

# Servidor simple para health check en puerto 8080
while true; do echo -e 'HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK' | nc -l -p 8080; done &

# Esperar a que Ollama esté listo
for i in {1..30}; do
    if curl -s http://localhost:11434/api/tags > /dev/null; then
        echo "Ollama listo."
        break
    fi
    echo "Esperando... ($i/30)"
    sleep 1
done

# Descargar modelo si no está
if ! ollama list | grep -q "llama3:8b"; then
    echo "Descargando modelo..."
    ollama pull llama3:8b
fi

wait
