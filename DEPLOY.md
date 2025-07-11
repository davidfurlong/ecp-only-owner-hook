# Deploying to Base Mainnet

## Prerequisites

1. Install Foundry if you haven't already:
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. Set up your environment variables:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and add:
   - `PRIVATE_KEY`: Your wallet's private key (without 0x prefix)
   - `BASESCAN_API_KEY`: Your BaseScan API key for contract verification (optional)

## Deployment Steps

1. **Deploy the hook to Base mainnet:**
   ```bash
   forge script script/Deploy.s.sol --rpc-url base --broadcast --verify
   ```

2. **Alternative deployment without verification:**
   ```bash
   forge script script/Deploy.s.sol --rpc-url base --broadcast
   ```

3. **Manual verification (if needed):**
   ```bash
   forge verify-contract <CONTRACT_ADDRESS> src/hook.sol:OnlyOwnerCanMakeTopLevelCommentsHook --chain base
   ```

## What This Hook Does

The `OnlyOwnerCanMakeTopLevelCommentsHook` restricts top-level comments to only the channel owner. Other users can still:
- Reply to existing comments
- Add reactions
- The channel owner can make top-level comments

## Post-Deployment

After deployment, you'll need to:
1. Note the deployed contract address from the console output
2. Register the hook with your channel manager
3. Configure your channel to use this hook

## Troubleshooting

- If deployment fails, check that your private key is correct and has sufficient ETH for gas
- If verification fails, make sure your `BASESCAN_API_KEY` is set correctly
- For RPC issues, you can use a different Base RPC endpoint by setting `BASE_RPC_URL` in your `.env` file