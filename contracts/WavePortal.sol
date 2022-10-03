// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "hardhat/console.sol";

//contract adress:0x44a6BF59998866d2A2757BF1EA3175F7ADD0dBaC
contract WavePortal {
    uint256 totalWaves;

    event NewWave(address indexed sender, uint256 timeStamp, string message);

    struct Wave {
        address sender;
        uint256 timeStamp;
        string message;
    }

    Wave[] waves;

    uint256 seed;

    mapping(address => uint256) lastWaved;

    constructor() payable {
        console.log("Yo yo I am smartcontract and I am smart");
    }

    function wave(string memory _message) public {
        require(
            (lastWaved[msg.sender] + 15 minutes) < block.timestamp,
            "Wait for 15 Minutes"
        );

        lastWaved[msg.sender] = block.timestamp;

        console.log("%s has waved at you!!", msg.sender);
        waves.push(Wave(msg.sender, block.timestamp, _message));
        totalWaves += 1;

        seed = (block.timestamp + block.difficulty + seed) % 100;

        console.log("%d Seed Generated!", seed);

        if (seed > 50) {
            uint256 giftEther = 0.0001 ether;

            console.log("%d address(this).balance!", address(this).balance);
            console.log("%d giftEther!", giftEther);

            require(
                giftEther <= address(this).balance,
                "Contract Fund is not Enough to gift!!"
            );

            (bool success, ) = (msg.sender).call{value: giftEther}("");
            require(success, "Gift transfer is failed!!");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getTotalWaves() public view returns (Wave[] memory) {
        console.log("You have totalWaves like %d ", totalWaves);
        return waves;
    }
}
