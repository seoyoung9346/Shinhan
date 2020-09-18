<%@page import="com.inswave.util.*"%><%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" pageEncoding="UTF-8" %><%@ page import="java.net.URLEncoder"%>
<%@ page import="com.initech.util.Base64Util, java.util.Map, java.io.*, java.net.*, com.inswave.admin.*, com.inswave.system.*, com.inswave.system.exception.*,com.inswave.util.*,com.inswave.msg.warn.*,org.w3c.dom.*,com.inswave.util.sfg.*,com.shinhan.util.*" %>
<%!
   public static byte[] httpGet(String requestUrl) throws Exception {
       HttpURLConnection connection = null;
       DataInputStream dis = null;

       try{
           URL url = new URL(requestUrl);

           connection = (HttpURLConnection) url.openConnection();
           connection.setRequestMethod("GET");
           connection.setAllowUserInteraction(false);
           connection.setConnectTimeout(5000);
           connection.setReadTimeout(20000);
           connection.setUseCaches(false);
           connection.setDefaultUseCaches(false);

           int status = connection.getResponseCode();
           ByteArrayOutputStream baos = new ByteArrayOutputStream();
           byte[] result = null;

           switch (status) {
               case HttpURLConnection.HTTP_OK:
               case HttpURLConnection.HTTP_CREATED:
                   int nRead;
                   byte[] data = new byte[1024];
                   InputStream is = connection.getInputStream();
                   while ((nRead=is.read(data,0,data.length)) != -1) {
                       baos.write(data, 0, nRead);
                   }
                   baos.flush();
                   result = baos.toByteArray();
               //dis= new DataInputStream(connection.getInputStream());
               //result = new byte[dis.available()];
               //dis.readFully(result);
                   break;

               default:
                   break;
           }

           return result;

       }
       catch (SocketTimeoutException e) {
           Writer writer = new StringWriter();
           PrintWriter printWriter = new PrintWriter(writer);
           e.printStackTrace(printWriter);
           throw e;
       }
       catch (Exception e) {
            Writer writer = new StringWriter();
           PrintWriter printWriter = new PrintWriter(writer);
           e.printStackTrace(printWriter);
           throw e;
       }
       finally {
           if(dis != null) {
               dis.close();
           }

           if(connection != null) {
               connection.disconnect();
           }
       }
   }

public static byte[] httpPost(String requestUrl, String data) throws Exception {
   HttpURLConnection connection = null;

   try {
       URL url = new URL(requestUrl);

       connection = (HttpURLConnection) url.openConnection();
       connection.setRequestMethod("POST");
       connection.setAllowUserInteraction(false);
       connection.setConnectTimeout(5000);
       connection.setReadTimeout(20000);

       if (data != null) {
           byte[] sendData = data.getBytes("utf-8");
           connection.setDoInput(true);
           connection.setDoOutput(true);
           connection.setUseCaches(false);
           connection.setDefaultUseCaches(false);

           OutputStream os = connection.getOutputStream();
           os.write(sendData);
           os.flush();
           os.close();
       }

       int status = connection.getResponseCode();
       byte[] result = null;

       switch(status) {
           case HttpURLConnection.HTTP_OK:
           case HttpURLConnection.HTTP_CREATED:
               DataInputStream dis = new DataInputStream(connection.getInputStream());
               result = new byte[dis.available()];
               dis.readFully(result);

               break;
           default:
               break;
       }

       return result;

   } catch (SocketTimeoutException e) {
       Writer writer = new StringWriter();
       PrintWriter printWriter = new PrintWriter(writer);
       e.printStackTrace(printWriter);
       throw e;

   } catch (Exception e) {
       Writer writer = new StringWriter();
       PrintWriter printWriter = new PrintWriter(writer);
       e.printStackTrace(printWriter);
       throw e;

   } finally {
       if(connection != null) {
           connection.disconnect();
       }
   }
}

public static String getQrUrl() {
   Logger.info("#### getQr serverG :"+SysUtil.getSystemGubun());

   if("T".equals(SysUtil.getSystemGubun())) {
       return "http://" + "192." + "168." + "155." + "145";
   } else if ("D".equals(SysUtil.getSystemGubun())) {
       return "http://" + "192." + "168." + "155." + "145";
   } else {
       return "http://" + "192." + "168." + "91." + "26";
   }
}

public static String getImageDomain () {
   Logger.info("#### getQr getImageDomain :"+SysUtil.getSystemGubun());

   if("T".equals(SysUtil.getSystemGubun())) {
       return "https://devimg3.shinhan.com";
   } else if ("D".equals(SysUtil.getSystemGubun())) {
       return "https://devimg3.shinhan.com";
   } else {
       return "https://image.shinhan.com";
   }
}

//보안취약점 XSS (Cross-Site Scripting) 방지 (2009.03.04 L.S.H)
public static String XSSFilter(String sInvalid) {
   if(sInvalid == null || sInvalid.equals("")) {
       return "";
   }

   String sValid = sInvalid.trim();

   //sValid=sValid.replaceAll("&", "&amp;");
   sValid=sValid.replaceAll("<", "&lt;");
   sValid=sValid.replaceAll(">", "&gt;");

   return sValid;
}
%>