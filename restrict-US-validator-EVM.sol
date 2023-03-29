pragma solidity ^0.8.0;

contract USValidationRestriction { mapping (string => string) private _ipCountry; address private _owner;

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

