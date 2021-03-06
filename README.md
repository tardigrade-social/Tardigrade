# Tardigrade
![](https://github.com/tardigrade-social/Tardigrade/blob/master/docs/static/img/tardigrade-logo.png)

[discord](https://discord.gg/BUJaYAFxRr)

Inspired by [Caw](https://www.reddit.com/r/SatoshiStreetBets/duplicates/up121h/caw_white_paper_decentralized_social_network/), Tardigrade is a pure utilitarian vision of the manifesto.  Token agnostic, Username nodes with connections' vertices, attempts at Zero Knowledge proofs, Deposit box timelocking, IPFS pubsub signature chaining and harvesting, a call to social media tech stack composability and competition, Tardigrade.social attempts to focalize the share desired for a decentralized social media into an ecosystem that brings control of the media back the inot the users and its creators hands.


## About
### Tardigrade
Even only a shortwhile of applying my research to the problem outlined in the manifesto, it became apparent of the possibilities that laid outside of CAW.  'Why token' always popped back to me, just signature send Eth, or make it ERC20 composable, now that is integratable!  Attempting to make a user spend gas in exchange to update CAW state, even if by crunching bits into chained message signatures at the gas limit, seemed ambitious to me.  But the tokenomics this situation enables offers a topology of game theories. Quickly a vault can become a tip jar, or an honour box, if such a situation permits it sufficient, the token bequeaths it. Regardless, performing such experiments is more straight to the point inheriting a stable coin than an internally hoisted erc20 anyways.  This is Tardigrade.social Orbital Meshnet.

### Goals
Tardigrade aspires to be the pure vision manifested in the vision of CAW, ZkSnarked social graph unlocks composability with defi value primitives and is injectible and composable with every part of the social media tech stack, from moderation, to data, to algorithm, to feedback loop, or what ever platform one chooses.  It offers a vault interface with timelocking to match deadlines of IPFS pubsub chained signature send systems to unlock low security metagames that are none the less sufficient. Tardigrade focalizes on the shared desire to have a decentralized social media, and that the idea that persistence over the most rudimentary elements of the social graph is a wise decision, and can reduce costs in switching social medias.




### Genesis, the Story of CAW

[CommunityCaw](https://twitter.com/CommunityCaw) drafted a [specification](https://www.reddit.com/r/SatoshiStreetBets/duplicates/up121h/caw_white_paper_decentralized_social_network/) for a decentralized social network that contains an open call for implementors.  Cawdrivium attempts to implement and explore the specification around a conservative starting point for a social media that cryptographically denies the right to be forgotten, the seven classical liberal arts; Grammar, Logic, Rhetoric through Geometry, Mathematics, Astronomy and Music.  It was after the bubonic plague that the Renaissance emerged, and now we have all seen the outcome of a world where knowledge and wisdom is monopolized over the ignorant for profit and prestige.  Cawdrivium hopes to offer a place where we can collectivly offer the opportunity of acheiving liberalis, the quality of being a free man, to each other.

## Goals
There is many ways to skin this specification so to speak.  The current goal of Cawdrivium is to simply start testing out some opinions, and hopefully solicit some feed back as different options on the tech stack are tried out. All Code and feedback is welcome, consider this a research project for now, (in fact the Caw creator seems apprehensive of accepting solo projects :))

## Technology Notes

- [IPFS](https://github.com/ipfs/go-ipfs)
- [Orbit DB](https://github.com/orbitdb/orbit-db)
- [Node.js](https://nodejs.org/en/download/) version 14 or above:
  - When installing Node.js, you are recommended to check all checkboxes related to dependencies.
- [Metamask](https://metamask.io/)
- [Hardhat](https://hardhat.org/)

- [EIP-712](https://eips.ethereum.org/EIPS/eip-712)
- [EIP-1155](https://eips.ethereum.org/EIPS/eip-1155)
- [EIP-2535](https://eips.ethereum.org/EIPS/eip-2535)


[EIP-2535](https://eips.ethereum.org/EIPS/eip-2535) While the specification calls for no proxy contracts.  The developer may have been unfamiliar with a new emerging standard the Diamand multi-facet proxy.  It is possible in this standard to make the proxy immutable by removing the editing function, so one can acheive immutability while utilizing its other benefits like unlimited contract size, avoiding passing large structs between contracts, and terseness, not having to import endless interfaces.  

It is the proposal of this developer that this set of contracts is too complex to yolo a one and done contract.  And that instead a *nightly* version of the protocol is build mutably on the diamond, battle tested by the community, than frozen as the current version.  Updates can be started in a new nightly diamond.

[StandardERC20](https://etherscan.io/address/0xf3b9569F82B18aEf890De263B84189bd33EBe452#code) is an autogenerated contract by a tool perhaps similar to [erc20-create](https://vittominacori.github.io/erc20-generator/) all well and fine, but this does block the 0x000 burn address.  As such Caw burns are directed to the [0x0...0dead](https://etherscan.io/address/0x000000000000000000000000000000000000dead)  

The Crux on the smart contract side seems to be faciliting the [EIP-712](https://eips.ethereum.org/EIPS/eip-712) v4 signatures that stand in as a sort of micropayment channel for incentives for the liking, creating and following of Caws.  I'd like to exploring perhaps even doing an internal merkle tree structure, and to see if many users can chain permits to the same message.

[web3-react](https://github.com/NoahZinsmeister/web3-react) react typescript seems to be the bread and butter of front end web3 at the moment

Still exploring persistent storage and message ques.  Would love to hear debates between the different storage medium.  I am thinking initially I'll explore Arweave or filecoin, and than orbit-db or the like for the passing of materials.

## Opensource
Feel free to use this code in your own Caw implementation and contribute to this repo

## Fun Ideas
Fund [sci-hub](https://sci-hub.se/) with the stakepool, buy out Elsivier, create an alternative platform for publishing science that gives open-access and monetary incentive in one


