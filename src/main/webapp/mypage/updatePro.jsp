<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
    <%@ page import="wouldyoulike.jdbc.OracleConnection" %>
    	
<% request.setCharacterEncoding("UTF-8"); %>

<%
	String id = (String)session.getAttribute("sid");
	String pw = request.getParameter("pw");
	String name = request.getParameter("name");
	String address = request.getParameter("address");
	String birth1 = request.getParameter("birth1");
	String birth2 = request.getParameter("birth2");
	String birth3 = request.getParameter("birth3");
	String birth = birth1+"/"+birth2+"/"+birth3;
	String phone1 = request.getParameter("phone1");
	String phone2 = request.getParameter("phone2");
	String phone3 = request.getParameter("phone3");
	String phone4 = request.getParameter("phone4");
	String phone = phone1+"-"+phone2+"-"+phone3+"-"+phone4;
	String email1 = request.getParameter("email1");
	String email2 = request.getParameter("email2");
	String email = email1+"@"+email2;

	Connection conn = OracleConnection.getConnection();
	String sql="update member set pw=?, name=?, address=?, birth=?, phone=?, email=? where id=?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	 pstmt.setString(1, pw);
	 pstmt.setString(2, name);
	 pstmt.setString(3, address);
	 pstmt.setString(4, birth);
	 pstmt.setString(5, phone);
	 pstmt.setString(6, email);
	 pstmt.setString(7, id);
	int result = pstmt.executeUpdate();
	
	if(result == 1){
%>		<script>
			alert("회원정보가 수정되었습니다.");
			window.location='../main.jsp';
		</script>
<%}%>	