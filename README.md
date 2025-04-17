# Argentum Blockchain

<div align="center">
    <img src="assets/argentum-logo.png" alt="Argentum Blockchain Logo" width="200"/>
    <h3>Blockchain del Club Argentino de Tecnología</h3>
</div>

## 🌟 Introducción

Argentum es una blockchain privada del [Club Argentino de Tecnología](https://clubartec.org) (CAT), diseñada para ser compatible con el ecosistema Ethereum mientras mantiene un control de gobernanza por parte de la DAO del club.

Esta blockchain utiliza un mecanismo híbrido de consenso (Clique PoA con adaptación PoS) para asegurar el control sobre quién puede validar la red, a la vez que se mantiene la compatibilidad con herramientas estándar como MetaMask, Remix y otras del ecosistema Ethereum.

## 🔑 Características principales

- ✅ **Compatibilidad EVM**: 100% compatible con Ethereum Virtual Machine
- 🛡️ **Consenso PoA**: Control de validadores mediante gobernanza de la DAO
- 🔄 **Token nativo**: CAT para pago de gas y gobernanza
- 🔗 **Chain ID**: 54911 (Producción) / 54912 (Testnet)
- 🚀 **Despliegue**: Fácil implementación a través de Docker
- ⚙️ **Escalabilidad**: Diseñada para crecer con la comunidad del club

## 📊 Redes disponibles

| Red | Chain ID | RPC URL | 
|-----|----------|---------|
| Producción | 54911 | https://rpc.argentum.clubartec.org |
| Testnet | 54912 | https://test.rpc.argentum.clubartec.org |

Para explorar bloques y transacciones, puedes usar [Blockscout](https://blockscout.com/) o [Expedition](https://expedition.dev/), configurando la URL de RPC de Argentum.

## 🚀 Guía rápida

### Configuración de MetaMask

1. Abrir MetaMask
2. Ir a "Redes" → "Agregar red" → "Agregar una red manualmente"
3. Completar con estos datos:

**Para Producción:**
- **Nombre de la red**: Argentum CAT
- **URL de RPC**: https://rpc.argentum.clubartec.org
- **ID de cadena**: 54911
- **Símbolo de moneda**: CAT
- **URL del explorador**: https://explorer.argentum.clubartec.org

**Para Testnet:**
- **Nombre de la red**: Argentum CAT Testnet
- **URL de RPC**: https://test.rpc.argentum.clubartec.org
- **ID de cadena**: 54912
- **Símbolo de moneda**: tCAT
- **URL del explorador**: https://test.explorer.argentum.clubartec.org

## 💻 Ejecutar un nodo

### Prerrequisitos

- Docker y Docker Compose
- Git
- Conexión a Internet

### Instalación automatizada

```bash
# Clonar el repositorio
git clone https://github.com/cat-dao/argentum-blockchain.git
cd argentum-blockchain

# Ejecutar script de instalación
# Para producción
./scripts/setup.sh -e production

# Para testnet
./scripts/setup.sh -e testnet
```

### Instalación manual

#### 1. Configuración del entorno

Primero, crea un archivo `.env` en la raíz del proyecto:

```bash
# Para producción
echo "NETWORK=production
BOOTNODE=enode://b0cede2b69ca11bc9dd7be78ded8019e64ab618b380bc7b70c6007884bcf2e86dfebf6ba5e7a628d774e41114f7e3a75a9a9e087ce8f6160588b467e4487bc29@98.81.94.105:30303
NODE_IP=$(curl -s https://api.ipify.org)
CHAIN_ID=54911" > .env

# Para testnet
echo "NETWORK=testnet
BOOTNODE=enode://72e0a765862053d09ad292d56fa78365fe0814153be7e2246e8efd88b0ab9edd3cb9f67c1b9ce6bc6e4e989d3142852aae04340c368c47eb9afbd8b5e16c1de9@98.81.94.106:30303
NODE_IP=$(curl -s https://api.ipify.org)
CHAIN_ID=54912" > .env
```

**IMPORTANTE**: Para los bootnodes, Geth requiere que se usen direcciones IP directamente, no nombres de dominio. Si la IP del bootnode cambia, deberás actualizar este valor.

#### 2. Crear estructura de directorios

```bash
mkdir -p data config
```

#### 3. Generar cuenta para el nodo

```bash
docker run --rm -v $(pwd)/data:/data ethereum/client-go:stable account new --datadir /data
```

Guarda la dirección y la contraseña de manera segura.

#### 4. Guardar la contraseña en un archivo

```bash
echo "TU_CONTRASEÑA" > config/password.txt
```

#### 5. Inicializar el nodo con genesis.json

```bash
# Copiar el genesis correspondiente
cp genesis/${NETWORK}/genesis.json config/

# Inicializar el nodo
docker run --rm -v $(pwd)/data:/data -v $(pwd)/config:/config ethereum/client-go:stable init --datadir /data /config/genesis.json
```

#### 6. Iniciar el nodo

```bash
docker compose up -d
```

## 🔒 Convertirse en validador

Para convertirse en validador de la red Argentum, los miembros del Club Argentino de Tecnología deben:

1. Ejecutar un nodo sincronizado siguiendo los pasos anteriores
2. Completar el formulario de solicitud en: https://clubartec.org/blockchain/join
3. Esperar la aprobación por parte de la DAO

Una vez aprobada la solicitud, tu nodo se convertirá automáticamente en validador en el próximo ciclo de actualización.

## 📝 Estructura del repositorio

```
argentum-blockchain/
  ├── docker-compose.yml       # Plantilla para Docker Compose
  ├── .env.example             # Ejemplo de variables de entorno
  ├── genesis/                 # Archivos genesis para cada red
  │   ├── production/
  │   │   └── genesis.json
  │   └── testnet/
  │       └── genesis.json
  ├── scripts/                 # Scripts de utilidad
  │   ├── setup.sh             # Script de instalación
  │   ├── backup.sh            # Script de backup
  │   └── update-node.sh       # Actualización del nodo
  └── docs/                    # Documentación detallada
      ├── operations.md        # Guía de operaciones
      ├── validator.md         # Guía para validadores
      └── troubleshooting.md   # Solución de problemas
```

## 🤝 Contribuir

Las contribuciones son bienvenidas. 

## 📄 Licencia

Este proyecto está licenciado bajo [MIT License](LICENSE).

## 📞 Contacto

Para consultas relacionadas con Argentum:
- **Discord**: [Club Argentino de Tecnología](https://discord.gg/DdSZxmr6Ay)
- **Email**: clubargentinodetecnologia@gmail.com