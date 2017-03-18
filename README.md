## Chain Forge

A blockchain tutorial from [Coder Forge](http://coderforge.io)

*Currently this project is a work in progress.*
*Project is conceptual only, not ready for production servers.*
*You have been warned... 3 times*

Another shout...
*Unstable. This project is currently being bumped up to truffle v3*

# The project.

The end goal is when a user registers they get their own smart contract
automatically generated for them. This smart contract will have the ability to
accept funds from anyone, but release them to just the user.

It would be possible to have just one smart contract, as a template, and then
deploy that when a user registers - but we would loose control, and there is no
method to make a change or fix a bug to a contract. So we will be using a
facade pattern. A parent contract will act as a controller and factory to
generate child contracts, one child contract for each user.

In the case of Coder Forge this is revolutionary, it means that each individual
Forge can manage their own sponsorship should they need funds for rent or
insurance. All transactions are open and publicly viewable using simple online
blockchain browsers.

# Plan of action

We will be using Remix online solidity browser, run locally, to prototype our
contracts. We can then watch the contracts send funds to each other using
Metamask.

 1. Start up `testrpc`
 2. Start up `Remix Solidity Browser`
 3. MetaMask to monitor transactions and accounts (Uninstall / reinstall needed each time, solution?)

Once we are happy with the functionality of the contracts then we will build our
we app using `truffle`. Working with truffle will involve:

 1. Comile our contracts
 2. Deploy them to our local blockchain (migrate)
 3. Update the address of the parent contract.

# About truffle-init-webpack
This project is build using the webpack project with Truffle. Includes contracts, migrations, tests, user interface and webpack build pipeline.
Project built using [truffle-init-webpack](https://github.com/trufflesuite/truffle-init-webpack)

## Installation
```
npm install -g ethereumjs-testrpc truffle
npm install
```

## Runhing

In first terminal window...
```
testrpc -b 1
```
In second terminal run...
```
truffle compile
truffle migrate
npm run build
npm run dev
```
