# ✈️ Travel Insurance Payout Smart Contract

## What is it?

A smart contract that lets users **purchase travel insurance** for a specific flight. If the flight is **delayed or canceled**, the contract **automatically pays out** the claim — no manual claim submission required.

This is achieved by integrating **off-chain flight data oracles** that call the contract in case of delays or cancellations.

---

## Why is it useful?

Traditional travel insurance is slow, paperwork-heavy, and sometimes shady with claim rejections.

With this contract:

- ✅ **No paperwork** or manual claim process.
- ⏱️ **Real-time payout** triggered by verifiable flight data.
- 🤝 **Trustless interaction** between users and insurers.
- 🪙 Fully on-chain policy management and fund flow.

---

## Key Features

- 🔐 **Purchase Policy:** Users send ETH as premium for a flight.
- 💸 **Automated Payouts:** Owner or oracle calls `triggerPayout()` if eligible.
- 🕑 **Policy Expiry:** If not claimed in time, policy is marked expired.
- 📊 **User Dashboard:** View all policies per wallet.
- 👑 **Admin Control:** Owner can withdraw unused funds.

---

## Functions

| Function                            | Purpose                      |
| ----------------------------------- | ---------------------------- |
| `purchasePolicy(flight, timestamp)` | User buys insurance          |
| `triggerPayout(policyId)`           | Oracle/admin triggers payout |
| `expirePolicy(policyId)`            | Mark policy expired          |
| `getUserPolicies(address)`          | View all policies            |
| `withdraw(amount)`                  | Admin withdraw unused funds  |

---

## Integration Suggestions

- Use **Chainlink or RedStone oracles** to fetch flight delay/cancellation status.
- Frontend UI can allow users to enter flight number and departure time.
- Can be extended to support ERC20 tokens or NFT-based policy IDs.

---

## License

MIT
