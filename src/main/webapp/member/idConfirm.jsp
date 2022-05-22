<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="wouldyoulike.jdbc.OracleConnection" %>

<%
 String id = request.getParameter("id");

Connection conn = OracleConnection.getConnection();

String sql = "select * from member where id=?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1,id);

ResultSet rs = pstmt.executeQuery();
String result = "사용가능한 아이디 입니다";
if(rs.next()){
	result = "이미 사용중인 아이디 입니다";
}
	rs.close();
	pstmt.close();
	conn.close();
%>
	<h4><%=result%></h4>
