# Shinhan


<h2> 서버 시작하기 : <br></h2>
server 폴더에서 npm install -> npm start <br>
localhost:3000에서 서버가 시작됨

DB / 체인코드 연동 설정은 모두 따로 해줘야함.

<h2> DB 연동 : <br></h2>
mysql이나 mariadb 설치 후 서버 실행 <br>
server/routes/api/mariadb-connect.js 에서 db 설정 확인

데이터 베이스 생성 후
users 테이블과 logs 테이블을 생성해야함

<h2> 체인코드 연동 : <br></h2>
hyperledger fabric 2.1.0을 설치하고 fabric-samples/chaincode/go/fabcar.go 를 chaincodeLC.go에 있는 내용으로 바꿈.
그 후에 test-network에서 네트워크 실행 및 체인코드 설치하면 연동됨
