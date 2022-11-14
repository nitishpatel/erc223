const deployOptions = {
    log: true,
    gasPrice: ethers.utils.parseUnits("1", "gwei"),
  };
  
  module.exports = async ({ getNamedAccounts, deployments, network }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    await deploy("ERC223Mintable", {
      from: deployer,
      args: [
        "Test Token",
        "TST",
        18
      ],
      ...deployOptions,
    });
    const token = await ethers.getContract("ERC223Mintable", deployer);
    await deploy("ReceiverContract", {
      from: deployer,
      args: [
        token.address
      ]
    })
  };
  
  module.exports.tags = ["ERC223Mintable","ReceiverContract"];