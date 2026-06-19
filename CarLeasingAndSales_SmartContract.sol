
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CarLeasingAndSales_SmartContract {

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    struct Car {
        uint256 id;
        string vin;
        string make;
        string model;
        uint16 year;
        uint256 price;
        address owner;
        bool availableForSale;
        bool availableForLease;
    }

    struct Lease {
        uint256 carId;
        address lessor;
        address lessee;
        uint256 monthlyPayment;
        uint256 leaseDuration;
        uint256 paymentsMade;
        uint256 startTime;
        bool active;
    }

    uint256 public nextCarId;

    mapping(uint256 => Car) public cars;
    mapping(uint256 => Lease) public leases;

    event CarRegistered(
        uint256 indexed carId,
        string vin,
        address owner
    );

    event CarPurchased(
        uint256 indexed carId,
        address seller,
        address buyer,
        uint256 amount
    );

    event LeaseStarted(
        uint256 indexed carId,
        address lessor,
        address lessee
    );

    event LeasePaymentMade(
        uint256 indexed carId,
        address lessee,
        uint256 paymentNumber
    );

    event LeaseCompleted(
        uint256 indexed carId,
        address lessee
    );

    function registerCar(
        string memory _vin,
        string memory _make,
        string memory _model,
        uint16 _year,
        uint256 _price,
        bool _forSale,
        bool _forLease
    ) public {

        cars[nextCarId] = Car({
            id: nextCarId,
            vin: _vin,
            make: _make,
            model: _model,
            year: _year,
            price: _price,
            owner: msg.sender,
            availableForSale: _forSale,
            availableForLease: _forLease
        });

        emit CarRegistered(
            nextCarId,
            _vin,
            msg.sender
        );

        nextCarId++;
    }

    function purchaseCar(uint256 _carId)
        public
        payable
    {
        Car storage car = cars[_carId];

        require(car.availableForSale, "Not for sale");
        require(msg.value >= car.price, "Insufficient payment");
        require(msg.sender != car.owner, "Already owner");

        address seller = car.owner;

        payable(seller).transfer(msg.value);

        car.owner = msg.sender;
        car.availableForSale = false;
        car.availableForLease = false;

        emit CarPurchased(
            _carId,
            seller,
            msg.sender,
            msg.value
        );
    }

    function startLease(
        uint256 _carId,
        address _lessee,
        uint256 _monthlyPayment,
        uint256 _durationMonths
    ) public {

        Car storage car = cars[_carId];

        require(msg.sender == car.owner, "Not owner");
        require(car.availableForLease, "Not available");

        leases[_carId] = Lease({
            carId: _carId,
            lessor: msg.sender,
            lessee: _lessee,
            monthlyPayment: _monthlyPayment,
            leaseDuration: _durationMonths,
            paymentsMade: 0,
            startTime: block.timestamp,
            active: true
        });

        car.availableForLease = false;

        emit LeaseStarted(
            _carId,
            msg.sender,
            _lessee
        );
    }

    function makeLeasePayment(uint256 _carId)
        public
        payable
    {
        Lease storage lease = leases[_carId];

        require(lease.active, "Lease inactive");
        require(msg.sender == lease.lessee, "Not lessee");
        require(
            msg.value == lease.monthlyPayment,
            "Incorrect payment"
        );

        payable(lease.lessor).transfer(msg.value);

        lease.paymentsMade++;

        emit LeasePaymentMade(
            _carId,
            msg.sender,
            lease.paymentsMade
        );

        if (
            lease.paymentsMade >= lease.leaseDuration
        ) {
            lease.active = false;

            emit LeaseCompleted(
                _carId,
                msg.sender
            );
        }
    }

    function transferOwnership(
        uint256 _carId,
        address _newOwner
    ) public {

        Car storage car = cars[_carId];

        require(msg.sender == car.owner, "Not owner");

        car.owner = _newOwner;
    }

    function setForSale(
        uint256 _carId,
        uint256 _price
    ) public {

        Car storage car = cars[_carId];

        require(msg.sender == car.owner, "Not owner");

        car.price = _price;
        car.availableForSale = true;
    }

    function setForLease(
        uint256 _carId
    ) public {

        Car storage car = cars[_carId];

        require(msg.sender == car.owner, "Not owner");

        car.availableForLease = true;
    }

    function getCar(
        uint256 _carId
    )
        public
        view
        returns (
            Car memory
        )
    {
        return cars[_carId];
    }

    function getLease(
        uint256 _carId
    )
        public
        view
        returns (
            Lease memory
        )
    {
        return leases[_carId];
    }
}
