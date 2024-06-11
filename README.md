Certainly! Let's include the details about `Balances.mo` and `App.mo` in the README.

# Cupolaxs_blockchain

Welcome to the Cupolaxs_blockchain project! This README will guide you through the project structure, setup, and functionality of the codebase. By following this guide, you will understand how to work with the project, deploy it locally, and utilize its various functions.

## Project Structure

The project is organized into several directories and files:

- `src/`: Contains the source code for the backend and frontend.
  - `cupolaxs_blockchain_backend/`: Contains the Motoko code for the backend.
    - `main.mo`: The main Motoko file for the backend logic.
    - `Balances.mo`: Contains the logic for managing token balances.
    - `App.mo`: Contains the application logic for handling user interactions and payments.
  - `cupolaxs_blockchain_frontend/`: Contains the frontend code.
    - `index.html`: The main HTML file for the frontend.
    - `package.json`: The package configuration file for the frontend.
    - `postcss.config.js`: PostCSS configuration.
    - `tailwind.config.js`: Tailwind CSS configuration.
    - `tsconfig.json`: TypeScript configuration.
    - `vite.config.js`: Vite configuration for the frontend.
- `dfx.json`: The DFX configuration file.
- `package.json`: The package configuration file for the project.
- `README.md`: This README file.
- `tsconfig.json`: TypeScript configuration for the project.

## Setup

To get started with the project, follow these steps:

1. **Install DFX SDK**: Follow the [SDK Developer Tools](https://internetcomputer.org/docs/current/developer-docs/setup/install) guide to install the DFX SDK.

2. **Clone the Repository**: Clone the project repository to your local machine.

3. **Navigate to the Project Directory**:
   ```bash
   cd Cupolaxs_blockchain/
   ```

4. **Install Dependencies**: Install the necessary dependencies for the frontend.
   ```bash
   npm install
   ```

## Running the Project Locally

To test the project locally, use the following commands:

1. **Start the Replica**: Start the Internet Computer replica in the background.
   ```bash
   dfx start --background
   ```

2. **Deploy Canisters**: Deploy your canisters to the replica and generate the candid interface.
   ```bash
   dfx deploy
   ```

   Once the deployment is complete, your application will be available at `http://localhost:4943?canisterId={asset_canister_id}`.

3. **Generate Candid Interface**: If you make changes to your backend canister, generate a new candid interface.
   ```bash
   npm run generate
   ```

4. **Start Frontend Development Server**: If you are making frontend changes, start the development server.
   ```bash
   npm start
   ```

   This will start a server at `http://localhost:8080`, proxying API requests to the replica at port 4943.

## Functions and Their Usage

### Backend Functions

The backend is written in Motoko and provides several functions for managing balances, booking cells, and handling payments.

- **deployBalances**: Deploys the Balances canister if not already deployed.
- **deposit_cycles**: Deposits available cycles into the canister.
- **deployApp**: Deploys the App canister if the Balances canister is ready.
- **deployAll**: Initiates the deployment of both Balances and App canisters.
- **isReady**: Checks if both Balances and App canisters are deployed.
- **registerUser**: Registers a new user.
- **bookCell**: Books a cell for a user.
- **updateCellEndDate**: Updates the end date of a booked cell.
- **checkCell**: Checks the details of a specific cell.
- **listCells**: Lists all cells.
- **removeCell**: Removes a cell by its ID.
- **addCell**: Adds a new cell.
- **getCellDetails**: Retrieves the details of a specific cell.
- **setCell**: Updates the details of a specific cell.
- **removeUser**: Removes a user by their ID.
- **addUser**: Adds a new user.
- **setBalance**: Sets the balance for a user.
- **makePayment**: Makes a payment from one user to another.

### Frontend

The frontend is built using modern web technologies and is configured to work seamlessly with the backend canisters. It provides a user interface for interacting with the blockchain functionalities.

## Additional Resources

To learn more about developing on the Internet Computer, refer to the following documentation:

- [Quick Start](https://internetcomputer.org/docs/current/developer-docs/setup/deploy-locally)
- [SDK Developer Tools](https://internetcomputer.org/docs/current/developer-docs/setup/install)
- [Motoko Programming Language Guide](https://internetcomputer.org/docs/current/motoko/main/motoko)
- [Motoko Language Quick Reference](https://internetcomputer.org/docs/current/motoko/main/language-manual)

By following this guide, you should be able to set up, run, and understand the Cupolaxs_blockchain project. Happy coding!