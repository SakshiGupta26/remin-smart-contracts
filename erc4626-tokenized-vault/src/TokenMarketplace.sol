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


function adjustTokenPriceBasedOnDemand() public {

   
}

function buyGLDToken(uint256 _amountOfToken) public payable {
   
}

function calculateTokenPrice(uint _amountOfToken) public {
    
}

function sellGLDToken(uint256 amountOfToken) public {
    requ
}

function withdrawTokens(uint256 amount) public onlyOwner {
   
}

function withdrawEther(uint256 amount) public onlyOwner {
    
}
}
