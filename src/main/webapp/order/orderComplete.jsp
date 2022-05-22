<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>
<%@page import="java.sql.*"%>
<%@ page import="wouldyoulike.order.orderDAO" %>
<%@ page import="wouldyoulike.order.orderDTO" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>주문 완료 페이지</title>
</head>

<%
	String id = (String) session.getAttribute("sid");
	if(id==null){
%>		<script>
			alert("로그인이 필요한 페이지 입니다!");
			window.location="/wouldyoulike_final/member/loginForm.jsp";
		</script>
<%	}
%>

<body>

<h3 align="center">주문이 완료되었습니다</h3>
</body>
</html>