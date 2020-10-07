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
	public String httpPost(String requestUrl,String bankCode,String notiNumber,String notiChangeNum,String password) {
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
	}
%>

<%
	//이전 페이지 or QR 에서 받아온 패러미터 파싱.
	String bankCode = request.getParameter("bankCode");
	String notiNumber = request.getParameter("notiNumber");
	String notiChangeNum = request.getParameter("notiChangeNum");
	String password = request.getParameter("password");
%>

<!DOCTYPE html>
<html>
<head>
   <title>Shinhan Bank L/C Service [매입 서비스]</title>
   <meta http-equiv="X-UA-Compatible" content="IE=Edge; chrome=1"> <!--IE Edge 최신 엔진으로 페이지 렌더링, chromeframe 사용 유저에게 렌더링-->
   <meta charset="utf-8"> <!--문자 인코딩 방식-->
   <link href="style.css" rel="stylesheet" type="text/css"> <!--CSS 연결-->

</head>

<body>
   <!--네이게이션 바-->
   <nav>
       <ul class="nav-container">
           <li class="nav-item"><a href="/">신한은행 홈</a></li>
           <li class="nav-item"><a href="main.html">메인페이지</a></li>
           <li class="nav-item"><a href="client.html">신용장 정보 조회</a></li>
       </ul>
   </nav>

   <script type="text/javascript">
	
    //서버로 패러미터 넘겨줌.
	function identify()
	{
		
		//조회 요청. (httpPost)
		var result = <%=httpPost("http://172.23.255.61:3000/query",bankCode,notiNumber,notiChangeNum,password)%>;
		
		return result.isSuccess;
	}
	
	//jsp로 패스워드 넘겨줌.
    function send(password) {
			var pwJson = {password: password}
	        data = JSON.stringify(pwJson); // JavaScript 값을 JSON 문자열로 변환
	        // 비동기적(페이지 렌더링 없이 데이터 받기)으로 정보를 요청
	        var xhr = new XMLHttpRequest(); // 생성자 호출               xhr.open('post',url); // 보내는 스트림 열기
	        xhr.setRequestHeader('Content-Type','application/json'); // 헤더 선언, 데이터 인코딩
	        xhr.send(data); // 백엔드로 데이터 전송
	        xhr.addEventListener('load',function () {
	        //var result = JSON.parse(xhr.responseText); // getresult class 에 백엔드에서 넘어온 정보를 JSON 형식으로 바꾸어 입력 -> 나중에 result.name 이런 식으로 필요한 정보 가져오기
	        
			if(identify()) {
					<%=httpGet("getLC.jsp?bankCode="+bankCode+"&notiNumber="
					+notiNumber+"&notiChangeNum="+notiChangeNum+"&password="+password)%>;
			} else alert('잘못된 패스워드 입니다.')
        });
        
    }

   </script>

   <!--백엔드에서 보내는 데이터 받을 객체 생성-->
   <div class="result" type="hidden"></div>

   <div class="inner_inquiry">
       <div class="inquiry_tistory">
           <form name="inquiryForm" action="webserver.jsp" method="post" enctype="application/x-www-form-urlencoded">
               <fieldset>
                   <legend class="screen_out">신용장 매입 서비스</legend>
                   <h1 id="title"> 신용장 매입 서비스</h1>
                   <p style ="line-height: 1px">
                   <legend id="information">조회 할 신용장의 비밀번호를 입력해주세요.</legend>
                   </p>
                   <div class="box_inquiry">
                       <div class="inp_text">
                           <label for="password" class="screen_out">비밀번호</label>
                           <input type="password" id="password" name="password" placeholder="비밀번호">
                           <i class="fa fa-eye fa-lg"></i>
                       </div>
                   </div>
                   <button type="button" class="btn_inquiry" onclick="send()">신용장 매입</button>
               </fieldset>
           </form>
       </div>
   </div>

</body>

</html>