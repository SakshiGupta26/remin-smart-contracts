// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SimpleWallet {
     
     struct Transaction{
      address from;
      address to;
      uint timestamp;
      uint amount;
     }

    Transaction[] public transactionhistory;

     address public owner;
     string public str;

     event Transfer(address receiver, uint amount);
     event Receive(address sender, uint amount);
     event ReceiveFromUser(address sender, address receiver, uint amount);

     constructor(){
        owner = msg.sender;
     }

     modifier onlyOwner() {
        require(msg.sender == owner,"You are not owner");
        _;
     }

    function transferToContract() external payable{
        transactionhistory.push(Transaction({from:msg.sender,to:address(this),timestamp:block.timestamp,amount:msg.value}));
    }

    function transferToUserViaContract(address payable _to,uint _weiAmount)  external onlyOwner {
        require(address(this).balance>=_weiAmount,"Insufficient Balance");
        _to.transfer(_weiAmount);
        emit Transfer(_to,_weiAmount);
    }

    function withdrawFromContract(uint _weiAmount) external  onlyOwner{
      require(address(this).balance >=_weiAmount,"Insufficient Balance");
      payable(owner).transfer(_weiAmount);
      transactionhistory.push(Transaction({from:address(this),to:owner,timestamp:block.timestamp,amount:_weiAmount}));
    }

    function getContractBalanceInWei()  external  view  returns (uint)
    { 
         return address(this).balance;
    }


    function transferToUserViaMsgValue(address _to)  external payable
    {  require(address(this).balance>=msg.value,"Insufficient Balance");
       payable(_to).transfer(msg.value);
    }

    function receiveFromUser(address _from) external payable  {
      require(msg.value > 0, "Insufficient balance! Payable value is greater than 0");
      payable(owner).transfer(msg.value);
      emit ReceiveFromUser(msg.sender, owner, msg.value);
    }

    function getOwnerBalanceInWei() external view returns (uint){
       return owner.balance;
    }

    receive() external payable {
       emit Receive(msg.sender, msg.value);
    }


    fallback() external payable {
     payable(msg.sender).transfer(msg.value);
    }
   
}
