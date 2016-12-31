pragma solidity ^0.4.2;

import 'Forge.sol';

contract CoderForge{

    address owner;

    address[] forges;

    event LogForge(
        address _from,
        address forge
    );

    function CoderForge(){
        owner = msg.sender;
    }

    function newForge(bytes32 name, bytes32 organiser, bytes32 url) returns (address){

        Forge forge = new Forge();
        forge.setName(name);
        forge.setOrganiser(organiser);
        forge.setUrl(url);
        LogForge(owner, forge);

        return forge;
    }

    function kill() returns(bool){
        if(msg.sender==owner){
            selfdestruct(msg.sender);
            return true;
        }
        return false;
    }
}
