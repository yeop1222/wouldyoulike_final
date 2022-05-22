<%--
	list.jsp
	Notice 글 목록 불러오는 페이지
	다른 게시판과 다르게 글 내용을 바로 보여주지 않고,
	글 제목에 a tag 걸어서 read.jsp 로 가서 글을 읽는다
	
 --%>
<%@page import="wouldyoulike.board.BoardNoticeDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- Navbar -->
<jsp:include page="../../menu.jsp"/>


<jsp:useBean id="dto" class="wouldyoulike.board.BoardNoticeDTO" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardNoticeDAO" />

<script>
	//삭제버튼 눌렀을때 확인
	function confirmDelete(boardnum){
		var confirmDelete = confirm("정말로 삭제하시겠습니까?\n삭제한 글은 복구할 수 없습니다.");
		if(confirmDelete){
			window.location="deletePro.jsp?boardnum=" + boardnum;
		}
	}
</script>

<%
	String sid = (String)session.getAttribute("sid");

	//페이징 관련 변수
	final int PAGE_SIZE = 20; //1페이지당 글 개수
	
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	}
	int currentPage = Integer.parseInt(pageNum);
	int start = (currentPage-1)*PAGE_SIZE+1;
	int end = currentPage*PAGE_SIZE;
	
	int count = dao.boardCount(0);
	if(end>count){
		end=count;
	}
	
	if("admin".equals(sid)){
		//관리자만 글 작성 가능
%>		<input type="button" value="글 작성" onclick="window.location='writeForm.jsp'" />
<%	}
	ArrayList<BoardNoticeDTO> list = dao.showList(0, start, end);
%>
<table border="1" width="500">
	<tr>
		<th width="60%">제목</th>
		<th width="15%">작성자</th>
		<th width="25%">작성시간</th>
	</tr>
<%
	for(BoardNoticeDTO d : list){
%>		<tr>
			<td><a href="read.jsp?boardnum=<%=d.getBoardnum()%>"><%=d.getBoardtitle() %></a></td>
			<td align="center"><%=d.getBoardwriter() %></td>
			<td align="center"><%=String.format("%1$ty.%1$tm.%1$td %1$tH:%1$tM",d.getBoardreg()) %></td>
<%			if("admin".equals(sid)){
				//관리자만 삭제 가능
%>				<td>
					<input type="button" value="삭제" onclick="confirmDelete(<%=d.getBoardnum() %>)" />
				</td>
<%			} %>
		</tr>
<%	}
%>	
	<tr><td colspan="3" align="center">
<%
		//페이징 처리
		if(count > 0){
			int pageCount = count / PAGE_SIZE + (count % PAGE_SIZE == 0 ? 0 : 1);
			int startPage = (int)(currentPage / PAGE_SIZE)*PAGE_SIZE+1;
			final int PAGE_BLOCK = 10;
			int endPage = startPage + PAGE_BLOCK-1;
			if(endPage>pageCount){
				endPage = pageCount;
			}
			if(startPage > PAGE_BLOCK){
%>				<a href="list.jsp?pageNum=<%=startPage-PAGE_BLOCK%>">[이전]</a>
<%			}
			for(int i = startPage ; i<=endPage ; i++){
%>				<a href="list.jsp?pageNum=<%=i%>">[<%=i %>]</a>
<%			}
			if(endPage < pageCount){
%>				<a href="list.jsp?pageNum=<%=startPage+PAGE_BLOCK%>">[다음]</a>
<%			}
		}
%>	</td></tr>
</table>

<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>



