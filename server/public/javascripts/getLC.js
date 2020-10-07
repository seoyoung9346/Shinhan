function send (callback) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === xhr.DONE) {
            if (xhr.status === 200 || xhr.status === 201) {
                callback(xhr.responseText);
            } else {
                console.error(xhr.responseText);
            }
        }
    };
    xhr.open('GET', '/rejected');
    xhr.send();
}

function loadText(result) {
    // 페이지 수
    var count = result.length;
    // 최상위 컨테이너 생성
    var div = document.createElement('div');
    div.className = 'topcontainer';
    for (var i = 0; i < count; i += 30) {
        var page = document.createElement('div');
        page.className = 'page';
        for (var j = 0; j < 30; j++) {
            page.innerHTML += result[i+j] + '<br>';
        }
        div.appendChild(page);
    }
    document.getElementById("top").appendChild(div);
}

// 출력하기
function printQR() {
    /*
    // client 에서 넘긴 입력 데이터들 받아서 출력 요청
    var keys = parseQueryString();
    send('http://172.29.255.189:3000/print', 'success', keys[0], keys[1], keys[2]);
    // 백에서 성공 신호 보낼 시 QR 생성 및 인쇄
    var submit = document.getElementsByClassName("success"); // 만약 오류가 이 줄에서 뜬다면 뒤에 [0]을 붙여주세요!
    if(submit.isSuccess == true) {
        getQR();
        loadText('qr');
        window.print();
    }
    else
        alert('신용장 출력에 실패하였습니다. 다시 시도해주십시오.');
    */
    window.print();
}

// 신용장 수령 거절 시
function inquiry() {
    send((response) => {
        console.log(response);
        // 거절 확인
        if (response.isRejected == true){
            alert('신용장이 거절되었습니다. 메인 페이지로 이동합니다.');
        }
        else
            alert('신용장 거절이 실패되었습니다. 다시 시도해주십시오.');
    });
}

// 키 값 보내서 QR 생성 후 qr 이라는 class 에 담아주기
function getQR() {
    var keys = parseQueryString();
    //send('getQr.jsp?z=bank.html?'bankCode='+keys[0]+'notiNumber='+keys[1]+'notiChangeNum='+keys[2]', 'qr', keys[0], keys[1], keys[2]);
}

/* 여기서부터 실행 */
loadText(result);
console.log(result);