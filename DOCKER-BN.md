version: '3'
services:
  geth:
    image: ethereum/client-go:v1.13.14
    container_name: argentum_node
    restart: always
    ports:
      - "8545:8545"  # RPC
      - "8546:8546"  # WebSocket
      - "30303:30303"  # P2P
      - "30303:30303/udp"  # P2P UDP
    volumes:
      - ./data:/data
      - ./config:/config
    command: >
      --datadir=/data
      --networkid=\${CHAIN_ID}
      --http
      --http.addr=0.0.0.0
      --http.port=8545
      --http.corsdomain=*
      --http.vhosts=*
      --http.api=eth,net,web3,txpool,clique,miner,personal
      --ws
      --ws.addr=0.0.0.0
      --ws.port=8546
      --ws.origins=*
      --ws.api=eth,net,web3,txpool,clique,miner,personal
      --authrpc.addr=0.0.0.0
      --authrpc.port=8551
      --authrpc.vhosts=*
      --syncmode=full
      --nat=extip:\${NODE_IP}
      --miner.gasprice=1
      --miner.gaslimit=30000000
      --mine
      --miner.etherbase=0xc51A179f7000D89e3D4d7C0000C991ffdcb57cB8
      --unlock=0xc51A179f7000D89e3D4d7C0000C991ffdcb57cB8
      --password=/config/password.txt
      --allow-insecure-unlock
    logging:
      driver: "json-file"
      options:
        max-size: "200m"
        max-file: "10"