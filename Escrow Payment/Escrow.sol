// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


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

function createItem(string memory purpose) public payable returns(bool){
  require(bytes(purpose).length > 0, "Purpose cannot be blank");
  require(msg.value > 0 ether, "Amount Cannot be Zero");
  
  uint itemId = totalItems++;
  ItemStruct storage item = items[itemId];
  item.itemId = itemId;
  item.purpose = purpose;
  item.amount = msg.value;
  item.timestamp = block.timestamp;
  item.owner = msg.sender;
  
  itemsOf[msg.sender].push(item);
  ownerOf[itemId] = msg.sender;
  isAvailable[itemId] = Available.YES;
  escBal += msg.value;

 
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
  require (msg.sender != ownerOf[itemId], "Owner cannot Request for own item");
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

items[itemId].buyer = buyer;
items[itemId].status = Status.PENDING;
isAvailable[itemId] = Available.NO;


  emit Action (
    itemId,
    "ITEM APPROVED",
    Status.PENDING,
    msg.sender
  );
 
 return true;
}


function performDelevery(uint itemId) public returns (bool){
  require(msg.sender == items[itemId].buyer, "You are not the approved buyer");
  require(!items[itemId].provided, "You have already delevered this item");
  require(!items[itemId].confirmed, "You have already confirmed this item");

  items[itemId].provided = true;
  items[itemId].status = Status.DELIVERY;

  emit Action(
    itemId, 
    "ITEM DELIVERY INITIATED",
    Status.DELIVERY,
    msg.sender
    );
   return true;
}


function confirmDelivery(uint itemId, bool provided) public returns (bool){
  require(msg.sender == ownerOf[itemId], "Only owner allowed");
  require (items[itemId].provided, "You haven't delivered this item");
  require (items[itemId].status !=Status.REFUNDED, "Already refunded, create new item");

  if(provided){
    uint fee = (items[itemId].amount = escFee) / 100;
    uint amount = items[itemsId].amount = fee;
    payTo(items[itemId].buyer, amount);
    escBal -= items[itemId].amount;
    escAvailable += fee;

    items[itemId].confirmed = true;
    items[itemId].status = Status.CONFIRMED;
    totalConfirmed++; 
    
    emit Action (
      itemId,
      "ITEM CONFIRMED",
      Status.CONFIRMED,
      msg.sender
    );
  }
  else{
       items[itemId].status = Status.DISPUTED;
      
      
    emit Action (
      itemId,
      "ITEM DISPUTED",
      Status.DISPUTED,
      msg.sender
    );
  }

  return true;
}


function refundItem(uint itemId) public returns(bool){
  require(msg.sender == escAcc, "Only Escrow Validator allowed");
  require(!items[itemId],provided, "Already delivered");

  payTo(items[itemId].owner, items[itemId].amount);
  escBal -= items[itemId].amount;
  items[itemId].status = Status.REFUNDED;
  totalDisputed++;

     emit Action (
      itemId,
      "ITEM REFUNDED",
      Status.REFUNDED,
      msg.sender
    );
 return true;
}


function withdrawFund(address to, uint amount) public returns(bool){
  require(msg.sender == escAcc, "Only Escrow validator can withdraw");
  require(amount <= escAvailBal, "insufficient funds");

  payTo(to, amount);
  escAvailBal -= amount;

return true; 
}


function payTo (address to, uint amount) internal returns (bool){
 (bool successful,) = payable(to).call{value: amount}("");
 require(seccessful, "Payment Failed");
 return true;
}

 }