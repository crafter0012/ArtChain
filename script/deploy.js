const hre = require("hardhat");

async function main() {
  // Get the contract to deploy
  const ArtChainMarketplace = await hre.ethers.getContractFactory("ArtChainMarketplace");
  const artChainMarketplace = await ArtChainMarketplace.deploy();

  console.log("ArtChainMarketplace contract deployed to:", artChainMarketplace.address);

  // Optionally verify the deployment on block explorer after deployment (e.g., Etherscan)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
