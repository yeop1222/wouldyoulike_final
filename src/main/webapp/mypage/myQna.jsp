<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String id = (String) session.getAttribute("sid");
	if(id==null){
%>		<script>
			alert("로그인이 필요한 페이지 입니다!");
			window.location="/wouldyoulike_final/member/loginForm.jsp";
		</script>
<%	}
%>


<!-- Navbar -->
<jsp:include page="../menu.jsp"/>
<!-- Sidebar -->
<jsp:include page="../mypageForm.jsp"/>

<section style="margin-left:25%;">
	<h2>문의게시판</h2>
	<jsp:include page="../board/boardCommonQna/list.jsp">
		<jsp:param value="1" name="option"/>
	</jsp:include>
	<br/>
	<h2>상품 문의</h2>
	<jsp:include page="../board/boardProdQna/list.jsp">
		<jsp:param value="1" name="option"/>
	</jsp:include>
</section>


<!-- Footer -->
<jsp:include page="../footer.jsp"></jsp:include>

