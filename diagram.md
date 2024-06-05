```mermaid
graph TD
    %% Coupla System
    subgraph Coupla
        A[User] -->|Registers| B[registerUser]
        A -->|Books Cell| C[bookCell]
        A -->|Checks Cell| D[checkCell]
        A -->|Lists Cells| E[listCells]
        A -->|Gets Cell Details| F[getCellDetails]
        A -->|Updates End Date| G[updateCellEndDate]

        %% Function outcomes
        B --> H[User Registered]
        C --> I[Booking Status]
        D --> J[Cell Details]
        E --> K[All Cells]
        F --> L[Cell Details]
        G --> M[End Date Updated]

        %% Internal processes
        subgraph Internal Processes
            N[Manage Cells]
            O[Manage Users]
        end

        %% Function to internal process mapping
        B --> O
        C --> N
        D --> N
        E --> N
        F --> N
        G --> N
    end

    %% IC-Pos System
    subgraph IC-Pos
        P[User] -->|Initiates Payment| Q[initiatePayment]
        P -->|Checks Payment Status| R[checkPaymentStatus]
        P -->|Gets Payment Details| S[getPaymentDetails]

        %% Function outcomes
        Q --> T[Payment Initiated]
        R --> U[Payment Status]
        S --> V[Payment Details]

        %% Internal processes
        subgraph Payment Processes
            W[Process Payment]
            X[Manage Transactions]
        end

        %% Function to internal process mapping
        Q --> W
        R --> X
        S --> X
    end

    %% ICRC1 Canister and BTC Ledger
    subgraph ICRC1_Canister
        AA[ICRC1 User] -->|Transfers Tokens| BB[transferTokens]
        AA -->|Checks Balance| CC[checkBalance]
        AA -->|Gets Transaction History| DD[getTransactionHistory]

        %% Function outcomes
        BB --> EE[Tokens Transferred]
        CC --> FF[Balance Checked]
        DD --> GG[Transaction History]

        %% Internal processes
        subgraph Token Management
            HH[Manage Token Transfers]
            II[Manage Balances]
            JJ[Manage Transaction History]
        end

        %% Function to internal process mapping
        BB --> HH
        CC --> II
        DD --> JJ
    end

    subgraph BTC_Ledger
        KK[BTC User] -->|Transfers BTC| LL[transferBTC]
        KK -->|Checks BTC Balance| MM[checkBTCBalance]
        KK -->|Gets BTC Transaction History| NN[getBTCTransactionHistory]

        %% Function outcomes
        LL --> OO[BTC Transferred]
        MM --> PP[BTC Balance Checked]
        NN --> QQ[BTC Transaction History]

        %% Internal processes
        subgraph BTC Management
            RR[Manage BTC Transfers]
            SS[Manage BTC Balances]
            TT[Manage BTC Transaction History]
        end

        %% Function to internal process mapping
        LL --> RR
        MM --> SS
        NN --> TT
    end

    %% Integration Points
    C -->|Calls| Q
    Q -->|Returns| C
    R -->|Returns| C
    S -->|Returns| C

    %% Payment Integration with ICRC1 and BTC Ledger
    Q -->|Calls| BB
    Q -->|Calls| LL
    BB -->|Returns| Q
    LL -->|Returns| Q