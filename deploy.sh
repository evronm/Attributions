#!/bin/bash
export RPC_URL=http://127.0.0.1:8545
export KEY=0x3a722d3b6b2124e82f640576c0c543dd714d9ee4d316c9ea27b622475b863c95

export CONTRACT_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY ./src/Factory.sol:Factory|grep "Deployed to:"|sed "s/Deployed to: //"`
cast send $CONTRACT_ADDR "init()" --rpc-url $RPC_URL --private-key $KEY --legacy
echo $CONTRACT_ADDR "init()" --rpc-url $RPC_URL --private-key $KEY --legacy
