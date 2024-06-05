# Koepel Project README

## Project Overview

The Koepel project is a blockchain-based solution for the De Koepel Haarlem booking system. It leverages the Internet Computer Protocol (ICP) to implement smart contracts, tokenize rooms and spaces as non-fungible tokens (NFTs), and ensure robust security features.

## File System and Directory Structure

The project follows a standard file system structure for ICP projects:

```
koepel/
├── src/
│   ├── canisters/
│   │   └── koepel_backend/
│   │       ├── motoko/
│   │       └── tests/
│   └── identity/
├── assets/
├── dfx.json
├── package.json
└── README.md
```

## Setting up DFX

To set up the DFX SDK, follow these steps:

1. Install DFX using npm:
```bash
npm install -g dfx
```
1. Create a new project:
```bash
dfx new koepel
```
1. Navigate to the project directory:
```bash
cd koepel
```
## Common Issues and Solutions

### Issue 1: DFX installation error

If you encounter an error during DFX installation, try using the following command:
```bash
npm install -g dfx --unsafe-perm=true --allow-root
```
### Issue 2: Canister deployment error

If you face a canister deployment error, ensure that the Internet Computer (IC) network is running and accessible. You can check the network status using the following command:
```bash
dfx network list
```
If the IC network is not running, start it using:
```bash
dfx start
```
## Developing the Application

To develop the Koepel application, follow these steps:

1. Deploy the canisters:
```bash
dfx deploy
```
1. Build the frontend:
```bash
npm run build
```
1. Start the frontend development server:
```bash
npm run serve
```
## Error Encounters and Fixes

### Error 1: Unknown identifier in Motoko code

If you encounter an "unknown identifier" error in your Motoko code, ensure that all imports are correctly specified and that the required modules are installed.

### Error 2: Failed to fetch candid interface

If you face a "failed to fetch candid interface" error, ensure that the canister is deployed and running. You can check the canister status using the following command:
```bash
dfx canister status <canister_id>
```
If the canister is not running, redeploy it using:
```bash
dfx deploy <canister_name>
```


## Smart Contract Implementation

Implementing smart contracts on the Internet Computer Protocol (ICP) for the De Koepel Haarlem booking system can offer several benefits, such as automating the booking process, reducing the need for intermediaries, and enhancing security. However, challenges may arise during integration, such as ensuring compatibility with existing systems and addressing potential scalability issues. To best integrate smart contracts, consider the following recommendations:

1. Evaluate the existing booking system and identify areas where smart contracts can be implemented to improve efficiency and security.
2. Develop a phased implementation plan, starting with smaller, less critical components before moving on to more complex aspects of the booking system.
3. Collaborate with experienced ICP developers to ensure proper integration and address any potential challenges.

## Tokenization and NFTs

Tokenizing rooms and spaces within De Koepel Haarlem as non-fungible tokens (NFTs) can provide an efficient way to manage property rights and access. The ORYGN NFT standard is one option to consider for implementing NFTs on the ICP. Some advantages of this approach include:

1. Simplified property management: NFTs can be used to represent individual rooms or spaces, making it easier to track ownership and access rights.
2. Enhanced security: The ICP's secure infrastructure can help protect NFTs from unauthorized access or manipulation.
3. Streamlined transactions: NFTs can be easily transferred or traded, simplifying the process of managing property rights and access.

However, potential drawbacks may include the need for users to understand and interact with NFTs, as well as potential challenges related to scalability and compatibility with existing systems. To implement NFTs using the ORYGN standard, follow these steps:

1. Create an ORYGN NFT for each room or space within De Koepel Haarlem.
2. Develop a user interface that allows property owners and users to interact with the NFTs, such as transferring ownership or granting access.
3. Integrate the NFT system with the existing booking system to ensure seamless operation.

## Security Measures

The ICP chain offers robust security features that can be applied to the De Koepel Haarlem booking system. Some key security measures include:

1. Data integrity: The ICP's consensus mechanism helps ensure that data stored on the chain is accurate and tamper-proof.
2. Privacy protection: The ICP supports encrypted data storage and communication, helping protect sensitive information related to bookings and personal data.
3. Access control: Implementing smart contracts and NFTs can help enforce access control policies, ensuring that only authorized users can access specific rooms or spaces.

To ensure data integrity and protect sensitive information, consider the following recommendations:

1. Implement encryption for all data stored on the ICP chain, as well as for any communication between users and the booking system.
2. Regularly audit the smart contracts and NFT system to identify and address any potential security vulnerabilities.
3. Establish clear access control policies and enforce them using smart contracts and NFTs.

## Useful Commands and Installation Guides

To clear the cache for DFX and the NVM, NPM managers, use the following commands:

1. DFX:
```bash
dfx cache clear
```
1. NVM:
```bash
nvm cache clear
```
1. NPM:
```bash
npm cache clean --force
```
To install DFX, follow these steps:

1. Download the DFX SDK from the official Internet Computer website (<https://sdk.dfinity.org/>).
2. Extract the downloaded archive and navigate to the extracted folder.
3. Run the installation script, following the instructions provided.
4. Verify the installation by running the command:
```bash
dfx --version
```
For more detailed installation instructions, refer to the official DFX documentation (<https://sdk.dfinity.org/docs/getting-started/install.html>).

To manage the NFT system for the Koepel project owners, consider implementing a user-friendly interface that allows owners to create, transfer, and manage NFTs associated with their properties. This interface should be integrated with the existing booking system, enabling seamless interaction between the NFT system and the booking process. Additionally, provide documentation and support to help project owners understand and effectively utilize the NFT system.


## CanisterConfig File and Development Structure

The CanisterConfig file is a JSON file that stores configuration data for the canisters in the De Koepel Haarlem project. It contains information such as canister IDs, endpoints, and other settings required for the canisters to communicate with each other and the frontend application.

When developing with this structure, the team should follow these steps:

1. Set up the local development environment, including DFX and other required tools.
2. Create and configure the CanisterConfig file for each team member's local environment.
3. Develop and test smart contracts and other canister functionality locally using the local CanisterConfig file.
4. Commit and push changes to the GitLab repository, ensuring that the CanisterConfig file is not included to avoid conflicts with other team members' configurations.
5. Deploy canisters to the ICP chain for integration testing and production use.


The Internet Computer (ICP) has launched a GDPR-ready European subnet, providing a decentralized infrastructure for developers to build GDPR-compliant applications. This subnet operates as a collection of nodes located within the EU, ensuring data is processed and stored within the EU to align with GDPR's jurisdictional requirements.

Here's an example of a config file for multiple canisters, including frontend, backend, and management:
```json
{
  "frontend": {
    "canister_id": "xxxx-xxxx-xxxx-xxxx-xxxx",
    "url": "https://xxxx-xxxx-xxxx-xxxx-xxxx.ic0.app"
  },
  "backend": {
    "canister_id": "yyyy-yyyy-yyyy-yyyy-yyyy",
    "url": "https://yyyy-yyyy-yyyy-yyyy-yyyy.ic0.app"
  },
  "management": {
    "canister_id": "zzzz-zzzz-zzzz-zzzz-zzzz",
    "url": "https://zzzz-zzzz-zzzz-zzzz-zzzz.ic0.app"
  }
}
```
This config file contains the canister IDs and URLs for each canister, allowing developers to easily manage and interact with them.


To set up the `canisterconfig.json` file for the De Koepel Haarlem project, follow these steps:

1. Create a new file named `canisterconfig.json` in the root directory of your project.
2. Open the file and define the JSON structure for the canisters involved in the project. For example:
```json
{
  "booking_system": {
    "canister_id": "",
    "url": ""
  },
  "nft_manager": {
    "canister_id": "",
    "url": ""
  },
  "security_manager": {
    "canister_id": "",
    "url": ""
  }
}
```
1. Replace the empty strings for `canister_id` and `url` with the appropriate values for each canister. The `canister_id` is a unique identifier for each canister, and the `url` is the endpoint used to interact with the canister.
2. Save the `canisterconfig.json` file.
3. In your project's code, import the `canisterconfig.json` file and use the canister IDs and URLs to interact with the canisters.

Here's an example of how to import and use the `canisterconfig.json` file in a JavaScript project:
```javascript
const canisterConfig = require('./canisterconfig.json');

const bookingSystemCanisterId = canisterConfig.booking_system.canister_id;
const bookingSystemUrl = canisterConfig.booking_system.url;

// Use the canister ID and URL to interact with the booking system canister
```
By following these steps, you can set up the `canisterconfig.json` file and use it to manage the canisters in your project. This approach allows you to easily update canister IDs and URLs as needed, ensuring that your project remains up-to-date and functional.



To create a simple Motoko backend for the booking system without using the base64 package, follow these steps:

1. Create a new actor in your Motoko file (e.g., `main.mo`).
2. Define a record for the NFT, including the 3D object data.
3. Implement a function to create a new NFT with the given data.
4. Implement a function to book a room using an NFT.

Here's a simple example of the Motoko backend code:
```motoko
actor BookingSystem {
  record NFT {
    id : Nat64;
    name : Text;
    description : Text;
    image : Blob;
    object : Blob; // 3D object data
  };

  var nextId : Nat64 = 0;
  var nfts : Map<Nat64, NFT> = {};

  public func createNFT(name : Text, description : Text, image : Blob, object : Blob) : async Nat64 {
    let id = nextId;
    nextId += 1;
    let newNFT = NFT { id = id; name = name; description = description; image = image; object = object };
    nfts[id] = newNFT;
    return id;
  };

  public func bookRoom(nftId : Nat64) : async Bool {
    if (!nfts.contains(nftId)) {
      return false;
    }
    // Perform the booking logic here.
    // ...
    return true;
  };
};
```
For the frontend, you can use the Internet Identity canister to create and manage user identities. Here's an example using Vue.js:

1. Install the `@dfinity/auth-client` package:
```bash
npm install @dfinity/auth-client
```
1. Import the package in your Vue.js component:
```javascript
import { createActor, createIdentity } from '@dfinity/agent';
import { AuthClient } from '@dfinity/auth-client';
```
1. Create an instance of the `AuthClient`:
```javascript
const authClient = await AuthClient.create();
```
1. Create an identity using the `AuthClient`:
```javascript
const identity = await authClient.getIdentity();
```
1. Create an actor for the booking system canister:
```javascript
const bookingSystemActor = createActor(canisterId, {
  agentOptions: {
    identity,
  },
});
```
1. Use the actor to create NFTs and book rooms:
```javascript
const nftId = await bookingSystemActor.createNFT('Room 1', 'Description', imageBlob, objectBlob);
await bookingSystemActor.bookRoom(nftId);
```
Remember to replace `canisterId` with the actual canister ID for the booking system.

For testing purposes, you can deploy the canisters locally using the following command:
```bash
dfx deploy
```
This will deploy the canisters and print their canister IDs in the console. You can then use these IDs to interact with the canisters in your frontend application.

To use the Internet Identity canister, make sure to include it in your `dfx.json` file:
```json
{
  "canisters": {
    "booking_system": {
      "main": "src/main.mo",
      "type": "motoko"
    },
    "internet_identity": {
      "type": "custom",
      "candid": "https://github.com/dfinity/internet-identity/releases/latest/download/internet_identity.did",
      "wasm": "https://github.com/dfinity/internet-identity/releases/latest/download/internet_identity_dev.wasm.gz",
      "remote": {
        "id": { "ic": "rdmx6-jaaaa-aaaaa-aaadq-cai" },
        "frontend": {}
      }
    }
  }
}
```
Deploy the Internet Identity canister locally using the command:
```bash
dfx deploy internet_identity
```
After deploying the canisters, you can test the booking system on your local machine by interacting with the frontend canister and verifying that the NFTs and bookings are stored on the IC chain.
