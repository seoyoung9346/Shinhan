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
	//���� ������ or QR ���� �޾ƿ� �з����� �Ľ�.
	String bankCode = request.getParameter("bankCode");
	String notiNumber = request.getParameter("notiNumber");
	String notiChangeNum = request.getParameter("notiChangeNum");
	String password = request.getParameter("password");
%>

<!DOCTYPE html>
<html>
<head>
   <title>Shinhan Bank L/C Service [���� ����]</title>
   <meta http-equiv="X-UA-Compatible" content="IE=Edge; chrome=1"> <!--IE Edge �ֽ� �������� ������ ������, chromeframe ��� �������� ������-->
   <meta charset="utf-8"> <!--���� ���ڵ� ���-->
   <link href="style.css" rel="stylesheet" type="text/css"> <!--CSS ����-->

</head>

<body>
   <!--���̰��̼� ��-->
   <nav>
       <ul class="nav-container">
           <li class="nav-item"><a href="/">�������� Ȩ</a></li>
           <li class="nav-item"><a href="main.html">����������</a></li>
           <li class="nav-item"><a href="client.html">�ſ��� ���� ��ȸ</a></li>
       </ul>
   </nav>

   <script type="text/javascript">
	
    //������ �з����� �Ѱ���.
	function identify()
	{
		
		//��ȸ ��û. (httpPost)
		var result = <%=httpPost("http://172.23.255.61:3000/query",bankCode,notiNumber,notiChangeNum,password)%>;
		
		return result.isSuccess;
	}
	
	//jsp�� �н����� �Ѱ���.
    function send(password) {
			var pwJson = {password: password}
	        data = JSON.stringify(pwJson); // JavaScript ���� JSON ���ڿ��� ��ȯ
	        // �񵿱���(������ ������ ���� ������ �ޱ�)���� ������ ��û
	        var xhr = new XMLHttpRequest(); // ������ ȣ��               xhr.open('post',url); // ������ ��Ʈ�� ����
	        xhr.setRequestHeader('Content-Type','application/json'); // ��� ����, ������ ���ڵ�
	        xhr.send(data); // �鿣��� ������ ����
	        xhr.addEventListener('load',function () {
	        //var result = JSON.parse(xhr.responseText); // getresult class �� �鿣�忡�� �Ѿ�� ������ JSON �������� �ٲپ� �Է� -> ���߿� result.name �̷� ������ �ʿ��� ���� ��������
	        
			if(identify()) {
					<%=httpGet("getLC.jsp?bankCode="+bankCode+"&notiNumber="
					+notiNumber+"&notiChangeNum="+notiChangeNum+"&password="+password)%>;
			} else alert('�߸��� �н����� �Դϴ�.')
        });
        
    }

   </script>

   <!--�鿣�忡�� ������ ������ ���� ��ü ����-->
   <div class="result" type="hidden"></div>

   <div class="inner_inquiry">
       <div class="inquiry_tistory">
           <form name="inquiryForm" action="webserver.jsp" method="post" enctype="application/x-www-form-urlencoded">
               <fieldset>
                   <legend class="screen_out">�ſ��� ���� ����</legend>
                   <h1 id="title"> �ſ��� ���� ����</h1>
                   <p style ="line-height: 1px">
                   <legend id="information">��ȸ �� �ſ����� ��й�ȣ�� �Է����ּ���.</legend>
                   </p>
                   <div class="box_inquiry">
                       <div class="inp_text">
                           <label for="password" class="screen_out">��й�ȣ</label>
                           <input type="password" id="password" name="password" placeholder="��й�ȣ">
                           <i class="fa fa-eye fa-lg"></i>
                       </div>
                   </div>
                   <button type="button" class="btn_inquiry" onclick="send()">�ſ��� ����</button>
               </fieldset>
           </form>
       </div>
   </div>

</body>

</html>