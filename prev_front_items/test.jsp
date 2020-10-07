
<%@page import="com.inswave.util.*"%><%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" pageEncoding="UTF-8" %><%@ page import="java.net.URLEncoder"%>
<%@ page import="com.initech.util.Base64Util, java.util.Map, java.io.*, java.net.*, com.inswave.admin.*,com.inswave.system.*,com.inswave.system.exception.*,com.inswave.util.*,com.inswave.msg.warn.*,org.w3c.dom.*,com.inswave.util.sfg.*,com.shinhan.util.*" %>

<h1>testpage 입니다.</h1>
<h2>aaaaaaaaaatestpage 입니다.</h2>
<form method="post" action="http://172.23.255.61:3000/test">
	<input type="text" name="hello"/>
	<input type="text" name="world"/>
	<button type="submit">click</button>
</form>
<%
	out.flush();
	RequestDispatcher dispatcher = request.getRequestDispatcher("getQr.jsp?z=https://www.naver.com/");
	dispatcher.include(request, response);
	String param="aaa";
	URL targetURL = new URL("http://172.23.255.61:3000/test");
	URLConnection urlConn = targetURL.openConnection();
	HttpURLConnection hurlc = (HttpURLConnection) urlConn;
	hurlc.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
	hurlc.setRequestMethod("POST");
	hurlc.setDoOutput(true);
	OutputStream op = hurlc.getOutputStream();
	op.write(param.getBytes());
	op.flush();
	op.close();
	BufferedReader br = new BufferedReader(new OutputStreamReader(huc.getInputStream(),"EUC-KR"),huc.getContentLength());
	string buf;
	while((buf=br.readLine())!=null)
	{
		System.out.println(buf);
	}
%>


