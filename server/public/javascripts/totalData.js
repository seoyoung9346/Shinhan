var xhr = new XMLHttpRequest();
xhr.open('POST','/lcn/historyManagement.jsp'); // 보내는 스트림 열기
xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded'); // 헤더 선언, 데이터 인코딩
xhr.addEventListener('load',function () {
    result = JSON.parse(xhr.responseText); // result.result[0] result.result[1]
    try{
        if(result.isSuccess == 'true')
        {
            loadText(result.result);	
        }else
        {
            alert('DB와의 연결이 불안정합니다');
        }
    }catch(e)
    {
        alert('서버와의 연결이 불안정합니다');
    }
});
  xhr.send("kind=total"); // 백엔드로 데이터 전송
  
  function loadText(result)
  {
   var i =0;
      
      var tableRef = document.getElementById('showTable').getElementsByTagName('tbody')[0];
      var RowCount = tableRef.rows.length;

      while(result[i] != undefined)
    {
          var newRow = tableRef.insertRow(RowCount);
          var newCell1 = newRow.insertCell(0);
          var newCell2 = newRow.insertCell(1);
          var newCell3 = newRow.insertCell(2);
          var newCell4 = newRow.insertCell(3);
          var newCell5 = newRow.insertCell(4);
          var newCell6 = newRow.insertCell(5);
          
         newCell1.innerHTML = result[i].bankCode;
         newCell2.innerHTML = result[i].notiNumber;
         newCell3.innerHTML = result[i].notiChangeNum;
         newCell4.innerHTML = result[i].date;
         newCell5.innerHTML = result[i].request;
         newCell6.innerHTML = result[i].success;

       i+=1;
    }
  }