// scripts/generate-extradata.js

const fs = require('fs');

function generateExtradata(signers) {
  if (!signers || signers.length === 0) {
    throw new Error("Debe proveer al menos una dirección signer");
  }

  // Validar que todas las direcciones son de 20 bytes
  const signerHexList = signers.map(addr => {
    if (!addr.startsWith("0x") || addr.length !== 42) {
      throw new Error(`Dirección inválida: ${addr}`);
    }
    return addr.slice(2).toLowerCase();
  });

  const padding = "0".repeat(64); // 32 bytes
  const signerData = signerHexList.join(''); // 20 bytes cada una
  const signature = "0".repeat(130); // 65 bytes

  const extradata = `0x${padding}${signerData}${signature}`;

  if (extradata.length !== 2 + 64 + (signerHexList.length * 40) + 130) {
    throw new Error("Extradata tiene una longitud incorrecta. Revisar las direcciones.");
  }

  return extradata;
}

// --- CLI ---
const args = process.argv.slice(2);
const signers = [];

for (let i = 0; i < args.length; i++) {
  if (args[i] === '--signer' && args[i + 1]) {
    signers.push(args[i + 1]);
    i++;
  }
}

if (signers.length === 0) {
  console.error("Uso: node generate-extradata.js --signer 0x... [--signer 0x...]");
  process.exit(1);
}

const extradata = generateExtradata(signers);
console.log("\nExtradata generado:");
console.log(extradata);

// Guardar en archivo opcional
const outputFile = 'generated_extradata.txt';
fs.writeFileSync(outputFile, extradata);
console.log(`\nGuardado en archivo: ${outputFile}`);