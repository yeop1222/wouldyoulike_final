<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	
<% request.setCharacterEncoding("UTF-8"); %>
    
<jsp:useBean id="dto" class="wouldyoulike.member.MemberDTO" />
<jsp:setProperty property="*" name="dto" />

<jsp:useBean id="dao" class="wouldyoulike.member.MemberDAO" />
<%
	int result = dao.insert(dto);
	if(result == 1){
%>		<script>
			alert("회원가입이 완료되었습니다.");
			window.location='../main.jsp';
		</script>
	<% } %>	

