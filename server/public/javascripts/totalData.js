function loadText(result)
  {
   var i =0;
      
      var tableRef = document.getElementById('showTable').getElementsByTagName('tbody')[0];
      var RowCount = tableRef.rows.length;

      while(result[i])
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
         newCell4.innerHTML = result[i].time;
         newCell5.innerHTML = result[i].type;
         newCell6.innerHTML = result[i].isSuccess;

       i+=1;
    }
}

console.log(result);
loadText(result);