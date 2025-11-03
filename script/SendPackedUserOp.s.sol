// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {PackedUserOperation} from "account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract sendPackedUserOp is Script {
    function run() public {}

    function generatedSignedUserOperation(bytes memory callData, address sender)
        public
        view
        returns (PackedUserOperation memory)
    {
        uint256 nonce = vm.getNonce(sender);
        PackedUserOperation memory unsignedUserOp = _generateUnsignedUserOperation(callData, sender, nonce);

        return unsignedUserOp;
    }

    function _generateUnsignedUserOperation(bytes memory callData, address sender, uint256 nonce)
        internal
        pure
        returns (PackedUserOperation memory)
    {
        uint128 verificationGasLimit = 16777216;
        uint128 callGasLimit = verificationGasLimit; // Often different in practice
        uint128 maxPriorityFeePerGas = 256;
        uint128 maxFeePerGas = maxPriorityFeePerGas; // Simplification for example

        bytes32 accountGasLimits = bytes32((uint256(verificationGasLimit) << 128) | uint256(callGasLimit));

        bytes32 gasFees = bytes32((uint256(maxFeePerGas) << 128) | uint256(maxPriorityFeePerGas));

        return PackedUserOperation({
            sender: sender,
            nonce: nonce,
            initCode: hex"", // Empty for existing accounts
            callData: callData,
            accountGasLimits: accountGasLimits,
            preVerificationGas: verificationGasLimit, // Often related to verificationGasLimit
            gasFees: gasFees,
            paymasterAndData: hex"", // Empty if not using a paymaster
            signature: hex"" // Crucially, the signature is blank for an unsigned operation
        });
    }
}
