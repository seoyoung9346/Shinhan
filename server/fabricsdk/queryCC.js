/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Gateway, Wallets } = require('fabric-network');
const path = require('path');
const fs = require('fs');

async function getNetwork() {
    try{
    // load the network configuration
    const ccpPath = path.resolve(__dirname, '..', '..', 'fabric-samples', 'test-network', 'organizations', 'peerOrganizations', 'org1.example.com', 'connection-org1.json');
    const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

    // Create a new file system based wallet for managing identities.
    const walletPath = path.join(__dirname, 'wallet');
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);

    // Check to see if we've already enrolled the user.
    const identity = await wallet.get('appUser');
    if (!identity) {
        console.log('An identity for the user "appUser" does not exist in the wallet');
        console.log('Run the registerUser.js application before retrying');
        return;
    }

    // Create a new gateway for connecting to our peer node.
    const gateway = new Gateway();
    await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

    // Get the network (channel) our contract is deployed to.
    const network = await gateway.getNetwork('mychannel');

    return network;
    
    } catch (error) {
        console.error(`Failed to get contract: ${error}`);
        throw error;
    }
}

//LC 조회 SDK 함수
async function GetLC(keyJson) {
    try{
        //네트워크를 가져옴.
        const network = await getNetwork();
        //JSON으로 가져온 키를 string으로 변환.
        const keyJsonStr = JSON.stringify(keyJson);

        //필요한 Contract를 가져옴.
        let contract = network.getContract('fabcar', 'ValueContract');
        //트랜잭션 실행 후 결과 반환
        const result = await contract.evaluateTransaction('GetLC', keyJsonStr);
        return JSON.parse(result.toString('utf-8'));
    } catch (error) {
        console.log(`Failed to evaluate transaction: ${error}`)
    }
}

async function EnrollLC(keyJson, lcMasterJson, lcValueJson) {
    try {
        const network = await getNetwork();

        const keyJsonStr = JSON.stringify(keyJson);
        const lcMasterJsonStr = JSON.stringify(lcMasterJson);
        const lcValueJsonStr = JSON.stringify(lcValueJson);
        
        let contract = await network.getContract('fabcar', 'MasterContract');
        await contract.submitTransaction('EnrollLC', keyJsonStr, lcMasterJsonStr);
        console.log("here");
        contract = await network.getContract('fabcar', 'ValueContract');
        await contract.submitTransaction('EnrollLC', keyJsonStr, lcValueJsonStr);
    } catch (error) {
        console.log(`Failed to evaluate transaction: ${error}`)
    }
}

async function BuyLC(keyJson) {
    try{
        const network = await getNetwork();
        const keyJsonStr = JSON.stringify(keyJson);

        let contract = network.getContract('fabcar', 'MasterContract');
        const result = await contract.submitTransaction('BuyLC', keyJsonStr);
        return result;
    } catch (error) {
        console.log(`Failed to evaluate transaction: ${error}`)
    }
}

async function RejectLC(keyJson) {
    try{
        const network = await getNetwork();
        const keyJsonStr = JSON.stringify(keyJson);

        let contract = network.getContract('fabcar', 'MasterContract');
        const result = await contract.submitTransaction('RejectLC', keyJsonStr)
        return result;
    } catch (error) {
        console.log(`Failed to evaluate transaction: ${error}`)
    }
}

async function PrintLC(keyJson, curTime) {
    try{
        const network = await getNetwork();
        const keyJsonStr = JSON.stringify(keyJson);

        let contract = network.getContract('fabcar', 'MasterContract');
        const result = await contract.submitTransaction('PrintLC', keyJsonStr, curTime);
        return result;
    } catch (error) {
        console.log(`Failed to evaluate transaction: ${error}`)
    }
}

module.exports = {GetLC, EnrollLC, BuyLC, RejectLC, PrintLC};