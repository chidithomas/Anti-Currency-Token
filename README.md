📘 README: Anti-Currency Token (ACT)
Overview

Anti-Currency Token (ACT) is a deflationary fungible token built on the Stacks blockchain.
It introduces an auto-burn mechanism that reduces the total supply with every transaction — creating scarcity and increasing token value over time.

Each time a token transfer occurs, 5% of the transferred amount is burned and permanently removed from circulation.

🔥 Key Features

Deflationary Mechanism:
Automatically burns 5% of each transaction, decreasing total supply over time.

Minting Control:
Only the contract owner can mint new tokens.

Initialization Guard:
Ensures the token is initialized only once.

Transparent Supply Tracking:
Tracks both total supply and total burned tokens.

Compliant with SIP-010:
Uses standard ft-mint?, ft-burn?, and ft-transfer? functions for full compatibility with Stacks wallets and dApps.

⚙️ Contract Constants
Constant	Description	Value
BURN-RATE	Percentage of each transfer burned	5%
total-supply	Initial total supply	1,000,000.000000 ACT (1M tokens, 6 decimals)
CONTRACT-OWNER	Address deploying the contract	tx-sender
🧩 Data Variables
Variable	Type	Description
token-name	string	"Anti-Currency Token"
token-symbol	string	"ACT"
token-decimals	uint	6
total-supply	uint	Tracks dynamic total supply after burns/mints
total-burned	uint	Tracks cumulative tokens burned
initialized	bool	Prevents multiple initializations
🚀 Public Functions
initialize()

Initializes the contract by minting the total supply (1,000,000 * 10^6) to the contract owner.

Access: Owner only

Errors:

ERR-OWNER-ONLY (u100)

ERR-ALREADY-INITIALIZED (u103)

transfer(amount uint, recipient principal)

Transfers tokens from sender to recipient, automatically burning 5% of the amount.

Access: Public

Returns: { transferred: uint, burned: uint }

Errors:

ERR-INVALID-AMOUNT (u104)

ERR-INVALID-RECIPIENT (u105)

ERR-INSUFFICIENT-BALANCE (u102)

mint(amount uint, recipient principal)

Allows the contract owner to mint new tokens.

Access: Owner only

Errors:

ERR-OWNER-ONLY (u100)

ERR-INVALID-AMOUNT (u104)

ERR-INVALID-RECIPIENT (u105)

👁️ Read-Only Functions
Function	Description
get-name()	Returns token name
get-symbol()	Returns token symbol
get-decimals()	Returns token decimals
get-balance(who)	Returns balance of an account
get-total-supply()	Returns current total supply
get-total-burned()	Returns total burned tokens
is-initialized()	Returns whether initialization has occurred
🧠 Error Codes
Code	Meaning
u100	Only owner can perform this action
u102	Insufficient balance
u103	Contract already initialized
u104	Invalid amount provided
u105	Invalid recipient
🪙 Tokenomics Summary

Name: Anti-Currency Token

Symbol: ACT

Decimals: 6

Burn Rate: 5% per transfer

Initial Supply: 1,000,000 * 10^6 units

Supply Type: Deflationary

🧩 Example Flow

Initialization:

The contract owner calls initialize() → mints 1,000,000 ACT.

User Transfer:

Alice transfers 1000 ACT to Bob.

5% (50 ACT) is burned.

Bob receives 950 ACT.

Total supply decreases by 50 ACT.

✅ Deployment Notes

Must be deployed by the intended contract owner.

Run initialize() once after deployment to mint the initial supply.

All burns are permanent and cannot be reversed.

🧾 License

MIT License — free to use, modify, and distribute with attribution.