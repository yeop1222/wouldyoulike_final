<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="wouldyoulike.member.MemberDTO" %>
<%@ page import="wouldyoulike.member.MemberDAO" %>
<%@ page import="java.sql.*" %>   

<%
	String id = (String) session.getAttribute("sid");
	if(id==null){
%>		<script>
			alert("로그인을 해주세요.");
			window.location="../mainForm.jsp";
		</script>		
<%	}else if(!id.equals("admin")){
%>		<script>
			alert("관리자만 접근 가능한 페이지입니다!");
			window.location="../main.jsp";
		</script>
<%	} %>

<head>
	<title>회원관리</title>
	<style>
		section{
			margin-left:20%;
		}
	</style>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
</head>


<!-- Navbar -->
<jsp:include page="../adminmenu.jsp"/>

 <section>
<h1>회원 리스트</h1>



<%
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum="1";
	}
	
	int pageSize = 10; // 한 페이지 글 개수
	int currentPage = Integer.parseInt(pageNum);
	int start = (currentPage - 1) * pageSize + 1;
	int end = currentPage * pageSize;
	
	MemberDAO dao = new MemberDAO();
	int count = dao.memberCount();
	
	
%>
회원 목록(총 회원 : [<%=count %>]) 

<table border="1">
	<tr>
		<th>ID</th><th>PW</th><th>이름</th><th>주소</th><th>생년월일</th>
		<th>전화번호</th><th>이메일</th><th>가입일자</th><th>강제탈퇴</th>
		
	</tr>
	<%
	ArrayList<MemberDTO> list = dao.memberList(start, end);
		if(list.size() > 0){
			for(MemberDTO dto : list){
	%>
			<tr>
				<td><%=dto.getId() %></td>
				<td><%=dto.getPw() %></td>
				<td><%=dto.getName()%></td>
				<td><%=dto.getAddress()%></td>
				<td><%=dto.getBirth1() %></td>
				<td><%=dto.getPhone1() %></td>
				<td><%=dto.getEmail1() %></td>
				<td><%=dto.getReg()%></td>
				<td align="center"><a href="memberDelete.jsp?id=<%=dto.getId() %>" >탈퇴</a></td>
			</tr>
		<% } 
		}else{ 
		%>
	<tr><td colspan="9" align="center">등록된 제품이 없습니다.</td></tr>
<% } %>
</table>
</section>
<br>
<nav aria-label="Page navigation example">
	<ul class="pagination justify-content-center">
<% // 페이징 처리 공식
	if(count > 0){
		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
		int startPage = (int)(currentPage / 10)*10+1;
		int pageBlock = 10;
		int endPage = startPage + pageBlock-1;
		if(endPage > pageCount){
			endPage = pageCount;
		}
		if(startPage > 10){ %>
			<li class="page-item disabled">
     			<a class="page-link" href="memberList.jsp?pageNum=<%=startPage%>" tabindex="-1">이전</a>
   	 		</li>
	<%}
		for(int i = startPage; i <= endPage; i++){%>
			<li class="page-item">
				<a class="page-link" href="memberList.jsp?pageNum=<%=i%>"><%=i %></a>
			</li>
	<%}
		if(endPage < pageCount){ %>
			<li class="page-item">
      			<a class="page-link" href="memberList.jsp?pageNum=<%=startPage +10%>">다음</a>
    		</li>
		<%}
	}

%>
	</ul>
</nav>

<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>

<!-- Bootstrap core JS-->
<script src="../Bootstrap/bootstrap-4.6.1-dist/js/bootstrap.bundle.min.js"></script>