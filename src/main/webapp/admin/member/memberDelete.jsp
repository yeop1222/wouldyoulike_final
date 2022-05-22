<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="dto" class="wouldyoulike.member.MemberDTO" />
<jsp:setProperty name="dto" property="*" />
<jsp:useBean id="dao" class="wouldyoulike.member.MemberDAO" />

<%
	int result = dao.memberDelete(dto.getId());
		if(result != 0){
%>			<script>
				alert("회원을 탈퇴시켰습니다.");
				window.location = "memberList.jsp";
			</script>
<%		} else {%>
			<script>
				alert("잠시후 다시 실행해주세요.");
				history.go(-1);
			</script>
<% } %>