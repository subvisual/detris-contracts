all: clean install update build

clean  :; forge clean

install :; forge install

update:; forge update

build  :; forge clean && forge build --optimize --optimize-runs 1000000

test   :; forge clean && forge test --optimize --optimize-runs 1000000 -v

lint :; prettier --write src/**/*.sol && prettier --write src/*.sol

snapshot :; forge clean && forge snapshot --optimize --optimize-runs 1000000

mainnet-fork :; npx hardhat node --fork ${ETH_MAINNET_RPC_URL}
