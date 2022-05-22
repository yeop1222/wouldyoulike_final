<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<%
		response.setStatus(HttpServletResponse.SC_OK);
	%>
<jsp:include page="../menu.jsp"/>

<section style="margin-left:20%;margin-top:10%;margin-bottom:10%;">
    <h1> 404에러 </h1>
    <h2>죄송합니다. </h2>
    <h2>요청하신 페이지를 찾을 수 없습니다.</h2>
</section>