<%--
read.jsp
	list.jsp 에서 글 제목 클릭하게 되면 이 페이지로 넘어와서 글 내용을 보여준다
	boardnum 파라미터는 해당 글 번호
	pageNum 파라미터는 목록으로 버튼 눌렀을때 페이지 번호 저장해서 돌아가게 해준다
	
 --%>
 
 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- Navbar -->
<jsp:include page="../../menu.jsp"/>


<script>
	//삭제버튼 눌렀을때 확인
	function confirmDelete(boardnum){
		var confirmDelete = confirm("정말로 삭제하시겠습니까?\n삭제한 글은 복구할 수 없습니다.");
		if(confirmDelete){
			window.location="deletePro.jsp?boardnum=" + boardnum;
		}
	}
</script>

<jsp:useBean id="dto" class="wouldyoulike.board.BoardNoticeDTO" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardNoticeDAO" />

<%
	String sid = (String)session.getAttribute("sid");
	String bn = request.getParameter("boardnum");
	String pn = request.getParameter("pageNum");
	int boardnum=0;
	int pageNum=1;
	if(bn != null){
		boardnum = Integer.parseInt(bn);
	}else{
		//글번호가 없는경우
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="../../main.jsp";
		</script>
<%	}
	if(pn != null){
		pageNum = Integer.parseInt(pn);
	}
	dto = dao.information(boardnum);
%>

<input type="button" value="목록" onclick="window.location='list.jsp?pageNum=<%=pageNum%>'"/>
<%
	if("admin".equals(sid)){
%>		<input type="button" value="수정" onclick="window.location='updateForm.jsp?boardnum=<%=dto.getBoardnum() %>'" />
		<input type="button" value="삭제" onclick="confirmDelete(<%=dto.getBoardnum() %>)" />
<%	} %>
<br />
<table border="1">
	<tr>
		<td colspan="2" width="500">제목: <%=dto.getBoardtitle() %></td>
	</tr>
	<tr>
		<td width="50%">작성자: <%=dto.getBoardwriter() %></td>
		<td width="50%">작성일: <%=String.format("%1$ty.%1$tm.%1$td %1$tH:%1$tM",dto.getBoardreg()) %></td>
	</tr>
	<tr>
		<td colspan="2">내용:<br />
<%			if(dto.getBoardimage() != null) { %>
			<img src="<%="/wouldyoulike_final/img/board/noticeimage/" + dto.getBoardimage() %>" /> <br />
<%			} %>
			<%=dto.getBoardcontent() %>
		</td>
	</tr>
</table>


<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>

