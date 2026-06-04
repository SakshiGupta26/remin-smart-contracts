// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract  Capstone{
      enum Continent {
        None,
        NorthAmerica,
        Europe,
        Asia,
        Oceania,
        SouthAmerica,
        Africa
    }

    enum AssetClass {
        Equity,
        FixedIncome,
        Crypto,
        RealEstate
    }
      struct Investment {
        uint256 id;
        address investor;
        string assetName;
        uint256 principal;
        uint256 timestamp;
        Continent continent;
        AssetClass assetClass;
    }
    mapping(uint256 =>Investment) public ledger;
    mapping(uint256 => bool) public idUsed;

    uint256 public totalInvestmentsCount;
    address public owner;
    uint256 public deployTime;

    constructor(){
        owner = msg.sender;
        deployTime = block.timestamp;
    }
    modifier onlyOwner(){
        require(msg.sender == owner,"Not Authorized");
        _;
    }
    uint totalsecondperday =86_400;
    function Duration() public view returns(uint256){
       uint day = (block.timestamp - deployTime) / totalsecondperday;
       return day;
    }

    event InvestmentRecorded(uint256 id,address investor,string assetName,uint256 principal,Continent continent);

    function addInvestment( uint256 _id,  string memory _assetName,Continent _continent, AssetClass _assetClass ) external payable {
    require(msg.value > 0, "Invalid Amount");
    require(_continent != Continent.None, "Select Continent");
    require(!idUsed[_id], "ID Exists");
    ledger[_id] = Investment({
        id: _id,
        investor: msg.sender,
        assetName: _assetName,
        principal: msg.value,
        timestamp: block.timestamp,
        continent: _continent,
        assetClass: _assetClass });
    idUsed[_id] = true;
    totalInvestmentsCount += 1;
    emit InvestmentRecorded( _id,  msg.sender, _assetName, msg.value, _continent);
   }
    
    error InvestmentNotExist();
    function getDaysUnderManagement(uint256 _id) public view returns (uint256 daysUnderMgmt){
         if (!idUsed[_id] ) {
            revert InvestmentNotExist();
        }
        daysUnderMgmt = (block.timestamp - ledger[_id].timestamp)/totalsecondperday;
        return daysUnderMgmt;
    }

} 
