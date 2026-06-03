// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract TokenMarketPlace is Ownable {

using SafeERC20 for IERC20;


uint256 public tokenPrice = 2e16 wei; 
uint256 public sellerCount = 1;
uint256 public buyerCount=1;

IERC20 public gldToken;

event TokenPriceUpdated(uint256 newPrice);
event TokenBought(address indexed buyer, uint256 amount, uint256 totalCost);
event TokenSold(address indexed seller, uint256 amount, uint256 totalEarned);
event TokensWithdrawn(address indexed owner, uint256 amount);
event EtherWithdrawn(address indexed owner, uint256 amount);
event CalculateTokenPrice(uint256 priceToPay);

constructor(address _gldToken) Ownable(msg.sender){
     gldToken = IERC20(_gldToken);
}
 uint256 public minimumPrice = 1e15;

function adjustTokenPriceBasedOnDemand() public {
    uint marketDemandRatio = (buyerCount*(1e18))/(sellerCount);

    uint smoothingFactor = 1e18;

    uint adjustedRatio = (marketDemandRatio+(smoothingFactor))/2;


    uint newTokenPrice = (tokenPrice*(adjustedRatio))/(1e18);
   
   if(newTokenPrice<minimumPrice){
    tokenPrice = minimumPrice;
   } else{
   tokenPrice = newTokenPrice;
   }
}

function buyGLDToken(uint256 _amountOfToken) public payable {
   require(_amountOfToken>0,"Amount of token should be greater than 0");
   
   uint requiredTokenPrice = calculateTokenPrice(_amountOfToken);
   require(requiredTokenPrice == msg.value,"Incorrect token price paid");
 //  (bool success,) = payable(msg.sender).call{value:requiredTokenPrices}("");
   
  // require(success,"Token purchased successfully");

   gldToken.safeTransfer(msg.sender,_amountOfToken);
   buyerCount = buyerCount + 1;
   emit TokenBought(msg.sender, _amountOfToken, requiredTokenPrice);

}

function calculateTokenPrice(uint _amountOfToken) public returns(uint256) {
    require(_amountOfToken> 0, "Amount Of Token > 0");
    adjustTokenPriceBasedOnDemand();
    uint amountToPay =( _amountOfToken*(tokenPrice))/(1e18);
   
    return amountToPay;
}

function sellGLDToken(uint256 amountOfToken) public {

    require(gldToken.balanceOf(msg.sender) >= amountOfToken,"Insuffficent Balance");
    uint priceToPay = calculateTokenPrice(amountOfToken);
    
    gldToken.safeTransferFrom(msg.sender,address(this),amountOfToken);
    (bool success, ) = payable(msg.sender).call{value: priceToPay}("");
    require(success, "Payment failed");
    sellerCount += 1;
    emit TokenSold(msg.sender,amountOfToken,priceToPay);
}

function withdrawTokens(uint256 amount) public onlyOwner {
   require(gldToken.balanceOf(address(this)) >= amount,"Insuffienet Balance on Contract");
   gldToken.safeTransfer(msg.sender,amount);
   emit TokensWithdrawn(msg.sender, amount);
}

function withdrawEther(uint256 amount) public onlyOwner {
    require(address(this).balance>= amount,"Invalid Ether amount");
    (bool sucess,)= payable(msg.sender).call{value:amount}("");
    require(sucess,"Ether transfer failed");
    emit EtherWithdrawn(msg.sender, amount);
}
}
