pragma solidity ^0.5.0;



/**------------------------------------

Lava Minter  Middleman

Spend LAVA tokens to solo mine 0xBTC more easily.  Each solo miner must deploy their own copy of this contract.

------------------------------------*/



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



contract EIP918Interface {


    function mint(uint256 nonce, uint256 challenge_number) public returns (bool success);

    function getAdjustmentInterval() public view returns (uint);

    function getChallengeNumber() public view returns (bytes32);

    function getMiningDifficulty() public view returns (uint);

    function getMiningTarget() public view returns (uint);

    function getMiningReward() public view returns (uint);

    function decimals() public view returns (uint8);

    event Mint(address indexed from, uint rewardAmount, uint epochCount, bytes32 newChallengeNumber);

}


contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}


contract LavaMinter{

     address masterToken ;
     address payoutAddress ;

    constructor(address payout) public {
       payoutAddress = address(payout);
       masterToken = address(0xB6eD7644C69416d67B522e20bC294A9a9B405B31);
    }

    /**
    * Do not allow ETH to enter
    */
     function() external payable
     {
         revert();
     }


    function _purchaseOrder(bytes32 orderHash, address recipientAddress) internal returns (bool success) {

        /*  uint256 tokenId = (uint256) (keccak256(abi.encodePacked( name )));

          //claim the token for this contract
          require(NametagInterface(nametagTokenAddress).claimToken(address(this), name ));

          //send the token to the owner
          ERC721Interface(nametagTokenAddress).transferFrom(address(this), from, tokenId)  ;
          */

         return true;
     }

       /*
         Receive approval from ApproveAndCall() to claim a nametag token.

       */
     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public returns (bool success) {

       bytes32 bnonce;
       bytes32 bchallengeNumber;

       // Divide the data into variables
        //  assembly {
        //    borderHash := mload(add(data, 32))
        //    brecipientAddress := mload(add(data, 64))
        //  }

          assembly {
            bnonce := mload(add(data, 32))
            bchallengeNumber := mload(add(data, 64))
          }


        uint256 nonce = uint256(bnonce);
        uint256 challengeNumber =   uint256(bchallengeNumber);


        uint256 tokensRewarded = EIP918Interface(masterToken).getMiningReward() ;


        require(   EIP918Interface(masterToken).mint(nonce,challengeNumber)   );

        require(   ERC20Interface(masterToken).transfer( payoutAddress, tokensRewarded)  ) ;

        return true;

     }



}
