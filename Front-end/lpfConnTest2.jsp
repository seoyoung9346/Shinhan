<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%!
   // 서버 연동 함수 POST
   public String get (String strUrl, parameters) {
       try {
            URL url = new URL(strUrl); // url 객체로 반환
            HttpURLConnection con = (HttpURLConnection) url.openConnection(); // URLConnection 객체로 변환
           
           con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
           con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
          
           con.addRequestProperty("Content-Type", "application/json"); //key값 설정
           con.setRequestMethod("POST");

           //URLConnection에 대한 doOutput 필드값을 지정된 값으로 설정한다. URL 연결은 입출력에 사용될 수 있다.
           //URL 연결을 출력용으로 사용하려는 경우 DoOutput 플래그를 true로 설정하고, 그렇지 않은 경우는 false로 설정해야 한다. 기본값은 false이다.
           con.setDoOutput(false);
       
           // Send post request
           DataOutputStream wr = new DataOutputStream(con.getOutputStream());
           wr.writeBytes(parameters); // 전송할 데이터 담기
           wr.flush();
           wr.close();

           //응답 받는 부분.
           StringBuffer sb = new StringBuffer();
           if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
               //Stream을 처리해줘야 하는 귀찮음이 있음.
               BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
               String line;
               while ((line = br.readLine()) != null) {
                  sb.append(line).append("\n");
               }
               br.close();
               System.out.println("" + sb.toString());
           } else {
               System.out.println(con.getResponseMessage());
           }
           return sb.toString();
       } catch (Exception e) {
           System.err.println(e.toString());
           return null;
       }
  }
%>