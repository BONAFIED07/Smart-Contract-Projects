//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{

    address payable[] public players;
    address public manager;



    constructor(){
        manager = msg.sender;
    }

    receive () payable external{
        require(msg.value == 50000000000000000);
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }


    function pickWinner() public{

        require(msg.sender == manager);
        require (players.length >= 3);

        uint r = random();
        address payable winner;
        uint index = r % players.length;
        winner = players[index];
        winner.transfer(getBalance());

        players = new address payable[](0);
    }

}


