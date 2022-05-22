<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="wouldyoulike.jdbc.OracleConnection" %>
<% 
	String id = (String)session.getAttribute("sid");
	String pw = request.getParameter("pw"); 
	
	Connection conn = OracleConnection.getConnection();
	
	String sql = "delete from member where id=? and pw=?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, id);	
	pstmt.setString(2, pw);
	int result = pstmt.executeUpdate();
	

	sql = "delete from orderinfo where memberid=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, id);
	pstmt.executeUpdate();
		
	sql = "delete from user_cart where user_id=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, id);
	pstmt.executeUpdate();
	
	
	pstmt.close();
	conn.close();
	if(result == 0){
%> <script>
		alert("비밀번호가 일치하지 않습니다.");
		history.go(-1);
	</script>
<% } else{
		session.invalidate();
%>		<script>
			alert("탈퇴 완료되었습니다");
			window.location="../main.jsp";
		</script>
<% } %> 


}