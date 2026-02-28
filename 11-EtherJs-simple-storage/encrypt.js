const {ethers, Wallet} = require("ethers");
const fs = require("fs");
require("dotenv").config();

async function main(){
    const wallet =new ethers.Wallet(process.env.PRIVATE_KEY);
    const encryptedPK= await wallet.encrypt(process.env.PRIVATE_KEY_PASSWORD);
    fs.writeFileSync("./.encryptedKey.json", encryptedPK);
}

main().then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});