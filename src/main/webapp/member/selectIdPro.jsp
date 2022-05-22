<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="wouldyoulike.jdbc.OracleConnection" %>
	
<% request.setCharacterEncoding("UTF-8"); %>
<%	
	String name = request.getParameter("name");
	String phone1 = request.getParameter("phone1");
	String phone2 = request.getParameter("phone2");
	String phone3 = request.getParameter("phone3");
	String phone4 = request.getParameter("phone4");
	String phone = phone1+"-"+phone2+"-"+phone3+"-"+phone4;

	Connection conn = OracleConnection.getConnection();
		
	String sql ="select * from member where name=? and phone=?"; 
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, name); 
	pstmt.setString(2, phone); 
	
	ResultSet rs = pstmt.executeQuery();
	
	if(rs.next()){
		String id = rs.getString("id");
		String sname = rs.getString("name");
		String sphone = rs.getString("phone");
		Timestamp reg = rs.getTimestamp("reg");
	
%>
      <h2>고객님의 아이디 찾기가 완료되었습니다.</h2>
      <h3>이름:<%=sname%></h3>
      <h3>휴대폰 번호:<%=sphone%></h3>
      <h3>고객님의 아이디는 [<%=id%>] (<%=reg%>가입) 입니다.</h3>
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