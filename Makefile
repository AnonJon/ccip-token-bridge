-include .env

init-install:
	forge install Openzeppelin/openzeppelin-contracts foundry-rs/forge-std Openzeppelin/openzeppelin-contracts-upgradeable smartcontractkit/chainlink

install:
	forge install

clean:
	remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

test-contracts: 
	forge test -vvvv

generate-docs:
	forge doc --serve --port 4000

deploy-ccip-sender:
	forge script script/ccip/Deploy.MessageSender.s.sol:DeployMessageSenderScript --rpc-url ${RPC_URL} --etherscan-api-key ${EXPLORER_KEY} --broadcast --verify -vvvv --ffi --legacy

deploy-ccip-receiver:
	forge script script/ccip/Deploy.MessageReceiver.s.sol:DeployMessageReceiverScript --rpc-url ${RPC_URL} --etherscan-api-key ${EXPLORER_KEY} --broadcast --verify -vvvv --ffi

send-ccip-message:
	forge script script/ccip/Send.MessageSender.s.sol:SendMessageSenderScript --rpc-url ${RPC_URL} --broadcast -vvvv --ffi --legacy