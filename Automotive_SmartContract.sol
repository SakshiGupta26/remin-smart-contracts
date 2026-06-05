// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AutomotiveSmartContract {
    address public immutable owner;
    uint256 public nextVehicleId;
    uint128 public price;

    struct Vehicle {
        string make;
        string model;
        uint128 price;
        address owner;
    }

    mapping(uint256 => Vehicle) public vehicles;

    error NotOwner();
    error InsufficientPayment();
    error NotVehicleOwner();
    error VehicleDoesNotExist();

    event Purchase(
        uint256 indexed vehicleId,
        address indexed buyer,
        string make,
        string model,
        uint128 price
    );

    constructor() {
        owner = msg.sender;
    }

    function setPrice(uint128 _price) external {
        if (msg.sender != owner) {
            revert NotOwner();
        }

        price = _price;
    }

    function buyVehicle(
        string calldata _make,
        string calldata _model
    ) external payable {
        if (msg.value < price) {
            revert InsufficientPayment();
        }

        uint256 vehicleId = nextVehicleId++;

        vehicles[vehicleId] = Vehicle({
            make: _make,
            model: _model,
            price: price,
            owner: msg.sender
        });

        emit Purchase(
            vehicleId,
            msg.sender,
            _make,
            _model,
            price
        );
    }

    function transferVehicle(
        uint256 vehicleId,
        address newOwner
    ) external {
        Vehicle storage vehicle = vehicles[vehicleId];

        if (vehicle.owner == address(0)) {
            revert VehicleDoesNotExist();
        }

        if (vehicle.owner != msg.sender) {
            revert NotVehicleOwner();
        }

        vehicle.owner = newOwner;
    }

    function checkOwnership(
        uint256 vehicleId
    ) external view returns (bool) {
        return vehicles[vehicleId].owner == msg.sender;
    }

    function withdraw() external {
        if (msg.sender != owner) {
            revert NotOwner();
        }

        payable(owner).transfer(address(this).balance);
    }

    function getVehicle(
        uint256 vehicleId
    )
        external
        view
        returns (
            string memory make,
            string memory model,
            uint128 vehiclePrice,
            address vehicleOwner
        )
    {
        Vehicle storage vehicle = vehicles[vehicleId];

        if (vehicle.owner == address(0)) {
            revert VehicleDoesNotExist();
        }

        return (
            vehicle.make,
            vehicle.model,
            vehicle.price,
            vehicle.owner
        );
    }
}
