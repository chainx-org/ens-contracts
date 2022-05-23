// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "./SafeMath.sol";
import "./StringUtils.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// StablePriceOracle sets a price in USD, based on an oracle.
contract StablePriceOracle is Ownable {
    using SafeMath for *;
    using StringUtils for *;

    // Rent in base price units by length. Element 0 is for 1-length names, and so on.
    uint256 public rentPrices;

    event RentPriceChanged(uint prices);

    bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));
    bytes4 constant private ORACLE_ID = bytes4(keccak256("price(uint256)"));

    constructor(uint256  _rentPrices) {
        setPrices(_rentPrices);
    }

    function price(uint256 duration) external view returns(uint) {
        return rentPrices.mul(duration);
    }

    function setPrices(uint256 _rentPrices) public onlyOwner {
        rentPrices = _rentPrices;
        emit RentPriceChanged(_rentPrices);
    }


    function supportsInterface(bytes4 interfaceID) public view virtual returns (bool) {
        return interfaceID == INTERFACE_META_ID || interfaceID == ORACLE_ID;
    }
}
