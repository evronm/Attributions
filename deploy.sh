#!/bin/bash
export RPC_URL=http://127.0.0.1:8545
export KEY=0xf7d6fea62eeac6ceb372632ecc10702f4f97899d48647ddc88b0a31e438ad450

export LIB_FILE='./src/Common.sol'
export UTILS_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY $LIB_FILE:Utils|grep "Deployed to:"|sed "s/Deployed to: //"`
export UTILS_LIB="$LIB_FILE:Utils:${UTILS_ADDR}"
export KVS_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY --libraries $UTILS_LIB $LIB_FILE:Kvs|grep "Deployed to:"|sed "s/Deployed to: //"`
export KVS_LIB="$LIB_FILE:Kvms:${KVS_ADDR}"
export STR_ADDRS_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY --libraries $UTILS_LIB $LIB_FILE:Str_addrs|grep "Deployed to:"|sed "s/Deployed to: //"`
export STR_ADDRS_LIB="$LIB_FILE:Str_addrs:${STR_ADDRS_ADDR}"
export TAGS_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY --libraries $UTILS_LIB $LIB_FILE:Tags|grep "Deployed to:"|sed "s/Deployed to: //"`
export TAGS_LIB="$LIB_FILE:Tags:${TAGS_ADDR}"
export CONTRACT_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY --libraries $UTILS_LIB $KVMS_LIB $STR_ADDRS_LIB $TAGS_LIB ./src/Factory.sol:Factory|grep "Deployed to:"|sed "s/Deployed to: //"`
cast send $CONTRACT_ADDR "init()" --rpc-url $RPC_URL --private-key $KEY --legacy
