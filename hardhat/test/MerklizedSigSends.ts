import hre, { ethers } from "hardhat";
import { SigningKey } from './utils/SigningKey'
import { BigNumber, Signer } from "ethers";
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers'
import { signTypedData } from './utils/utils'
const { expect,assert } = require('chai')
import {
  encrypt,
  recoverPersonalSignature,
  recoverTypedSignature,
  TypedMessage,
  MessageTypes,
  SignTypedDataVersion
} from '@metamask/eth-sig-util';

const burnAddress ='0x000000000000000000000000000000000000dEaD'

const {
  getSelectors,
  FacetCutAction,
  removeSelectors,
  findAddressPositionInFacets
} = require('../scripts/libraries/diamond.js')

const { MerkleTree  } = require('merkletreejs');


const { deployDiamond } = require('../scripts/deploy.js')

function* idMaker() {
  var index = 0;
  while (true)
    yield index++;
}



describe("MerklizedSigSends", async () => {
  let genId = idMaker()
  let accounts: SignerWithAddress[]
  let diamondAddress: string
  let cawAddress: string
  let cawToken:any
  let usernameFacet:any
  let merklizedSigSendsFacet:any
  before(async () => {
    accounts = await ethers.getSigners();
    ;({diamond: diamondAddress, caw:cawAddress} = await deployDiamond())
    cawToken = await ethers.getContractAt('StandardERC20', cawAddress)
    usernameFacet = await ethers.getContractAt('UsernameFacet', diamondAddress, accounts[0])
    merklizedSigSendsFacet = await ethers.getContractAt('MerklizedSigSendsFacet', diamondAddress, accounts[0])
    const trillionCaw = ethers.utils.parseEther('1000000000000')
    const billionCaw = ethers.utils.parseEther('1000000000')
    await Promise.all(
      accounts.map(async (account, i) => {
        await cawToken.transfer(account.address,  trillionCaw)
        await cawToken.connect(account).approve(diamondAddress, billionCaw)
        const username = `account${i}`
        await usernameFacet.connect(account).createUser(username)
      })
    )
  })

  it("", async () => {

  })

})
