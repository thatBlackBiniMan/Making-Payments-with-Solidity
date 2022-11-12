// SPDX-License-Identifier: MIT;
pragma solidity ^0.8.0;

contract KryptoStore{
  uint public tax;
  address immutable taxAccount;
  uint totalSupply;
  KryptoStruct[] kryptos;
  mapping (address => KryptoStruct[]) public kryptoOf;
  mapping (uint => address) public sellerOf;
  mapping (uint => bool) public kryptoExist;
  
  
   struct KryptoStruct{
    uint id;
    address seller;
    string name;
    string description;
    string author;
    uint cost;
    uint timestamp;
   }

  event Sale (
    uint id,
    address buyer,
    address seller,
    uint cost,
    uint timestamp
  
  );
  

 event Created (
    uint id,
    address indexed seller,
    uint timestamp
 );
    
 

constructor(uint _tax) {
  tax = _tax;
  taxAccount = msg.sender;
}


function createKrypto(string memory name, string memory description, string memory author, uint cost) public returns (bool) {
 require (bytes(name).length > 0, "Name is empty" );
 require (bytes(description).length > 0, "Description is empty" );
 require (bytes(author).length > 0, "Author is empty" );
 require (bytes(cost > 0 ether, "price too low" );
   
  sellerOf[totalSupply] = msg.sender;

   kryptos.push(
    KryptoStruct(
    totalSupply,
    msg.sender,
     name,
     description,
     author,
     cost,
     block.timestamp;
          
    )
   );

   emit Created (
    totalSupply++,
    msg.sender,
    block.timestamp
   );
  
  return true;
}
  
function payForKrypto(uint id)public payable returns(bool){
 require(kryptoExist[id], "Krypto doesn't exist");
 require(msg.value >= kryptos[id].cost, "Insufficient amount");

 address seller = sellerOf[id];
 uint fee = (msg.value / 100 * tax);
 uint payment = msg.value - fee;

payTo(seller, payment); // maybe change to amount
payTo (taxAccount, fee);

kryptoOf[msg.sender].push(kryptos[id]);

  emit Sale (
    id,
    msg.buyer,
    seller,
    kryptos[id].cost,
    block.timestamp
  )

}


// Sending Money


function payTo (address to, uint amount) internal returns (bool){
 (bool successful,) = payable(to).call{value: amount}{""};
 require(seccessful, "Payment Failed");
 return true;
}

//       OR         \\

function transferTo (address to, uint amount) internal returns (bool){
 payable(to).transfer{amount};
return true;
}


//       OR         \\

function sendTo (address to, uint amount) internal returns (bool){
require(payable(to).send{amount}, "Payment failed");
return true;
}


//  Function to see buyer's / seller Kyptos

function myKryptos(address buyer) public view returns(KryptoStruct[] memory){
  return kryptoOf[buyer];
}

function getKryptos() public view returns(KryptoStruct[] memory){
  return kryptos;
}

function getKrypto(uint id) public view returns(KryptoStruct[] memory){
  return kryptos[id];
}

}