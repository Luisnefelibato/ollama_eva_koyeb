#!/bin/bash

# Iniciar el servidor de Ollama en segundo plano
ollama serve &

# Esperar a que el servidor esté listo (hasta 30 segundos)
for i in {1..30}; do
    if curl -s http://localhost:11434/api/tags > /dev/null; then
        echo "Servidor de Ollama está listo."
        break
    fi
    echo "Esperando a que el servidor de Ollama se inicie... ($i/30)"
    sleep 1
done

# Verificar si el servidor está realmente listo
if ! curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "Error: No se pudo conectar al servidor de Ollama después de 30 segundos."
    exit 1
fi

# Verificar si el modelo llama3:8b está instalado
if ! ollama list | grep -q "llama3:8b"; then
    echo "Modelo llama3:8b no encontrado, descargando..."
    ollama pull llama3:8b
else
    echo "Modelo llama3:8b ya está instalado."
fi

# Mantener el contenedor corriendo
wait