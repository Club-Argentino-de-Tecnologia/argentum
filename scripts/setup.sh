#!/bin/bash
# Script de configuración para nodos Argentum
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

print_warning() {
    echo -e "${YELLOW}[Advertencia]${NC} $1"
}

# Verificar prerrequisitos
check_prerequisites() {
    print_message "Verificando prerrequisitos..."
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker no está instalado. Por favor, instálalo antes de continuar."
        print_message "Puedes instalarlo siguiendo las instrucciones en: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    # Verificar Docker Compose (comprueba tanto la versión nueva como la legacy)
    if ! (docker compose version &> /dev/null || command -v docker compose &> /dev/null); then
        print_error "Docker Compose no está instalado. Por favor, instálalo antes de continuar."
        print_message "Puedes instalarlo siguiendo las instrucciones en: https://docs.docker.com/compose/install/"
        exit 1
    fi
    
    # Verificar curl
    if ! command -v curl &> /dev/null; then
        print_error "curl no está instalado. Por favor, instálalo antes de continuar."
        exit 1
    fi
    
    print_success "Todos los prerrequisitos están instalados."
}

# Mostrar ayuda
show_help() {
    echo "Uso: $0 [opciones]"
    echo ""
    echo "Opciones:"
    echo "  -e, --environment <env>   Especificar entorno (production o testnet)"
    echo "  -h, --help                Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 -e production          Configurar nodo para la red de producción"
    echo "  $0 -e testnet             Configurar nodo para la red de pruebas"
    echo ""
}

# Procesar parámetros
ENVIRONMENT=""

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -e|--environment)
            ENVIRONMENT="$2"
            shift
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Opción desconocida: $1"
            show_help
            exit 1
            ;;
    esac
done

# Verificar que se haya especificado el entorno
if [ -z "$ENVIRONMENT" ]; then
    print_error "No se ha especificado el entorno."
    show_help
    exit 1
fi

# Validar entorno
if [ "$ENVIRONMENT" != "production" ] && [ "$ENVIRONMENT" != "testnet" ]; then
    print_error "Entorno inválido. Debe ser 'production' o 'testnet'."
    show_help
    exit 1
fi

# Verificar prerrequisitos
check_prerequisites

# Crear directorios necesarios
print_message "Creando estructura de directorios..."
mkdir -p data config

# Configurar variables de entorno según el entorno
print_message "Configurando variables para entorno: $ENVIRONMENT"

if [ "$ENVIRONMENT" = "production" ]; then
    BOOTNODE="enode://b0cede2b69ca11bc9dd7be78ded8019e64ab618b380bc7b70c6007884bcf2e86dfebf6ba5e7a628d774e41114f7e3a75a9a9e087ce8f6160588b467e4487bc29@rpc.argentum.clubartec.org:30303"
    CHAIN_ID=54911
    NETWORK_NAME="Producción"
else
    BOOTNODE="enode://72e0a765862053d09ad292d56fa78365fe0814153be7e2246e8efd88b0ab9edd3cb9f67c1b9ce6bc6e4e989d3142852aae04340c368c47eb9afbd8b5e16c1de9@test.rpc.argentum.clubartec.org:30303"
    CHAIN_ID=54912
    NETWORK_NAME="Testnet"
fi

# Obtener IP pública
print_message "Obteniendo IP pública..."
NODE_IP=$(curl -s https://api.ipify.org)

if [ -z "$NODE_IP" ]; then
    print_error "No se pudo obtener la IP pública. Verifique su conexión a Internet."
    exit 1
fi

print_success "IP pública detectada: $NODE_IP"

# Crear archivo .env
print_message "Creando archivo .env..."
cat > .env << EOL
NETWORK=$ENVIRONMENT
BOOTNODE=$BOOTNODE
NODE_IP=$NODE_IP
CHAIN_ID=$CHAIN_ID
EOL

# Copiar el archivo genesis correspondiente
print_message "Configurando archivo genesis..."
cp genesis/$ENVIRONMENT/genesis.json config/

# Preguntar si el usuario quiere generar una nueva cuenta
print_message "¿Desea generar una nueva cuenta para este nodo? (s/n)"
read -r generate_account

if [ "$generate_account" = "s" ] || [ "$generate_account" = "S" ]; then
    print_message "Generando nueva cuenta..."
    docker run --rm -it -v $(pwd)/data:/data ethereum/client-go:stable account new --datadir /data
    
    print_message "Ingrese la contraseña que utilizó para la cuenta:"
    read -r account_password
    
    # Guardar contraseña en archivo
    echo "$account_password" > config/password.txt
    print_success "Contraseña guardada en config/password.txt"
fi

# Inicializar el nodo con el genesis
print_message "Inicializando nodo con genesis de $NETWORK_NAME..."
docker run --rm -v $(pwd)/data:/data -v $(pwd)/config:/config ethereum/client-go:stable init --datadir /data /config/genesis.json

print_success "Nodo inicializado correctamente."

# Iniciar el nodo
print_message "¿Desea iniciar el nodo ahora? (s/n)"
read -r start_node

if [ "$start_node" = "s" ] || [ "$start_node" = "S" ]; then
    print_message "Iniciando nodo..."
    docker compose up -d
    print_success "Nodo iniciado. Verifique los logs con: docker compose logs -f"
    
    print_message "Su nodo se está sincronizando con la red Argentum $NETWORK_NAME."
    print_message "Para convertirse en validador, complete el formulario en:"
    print_message "https://clubartec.org/blockchain/join"
else
    print_message "Puede iniciar el nodo más tarde con: docker compose up -d"
fi

print_success "Configuración completada exitosamente."
print_message "Gracias por unirse a la red Argentum del Club Argentino de Tecnología!"