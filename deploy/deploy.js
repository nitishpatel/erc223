const deployOptions = {
    log: true,
    gasPrice: ethers.utils.parseUnits("1", "gwei"),
  };
  
  module.exports = async ({ getNamedAccounts, deployments, network }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    await deploy("ERC223Token", {
      from: deployer,
      args: [
        "Test Token",
        "TST",
        18
      ],
      ...deployOptions,
    });
  };
  
  module.exports.tags = ["ERC223Token"];