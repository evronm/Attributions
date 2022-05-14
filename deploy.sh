#!/bin/bash
export RPC_URL=http://127.0.0.1:8545
export KEY=5ee56d995e0f821a360bc0e09aeab8c0593a2e96e037e080c6f70154cf1858d5

export LIB_FILE='./src/Common.sol'
export UTILS_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY $LIB_FILE:Utils|grep "Deployed to:"|sed "s/Deployed to: //"`
export UTILS_LIB="$LIB_FILE:Utils:${UTILS_ADDR}"
export KVMS_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY --libraries $UTILS_LIB $LIB_FILE:Kvs|grep "Deployed to:"|sed "s/Deployed to: //"`
export KVMS_LIB="$LIB_FILE:Kvms:${KVMS_ADDR}"
export STR_ADDRS_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY --libraries $UTILS_LIB $LIB_FILE:Str_addrs|grep "Deployed to:"|sed "s/Deployed to: //"`
export STR_ADDRS_LIB="$LIB_FILE:Str_addrs:${STR_ADDRS_ADDR}"
export TAGS_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY --libraries $UTILS_LIB $LIB_FILE:Tags|grep "Deployed to:"|sed "s/Deployed to: //"`
export TAGS_LIB="$LIB_FILE:Tags:${TAGS_ADDR}"
export CONTRACT_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY ./src/Factory.sol:Factory --libraries $UTILS_LIB --libraries $KVMS_LIB --libraries $STR_ADDRS_LIB --libraries $TAGS_LIB |grep "Deployed to:"|sed "s/Deployed to: //"`
cast send $CONTRACT_ADDR "init()" --rpc-url $RPC_URL --private-key $KEY --legacy
