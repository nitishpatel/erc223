const _ = require("lodash/fp");
const chai = require("chai");
const { ethers, deployments, getNamedAccounts } = require("hardhat");
const { expect } = chai;

const normalizeOutput = (output) =>
  output.map((v) => (ethers.BigNumber.isBigNumber(v) ? v.toNumber() : v));

const normalizeArrayOutput = (arrOutput) => arrOutput.map(normalizeOutput);

describe("ERC223", function () {
  let TERC223Token;

  beforeEach(async () => {
    await deployments.fixture(["ERC223Mintable"]);
    const { deployer } = await getNamedAccounts();
    TERC223Token = await ethers.getContract(
      "ERC223Mintable",
      deployer
    );
  });

    it("should have a name", async () => {
        expect(await TERC223Token.name()).to.equal("Test Token");
        }
    );
    it("should have a symbol", async () => {
        expect(await TERC223Token.symbol()).to.equal("TST");
        }
    );
    it("should have 18 decimals", async () => {
        expect(await TERC223Token.decimals()).to.equal(18);
        
    });
    it("should have a total supply of 0", async () => {
        expect(await TERC223Token.totalSupply()).to.equal(0);
    });
    it("should have a balance of 0 for the deployer", async () => {
        const { deployer } = await getNamedAccounts();
        expect(await TERC223Token.balanceOf(deployer)).to.equal(0);
    });

    it("should mint 1000 tokens to the deployer", async () => {
        const { deployer } = await getNamedAccounts();
        await TERC223Token.mint(deployer, 1000);
        expect(await TERC223Token.balanceOf(deployer)).to.equal(1000);
    });

    it("should transfer 100 tokens from deployer to account1", async () => {
        const { deployer, account1 } = await getNamedAccounts();
        await TERC223Token.mint(deployer, 1000);
        await TERC223Token["transfer(address,uint256)"](account1, 100);
        expect(await TERC223Token.balanceOf(deployer)).to.equal(900);
        expect(await TERC223Token.balanceOf(account1)).to.equal(100);
    });

    it("should transfer 100 tokens from deployer to account1 and emit Transfer event", async () => {
        const { deployer, account1 } = await getNamedAccounts();
        await TERC223Token.mint(deployer, 1000);
        await expect(TERC223Token["transfer(address,uint256)"](account1, 100))
            .to.emit(TERC223Token, "Transfer")
            .withArgs(deployer, account1, 100);
    });
});
