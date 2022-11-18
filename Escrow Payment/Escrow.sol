// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//To prevent Contract RE-enterance 
import "@openzepplin/contracts/security/ReentrancyGuard.sol";


contract Escrow is ReentrancyGuard{
  enum Available { NO, YES }
  enum Status    { OPEN, PENDING, DELIVERY, CONFIRMED, DISPUTED, REFUNDED, WITHDRAWED }


  struct ItemStruct {
    uint itemId;
    string purpose;
    uint amount;
    address owner;
    address buyer;
    Status status;
    bool provided;
    bool confirmed;
    uint timestamp;
  }

   address public escAcc;
   uint public escBal;
   uint public escAvailable;
   uint public escFee;
   uint public totalItems;
   uint public totalConfirmed;
   uint public totalDisputed;

   mapping(uint => itemStruct) items;
   mapping(address => itemStruct[]) itemsOf;
   mapping(address => mapping(uint => bool)) public requested;
   mapping(uint => address) public ownerOf;
   mapping(uint => Available) public isAvailable;


   event Action (
    uint itemId,
    string actiontype,
    Status status,
    address indexed executor  
   );
   

  constructor (uint_escFee){
    escAcc = msg.sender;
    escFee = _escFee;
  }

function createItem(string memory purpose, uint amount) public returns(bool){
  require(bytes(purpose).length > 0, "Purpose cannot be blank");
  require(amount > 0, "Amount Cannot be Zero");
  
  uint itemId = totalItems++;
  ItemStruct storage item = items[itemId];
  item.itemId = itemId;
  item.purpose = purpose;
  item.amount = amount;
  item.timestamp = block.timestamp;
  item.owner = msg.sender;
  
  itemsOf[msg.sender].push(item);
  ownerOf[itemId] = msg.sender;
  isAvailable[itemId] = Available.YES;

  emit Action (
    itemId,
    "ITEM CREATED",
    Status.OPEN,
    msg.sender  
   );

   return true;
}

function getItems() public returns(ItemStruct[] memory props) {
  props = new ItemStruct[](totalItems);

  for(uint i = 0; i < totalItems; i++){
    props[i] = items[i];
  }
}


function getItem(uint itemId) public view returns(ItemStuct memory){
  return items[itemId];
}
 
 
 function myItems () public view returns(ItemStruct[] memory) {
   return itemsOf[msg.sender];
 }
 

function requestItem (uint itemId) public returns(bool) {
  require (msg.sender != owner[itemId], "Owner cannot Request for own item");
  require(isAvailable[itemId] == Available.YES, "Item not Available");
  requested[msg.sender][itemId] = true;


  emit Action (
    itemId,
    "ITEM REQUESTED",
    Status.OPEN,
    msg.sender
  
  );
  
  return true;
}

function approveRequest(uint itemId, address buyer) public returns(bool){
 require(msg.sender == owner[itemId], "Only owner");
 require(isAvailable[itemId] == Available.YES, "Item  unavailable");
 require(requested[buyer][itemId], "Buyer not on Purchase list");
}

 }