// Importing modules
import React, { useEffect, useState } from "react";
// import { ethers } from "ethers";
import "./App.css";
import { Button, Card } from "react-bootstrap";
import "bootstrap/dist/css/bootstrap.min.css";
import { Types, AptosClient } from 'aptos';
// import {tokenaddress1,abi1,tokenaddress2,abi2,stakingaddress,abi3} from "./abi";
// import web3 from "./web3";
import {useRef} from "react";



function App() {

// usetstate for storing and retrieving wallet details
const [walletaddress, setdata] = useState();
const [walletpublickey, setWalletpublickey] = useState();


const inputamt=useRef(null);
const inputamt1=useRef(null);
const inputamt2=useRef(null);
const inputamt3=useRef(null);
// const inputamt4=useRef(null);
// const inputamt5=useRef(null);
// const inputamt6=useRef(null);
// const inputamt7=useRef(null);
// const inputamt8=useRef(null);




//petra wallet
const getAptosWallet = () => {
  if ('aptos' in window) {
    return window.aptos;
  } else {
    window.open('https://petra.app/', `_blank`);
  }
};

const wallet = getAptosWallet();
const Walletconnect = async() => { 
	try {
//   const response = await wallet.connect();
//   console.log("connect",response); // { address: string, address: string }
  const account = await wallet.account();
//   console.log(account); // { address: string, address: string }
setdata(account.address)
setWalletpublickey(account.publicKey)
  window.alert("wallet connected successfully")
//   const balance = await wallet.getAccountBalance(account.address);
//     console.log("Wallet Balance:",balance);
} catch (error) {
  // { code: 4001, message: "User rejected the request."}
  console.log(error);
}
}

// const Disconnect = async() => {
// 	const res = await wallet.disconnect();
// 	console.log(res);
// }

const initialize = async () => {
	const transaction = {
	type: "entry_function_payload",
	function: "0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29::Calculator::initialize",
	arguments: ["HUBO", "HUBO"],
	type_arguments: ["0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29::Calculator::DAI"],
	};
	try {
	const pendingTransaction = await (window).aptos.signAndSubmitTransaction(transaction);
	console.log("pendingTransaction", pendingTransaction);
	const client = new AptosClient('https://testnet.aptoslabs.com');
	client.waitForTransaction(pendingTransaction.hash);
	} catch (error) {
		console.log("error");
	}
	}

	// const inithandle = () =>{
	// 	let a = inputamt.current.value;
	// 	initialize(a)
	// }


	// const register = async () => {
	// 	const transaction = {
	// 	type: "entry_function_payload",
	// 	function: `0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29::Calculator::register`,
	// 	arguments: [],
	// 	type_arguments: [`0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29::Calculator::TR`],
	// 	};
	// 	try {
	// 	const pendingTransaction = await (window).aptos.signAndSubmitTransaction(transaction);
	// 	console.log("pendingTransaction", pendingTransaction);
	// 	const client = new AptosClient('https://testnet.aptoslabs.com');
	// 	client.waitForTransaction(pendingTransaction.hash);
	// 	} catch (error) {
	// 		console.log("error");
	// 	}
	// 	}


    //     const mint = async () => {
	// 		const transaction = {
	// 		type: "entry_function_payload",
	// 		function: `0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29::Calculator::mint_coin`,
	// 		arguments: ["0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29", 100000000],
	// 		type_arguments: [`0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29::Calculator::TR`],
	// 	};
	// 		try {
	// 		const pendingTransaction = await (window).aptos.signAndSubmitTransaction(transaction);
	// 		console.log("pendingTransaction", pendingTransaction);
	// 		const client = new AptosClient('https://testnet.aptoslabs.com');
	// 		client.waitForTransaction(pendingTransaction.hash);
	// 		} catch (error) {
	// 			console.log("error");
	// 		}
	// 		}


	// 	const transfer = async () => {
	// 		const transaction = {
	// 		type: "entry_function_payload",
	// 		function: `0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29::Calculator::transfer`,
	// 		arguments: ["0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29", 100000000],
	// 		type_arguments: [`0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29::Calculator::TR`],
	// 		};
	// 		try {
	// 		const pendingTransaction = await (window).aptos.signAndSubmitTransaction(transaction);
	// 		console.log("pendingTransaction", pendingTransaction);
	// 		const client = new AptosClient('https://testnet.aptoslabs.com');
	// 		client.waitForTransaction(pendingTransaction.hash);
	// 		} catch (error) {
	// 			console.log("error");
	// 		}
	// 		}


	// 		const escrow_account = async () => {
	// 			const transaction = {
	// 			type: "entry_function_payload",
	// 			function: `0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29::Calculator::create_new_pool`,
	// 			arguments: [],
	// 			type_arguments: [],
	// 			};
	// 			try {
	// 			const pendingTransaction = await (window).aptos.signAndSubmitTransaction(transaction);
	// 			console.log("pendingTransaction", pendingTransaction);
	// 			const client = new AptosClient('https://testnet.aptoslabs.com');
	// 			client.waitForTransaction(pendingTransaction.hash);
	// 			console.log("account created");
	// 			} catch (error) {
	// 				console.log("error");
	// 			}
	// 			}

	// 			const add_int = async () => {
	// 				const transaction = {
	// 				type: "entry_function_payload",
	// 				function: `0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29::Calculator::add`,
	// 				arguments: ["0x9da2f6b34755a8bfa7b52c3571babf7e0e097da58a0eb0244ee4fe57bc5d86c0",10,100],
	// 				type_arguments: [],
	// 				};
	// 				try {
	// 				const pendingTransaction = await (window).aptos.signAndSubmitTransaction(transaction);
	// 				console.log("pendingTransaction", pendingTransaction);
	// 				const client = new AptosClient('https://testnet.aptoslabs.com');
	// 				client.waitForTransaction(pendingTransaction.hash);
	// 				console.log("added");
	// 				} catch (error) {
	// 					console.log("error");
	// 				}
	// 				}


	// 				const calculator = async () => {
	// 					const transaction = {
	// 					type: "entry_function_payload",
	// 					function: `0xef9990736bdbfcb3e4ab7c036e61166659baaa1ac4faa5194f99cb4c07de0a29::Calculator::calaculator`,
	// 					arguments: [inputamt.current.value,inputamt1.current.value,inputamt2.current.value,`${inputamt3.current.value}`],
	// 					type_arguments: [],
	// 					};
	// 					try {
	// 					const pendingTransaction = await (window).aptos.signAndSubmitTransaction(transaction);
	// 					console.log("pendingTransaction", pendingTransaction);
	// 					const client = new AptosClient('https://testnet.aptoslabs.com');
	// 					client.waitForTransaction(pendingTransaction.hash);
	// 					console.log("calculated");
	// 					} catch (error) {
	// 						console.log("error");
	// 					}
	// 					}
 
	

return (
	<div className="App">
	{/* Calling all values which we
	have stored in usestate */}

	<Card className="text-center">
		<Card.Body>
		<Card.Text>
		<strong>Address: </strong>
		{walletaddress}
		<br></br>
			<strong>Publickey: </strong>
			{walletpublickey}
		</Card.Text>
		<Button onClick={Walletconnect} variant="primary">
			Connect to wallet
		</Button>
		<br/>
		<br/>
		{/* <Button onClick={Disconnect} variant="primary">
			DisConnect
		</Button> */}
		{/*
		<br/>
		<br/>
		<Button onClick={escrow_account} variant="primary">
			Create escrow
		</Button>
		<br/>
		<br/>
		<Button onClick={add_int} variant="primary">
			add
		</Button>
		<br/>
		<br/>
		
		<label>operand 1:</label>&nbsp;&nbsp;<input ref={inputamt}
        type="text"
        id="amt1"
        name="amt1"/>&nbsp;&nbsp;
		<label>operand 2:</label>&nbsp;&nbsp;<input ref={inputamt1}
        type="text"
        id="amt2"
        name="amt2"/>&nbsp;&nbsp;
		<label>option :</label>&nbsp;&nbsp;<input ref={inputamt2}
        type="text"
        id="amt3"
        name="amt3"/>&nbsp;&nbsp;
		<label>operation :</label>&nbsp;&nbsp;<input ref={inputamt3}
        type="text"
        id="amt4"
        name="amt4"/>
		<br/>
		<br/>
		<Button onClick={calculator} variant="primary">
			calculator
		</Button>
		
		
		
		<br/>
		<br/>
		<h2>INITIALIZE</h2><br/><br/>
		{/* <label>Token_name:</label>&nbsp;&nbsp;<input ref={inputamt}
        type="text"
        id="amt"
        name="amt"/>&nbsp;&nbsp;<br/>
		<label>Token_symbol:</label>&nbsp;&nbsp;<input ref={inputamt1}
        type="text"
        id="amt"
        name="amt"/>&nbsp;&nbsp; */}
		{/*
		<Button onClick={initialize} >
		init
		</Button><br/><br/>

		<h2>REGISTER</h2>
		<br/>
	
		{/* <label>Token_Name:</label>&nbsp;&nbsp;<input ref={inputamt2}
        type="text"
        id="amt"
        name="amt"/>&nbsp;&nbsp; */}
		{/*
     <button onClick={register}>REG</button>
	 <br/>
	 <br/>
     

		<h2>MINT</h2>
		<br/>
		{/* <label>A/C address:</label>&nbsp;&nbsp;<input ref={inputamt3}
        type="text"
        id="amt"
        name="amt"/>&nbsp;&nbsp;
		<label>Amount:</label>&nbsp;&nbsp;<input ref={inputamt4}
        type="text"
        id="amt"
        name="amt"/>&nbsp;&nbsp;
		<label>Token:</label>&nbsp;&nbsp;<input ref={inputamt5}
        type="text"
        id="amt"
        name="amt"/>&nbsp;&nbsp; */}
		{/*
     <button onClick={mint}>mint</button>
	 <br/><br/>




	 <h2>TRANSFER</h2>
		<br/>
		{/* <label>Token_Name:</label>&nbsp;&nbsp;<input ref={inputamt6}
        type="text"
        id="amt"
        name="amt"/>&nbsp;&nbsp;
		<label>Reciever:</label>&nbsp;&nbsp;<input ref={inputamt7}
        type="text"
        id="amt"
        name="amt"/>&nbsp;&nbsp;
		<label>Amount:</label>&nbsp;&nbsp;<input ref={inputamt8}
        type="text"
        id="amt"
        name="amt"/>&nbsp;&nbsp; */}
		{/*
     <button onClick={transfer}>TRANS</button>
     

	 {/* <br/>
		<br/>
		<Button onClick={reward} >
		get reward
		</Button>
		 */}
		</Card.Body>
	</Card>
	</div>
);

}
export default App;

