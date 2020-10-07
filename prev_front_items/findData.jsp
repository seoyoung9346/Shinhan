<%@page import="java.sql.*"%>
<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTyPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신용장 조회 이력</title>
</head>
<body>
   <!-- <center><h2>신용장</h2></center> -->
   <nav>
       <ul class="nav-container">
           <!--문서를 링크시키기 위해 사용하는 태그-->
           <li class="nav-item"> <a href="findData.jsp">신용장 조회</a> </li>
           <li class="nav-item"> <a href="print.html">신용장 출력</a> </li>
           <li class="nav-item"> <a href="reject.html">신용장 거절</a> </li>
           <li class="nav-item"> <a href="buy.html">신용장 매입</a> </li>
       </ul>
   </nav>

   <div class="container">
       <div class="table table-striped">
           <table class="type09">
               <thead>
                   <tr>
                       <th><B>날짜 및 시간</B></th>
                       <th><B>은행코드</B></th>
                       <th><B>통지번호</B></th>
                       <th><B>통지조건변경순번</B></th>
                       <th><B>비밀번호</B></th>
                   </tr>
               </thead>
               <tbody>
                   <%
                   Connection conn = null;
                   PreparedStatement pstmt = null;
                   ResultSet rs = null;
                   %>
                   <%
                   try {
                       String url = "jdbc:mysql://172.23.255.61:30006/mariaDBConnect";
                       String user = "lpfadm";
                       String password = "lpfadm";

                       Class.forName("com.mysql.jdbc.Driver"); // DB 연동을 위해 DriverManager에 등록
                       conn = DriverManager.getConnection(url, user, password); // DriverManager 객체로부터 Connection 객체 얻어오기
                      
                       String sql = "select * from history";
                       pstmt = conn.prepareStatement(sql); // prepareStatement 에서 해당 sql 컴파일
                       rs = pstmt.executeQuery(); // 쿼리 실행 후 결과를 ResultSet 객체에 담기
                       while(rs.next()) { // 한 행씩 돌아가면서 결과 가져오기
                           out.println("<tr>");
                           out.println("<td>" + rs.getString("date") + "</td>");
                           out.println("<td>" + rs.getString("bankCode") + "</td>");
                           out.println("<td>" + rs.getString("notiNumber") + "</td>");
                           out.println("<td>" + rs.getString("notiChangeNumber") + "</td>");
                           out.println("<td>" + rs.getString("notiChangeNumber") + "</td>");
                           out.println("</tr>");
                       }
                       rs.close();
                       pstmt.close();
                       conn.close();
                   } catch(Exception e) {
                       e.printStackTrace();
                       out.println("이력 관리 호출에 실패했습니다.");
                   } finally {
                       try {
                           if (rs != null)  rs.close();
                           if (conn != null)   conn.close();
                           if (pstmt != null)  pstmt.close();
                       } catch (Exception e) {
                           e.printStackTrace();
                       }
                   }

               </tbody>
           </table>
       </div>
   </div>