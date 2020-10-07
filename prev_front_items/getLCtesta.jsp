
<%@page import="com.inswave.util.*"%><%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" pageEncoding="UTF-8" %><%@ page import="java.net.URLEncoder"%>
<%@ page import="java.lang.*, com.initech.util.Base64Util, java.util.Map, java.io.*, java.net.*, com.inswave.admin.*,com.inswave.system.*,com.inswave.system.exception.*,com.inswave.util.*,com.inswave.msg.warn.*,org.w3c.dom.*,com.inswave.util.sfg.*,com.shinhan.util.*, org.apache.http.HttpResponse, org.apache.http.client.HttpClient, org.apache.http.client.ResponseHandler, org.apache.http.client.methods.HttpPost, org.apache.http.entity.StringEntity, org.apache.http.impl.client.BasicResponseHandler, org.apache.http.impl.client.DefaultHttpClient" %>

<%
    request.setCharacterEncoding("UTF-8");
	String bankCode = request.getParameter("bankCode");
	String notiNumber = request.getParameter("notiNumber");
	String notiChangeNum = request.getParameter("notiChangeNum");
	String password = request.getParameter("password");
	data = httpPost("http://172.23.255.61:3000/getData",json);		

    out.println(data);

%>
<%!
	public static String httpPost(String requestUrl,String json) {
		String body = null;
		try {

			HttpClient client = new DefaultHttpClient();
			HttpPost post = new HttpPost(requestUrl);
			
			post.addHeader("content-type","application/json");
			post.addHeader("Accept","application/json");
			post.setEntity(new StringEntity( "{\"kind\":\""+ json +"\"}" ));
			
			HttpResponse response = client.execute(post);
			
			ResponseHandler<String> handler = new BasicResponseHandler();
			body = handler.handleResponse(response);

		}catch(Exception e) {

		}
		return body;
	}
%>

