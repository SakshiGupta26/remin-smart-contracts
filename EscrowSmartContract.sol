// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;



contract  EscrowSmartContract{
    
     event EscrowCreated(uint id, address buyer,address,address seller,uint amount);
     event EscrowAccepted(uint id);
     event DeliveryConfirnmed(uint id);
     event PaymentReleased(uint id, uint amount);
     event DisputeRaised(uint id);
     event DisputeResloved(uint id, bool buyerRefunded);
     event EscrowCancelled(uint id);

    address public buyer;
    address public seller;
    address public arbiter;
    address public platformWallet;

    enum Status {
        AWITING_PAYMENT,
        AWAITING_DELIVERY,
        DELIVERED,
        DISPUTED,
        RESOLVED,
        CANCELLED
    }

    struct Escrow {
        uint id;
        address seller;
        uint amount;
        uint createAt;
        uint deliveryDeadline;
        uint releasedAmount;
        Status status;
        bool buyerApproved;
    }

    uint public escrowCount;
    mapping(uint => Escrow) public escrow;

    error ShouldHaveSufficientBalance();
    error BuyerShouldNotBeSeller();


    function createEscrow(address _seller,uint _deadline) public payable{
        if(msg.value == 0){
            revert ShouldHaveSufficientBalance();
        }
        if(msg.sender == _seller){
            revert BuyerShouldNotBeSeller();
        }
       escrowCount = escrowCount + 1;
       escrow[escrowCount] = Escrow({ 
        id: escrowCount,
        seller: _seller,
        amount: msg.value,
        createAt: block.timestamp,
        deliveryDeadline:_deadline,
        releasedAmount:msg.value,
        status:AWAITING_DELIVERY,
        buyerApproved:false
        })
        emit EscrowCreated(escrowCount,_seller,msg.sender,msg.value); 
    }
    
}
