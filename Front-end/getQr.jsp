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

<%
   SessionUtil.setSessionInfo( request, response);
   request.setCharacterEncoding("UTF-8");
   boolean permitMulti = false;

   try {

      /* *********************************************
       * 1. QR코드 등록(E 8701) 전문 호출로 QR키 값 생성
       ***********************************************/
       Document doc = XMLUtil.getDocument("qrdoc");
       //Document resultDoc = null;

       /* ********************************************
       * 2. QR데이터 생성
       ***********************************************/
       String paramStr = "z";
       String qrData = this.XSSFilter((String) request.getParameter(paramStr));
       if (qrData == null || "".equals(qrData)) {
           qrData = "isempty";
       }

       //param2 = URLEncoder.encode(param2, "UTF-8"); // 한글일 경우 인코딩
       Logger.info("#### getQr qrData :" + qrData);

       // 3. QR 변환서버로 QR 생성 요청
       String qrSize = XMLUtil.getString(doc, "QR크기");
       // QR 크기가 설정되지 않았을 경우. 일반 사이즈로 설정
       if ("".equals(qrSize)) {
           qrSize = "1";
       }

       long milliTime = System.currentTimeMillis();
       Logger.info("#### makeQr milli :" + milliTime);
       String milliStr = "" + milliTime;
       String fileName = DateUtil.getCurrentDate("yyyyMMddHHmmss");
       String qrServerUrl = getQrUrl() + "/qr/makeQr_Tong.jsp?";
       qrServerUrl += "qrData=" + qrData + "&k=" + fileName + milliStr + "&qrSize=" + qrSize;

       String nqr = qrData.replaceAll("\\^", "\\&");
       Logger.info("#### makeQr getQr qrData replaceAll :" + nqr);

       Logger.info("#### makeQr getQr qrServerUrl :" + qrServerUrl);

       // 4. 결과값 출력
       byte[] result = httpGet(qrServerUrl);

       // QR 서버에서 응답 값을 못 받은 경우
       if (result == null || result.length == 0) {
           Documment wDoc = WarningUtil.makeWarningDoc("QR코드 생성 중 오류가 발생했습니다. [RPT 통신 에러]", WarningUtil.WARNING, "", "");
           XMLUtil.setAttribute(wDoc, "errorCode", "1111");
           out.print("<?xml version='1.0' encoding='UTF-8' ?>\n" + MessageUtil.serialize(wDoc));
           return;
       }
       Logger.info("#### qrServer Url : " );
       Logger.info("#### getQr resultDoc : " + result + "      Base64Util.encode(result) = " + Base64Util.encode(result));

       String resultDats = new String(Base64Util.encode(result));

       //XMLUtil.setByte(resultDoc, "IMAGE", Base64Util.encode(result));

       //Logger.info("#### getQr resultData :" + resultData);
       String imgDomain = getImageDomain();
       boolean isMobile = SysUtil.isMobile(request);

       out.print("<div style='text-align:center'><img id='qr_img' src=\"data:image/jpeg;base64." + resultData + "\" width='100%' style='max-width:200px'/></div>");
       /*
       out.print("<div style='text-align:center'><img id='qr_img' src=\"data:image/jpeg;base64." + resultData + "\" width='100%' style='max-width:200px'/>" + "<a style='' href=\"data:image/jpeg;base64," + resultData + "\" download='shinhanQrImage'><img src='"+ imgDomain + "/rib2017/images/any/etc/btn_qrcodeDown.png' /></a>" + "</div>");
       */
   } catch (Throwable e) {
       Logger.exception("[getQr.jsp] Exception.", e);
       WARNINGMsg w = new WARNINGMsg();
       w.msg = e.getMessage();
       if (w.msg == null || w.msg.trim().equals("")) {
           w.msg = "Exception이 발생하였습니다.";
       }
       w.level = Warning.ERROR;
       w.detail = SystemUtil.getStackTrace(e);
       out.print("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>n" + w.toString());
   } finally {

   }
%>