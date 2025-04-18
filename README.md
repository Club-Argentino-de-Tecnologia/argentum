Argentum Blockchain

<div align="center">
    <img src="https://clubartec.org/_next/image?url=%2Fapi%2Fimage-proxy%3Furl%3Dhttps%253A%252F%252Fprod-files-secure.s3.us-west-2.amazonaws.com%252F6f8f785a-ee3d-4a4c-a487-c2683f8c0f52%252F0dc2cd51-67d6-46e1-b27d-dce7f24c1ac3%252Fargentum.jpg&w=384&q=75" alt="Argentum Blockchain Logo" width="200"/>
    <h3>Blockchain del Club Argentino de Tecnología</h3>
</div>


🌟 Introducción

Argentum es una blockchain privada del Club Argentino de Tecnología (CAT), diseñada para ser compatible con el ecosistema Ethereum mientras mantiene un control de gobernanza por parte de la DAO del club.

Esta blockchain utiliza un mecanismo de consenso Clique (PoA) para asegurar el control sobre quién puede validar la red, a la vez que se mantiene la compatibilidad con herramientas estándar como MetaMask, Remix y otras del ecosistema Ethereum.

🔑 Características principales
	•	✅ Compatibilidad EVM: 100% compatible con Ethereum Virtual Machine
	•	🛡️ Consenso PoA: Control de validadores mediante gobernanza de la DAO
	•	🔄 Token nativo: CAT para pago de gas y gobernanza
	•	🔗 Chain ID: 54911 (Producción) / 54912 (Testnet)
	•	🚀 Despliegue: Fácil implementación a través de Docker
	•	⏱️ Periodo de bloque ajustado: 44 segundos por bloque
	•	⚙️ Gas mínimo fijo: 1 wei, ideal para redes privadas

📊 Redes disponibles

Red	Chain ID	RPC URL
Producción	54911	https://rpc.argentum.clubartec.org

Para explorar bloques y transacciones, puedes usar Blockscout o Expedition, configurando la URL de RPC de Argentum.

🚀 Guía rápida

Configuración de MetaMask
	1.	Abrir MetaMask
	2.	Ir a “Redes” → “Agregar red” → “Agregar una red manualmente”
	3.	Completar con estos datos:

Para Producción:
	•	Nombre de la red: Argentum CAT
	•	URL de RPC: https://rpc.argentum.clubartec.org
	•	ID de cadena: 54911
	•	Símbolo de moneda: CAT

💻 Ejecutar un nodo

Prerrequisitos
	•	Docker y Docker Compose
	•	Git
	•	Conexión a Internet

Instalación automatizada

# Clonar el repositorio
git clone https://github.com/cat-dao/argentum-blockchain.git
cd argentum-blockchain

# Ejecutar script de instalación
./scripts/setup.sh -e production

Instalación manual

1. Configuración del entorno

Primero, crea un archivo .env en la raíz del proyecto:

NETWORK=production
BOOTNODE=enode://bbf4440531ac44165e984a1ff468873271bf5504f1372ca664c167738e3f803709e242a7c7cc1d3b8757f3a808312c023b57a83a3f4da21d1604f683d006f0fa@98.81.94.105:30303
NODE_IP=$(curl -s https://api.ipify.org)
CHAIN_ID=54911

⚠️ IMPORTANTE: Geth requiere direcciones IP directas para los bootnodes. Si cambia la IP, debés actualizarla en tu .env.

2. Crear estructura de directorios

mkdir -p data config

3. Generar cuenta para el nodo

docker run --rm -v $(pwd)/data:/data ethereum/client-go:stable account new --datadir /data

4. Guardar la contraseña en un archivo

echo "TU_CONTRASEÑA" > config/password.txt

5. Inicializar el nodo con genesis.json

cp genesis/production/genesis.json config/
docker run --rm -v $(pwd)/data:/data -v $(pwd)/config:/config ethereum/client-go:stable init --datadir /data /config/genesis.json

6. Iniciar el nodo

docker compose up -d

🧑‍⚖️ Convertirse en validador
	1.	Ejecutar un nodo sincronizado con los pasos anteriores.
	2.	Completar el formulario de solicitud: https://clubartec.org/blockchain/join
	3.	Una vez aprobado por la DAO, el nodo líder ejecutará en consola:

clique.propose("0xTU_DIRECCION", true)

	4.	Confirmar con:

clique.getSigners()

El nodo se convertirá en validador efectivo en el próximo bloque.

📝 Estructura del repositorio

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

🤝 Contribuir

Las contribuciones son bienvenidas.

📄 Licencia

Este proyecto está licenciado bajo MIT License.

📞 Contacto

Para consultas relacionadas con Argentum:
	•	Discord: Club Argentino de Tecnología
	•	Email: clubargentinodetecnologia@gmail.com