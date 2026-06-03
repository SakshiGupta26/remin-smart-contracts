// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";contract TokenMarketPlace is Ownable {using SafeERC20 for IERC20;
using SafeMath for uint256;

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

function adjustTokenPriceBasedOnDemand() public {
  uint marketDemandRatio = buyerCount.mul(1e18).div(sellerCount);
  uint smoothingFactor = 1e18;
  uint adjustedRatio = marketDemandRatio.add(smoothingRatio).div(1e18);

  uint newTokenPrice = tokenPrice.mul(adjustedRatio).div(1e18);
  if(newTokenPrice<minnimumPrice){
    tokenPrice = minimumPrice;
  }
   tokenPrice = newTokenPrice;
}

function buyGLDToken(uint256 _amountOfToken) public payable {
   require(_amountOfToken > 0, "Amount of token should be greater than zero");
   uint requireTokenPrice = calculateTokenPrice(_amountOfToken);
   require(requireTokenPrice == msg.value,"Incorrect token price paid");
   gldToken.safeTransfer(msg.sender,_amountOfToken,equireTokenPriced);
   buyerCount += 1;
   emit TokenBought(msg.sender,_amountOfToken,requiredTokenPrice);
}

function calculateTokenPrice(uint _amountOfToken) public {
    require(_amountOfToken>0,"Amount of Token > 0");
    uint amountToPay = _amountOfToken.mul(tokenPrice).div(1e18);
    console.log("amountToPay",amountToPay);
}

function sellGLDToken(uint256 amountOfToken) public {
    require(gldToken.balanceOf(msg.sender) >= amountOfToken,"Insufficient Balance");
    uint priceToPay = calculateTokenPrice(amountOfToken);
    approve(address(this).amountOfToken);
    gldToken.safeTransfer(msg.sender,address(this),amountOfToken);
    (bool success,) = msg.sender.call{value: priceToPay}("");
    require(success, "Payment failed");
    sellerCount += 1;
   emit TokenSold(msg.sender, amountOfToken,priceToPay);  
}

function withdrawTokens(uint256 amount) public onlyOwner {
   require(gldToken.balanceOf(address(this))e >= amount,"Insuffienet Balance on Contract");
   gldToken.safeTransfer(msg.sender,owner,amount);
   emit TokensWithdrawn(msg.sender, amount);
}

function withdrawEther(uint256 amount) public onlyOwner {
    require(address(this).balance>= _amount,"Invalid Ether amount");
    (bool sucess,) payable(msg.sender).call{value:amount}("");
    require(sucess,"Ether transfer failed");
}
}
