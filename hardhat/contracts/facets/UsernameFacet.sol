pragma solidity 0.8.14;

import "../interfaces/IERC1155.sol"; // not using open zep as ERC165 is already built into diamond
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import 'hardhat/console.sol';

import { LibAppStorage, AppStorage, Modifiers } from '../libraries/LibAppStorage.sol';
contract UsernameFacet is IERC1155, Modifiers {
  using Address for address;


  function balanceOf(address account, uint256 id) external view returns (uint256) {
    AppStorage storage s = LibAppStorage.diamondStorage();
    require (account != address(0), "ERC1155: burn addr not a valid owner");
    return s.nftIdBalances[id][account];
  }

  function balanceOfBatch(address[] memory accounts, uint256[] memory ids) external view returns (uint256[] memory) {
    AppStorage storage s = LibAppStorage.diamondStorage();
    require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
    uint256[] memory batchBalances = new uint256[](accounts.length);
    for (uint256 i = 0; i < accounts.length; ++i) {
      batchBalances[i] = s.nftIdBalances[ids[i]][accounts[i]];
    }

    return batchBalances;
  }

  function setApprovalForAll(address operator, bool approved) external {
    AppStorage storage s = LibAppStorage.diamondStorage();
    require(msg.sender != operator, "ERC1155: setting approval status for self");
    s.operatorApprovals[msg.sender][operator] = approved;
    emit ApprovalForAll(msg.sender, operator, approved); 
  }

  function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
    AppStorage storage s = LibAppStorage.diamondStorage();
    return s.operatorApprovals[account][operator];
  }

  function safeTransferFrom(
    address from,
    address to,
    uint256 id,
    uint256 amount,
    bytes memory data
  ) external  {
    AppStorage storage s = LibAppStorage.diamondStorage();
    require(
      from == msg.sender || isApprovedForAll(from, msg.sender),
      "ERC1155: caller is not token owner nor approved"
    );
    require(to != address(0), "ERC1155: transfer to the zero address");

    address operator = msg.sender;

    uint256[] memory ids = new uint256[](1);
    ids[0] = id;
    uint256[] memory amounts = new uint256[](1);
    amounts[0] = amount;


    uint256 fromBalance = s.nftIdBalances[id][from];
    require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
    unchecked {
      s.nftIdBalances[id][from] = fromBalance - amount;
    }
    s.nftIdBalances[id][to] += amount;

    emit TransferSingle(operator, from, to, id, amount);

    _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
  }

  function safeBatchTransferFrom(
    address from,
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
  ) external {
    AppStorage storage s = LibAppStorage.diamondStorage();
    require(
      from == msg.sender || isApprovedForAll(from, msg.sender),
      "ERC1155: caller is not token owner nor approved"
    );
    require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
    require(to != address(0), "ERC1155: transfer to the zero address");

    address operator = msg.sender;

    for (uint256 i = 0; i < ids.length; ++i) {
      uint256 id = ids[i];
      uint256 amount = amounts[i];

      uint256 fromBalance = s.nftIdBalances[id][from];
      require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
      unchecked {
        s.nftIdBalances[id][from] = fromBalance - amount;
      }
      s.nftIdBalances[id][to] += amount;
    }

    emit TransferBatch(operator, from, to, ids, amounts);


    _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);	
  }


  function _doSafeTransferAcceptanceCheck(
    address operator,
    address from,
    address to,
    uint256 id,
    uint256 amount,
    bytes memory data
  ) private {
    if (to.isContract()) {
      try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
        if (response != IERC1155Receiver.onERC1155Received.selector) {
          revert("ERC1155: ERC1155Receiver rejected tokens");
        }
      } catch Error(string memory reason) {
        revert(reason);
      } catch {
        revert("ERC1155: transfer to non ERC1155Receiver implementer");
      }
    }
  }

  function _doSafeBatchTransferAcceptanceCheck(
    address operator,
    address from,
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
  ) private {
    if (to.isContract()) {
      try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
        bytes4 response
      ) {
        if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
          revert("ERC1155: ERC1155Receiver rejected tokens");
        }
      } catch Error(string memory reason) {
        revert(reason);
      } catch {
        revert("ERC1155: transfer to non ERC1155Receiver implementer");
      }
    }
  }

  function _mint(
    address to,
    uint256 id,
    uint256 amount,
    bytes memory data
  ) internal {
    require(to != address(0), "ERC1155: mint to the zero address");

    address operator = msg.sender;
    uint256[] memory ids = new uint256[](1);
    ids[0] = id;
    uint256[] memory amounts = new uint256[](1);
    amounts[0] = amount;

    s.nftIdBalances[id][to] += amount;
    emit TransferSingle(operator, address(0), to, id, amount);

    _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
  }


  function createUser(string memory username) external {
    AppStorage storage s = LibAppStorage.diamondStorage();
    uint256 taken = s.usernameToNftId[username];
    (bool valid, uint256 length) = testString(username);
    require(valid, "UsernameFacet::Invalid Username, please only use 0-9 and a-z (no caps)");
    require(taken == 0, "UsernameFacet::Username Taken already");
    if (length > 8) {
      length = 8;
    }
    uint cost = s.usernameCostTable[length - 1]; 
    console.log('cost', cost);
    IERC20(s.caw).transferFrom(msg.sender, s.burn, cost);
    _mint(msg.sender, s.nextNftId, 1, bytes(username));
    s.usernameToNftId[username] = s.nextNftId;
    s.nftIdToUsername[s.nextNftId] = username;
    s.nftIdToAddress[s.nextNftId] = msg.sender;
    s.nextNftId++;
  }

  function testString(string memory letter) internal returns (bool, uint256) {
    bytes memory bytesLetter = bytes(letter);
    uint256 letterAmount = 0;
    for (uint i; i < bytesLetter.length; i++) {
      bytes1 char = bytesLetter[i];
      if (char >= 0x30 && char <= 0x39) {
        // 0-9
        letterAmount++;
      } else if (char >= 0x61 && char <=0x7A) {
        // a-z
        letterAmount++;
      } else {
        return (false, 0);
      }
    }
    return (true, letterAmount);
  }

  function setUsernameCost(uint256 length, uint256 cost) external onlyOwner {
    AppStorage storage s = LibAppStorage.diamondStorage();
    s.usernameCostTable[length] = cost;
  }

  function getUsernameCost(uint256 length) external view returns (uint256) {
    AppStorage storage s = LibAppStorage.diamondStorage();
    require(length > 0, "No zero length names");
    if (length > 8) {
      length = 8;
    }
    console.log(s.usernameCostTable[length-1]);
    return s.usernameCostTable[length - 1];
  }

  function getUsernameByNftId(uint256 id) external view returns (string memory) {
    AppStorage storage s = LibAppStorage.diamondStorage();
    return s.nftIdToUsername[id];
  }

  function getNftIdByUsername(string memory username) external view returns (uint256) {
    AppStorage storage s = LibAppStorage.diamondStorage();
    return s.usernameToNftId[username];
  }

  function getLastUsedNonce(uint256 nftId) external view returns (uint256) {
    AppStorage storage s = LibAppStorage.diamondStorage();
    return s.nftIdUsedNonces[nftId];
  }


}
