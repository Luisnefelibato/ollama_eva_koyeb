#!/bin/bash

# Iniciar el servidor Ollama en segundo plano
ollama serve &

# Redirigir a 0.0.0.0 para que Koyeb lo detecte
socat TCP-LISTEN:11434,fork,reuseaddr TCP:localhost:11434 &

# Esperar a que Ollama esté listo
for i in {1..30}; do
    if curl -s http://localhost:11434/api/tags > /dev/null; then
        echo "Servidor de Ollama está listo."
        break
    fi
    echo "Esperando a que Ollama se inicie... ($i/30)"
    sleep 1
done

if ! curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "Error: No se pudo conectar al servidor de Ollama."
    exit 1
fi

# Descargar modelo si no está
if ! ollama list | grep -q "llama3:8b"; then
    echo "Descargando modelo llama3:8b..."
    ollama pull llama3:8b
else
    echo "Modelo ya presente."
fi

# Mantener el contenedor vivo
wait
