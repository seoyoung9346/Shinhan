<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR" import="java.net.*, java.io.*, java.util.Map" %>
<%!
	public String httpGet(String strUrl) 
	{
		try {
			URL url = new URL(strUrl);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setConnectTimeout(5000);
			con.setReadTimeout(5000);
			con.addRequestProperty("Content-Type","application/json");
			con.setRequestMethod("GET");
			con.setDoOutput(false);
			
			StringBuffer sb = new StringBuffer();
			if(con.getResponseCode() == HttpURLConnection.HTTP_OK)
			{
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(),"utf-8"));
				String line;
				while((line = br.readLine())!=null)
				{
					sb.append(line).append("\n");
				}
				br.close();
				System.out.println(""+sb.toString());
			
			}else {
				System.out.println(con.getResponseMessage());
			}
			return sb.toString();
		}catch(Exception e){
			System.err.println(e.toString());
			return null;
		}
	}
	/*public String httpPost(String requestUrl,String bankCode,String notiNumber,String notiChangeNum,String password) {
		String body = null;
		try {
	
			HttpClient client = new DefaultHttpClient();
			HttpPost post = new HttpPost(requestUrl);
			
			post.addHeader("content-type","application/json");
			post.addHeader("Accept","application/json");
			post.setEntity(new StringEntity( "{\"bankCode\":\""+ bankCode +"\",\"notiNumber\":\"" +notiNumber +"\",\"notiChangeNum\":\"" + notiChangeNum + "\",\"password\":\"" + password +"\"}" ));
			
			HttpResponse response = client.execute(post);
			
			ResponseHandler<String> handler = new BasicResponseHandler();
			body = handler.handleResponse(response);
	
		}catch(Exception e) {
	
		}
		return body;
	}*//*
	public String httpPost(String requestUrl,String bankCode,String notiNumber,String notiChangeNum,String password) {
		try {
			URL url = new URL(strUrl);
			String urlParam = "?bankCode=" + bankCode +"&notiNumber="+notiNumber+"&notiChangeNum=" + notiChangeNum + "&password=" + password;
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setConnectTimeout(5000);
			con.setReadTimeout(5000);
			con.addRequestProperty("Content-Type","application/json");
			con.setRequestMethod("POST");
			con.setDoOutput(false);
			
			StringBuffer sb = new StringBuffer();
			if(con.getResponseCode() == HttpURLConnection.HTTP_OK)
			{
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(),"utf-8"));
				String line;
				while((line = br.readLine())!=null)
				{
					sb.append(line).append("\n");
				}
				br.close();
				System.out.println(""+sb.toString());
			
			}else {
				System.out.println(con.getResponseMessage());
			}
			return sb.toString();
		}catch(Exception e){
			System.err.println(e.toString());
			return null;
		}
	}*/
%>

<%
	//이전 페이지에서 받아온 패러미터 파싱.
	String bankCode = request.getParameter("bankCode");
	String notiNumber = request.getParameter("notiNumber");
	String notiChangeNum = request.getParameter("notiChangeNum");
	String password = request.getParameter("password");
%>

<!DOCTYPE html>
<html>
<head>
	<title>Shinhan Bank L/C Service [고객 정보 조회]</title>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge; chrome=1"> <!-- IE Edge 최신 엔진으로 페이지 렌더링, chromeframe 사용 유저에게 렌더링-->
	<meta charset="utf-8"> <!-- 문자 인코딩 방식 -->
	<link href="style.css" rel="stylesheet" type="text/css"> <!-- CSS 연결 -->
</head>
<body>
	<script type="text/javascript">
		//신용장 수령 거절시
		function reject()
		{
			//백에 거절 요청
			var result = <%=httpGet("http://172.25.255.61:3000/reject")%>;
			if(result.isSuccess ==true)
			{
				alert('신용장이 거절되었습니다. 메인 페이지로 이동합니다.');
			}
			else
			{
				alert('신용장이 거절이 실패되었습니다. 다시 시도해주십시오.');
			}
			
		}
		//신용장 출력
		function printPage()
		{
			var result = <%=httpGet("http://172.25.255.61:3000/print")%>;
			if(result.isSuccess ==true)
			{
				window.print();
			}
			else
			{
				alert('신용장 출력이 실패되었습니다. 다시 시도해주십시오.');
			}
			
		}
		//QR코드 load
		function loadQR()
		{
			// client 에서 넘긴 입력 데이터들 받아서 출력 요청
			var qr =  <%=httpGet("http://172.25.255.61:3000/qrcode?bankCode=" + bankCode + "notiNumber=" +notiNumber+ "notiPlaceNum=" + notiChangeNum)%>;
			loadText(qr.result); // QR로드 후에 LC 전문 로드.
			
		}
		//text load
		function loadText(qr)
		{
			// result 가져오기
			var text = <%=httpGet("http://172.25.255.61:3000/query")%>;
			
			render(qr,text) // QR,LC 전문 로드 후에 렌더링
		}
		//신용장 렌더링
		function render(qr,text)
		{
			// 최상위 컨테이너 생성
			var div = document.createElement('div');
			div.className = 'topcontainer';
			var count = text.lc.length; // 신용장 길이
			for (var i =0; i<count ; i+=30)
			{
				var page =document.createElement('div');
				page.className ='page';
				for(var j =0;j<30;j++)
				{
					page.innerHTML += text.lc[i+j] + '<br>';				
				}
				div.appendChild(page);
				var last = document.createElement("br");
				div.appendCild(last);
			}
			var qrpage = document.createElement('div');
			qrpage.className='page';
			var img = document.createElement('img');
			img.setAttribute('src',qr);
			qrpage.appendChild(img);
			div.appendChild(qrpage);
			document.getElementById("top").appendChild(div);
		}
		// 여기서 로드 이벤트 시작(신용장 띄우기)
		window.addEventListener("load",function(event){
			loadQR(); //  QR로드 시작
		});
	</script>
	<div class = "print_loc">
		<div class = "inner_print">
			<h1 id ="title">신용장 정보 조회</h1>
			<p id ="information">거래를 진행하실 경우 출력을, 거래를 원치 않으실 경우 거절을 선택해주세요.</p>
			</br>
		</div>
		<div class="topcontainer" id ="top" style="overflow-y:auto; overflow-x:hidden; width:100%; height:565px;"> <!-- 스크롤-->
		</div>
		<div class ="hide">
			<form>
				<button type="button" class="btn2_inquiry" onclick="printPage();">출력</button>
				<button type="button" class="btn2_inquiry" onclick="reject();">거절</button>
			</form>
		</div>
	</div>
</body>
</html>