// SPDX-License-Identifier: GPL-3.0
pragma solidity>=0.5.0<0.9.0;

contract lottery{
    address public manager;
    address payable[] public participants;

    constructor()
    {
        // address of manager who can control the contract
        manager=msg.sender; //Transfering address to the manager and msg.sender is global variable
    }

//we will make payable function so that partic can pay ether to contract

//payable function which will help in receiving some ether in contract , it is used only one times

    receive() external payable{
        require(msg.value==1 ether);
        participants.push(payable(msg.sender));  //pushing address of parti who is transfering the ether to contract

    }
    function getBalance() public view returns(uint)
    {
        require(msg.sender==manager);
        return address(this).balance;
    }

    // Random function
    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length)));
    }


    // select winner

    function selectWinner() public
    {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r=random();
        address payable winner;
        uint index =r % participants.length;
        winner=participants[index];
        winner.transfer(getBalance());
        participants=new address payable[](0);   // making Dyanamic array size 0
    }
}