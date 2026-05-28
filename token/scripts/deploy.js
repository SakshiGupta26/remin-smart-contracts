const hre = require("hardhat");

async function main() {
  const LearningToken =
    await hre.ethers.getContractFactory("LearningToken");

  const token = await LearningToken.deploy();

  await token.waitForDeployment();

  console.log("Token deployed to:", await token.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
