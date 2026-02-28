const fs = require("fs");
const solc = require("solc");

// Read Solidity file

const source = fs.readFileSync("./SimpleStorage.sol", "utf8");

// Prepare compiler input
const input = {
  language: "Solidity",
  sources: {
    "SimpleStorage.sol": {
      content: source,
    },
  },
  settings: {
    outputSelection: {
      "*": {
        "*": ["abi", "evm.bytecode"],
      },
    },
  },
};

// Compile
const output = JSON.parse(solc.compile(JSON.stringify(input)));

const contract = output.contracts["SimpleStorage.sol"]["SimpleStorage"];

// Create build folder if not exists
if (!fs.existsSync("build")) {
  fs.mkdirSync("build");
}

// Save ABI
fs.writeFileSync(
  "build/SimpleStorageABI.json",
  JSON.stringify(contract.abi, null, 2)
);

// Save Bytecode
fs.writeFileSync(
  "build/SimpleStorageBytecode.txt",
  contract.evm.bytecode.object
);

console.log("Compilation successful!");
console.log("ABI saved in build/SimpleStorageABI.json");
console.log("Bytecode saved in build/SimpleStorageBytecode.txt");
