const _ = require("lodash/fp");
const chai = require("chai");
const { ethers, deployments, getNamedAccounts } = require("hardhat");
const { expect } = chai;

const normalizeOutput = (output) =>
  output.map((v) => (ethers.BigNumber.isBigNumber(v) ? v.toNumber() : v));

const normalizeArrayOutput = (arrOutput) => arrOutput.map(normalizeOutput);

describe("ERC223", function () {
  let ERC223Token;

  beforeEach(async () => {
    await deployments.fixture(["ERC223Token"]);
    const { deployer } = await getNamedAccounts();
    TERC223Token = await ethers.getContract(
      "ERC223Token",
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
    
});