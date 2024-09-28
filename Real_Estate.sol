//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Real_State {

    struct Property {            // what we want in our property to show to the customer
        uint price;
        address owner;
        bool forSale;
        string name;
        string location;
    }

    mapping(uint => Property) public properties;  //  is going to store all the properties
    uint[] public propertIDS; // will going to store all the ids of the homes

    event PropertySold(uint propertId);

    //fuction to list a new property
    function listProperty(uint _propertyId, uint _price, string memory _name, string memory _location) public{

        Property memory newProperty = Property({
            price : _price,
            owner : msg.sender,
            forSale : true, //since wo list kr rha hai
            name : _name,  // propert kaa name
            location : _location // haryana ka mat daal dena koi nahi lega teri property
        });

        properties[_propertyId] = newProperty;
        propertIDS.push(_propertyId);
    }

    //function to buy a listed property
    function buyProperty(uint _propertyId) public payable{  //allowing the user to send fund during the transaction

        Property storage property = properties[_propertyId];   // whatever happens here the data sholud persisted in the blockchain thats why we used storage

        require(property.forSale, "Property is not for Sale");
        require(msg.value >= property.price, "Insufficient Funds");  //waha par jo wo pay kr rha hai wo hai msg.value

        (bool success,) = payable(property.owner).call{value: property.price}("");  //The payable keyword is used to indicate that the address property.owner can receive Ether
        require(success, "Transfer failed.");  //step to stop the transfer in case of the payment failure


        property.owner = msg.sender;
        property.forSale = false;

        emit PropertySold(_propertyId);

    }
    
}