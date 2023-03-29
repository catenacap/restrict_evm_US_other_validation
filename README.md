# Restrict EVM from processing transactions on a US Based Validator/Minor Node.

**EVM_IP_Based_Restrictions**

The following mechanism added into your smart contract's will add the function to reject validation or mining from nodes located in the United States**[1]**,**[2]**,**[3]**. 

**[1]** Understand this is not specific to the US, due to regulatory lack of clarity, it would be prudent to cut the US from validation processes for validating transactions/smart-contracts processes in the US so as to avoid regulatory action against the project/company/developer. 

**[2]** Replace US with or addition to other countries you wish to restrict from processing your transactions/smart-contract processes.

**[3]** Look for (advisable) friendly states where there is no concern for regulatory attacks based on 1 or % of transactions processing through validators/miners in those states (suggestions : BVI, Thailand, Singapore, UAE, Bahamas, Malaysia.

**1)** Start by importing the necessary Ethereum libraries and defining the contract:

pragma solidity ^0.8.0;

contract USValidationRestriction {
    // Declare the state variables and functions here
}

2) Declare a mapping that associates IP addresses with their corresponding countries. You can use a public API such as ipstack.com or ipapi.com to retrieve this information. Make sure to declare the mapping as private to prevent external access:
csharp

mapping (string => string) private _ipCountry;

3) Create a function to update the IP-country mapping. This function should be restricted to the contract owner, who has the authority to add or remove IP addresses as necessary. For example:
csharp

function updateIpCountryMapping(string memory ipAddress, string memory country) public onlyOwner {
    _ipCountry[ipAddress] = country;
}

4) Define a modifier that restricts access to certain functions based on the IP-country mapping. This modifier should check if the IP address of the node that is validating or mining the contract is located in the United States. If so, it should revert the transaction and prevent the contract from being executed. For example:
less

modifier onlyNonUS() {
    string memory country = _ipCountry[tx.origin];
    require(keccak256(bytes(country)) != keccak256(bytes("United States")), "US-based node detected.");
    _;
}

5) Apply the onlyNonUS modifier to the functions that you want to restrict to non-US nodes. For example:
csharp

function myRestrictedFunction() public onlyNonUS {
    // This function can only be called from nodes located outside the United States
    // ...
}

By using this approach, you can ensure that your smart contract only operates from nodes that are located outside the United States, as required by your regulatory requirements.


-----
####
pragma solidity ^0.8.0;

contract USValidationRestriction {
    mapping (string => string) private _ipCountry;
    address private _owner;

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the contract owner can call this function.");
        _;
    }

    modifier onlyNonUS() {
        string memory country = _ipCountry[tx.origin];
        require(keccak256(bytes(country)) != keccak256(bytes("United States")), "US-based node detected.");
        _;
    }

    function updateIpCountryMapping(string memory ipAddress, string memory country) public onlyOwner {
        _ipCountry[ipAddress] = country;
    }

    function myRestrictedFunction() public onlyNonUS {
        // This function can only be called from nodes located outside the United States
        // ...
    }
}

###
---

The 'onlyOwner' modifier restricts access to the 'updateIpCountryMapping' function to the contract owner, who has the authority to update the IP-country mapping.

The 'onlyNonUS' modifier checks if the IP address of the node that is calling the function is located in the United States. If so, it reverts the transaction and prevents the function from being executed.

The 'myRestrictedFunction' function is an example of a function that is restricted to non-US nodes. It can only be called from nodes located outside the United States.

You can customize the IP-country mapping and the country name used in the 'onlyNonUS' modifier to meet your specific regulatory requirements. Also, keep in mind that this approach relies on the accuracy and reliability of the external API used to retrieve the country information, so you should choose a reputable and trustworthy provider.

--
How does it check the IP address of the validator node?

The IP address of the validator or miner is retrieved through the tx.origin variable, which represents the address of the sender of the transaction that triggered the function call.

When a validator or miner submits a transaction to the Ethereum network, they include their IP address in the transaction payload. The tx.origin variable allows you to retrieve this information and use it to determine the country of origin of the node.

The IP address is then used as a key in the _ipCountry mapping to retrieve the corresponding country value. If the country is detected as "United States", the onlyNonUS modifier reverts the transaction and prevents the function from being executed.

Note that this approach relies on the accuracy and reliability of the IP-country mapping and external APIs used to retrieve this information. It's also possible for malicious actors to spoof their IP addresses or use proxy servers to bypass this restriction. Therefore, you should use this mechanism in combination with other security measures to ensure the integrity and safety of your smart contract.
