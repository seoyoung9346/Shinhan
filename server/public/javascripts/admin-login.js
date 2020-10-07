function inquiry()
{
    var id = document.getElementById('userid').value;
    var pw = document.getElementById('userpw').value;

    if(id == "" || pw == "")
    {
         alert('모든 정보를 입력해주세요.');
    }
    else
    {
         document.authForm.submit();
    }
}