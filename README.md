

# Tamper-Proof Event Log and Audit Trail

## Overview

This project is designed to record events in a tamper-proof way on the Ethereum blockchain. It utilizes the power of smart contracts and ECDSA digital signatures for data integrity and non-repudiation.

## Features

- Record an event with digital signature.
- Verify an event with a provided digital signature.
- Fetch an individual event by ID.
- Fetch all events recorded by a specific address.
- Tamper-proof and transparent logging of all events.

## Smart Contract

The contract uses OpenZeppelin library for secure and efficient cryptographic operations.

## Usage

To interact with the contract, the following functions are provided:

- `recordEvent(string calldata data, bytes calldata signature)`: Allows a user to record a new event. The user must sign the data they are inputting to ensure authenticity. The event is saved with the current timestamp, the sender's address, and the signature.

- `verifyEvent(uint256 eventId, bytes calldata signature)`: Allows anyone to verify an event by comparing the provided signature and the stored signature. Emits a `EventVerified` event.

- `getEvent(uint256 eventId)`: Fetches an event by ID. It returns the timestamp, data, recorder address, and signature.

- `getEventsByRecorder(address recorder)`: Fetches all events recorded by a specific address. It returns arrays of timestamps, data, and signatures.

## Dependencies

The smart contract is written in Solidity and uses OpenZeppelin library for cryptographic functions.

## Setup

1. Compile the contract using the Solidity Compiler (solc).

2. Deploy the contract on your preferred Ethereum network (mainnet, testnet, or local).

3. Interact with the contract using either a script (truffle console, hardhat, etc.) or a front-end interface.

## Disclaimer

Please note that this contract has not been professionally audited. Use it at your own risk.

## License
fileXcure is released under the [MIT License](https://github.com/dhruv1972/Tamper-Proof/LICENSE.md).
