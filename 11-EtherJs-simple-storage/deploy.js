const {ethers} = require("ethers");
const fs = require("fs");
const dotenv = require("dotenv");

const abi =JSON.parse(
  fs.readFileSync("build/SimpleStorageABI.json", "utf8")
);

const bytecode =`0x${fs.readFileSync("build/SimpleStorageBytecode.txt", "utf8")}`;

async function main() {
  const provider=new ethers.JsonRpcProvider(dotenv.config().parsed.RPC_URL);
  const encryptedJson=fs.readFileSync("./.encryptedKey.json", "utf8");
  let wallet =await ethers.Wallet.fromEncryptedJsonSync(encryptedJson,process.env.PRIVATE_KEY_PASSWORD);
  // const privateKey=dotenv.config().parsed.PRIVATE_KEY;
  // const wallet = new ethers.Wallet(privateKey, provider);

  wallet = wallet.connect(provider);

const factory = new ethers.ContractFactory(abi, bytecode, wallet);

const contract = await factory.deploy();
await contract.waitForDeployment();

console.log("Contract deployed at:", await contract.getAddress());

const favoriteNumber = await contract.retrieve();
console.log("Favorite Number:", favoriteNumber.toString());

const nonce = await provider.getTransactionCount(wallet.address, "latest");
const tx = await contract.store(54, {
  nonce: nonce
});



const updatedFavoriteNumber = await contract.retrieve();
console.log("Updated Favorite Number:", updatedFavoriteNumber.toString());

}

main().then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});