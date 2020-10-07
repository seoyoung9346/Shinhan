function sendData() {
    var bankCode = document.getElementById('bankCode').value;
    var notiNumber = document.getElementById('notiNumber').value;
    var notiChangeNum = document.getElementById('notiChangeNum').value;
    var password = document.getElementById('password').value;
   
    if(bankCode == "" || notiNumber == "" || notiChangeNum == "" || password == "")
    {
        alert('모든 정보를 입력해주세요.');
    }
    else
    {
        document.inquiryForm.submit();
    }
}