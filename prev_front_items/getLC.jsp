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
	//���� ���������� �޾ƿ� �з����� �Ľ�.
	String bankCode = request.getParameter("bankCode");
	String notiNumber = request.getParameter("notiNumber");
	String notiChangeNum = request.getParameter("notiChangeNum");
	String password = request.getParameter("password");
%>

<!DOCTYPE html>
<html>
<head>
	<title>Shinhan Bank L/C Service [�� ���� ��ȸ]</title>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge; chrome=1"> <!-- IE Edge �ֽ� �������� ������ ������, chromeframe ��� �������� ������-->
	<meta charset="utf-8"> <!-- ���� ���ڵ� ��� -->
	<link href="style.css" rel="stylesheet" type="text/css"> <!-- CSS ���� -->
</head>
<body>
	<script type="text/javascript">
		//�ſ��� ���� ������
		function reject()
		{
			//�鿡 ���� ��û
			var result = <%=httpGet("http://172.25.255.61:3000/reject")%>;
			if(result.isSuccess ==true)
			{
				alert('�ſ����� �����Ǿ����ϴ�. ���� �������� �̵��մϴ�.');
			}
			else
			{
				alert('�ſ����� ������ ���еǾ����ϴ�. �ٽ� �õ����ֽʽÿ�.');
			}
			
		}
		//�ſ��� ���
		function printPage()
		{
			var result = <%=httpGet("http://172.25.255.61:3000/print")%>;
			if(result.isSuccess ==true)
			{
				window.print();
			}
			else
			{
				alert('�ſ��� ����� ���еǾ����ϴ�. �ٽ� �õ����ֽʽÿ�.');
			}
			
		}
		//QR�ڵ� load
		function loadQR()
		{
			// client ���� �ѱ� �Է� �����͵� �޾Ƽ� ��� ��û
			var qr =  <%=httpGet("http://172.25.255.61:3000/qrcode?bankCode=" + bankCode + "notiNumber=" +notiNumber+ "notiPlaceNum=" + notiChangeNum)%>;
			loadText(qr.result); // QR�ε� �Ŀ� LC ���� �ε�.
			
		}
		//text load
		function loadText(qr)
		{
			// result ��������
			var text = <%=httpGet("http://172.25.255.61:3000/query")%>;
			
			render(qr,text) // QR,LC ���� �ε� �Ŀ� ������
		}
		//�ſ��� ������
		function render(qr,text)
		{
			// �ֻ��� �����̳� ����
			var div = document.createElement('div');
			div.className = 'topcontainer';
			var count = text.lc.length; // �ſ��� ����
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
		// ���⼭ �ε� �̺�Ʈ ����(�ſ��� ����)
		window.addEventListener("load",function(event){
			loadQR(); //  QR�ε� ����
		});
	</script>
	<div class = "print_loc">
		<div class = "inner_print">
			<h1 id ="title">�ſ��� ���� ��ȸ</h1>
			<p id ="information">�ŷ��� �����Ͻ� ��� �����, �ŷ��� ��ġ ������ ��� ������ �������ּ���.</p>
			</br>
		</div>
		<div class="topcontainer" id ="top" style="overflow-y:auto; overflow-x:hidden; width:100%; height:565px;"> <!-- ��ũ��-->
		</div>
		<div class ="hide">
			<form>
				<button type="button" class="btn2_inquiry" onclick="printPage();">���</button>
				<button type="button" class="btn2_inquiry" onclick="reject();">����</button>
			</form>
		</div>
	</div>
</body>
</html>