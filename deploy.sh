#!/bin/bash
export KEY=0x01ca3eff7f73674e3d290e3e2401f16d76a90a63ee6ed62b95f1636342a7b344

export CONTRACT_ADDR=`forge create --legacy --rpc-url http://192.168.1.121:8545 --private-key $KEY ./src/Factory.sol:Factory|grep "Deployed to:"|sed "s/Deployed to: //"`
cast send $CONTRACT_ADDR "init()" --rpc-url http://192.168.1.121:8545 --private-key $KEY --legacy
echo $CONTRACT_ADDR "init()" --rpc-url http://192.168.1.121:8545 --private-key $KEY --legacy
