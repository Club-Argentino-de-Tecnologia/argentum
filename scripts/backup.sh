#!/bin/bash
# Script de backup para nodos Argentum
# Club Argentino de Tecnología

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar mensajes
print_message() {
    echo -e "${BLUE}[Argentum]${NC} $1"
}

print_error() {
    echo -e "${RED}[Error]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[Éxito]${NC} $1"
}

# Obtener la fecha actual para el nombre del archivo
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/argentum_backups"
BACKUP_FILE="$BACKUP_DIR/argentum_backup_$DATE.tar.gz"

# Crear directorio de backups si no existe
mkdir -p $BACKUP_DIR

# Verificar que el script se ejecute desde el directorio raíz del nodo
if [ ! -d "data" ] || [ ! -f "docker-compose.yml" ]; then
    print_error "Este script debe ejecutarse desde el directorio raíz del nodo Argentum."
    print_message "Cambie al directorio donde instaló el nodo y vuelva a intentar."
    exit 1
fi

# Preguntar al usuario si desea detener el nodo
print_message "Para realizar un backup seguro, se recomienda detener el nodo."
read -p "¿Desea detener el nodo ahora? (s/n): " stop_node

if [ "$stop_node" = "s" ] || [ "$stop_node" = "S" ]; then
    print_message "Deteniendo el nodo..."
    docker compose down
    print_success "Nodo detenido correctamente."
else
    print_message "Continuando sin detener el nodo. El backup podría no ser consistente."
fi

# Realizar el backup
print_message "Creando backup en $BACKUP_FILE..."
tar -czf "$BACKUP_FILE" data config .env docker-compose.yml

# Verificar si el backup fue exitoso
if [ $? -eq 0 ]; then
    print_success "Backup creado exitosamente."
    print_message "Tamaño del backup: $(du -h "$BACKUP_FILE" | cut -f1)"
    print_message "Ubicación: $BACKUP_FILE"
else
    print_error "Ocurrió un error durante la creación del backup."
fi

# Reiniciar el nodo si fue detenido
if [ "$stop_node" = "s" ] || [ "$stop_node" = "S" ]; then
    print_message "Reiniciando el nodo..."
    docker compose up -d
    print_success "Nodo reiniciado correctamente."
fi

print_message "Proceso de backup finalizado."