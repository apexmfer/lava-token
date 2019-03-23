pragma solidity ^0.5.0;



/**------------------------------------

LAVA Token Demutator

This is a Lava Middleman contract that can be the target of Lava Packets for ApproveAndCall.

This will unmutate lava tokens back to the master token.


------------------------------------*/


/*
contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
*/

contract ERC721Interface {

  function balanceOf(address _owner) external view returns (uint256);
  function ownerOf(uint256 _tokenId) external view returns (address);

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
  function approve(address _approved, uint256 _tokenId) external payable;
  function setApprovalForAll(address _operator, bool _approved) external;
  function getApproved(uint256 _tokenId) external view returns (address);
  function isApprovedForAll(address _owner, address _operator) external view returns (bool);

  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

}

contract NametagInterface {
    function claimToken( address to,  string memory name  ) public  returns (bool);
    function reserveToken( address to, uint256 tokenId ) public  returns (bool);
}


contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}


contract NTTBuyer{


  address nametagTokenAddress;

    constructor(address nttAddress ) public {
      nametagTokenAddress = nttAddress;
    }

    /**
    * Do not allow ETH to enter
    */
     function() external payable
     {
         revert();
     }


    function _claimNametagToken(address from, string memory name) internal returns (bool success) {

          uint256 tokenId = (uint256) (keccak256(abi.encodePacked( name )));

          //claim the token for this contract
          require(NametagInterface(nametagTokenAddress).claimToken(address(this), name ));

          //send the token to the owner
          require(ERC721Interface(nametagTokenAddress).transferFrom(address(this), from, tokenId));

         return true;
     }

       /*
         Receive approval from ApproveAndCall() to claim a nametag token.

       */
     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public returns (bool success) {

        require(_claimNametagToken( from, data ));

        return true;

     }







}
