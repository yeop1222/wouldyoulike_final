<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="wouldyoulike.jdbc.OracleConnection" %>

<%
	String id = request.getParameter("id");
	String name = request.getParameter("name");

	Connection conn = OracleConnection.getConnection();

   String sql ="select * from member where id=? and name=?";  
   PreparedStatement pstmt = conn.prepareStatement(sql);
   pstmt.setString(1, id); 
   pstmt.setString(2, name);
   
   ResultSet rs = pstmt.executeQuery();
   if(rs.next()){
      String pw = rs.getString("pw");

%>
      <h2>고객님의 비밀번호는 "<%=pw%>" 입니다.</h2>
<%  }else{
%>	<script >
	alert("입력하신 정보로 가입된 회원은 존재하지 않습니다.");
	history.go(-1);
	</script>
<%   }

   rs.close();
   pstmt.close();
   conn.close();
%>