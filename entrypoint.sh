#!/bin/bash

# Ejecutar Ollama escuchando explícitamente en 127.0.0.1 (por defecto) en segundo plano
ollama serve &

# Esperar a que el puerto esté libre antes de redirigir
sleep 3

# Redirigir puerto 11434 desde 0.0.0.0 hacia localhost (para que Koyeb lo detecte)
socat TCP-LISTEN:11434,fork,reuseaddr TCP:127.0.0.1:11434 &

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

# Mantener contenedor activo
wait
