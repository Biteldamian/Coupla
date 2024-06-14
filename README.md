

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

## Tech Stack

- **Motoko**: The primary programming language used for the backend.
- **Node.js**: Used for managing dependencies and running scripts.
- **dfx**: The DFINITY SDK for deploying and managing canisters on the Internet Computer.
- **Tailwind CSS**: For styling the frontend.
- **Vite**: A build tool for the frontend.

## User Stories Implemented

1. **User Registration**: Users can register with the system.
2. **Cell Booking**: Users can book cells.
3. **Balance Management**: Users can have their balances set and queried.
4. **Cell Management**: Admins can add, remove, and update cells.
5. **Cycle Management**: The system can deposit and manage cycles.

## Setup Instructions

### Prerequisites

- Node.js and npm installed
- dfx (DFINITY SDK) installed

### Step-by-Step Setup

1. **Install Dependencies**

   Navigate to the project directory and run:

   ```bash
   npm install
   ```

2. **Deploy the Application**

   Run the deployment script to set up the canisters and deploy the application:

   ```bash
   ./deploy.sh
   ```

3. **Test the Functions**

   Run the test script to ensure all functions are working as expected:

   ```bash
   sudo ./test.sh
   ```

4. **Interact with the Backend**

   Use the main script to interact with the backend:

   ```bash
   ./main.sh
   ```

## Current Status

### Fully Implemented and Working Functions

- **User Registration**: Users can register successfully.
- **Cell Booking**: Users can book cells, and the system deducts the appropriate balance.
- **Balance Management**: Users can have their balances set and queried.
- **Cell Management**: Admins can add, remove, and update cells.
- **Cycle Management**: The system can deposit and manage cycles.

### Functions in Debug Mode

- **Transfer Between Users**: The function to transfer tokens between users is still under debugging. The `makePayment` function is implemented but may require further testing and validation.

## Documentation

### User Registration

- **Function**: `registerUser(user: Principal): async Bool`
- **Description**: Registers a new user if they are not already registered.

### Cell Booking

- **Function**: `bookCell(userId: Principal, cellId: Nat, dateStart: Text): async Bool`
- **Description**: Books a cell for a user if the cell is available and the user has sufficient balance.

### Balance Management

- **Function**: `setBalance(user: UserId, amount: Nat): async Bool`
- **Description**: Sets the balance for a user.
- **Function**: `getTokenBalance(user: UserId): async Nat`
- **Description**: Retrieves the token balance for a user.

### Cell Management

- **Function**: `addCell(cell: Cell): async ()`
- **Description**: Adds a new cell to the system.
- **Function**: `removeCell(cellId: Nat): async ()`
- **Description**: Removes a cell from the system.
- **Function**: `updateCellEndDate(id: CellId, newEndDate: Text): async Bool`
- **Description**: Updates the end date of a cell booking.

### Cycle Management

- **Function**: `deposit_cycles(): async ()`
- **Description**: Deposits cycles into the canister.





- [Quick Start](https://internetcomputer.org/docs/current/developer-docs/setup/deploy-locally)
- [SDK Developer Tools](https://internetcomputer.org/docs/current/developer-docs/setup/install)
- [Motoko Programming Language Guide](https://internetcomputer.org/docs/current/motoko/main/motoko)
- [Motoko Language Quick Reference](https://internetcomputer.org/docs/current/motoko/main/language-manual)

By following this guide, you should be able to set up, run, and understand the Cupolaxs_blockchain project. Happy coding!