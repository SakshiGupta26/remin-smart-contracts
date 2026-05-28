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
     uint public DeployTime;
     bool public stop;

     event Transfer(address receiver, uint amount);
     event Receive(address sender, uint amount);
     event ReceiveFromUser(address sender, address receiver, uint amount);

     constructor(){
        owner = msg.sender;
        DeployTime = block.timestamp;
     }

     modifier onlyOwner() {
        require(msg.sender == owner,"You are not owner");
        _;
     }
         modifier CorrectAddres(address _to){
      require(_to!= address(0),"Addtress is invalid");
      _;
     }

     modifier Starting(uint time){
      require(block.timestamp >= DeployTime + 360000,"Send after starting time");
      _;
     }
     
     mapping(address => uint) suspiciousUser;

   modifier getSuspiciousUser(address _sender){
      require(suspiciousUser[_sender]<5,"Activity found suspicious, Try Later");
      _;
   }
   
    modifier isEmergencyDeclared(){
      require(stop== false,"Emergency Declared");
      _;
    }
      function toggleStop() view internal {
      stop!=stop;
   }
   function ChangeOwner(address user) public onlyOwner isEmergencyDeclared{
      owner = user;
   }

    function transferToContract() external payable Starting(block.timestamp) getSuspiciousUser(msg.sender){
        transactionhistory.push(Transaction({from:msg.sender,to:address(this),timestamp:block.timestamp,amount:msg.value}));
    }

    function transferToUserViaContract(address payable _to,uint _weiAmount)  external onlyOwner  CorrectAddres(_to){
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


    function transferToUserViaMsgValue(address _to)  external payable CorrectAddres(_to)
    {  require(address(this).balance>=msg.value,"Insufficient Balance");
       payable(_to).transfer(msg.value);
      transactionhistory.push(Transaction({from:address(this),to:_to,timestamp:block.timestamp,amount:msg.value}));
    }

    function receiveFromUser(address _from) external payable  {
      require(msg.value > 0, "Insufficient balance! Payable value is greater than 0");
      payable(owner).transfer(msg.value);
      transactionhistory.push(Transaction({from:msg.sender,to:owner,timestamp:block.timestamp,amount:msg.value}));
      emit ReceiveFromUser(msg.sender, owner, msg.value);
    }

    function getOwnerBalanceInWei() external view returns (uint){
       return owner.balance;
    }

    receive() external payable {
       transactionhistory.push(Transaction({from:msg.sender,to:address(this),timestamp:block.timestamp,amount:msg.value}));
       emit Receive(msg.sender, msg.value);
    }

  function suspiciousActivity(address _sender) public {
      suspiciousUser[_sender] += 1;
     }

    fallback() external payable {
      suspiciousActivity(msg.sender);
    }
    function getTansferHistory() external view returns(Transaction[] memory){
      return transactionhistory;
    }
   
   function emergencyWithdrawl() external {
      require(stop== true, "Emergency not declared");
      payable(owner).transfer(address(this).balance);
   }   
}
