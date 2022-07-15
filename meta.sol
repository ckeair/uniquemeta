//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract LirnOnboard is ERC1155, Ownable {

    
    string public name;
    string public symbol; 
    mapping (uint256 => string) private _uris;
    mapping(address => mapping (uint256 => uint256))  public supplyBalance;


    constructor() ERC1155("") {
        name = "learn";
        symbol = "learn";

    }

    function mintNtt(address _adr, uint256 tokenid ) external { // removed onlyOwner for demo
            require(supplyBalance[_adr][tokenid] < 1, "Already owns Quiz1 NFT");
            _mint(_adr, tokenid, 1, "");
            supplyBalance[msg.sender][tokenid] += 1;
    }

    function burnToken(address _adr, uint256 _id) external onlyOwner {
            _burn(_adr, _id, 1);
            supplyBalance[msg.sender][_id] -= 1;
    }


    // URI overide for number schemes
    function uri(uint256 tokenid) override public view returns (string memory) {
        return (_uris[tokenid]);
    }
    function setTokenUri(uint256 tokenid, string memory uri) public onlyOwner {
        require(bytes(_uris[tokenid]).length == 0, "Cannot set uri twice"); 
        _uris[tokenid] = uri; 
    }
    
    
    //Make Nontranferable
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
        // Ignore transfers during minting
        if (from == address(0)) {
            return;
        }
        require(
            to == address(0),
            "Cannot transfer knowledge fam"
        );
    }


}
