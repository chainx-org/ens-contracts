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

    function price(uint expires,uint256 duration) external view returns(uint) {
        uint basePrice = rentPrices.mul(duration);
        basePrice = basePrice.add(premium(expires));
        return basePrice;
    }

    function premium(uint expires) internal view returns(uint) {
        if(block.timestamp > expires){
            return 10000000000000000000;
        }
        return 0;
    }

    function setPrices(uint256 _rentPrices) public onlyOwner {
        rentPrices = _rentPrices;
        emit RentPriceChanged(_rentPrices);
    }

    function supportsInterface(bytes4 interfaceID) public view virtual returns (bool) {
        return interfaceID == INTERFACE_META_ID || interfaceID == ORACLE_ID;
    }
}
