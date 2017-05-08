## Chain Forge

A blockchain tutorial from [Coder Forge](http://coderforge.io)

# Part 2

What we are going to attempt here is run a `mock` ethereum node locally, to
build out and test handling of funds (`ether`) between our contracts and the
organiser. With this there will be a second tool that will server our web
application and deploy our contracts to the `mock` ethereum node, then later
deploy to the `ethereum testnet`. We will leave deploying to the live
ethereum network for you to do, with proper instructions of course ;) There
are many tools for the job:

 - [testrpc](https://github.com/ethereumjs/testrpc) mock ethereum node to build and test against.
 - [geth](https://github.com/ethereum/go-ethereum/wiki/geth) command line for creating local private network or running as node.
 - [parity](https://github.com/paritytech/parity) mock and live node in one, has handy web interface as well.
 - [truffle](http://truffleframework.com/) tool for building web interfaces and deploying contracts to mock or
 live nodes.


### Tools

The tools we will be using from the list above are:

 - [parity](https://github.com/paritytech/parity) Ethereum Node.
 - [truffle](http://truffleframework.com/) For our Dapp.

Both above require `nodejs` to be installed. I highly recommend using a `node
version manager` for your particular operating system. Once you have node
installed then move on to install parity and truffle...

##### Install Truffle

Truffle serve's two purposes:

 1. A deploy tool.
 2. A webserver provitioned for `Dapp`'s.

As a deployment and development tool we will use truffle for deploying our
contracts and building the web application, all of which compose our Dapp.

We can easily install it with the command:

```bash
npm install -g truffle
```

If you have any issues installing please leave an issue, that way we can
improve this documentation where ever possible.

##### Install Parity

Parity is a cool tool for Dapp development. It can sync to the live ethereum
network, the test network, or run a local mock network. Also the team at
`paritytech` have provided us with installers, head to the releases section
and install the revelant package for your operating system...

https://github.com/paritytech/parity/releases

You can find documentation for Parity in their [github wiki](https://github.com/paritytech/parity/wiki).
Of special interest to us is the instructions for creating a [local private
development chain](https://github.com/paritytech/parity/wiki/Private-development-chain)

##### Setting up for mock network

First we will start our Parity node with the command...

```bash
parity --chain dev
```

As the [documentation](https://github.com/paritytech/parity/wiki/Private-development-chain)
states, you can create default accounts using the command line or the handy
user interface at: [http://localhost:8080](http://localhost:8080)

We will describe setting up using the user interface here, head to
[http://localhost:8080](http://localhost:8080)

 1. 1st screenshot
 2. 2nd screenshot
 3. 3rd screenshot

This address you created is the default address, also known as the coinbase.

##### Talk to our private net

Next we are going to use a node library called `web3`, this is perfect for
communicating with the a blockchain network. The `RPC` port of parity is set at
default: `8485`. These commands can easily be put in a file and run with node,
but its much easier to use from the node console as you get method lists from
objects.

From the directory you ran `truffle init webpack` from, should be current,
start the node console with:

```
node
```

In the output load the `web3` package, should have been auto installed with
`truffle` command above...

```node
> Web3 = require('web');    // notice capital 'W'
```

which should return

```
{ [Function: Web3]
  providers:
   { HttpProvider: [Function: HttpProvider],
     IpcProvider: [Function: IpcProvider] } }
```

Next create an instance connected to our local RPC port that parity has
exposed...

```node
> web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
```

To test that we are connected we will check the current block number of our
private test net...

```node
> web3.eth.blockNumber
```

It should return `0` because no blocks have been mined, because there is
nothing mining this private local testnet.





### Child releases funds to organiser

All of the blockchain world has an attack surface. There are numerous ways that
an attacker can syphon your funds into their account. It almost always
involves contracts that have methods working with funds and a loop. The method
below may be the best way of doing this, at time of writing, but as the
language and technology evolve, new solutions and complexity will mean that new
threats will be discoverd.

Our child contract must receive funds, as a security precaution only methods
that have the `payable` `modifier` can work with incoming funds. So we will
create a `catchall` method that will store the quantity of funds in a
`property`, we will then have a method to release whatever value is in this
`property` to the `orgWallet` address that the child contract was created with.

`Child`

```javascript
    mapping(address => uint) funds;
```

Here we are creating an array of `address`'s with values that are `uint` called
`funds`. There will only every be one item in the array, with the `orgWallet`
as its index, but its good practice, where ever funds are linked to one account,
to use this pattern. It means if you want to add / manage another address at a
later date you have no refactoring to do. Blockchain Dapp's are microservices
architecture, the contracts are small and many, each reading from another.

`Child`

```javascript
    // catch all
    function() payable{
        funds[_organiser] += msg.value;
    }
```

Here is the `magic method` `catchall`. Like ronseal, it litteraly does what it
says on the tin. Use the `function` keyword without a name and add the
`payable` modifier, now all funds sent to this contract, without calling one
of the existing methods, will be caught by this method. We take the value that
is being sent and store it as a `uint` in the `funds[address]` array, under
the index `_organiser`.

`Child`

As `child` creation is protected by only allowing an owner address, we want to
the public to be able to script calls to their `child` contract. We can't
check that the call comes from the `owner` or `orgWallet` address's, so here
we have a massive attack surface in the world of ethereum.

A method that deals with fund transfere that is fully public.

```javascript
    // release funds to organizer
    function payOrganizer() payable returns(bool){


        uint fund = funds[_organiser];
        funds[_organiser] = 0;

        if(!_organiser.send(fund)){
            TransferStatus('it failed');
            funds[_organiser] = fund;
        }
        else{
            TransferStatus('success');
        }
        return true;
    }
```
