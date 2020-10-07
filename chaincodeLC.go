/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// MasterContract provides functions for managing lc infos.
type MasterContract struct {
	contractapi.Contract
}

// ValueContract provides functions for managing lc values.
type ValueContract struct {
	contractapi.Contract
}

// LCMaster describes basic details of LC.
type LCMaster struct {
	ClientNum    string `json:"clientNum"`    //고객번호
	LCNum        string `json:"lcNum"`        //신용장번호
	NotiPlaceNum string `json:"notiPlaceNum"` //통지점번호
	PrtCnt       int    `json:"prtCnt"`       //출력횟수
	EnrollTime   string `json:"enrollTime"`   //신용장 등록일시
	FirstPrtTime string `json:"firstPrtTime"` //신용장 최초 출력일시
	LastPrtTime  string `json:"lastPrtTime"`  //신용장 최근 출력일시
	IsBuyed      bool   `json:"isBuyed"`      //매입여부
	LCState      string `json:"lcState"`      //상태
	Password     string `json:"password"`     //비밀번호
	BuyBankCode  string `json:"buyBankCode"`  //매입은행코드
}

//LCValue contains LC datas.
type LCValue struct {
	LCHeader []string `json:"lcHeader"`
	LCBody   []string `json:"lcBody"`
	LCTail   []string `json:"lcTail"`
}

//LCKey contains key values.
type LCKey struct {
	BankCode      string `json:"bankCode"`
	NotiNumber    string `json:"notiNumber"`
	NotiChangeNum string `json:"notiChangeNum"`
	Password      string `json:"password"`
}

/*
*
* MasterContract 임베딩 함수.
*
 */

//InitLedger 레저 초기화 (테스트)
func (m *MasterContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	lcMaster := LCMaster{
		ClientNum:    "0",
		LCNum:        "0",
		NotiPlaceNum: "0",
		PrtCnt:       0,
		EnrollTime:   "0",
		FirstPrtTime: "0000-00-00",
		LastPrtTime:  "0000-00-00",
		IsBuyed:      false,
		LCState:      "ok",
		Password:     "0",
		BuyBankCode:  "0",
	}
	lcMasterAsBytes, _ := json.Marshal(lcMaster)
	key, err := ctx.GetStub().CreateCompositeKey("LC001", []string{"LC001", "LC001"})

	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(key, lcMasterAsBytes)
}

// EnrollLC : 새로운 신용장 등록
func (m *MasterContract) EnrollLC(ctx contractapi.TransactionContextInterface, keyStr string, lcMasterStr string) error {
	compKey, err := m.createCompKeyFromStr(ctx, keyStr)

	if err != nil {
		return err
	}

	lcMaster := new(LCMaster)
	json.Unmarshal([]byte(lcMasterStr), lcMaster)

	lcMaster.PrtCnt = 0
	lcMaster.FirstPrtTime = "0000-00-00 00:00:00"
	lcMaster.LastPrtTime = "0000-00-00 00:00:00"
	lcMaster.IsBuyed = false
	lcMaster.LCState = "ok"

	lcMasterAsBytes, err := json.Marshal(lcMaster)

	return ctx.GetStub().PutState(compKey, lcMasterAsBytes)
}

//RejectLC - 신용장 매입 거절
func (m *MasterContract) RejectLC(ctx contractapi.TransactionContextInterface, keyStr string) error {
	compKey, err := m.createCompKeyFromStr(ctx, keyStr)
	lcMaster, err := m.getLCMaster(ctx, compKey)

	if err != nil {
		return err
	}

	//이미 신용장이 거절된 경우, 에러 반환
	if lcMaster.LCState != "Rejected" {
		lcMaster.LCState = "Rejected"
		lcMasterAsByte, err := json.Marshal(lcMaster)
		err = ctx.GetStub().PutState(compKey, lcMasterAsByte)
		if err != nil {
			return err
		}
	} else {
		return fmt.Errorf("이미 매입 거부된 신용장입니다")
	}
	return nil
}

//UpdateStateLC - 신용장 상태 변경
func (m *MasterContract) UpdateStateLC(ctx contractapi.TransactionContextInterface, keyStr string, state string) error {
	compKey, err := m.createCompKeyFromStr(ctx, keyStr)
	lcMaster, err := m.getLCMaster(ctx, compKey)

	if err != nil {
		return err
	}

	//이미 신용장이 해당 상태일 경우, 상태 변경하지 않음
	if lcMaster.LCState != state {
		lcMaster.LCState = state
		lcMasterAsByte, err := json.Marshal(lcMaster)
		err = ctx.GetStub().PutState(compKey, lcMasterAsByte)
		if err != nil {
			return err
		}
	} else {
		return fmt.Errorf("이미 매입 거부된 신용장입니다")
	}
	return nil
}

//BuyLC - 신용장 거절을 위해 사용
func (m *MasterContract) BuyLC(ctx contractapi.TransactionContextInterface, keyStr string) error {
	compKey, err := m.createCompKeyFromStr(ctx, keyStr)
	lcMaster, err := m.getLCMaster(ctx, compKey)

	if err != nil {
		return err
	}

	if lcMaster.IsBuyed == false {
		lcMaster.IsBuyed = true
		lcMasterAsByte, err := json.Marshal(lcMaster)
		err = ctx.GetStub().PutState(compKey, lcMasterAsByte)
		if err != nil {
			return err
		}
	} else {
		return fmt.Errorf("이미 매입된 신용장입니다")
	}
	return nil
}

//PrintLC - 신용장 출력을 위해 사용
func (m *MasterContract) PrintLC(ctx contractapi.TransactionContextInterface, keyStr string, curTime string) error {
	compKey, err := m.createCompKeyFromStr(ctx, keyStr)
	lcMaster, err := m.getLCMaster(ctx, compKey)

	if err != nil {
		return err
	}

	if lcMaster.PrtCnt == 0 {
		lcMaster.FirstPrtTime = curTime
		lcMaster.LastPrtTime = curTime
	} else {
		lcMaster.LastPrtTime = curTime
	}
	lcMaster.PrtCnt = lcMaster.PrtCnt + 1

	lcMasterAsByte, err := json.Marshal(lcMaster)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(compKey, lcMasterAsByte)
}

//내부에서만 호출. 입력받은 key로 LCMaster 값을 찾아주는 함수.
func (m *MasterContract) getLCMaster(ctx contractapi.TransactionContextInterface, compKey string) (*LCMaster, error) {
	resByte, err := ctx.GetStub().GetState(compKey)

	if resByte == nil || err != nil {
		return nil, fmt.Errorf("Ledger에 신용장이 존재하지 않습니다")
	}

	lcMaster := new(LCMaster)
	err = json.Unmarshal(resByte, lcMaster)

	if err != nil {
		return nil, fmt.Errorf("데이터 언마샬링 실패 in getLCMaster")
	}

	return lcMaster, nil
}

//내부에서만 호출. 입력받은 JSON string을 key로 만들어주는 함수.
func (m *MasterContract) createCompKeyFromStr(ctx contractapi.TransactionContextInterface, keyStr string) (string, error) {
	key := new(LCKey)
	err := json.Unmarshal([]byte(keyStr), key)

	if err != nil {
		return "", fmt.Errorf("데이터 언마샬링 실패:" + keyStr)
	}

	compKey, err := ctx.GetStub().CreateCompositeKey(key.NotiNumber, []string{key.NotiChangeNum, key.BankCode})
	return compKey, nil
}

/*
*
*	ValueContract 임베딩 함수.
*
 */

// EnrollLC : 새로운 신용장 등록
func (v *ValueContract) EnrollLC(ctx contractapi.TransactionContextInterface,
	keyStr string, lcValueStr string) error {

	key := new(LCKey)
	err := json.Unmarshal([]byte(keyStr), key)

	if err != nil {
		return fmt.Errorf("데이터 언마샬링 실패:" + keyStr)
	}

	compKey, err := ctx.GetStub().CreateCompositeKey(key.NotiNumber, []string{key.NotiChangeNum, key.BankCode, "LC"})
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(compKey, []byte(lcValueStr))
}

//GetLC - 신용장 조회를 위해 사용
func (v *ValueContract) GetLC(ctx contractapi.TransactionContextInterface, keyStr string) (*LCValue, error) {

	key := new(LCKey)
	err := json.Unmarshal([]byte(keyStr), key)

	if err != nil {
		return nil, fmt.Errorf("데이터 언마샬링 실패:" + keyStr)
	}

	compKey, err := ctx.GetStub().CreateCompositeKey(key.NotiNumber, []string{key.NotiChangeNum, key.BankCode, "LC"})
	resByte, err := ctx.GetStub().GetState(compKey)

	if resByte == nil || err != nil {
		return nil, fmt.Errorf("Ledger에 신용장이 존재하지 않습니다")
	}

	lcValue := new(LCValue)
	err = json.Unmarshal(resByte, lcValue)

	if err != nil {
		return nil, fmt.Errorf("데이터 언마샬링 실패" + string(resByte))
	}

	return lcValue, nil
}

func main() {
	masterContract := new(MasterContract)
	masterContract.Contract.Name = "MasterContract"

	valueContract := new(ValueContract)
	valueContract.Contract.Name = "ValueContract"

	chaincode, err := contractapi.NewChaincode(masterContract, valueContract)

	if err != nil {
		fmt.Printf("Error when creating LC chaincode: %s", err.Error())
	}

	err = chaincode.Start()
	if err != nil {
		fmt.Printf("Error when starting LC chaincode: %s", err.Error())
	}
}
