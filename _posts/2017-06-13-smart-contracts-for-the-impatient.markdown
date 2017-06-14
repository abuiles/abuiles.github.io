---
layout: post
title: "Smart contracts for the impatient"
date: 2017-06-13T06:10:40-07:00
---
I've been learning about ethereum and smart contracts, and one of the
biggest issues I've found is the lack of documentation to do some
basic things.

In this article I want to do the dumbest contract possible, which kind
of resembles our first program ever: "Hello World".

I'll show you how to:

- Run mist using the test net [rinkeby](https://www.rinkeby.io/) and get free ether for testing.
- Deploy a contract and interact with it using mist.

For easiness, I'll assume people is using macOS.

## Setting up a test net

To get started we need to install Mist, from the readme:

> The Mist browser is the tool of choice to browse and use Ðapps.

It not only works as a browser, but also allow us to create wallets and contracts.

We can downloading it from [https://github.com/ethereum/mist/releases](https://github.com/ethereum/mist/releases).

Once it is installed, don't bother yet about setting a wallet.

Since we don't want to run on the default `test-net` or `main network`, we
need install `geth`, which is a command line interface for running a
ethereum node. It will allow us to interact with rinkeby.

Follow the instructions here [https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum](https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum).

Once we have mist and get installed, let's get rinkeby running.

## Running mist with rinkeby

Since `mist` doesn't have out of the box support for rinkeby. We need
to connect to it using `geth` and then tell mist to use that connection.

Let's run in the console the following command:

```bash
geth --rinkeby --rpc console --rpcapi db,eth,net,web3,personal
```

That will start the a new ethereum node, connected to rinkeby.

Let's open mist and tell it to connect to our running node. It
will show you an alert saying the connection is insecure, but since
this is a test net, we can ignore it.


```bash
/Applications/Mist.app/Contents/MacOS/Mist --rpc http://localhost:8545
```

It will take some time the first time we run it since it has to
download the test blockchain, go for a walk and then come back.

## Creating a wallet in rinkeby

After mist has started, we'll see an interface similar to the following:

![](/assets/wallet.png)

We can then create our first account in rinkeby by clicking in the "Add account" button.

<iframe width="100%" height="400px" src="https://www.youtube.com/embed/5fGRdbuQReo" frameborder="0" allowfullscreen></iframe>

There are two types of "accounts" in ethereum:

- Externally Owned Account (EOA) or just "accounts"
- Contracts accounts or "contracts"

What we created was an EOA, and is normally what people would refer to as a wallet.

Now that we have an account, let's send ether to it. Since we are using a testnet, we can get ether doing one of the following:

- Mining: we are running a test-net and it has all the same functionalities as the main-net. Mining here is faster but the ether you are mining does not have any value.
- Asking someone to send us ETH.
- Use a public faucet.

Luckily for us, there is a public faucet where we can get "free" ether from. We need to do the following steps:

- Copy our account address.
- Paste it in GitHub gist.
- Submit the gist to https://faucet.rinkeby.io and get free ether.

The following video demonstrates the 3 steps above:

<iframe width="100%" height="400px" src="https://www.youtube.com/embed/wKFz5c3TU4s" frameborder="0" allowfullscreen></iframe>

In the video above, that user already maxed out the allowance for 3
days, but we should see a success message under normal circumstances.
After that, the ether should be in the wallet balance.

![](/assets/wallet2.png)

## Hello world

With rinkeby configured and ether to spend, let's deploy our hello
world contract.

The contract is going to be called HelloWorld.

It has 4 state variables:

- creator: the account who created the contract
- lastCaller: the last account who changed the state of the contract.
- message: an internal message.
- totalGas: total amount of gas spend interacting with the contract.

We'll define four getters for each of the state variables:

- getMessage
- getLastCaller
- getCreator
- getTotalGas

We call the functions above by making calls to the contract. Calls
don't have any cost since they don't change the state of the network,
therefore you don't need to pay gas to run them.

To change the internal state of the contract, we'll define a
setter. Anything that changes the contract state is considered a
transaction. Transactions change the state of the blockchain, they
have to be run by multiple nodes and be verified. Transactions have an
associated cost and we have to pay gas to run them.

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

To deploy the contract above, we need to copy it into the clipboard and then do the following steps:

- Click "Contracts" in the button next to the balance.
- Click "Deploy new contract".
- Select your account and the paste the code in the text editor.
- Select how much gas to pay to get the contract created.
- Click deploy.

![](/assets/deploy-smart-contracts.gif)

## Interacting with the contract

Once the contract has been deployed, we can interact with it.

Let's click in "Contracts" and then select our recently deployed contract.

We'll see a screen similar to the following which shows the result for each getter:

![](/assets/contract.png)

Next, let's try changing the message. On the top right corner of the
screen, we'll see a section called "Write to contract", and we can
pick the function to call. If we select `setMessage` it will ask us
for the message and then write to the contract.

![](/assets/contract-transaction.gif)

We can see all the activity for our contract by copying its address and then going to [rinkeby](https://rinkeby.etherscan.io).

The following are the transactions for my hellow world contract: [https://rinkeby.etherscan.io/address/0xbE8852a2682Fc8C9d7c1619a7488c6F0dE2Ca8ab](https://rinkeby.etherscan.io/address/0xbE8852a2682Fc8C9d7c1619a7488c6F0dE2Ca8ab)

## Wrapping up

Congrats! You have deployed your first hello world contract. Now you
have the bare minium to start getting into more serious stuff.

If you are interested in ethereum and writing smart contract,
subscribe to my feed or [follow me on
twitter](https://twitter.com/abuiles).

Through the following weeks, we'll be exploring
[Truffle](http://truffleframework.com/) to code the examples from the
ethereum website and work on our first Ðapps.
