---
layout: post
title: "Writing Smart Contracts With Truffle"
date: 2017-07-08T23:10:06-07:00
categories: ethereum smart-contracts truffle
---
In my article [Smart contracts for the
impatient](/blog/2017/06/13/smart-contracts-for-the-impatient/) I
documented how to deploy a contract using Mist to the testnet Rinkeby.

While it is a good example for demonstration purposes, we'll probably
go crazy if we try to deploy a Ðapp or contract doing everything
manually.

What if we could develop for Ethereum, just as if we were building yet
another JavaScript application. What if we could:

- Automatically test our contracts or Ðapps before deploying to a real network?
- Deploy contracts with a simple command?
- Write contracts in a modular way?
- Interact with our contracts through a CLI?
- Have automatic linting?

## Truffle

[Truffle](http://truffleframework.com/docs/) is a development
framework for Ethereum, it not only offers all the things listed above
but even more!

From their README, they describe themselves as:

> YOUR ETHEREUM SWISS ARMY KNIFE

For people familiar with JavaScript and Ember.js, we could say Truffle
is the [ember-cli](https://ember-cli.com/) for Ethereum.

The goal of this article is to teach people how to:

- Install Truffle.
- Use the Ethereum RPC client for testing and development.
- Familiarize with the basic concepts in Truffle.
- Write the "Hello World" contract including tests.
- Deploy the contract to Rinkeby.

Basic familiarity with JavaScript and Node.js is required, and we
assume people is using macOS and Node.js higher or equal to 7.6.

## Installing Truffle

We can install Truffle using `npm`, from [their guide](http://truffleframework.com/docs/getting_started/installation):

```
npm install -g truffle
```

After running the command above, we should we able to do the following and see some kind of output:

```
$ truffle
Truffle v3.2.5 - a development framework for Ethereum

Usage: truffle <command> [options]

Commands:
  init      Initialize new Ethereum project with example contracts and
            tests
  compile   Compile contract source files
  migrate   Run migrations to deploy contracts
  deploy    (alias for migrate)
  build     Execute build pipeline (if configu
```

## Testrpc

In theory we could use Rinkeby for development, but relying on a real
blockchain for development is not very efficient. We don't want to use
our test Ether or wait for transactions to complete. Also, since we
don't have control of such network, it would be very hard for us to
write test in a deterministic way.

The Ethereum JavaScript community has an Ethereum RPC client for
testing and development, which allow us to mock our interactions with
a real network.

The name of the project is [testrpc](https://github.com/ethereumjs/testrpc):

> testrpc is a Node.js based Ethereum client for testing and development. It uses ethereumjs to simulate full client behavior and make developing Ethereum applications much faster. It also includes all popular RPC functions and features (like events) and can be run deterministically to make development a breeze.

Since it's published as an npm package, we can install it with the following command:

```
npm install -g ethereumjs-testrpc
```

Once `testrpc` is installed, we can start the client by running `testrpc`.

```
$ testrpc
EthereumJS TestRPC v3.0.5

Available Accounts
==================
(0) 0x05dd2f0e2c917d2f83770403359cab4b1645ab9c
(1) 0xaefcaeeda04808db06abf62a29cfccc2892c48e3
(2) 0xbd3d2750e62063ace2f6bc7157e4d8a81c36093b
(3) 0x91c86d236cc301756effae9db74ce8cb3a3c6a1e
(4) 0x1fed08900dd0420235dc9bb812483299f74200e2
(5) 0xe42e9f89b2d96ab6dd4711da4ebee4d0f792fb1b
(6) 0x4166f9a27a7303f3c820d85c0f1641315cfa0474
(7) 0x51691ae53211fa46c4b1b99d42255e02905f400f
(8) 0x8dbfdced435891e24e0fa4c54dde78ea843f94e2
(9) 0xcbd1865983eabac38e3816cdc257bb4fcc65f9d0

Private Keys
==================
(0) 8f2dbfaab1307655f2e5751e9f4ff997b5ce312b4b50b14cbd26cb71f89b5b0e
(1) 2c8c794d7f82ccccdad471aa9d82f59c13396ec266c5cbc227bfe5a7df04f94f
(2) 55d116cef11e807098f5dac5120b843b1535235241a044f7a0a50cefbd2e3b8e
(3) 63ef474c8f686774d38f420af459ad32978757dc40c9c28fbdfc46aa161f5362
(4) 5719fa65b2f360b778dff07ef7daad555cfee0b80988c8a5480a9241c63a5898
(5) 0b73f66a37fb65dd6410c55ae0293899bf72ccc98b18766b5bc107bfac40f0d7
(6) 46d745be848383573207615b213abde5c70ec078d2bf087de9de4e1b577368ee
(7) d3b4a15fb0f13a77c34edd5e630bae7c4faf49eba81573a274fa2abe14db3759
(8) fdfd64d0167d716bc743bdd1ddb45bb82a6d01fa6db02cebbb8d568dd57b91d3
(9) 1ae6c6c0cbf4d380adef1a718bf2a2cd62a89212f60cf672a77aaeeb543c1a80

HD Wallet
==================
Mnemonic:      audit can stock squeeze equip aerobic abuse access fringe grocery stone novel
Base HD Path:  m/44'/60'/0'/0/{account_index}

Listening on localhost:8545
```

As a quick test, we can start `Mist` using this client instead of geth and then we should see all the wallets listed above with some Ether.

```
/Applications/Mist.app/Contents/MacOS/Mist --rpc http://localhost:8545
```

Keep `testrpc` running and now let's start using Truffle.

## Starting a project

To create a new project do the following:

```
$ mkdir hello-world
$ cd hello-world
$ truffle init
```

After creating the project, we'll see a basic skeleton app, we can test that everything is working by running the default test:

```
$ truffle test
Using network 'development'.

Compiling ./contracts/ConvertLib.sol...
Compiling ./contracts/MetaCoin.sol...
Compiling ./test/TestMetacoin.sol...
Compiling truffle/Assert.sol...
Compiling truffle/DeployedAddresses.sol...


  TestMetacoin
    ✓ testInitialBalanceUsingDeployedContract (63ms)
    ✓ testInitialBalanceWithNewMetaCoin (60ms)

  Contract: MetaCoin
    ✓ should put 10000 MetaCoin in the first account (63ms)
    ✓ should call a function that depends on a linked library (79ms)
    ✓ should send coin correctly (173ms)


  5 passing (840ms)
```

The command `truffle init` uses the following repo as default blueprint [https://github.com/trufflesuite/truffle-init-default](https://github.com/trufflesuite/truffle-init-default), it includes an example contract and tests.

Since we are going to be writing our own contract and tests, we are going to remove some of the defaults:

```
rm contracts/ConvertLib.sol contracts/MetaCoin.sol
rm test/TestMetacoin.sol test/metacoin.js
rm migrations/2_deploy_contracts.js
```

## Creating contracts with Truffle and testing

To [create a new contract](http://truffleframework.com/docs/advanced/commands#create-contract), run the command `truffle create`. It
requires the type of item we want to create and the name.

```
truffle create contract HelloWorld
```

The name must be `CamelCased`. After running the command, the file will be under `contracts/HelloWorld.sol` with the following content:

{% highlight javascript %}
pragma solidity ^0.4.4;

contract HelloWorld {
  function HelloWorld() {
    // constructor
  }
}
{% endhighlight %}

Next, add the code for [the hello world contract](/blog/2017/06/13/smart-contracts-for-the-impatient/).

{% highlight javascript %}
pragma solidity ^0.4.4;

contract HelloWorld {
  //Begin: state variables
  address private creator;
  address private lastCaller;
  string private message;
  uint private totalGas;
  //End: state variables

  //Begin: constructor
  function HelloWorld() {
    /*
      We can use the special variable `tx` which gives us information
      about the current transaction.

      `tx.origin` returns the sender of the transaction.
      `tx.gasprice` returns how much we pay for the transaction
    */
    creator = tx.origin;
    totalGas = tx.gasprice;
    message = 'hello world';
  }
  //End: constructor

  //Begin: getters
  function getMessage() constant returns(string) {
    return message;
  }

  function getLastCaller() constant returns(address) {
    return lastCaller;
  }

  function getCreator() constant returns(address) {
    return creator;
  }

  function getTotalGas() constant returns(uint) {
    return totalGas;
  }
  //End: getters

  //Being: setters
  function setMessage(string newMessage) {
    message = newMessage;
    lastCaller = tx.origin;
    totalGas += tx.gasprice;
  }
  //End: setters
}
{% endhighlight %}

## Migration

Once we have the code for the contract, we need to find a way to
deploy it into the blockchain. Truffle has a primitive called
migration, which can be used to compose and deploy contracts.

Create a migration called `deploy_hello_world`:

```
$ truffle create migration deploy_hello_world
$ git st
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	migrations/1499575148_deploy_hello_world.js
```

Above we can see that a new file got created  (if you get a different
result, it means the following PR has not been merged yet
[https://github.com/trufflesuite/truffle-core/pull/13](https://github.com/trufflesuite/truffle-core/pull/13), rename it so it look similar to the one above).

Next, update the code for the contract to deploy our `HelloWorld` example, to do so we'll require the contract and then use the [deployer](http://truffleframework.com/docs/getting_started/migrations#deployer):

{% highlight javascript %}
// We use artifacts.require to tell Truffle which artifacts we'll be
// interacting with.

// In the example below, we are requiring the contract HelloWorld
// which returns an abstraction that we can use for the deployment.
const HelloWorld = artifacts.require('HelloWorld')

module.exports = function(deployer) {
  deployer.deploy(HelloWorld)
}

// Read more about artifacts here http://truffleframework.com/docs/getting_started/migrations#artifacts-require-
{% endhighlight %}

We should be able to deploy the contract to the test blockchain
running `truffle migrate --reset`:

{% highlight bash %}
$ truffle migrate --reset
Compiling ./contracts/HelloWorld.sol...
Compiling ./contracts/Migrations.sol...
Writing artifacts to ./build/contracts

Using network 'development'.

Running migration: 1_initial_migration.js
  Deploying Migrations...
  Migrations: 0x665311133c3f2ca24c633da656ded48619fb3239
Saving successful migration to network...
Saving artifacts...
Running migration: 1499575148_deploy_hello_world.js
  Deploying HelloWorld...
  HelloWorld: 0xba06f7905d9c4584be914365ae1ce44688e50504
Saving successful migration to network...
Saving artifacts...
{% endhighlight %}

If we look at the log from `testrpc` we'll see a register of the
transactions:

{% highlight bash %}
eth_sendTransaction
  Transaction: 0x11316dc23e638f8d9aaae06fd0751a209f94ed2dd1c42307cf25c6c01198f0df
  Contract created: 0xba06f7905d9c4584be914365ae1ce44688e50504
  Gas usage: 0x05a8a4
  Block Number: 0x07
  Block Time: Sat Jul 08 2017 22:21:52 GMT-0700 (PDT)

eth_sendTransaction

  Transaction: 0x3b0c127d8a8ffe1465091a4208204b97016991f4396d19e40edcbd8323988a7a
  Gas usage: 0x696e
  Block Number: 0x08
  Block Time: Sat Jul 08 2017 22:21:53 GMT-0700 (PDT)
{% endhighlight %}

We have successfully deployed a contract using Truffle to `testrpc`
but we haven't written any test yet. That's what we'll do next.

## Testing

Truffle has built-in support for testing. We'll write some test for
the methods defined in our contract.

To create the test we need to run the command `truffle create test HelloWorld` and then put the following content in `test/hello_world.js`:

```
const HelloWorld = artifacts.require('HelloWorld')

contract('HelloWorld', function(accounts) {
  it('sets the first account as the contract creator', async function() {
    // This give a truffle abstraction which allow us to interact with our contracts.
    const contract = await HelloWorld.deployed()

    // Once we have the "contract" we can make calls or transations and then assert.
    // The following is making a call to get the creator.
    const creator = await contract.getCreator()

    assert.equal(creator, accounts[0], 'main account is the creator')
  })
  it('has hello world as initial message ', async function() {
    const contract = await HelloWorld.deployed()
    const message = await contract.getMessage()

    assert.equal(message, 'hello world', 'message is hello world')
  })
  it('changes the message via setMessage', async function() {
    const contract = await HelloWorld.deployed()

    // Execute a transaction and change the state of the contract.
    await contract.setMessage('hola mundo')

    // Get the new state.
    const message = await contract.getMessage()

    assert.equal(message, 'hola mundo', 'message is hola mundo')
  })
})
```

Once we have the test file setup, we can run our tests with the command
`truffle test`.

{% highlight bash %}
$ truffle test
Compiling ./contracts/HelloWorld.sol...
Compiling ./contracts/Migrations.sol...


  Contract: HelloWorld
    ✓ sets the first account as the contract creator (47ms)
    ✓ has hello world as initial message  (44ms)
    ✓ changes the message via setMessage (80ms)


  3 passing (197ms)
{% endhighlight %}

## Wrapping up

In this article, we covered how to create, test and deploy a contract
using Truffle and testrpc. In [Deploying Truffle contracts to
Rinkeby](/blog/2017/07/09/deploying-truffle-contracts-to-rinkeby),
we'll see how to add networks and deploy to Rinkeby. [Follow me on
twitter (@abuiles)](http://twitter.com/abuiles) or subscribe to my
feed to get updates on my post.

You can find the code and steps for this article in GitHub [https://github.com/abuiles/Writing-Smart-Contracts-With-Truffle](https://github.com/abuiles/Writing-Smart-Contracts-With-Truffle).

Finally, we talked superficially about Truffle's contracts, migrations
and tests. To learn more about it check their
[website](http://truffleframework.com/docs/getting_started/installation).
