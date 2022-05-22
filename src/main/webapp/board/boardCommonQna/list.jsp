<%--
	list.jsp
	각종 CommonQna와 관련된 글 목록 불러오는 페이지
	option에 따라
		option==0 :	일반적으로 게시판에서 볼때
		option==1 :	마이페이지에서 작성자가 질문한 내역 볼때
		option==2 :	마이페이지에서 질문한 내역 클릭해서 답변까지 볼때
	
 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="wouldyoulike.board.BoardCommonQnaDTO" %>

<!-- Navbar -->
<% if(request.getParameter("option") == null || request.getParameter("option").equals("0") || request.getParameter("option").equals("2")){%>
	<jsp:include page="../../menu.jsp"/>
<% }%>


<jsp:useBean id="dto" class="wouldyoulike.board.BoardCommonQnaDTO" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardCommonQnaDAO" />

<script>
	//삭제버튼 눌렀을때 확인
	function confirmDeleteCommon(boardnum, option){
		var confirmDeleteCommon = confirm("정말로 삭제하시겠습니까?\n삭제한 글은 복구할 수 없습니다.");
		if(confirmDeleteCommon){
			window.location="/wouldyoulike_final/board/boardCommonQna/deletePro.jsp?boardnum=" + boardnum + "&option=" + option;
		}
	}
</script>

<%
	//옵션 변수
	String sOpt = request.getParameter("option");
	int option = 0;
	if(sOpt != null){
		option = Integer.parseInt(sOpt);
	}

	String sid = (String)session.getAttribute("sid");
	
	final int PAGE_SIZE; //1페이지당 글 개수
	//페이징 관련 변수
	if(option == 1){
		PAGE_SIZE = 5;
	}else if(option==2){
		PAGE_SIZE = 1000;
	}else{
		PAGE_SIZE = 10;
	};
	
	String qnaPageNum = request.getParameter("qnaPageNum");
	if(qnaPageNum == null){
		qnaPageNum = "1";
	}
	
	int currentPage = Integer.parseInt(qnaPageNum);
	int start = (currentPage-1)*PAGE_SIZE+1;
	int end = currentPage*PAGE_SIZE;

	int count;
	int sDayCommon = 10000;
	
	if(option == 1){
		String strsDayCommon = request.getParameter("sDayCommon");
		if(strsDayCommon != null){
			sDayCommon = Integer.parseInt(strsDayCommon);
		}
	}
	
	//option 에 따라 카운트 변수 달라짐
	if(option == 1){
		count = dao.countWriter(sid, sDayCommon);
	}else if(option == 2){
		count = dao.countReply(Integer.parseInt(request.getParameter("boardnum"))) + 1 ;
	}else{
		count = dao.boardCount(0);
	}
	if(end>count){
		end=count;
	}
	
	if(sid != null && option==0){
		//글은 로그인 한 사람만 작성가능
%>		<input type="button" value="질문글 작성" onclick="window.location='/wouldyoulike_final/board/boardCommonQna/writeForm.jsp?option=<%=option %>'" />
<%	}
	if(sid != null && option==1) {
//TODO : myQna 파라미터 더 불러와서 인수 넣어주기
%>		<form name="frm">
			조회 기간 선택 :
			<select name = "sDayCommon" onchange="window.location='/wouldyoulike_final/mypage/myQna.jsp?option=1&sDayCommon=' +this.value" onfocus="this.selectedIndex=-1;">
				<option value="10000">모두보기</option>
				<option value="7">일주일 이내</option>
				<option value="30">30일 이내</option>
				<option value="185">6개월 이내</option>
				<option value="366">1년 이내</option>
			</select>
		</form>
		
		<script>
			document.frm.sDayCommon.value = sDayCommon;
		</script>

<%	}
	
	//option에 따라서 호출 메서드 다름
	ArrayList<BoardCommonQnaDTO> list = null;
	if(option == 1){
		list = dao.showMyList(sid, sDayCommon, start, end);
	}else if(option == 2){
		list = dao.showReply(Integer.parseInt(request.getParameter("boardnum")));
	}else{
		list = dao.showList(0,start,end);
	}
	
%>
<table border="1">
<%
	for(BoardCommonQnaDTO d : list){
%>		<tr>
<%			if(d.getOriginalnum() != 0){
%>				<td width="5%"></td>
				<td>
<%			}else{ %>
				<td colspan="2">
<%			} %>
				<table width="500">
					<tr>
						<td width="70%">
<%							// 비밀번호가 없거나, 관리자이거나, 글작성자이거나, (답글인경우)원글의 작성자 는 비밀글을 볼수있음 
							if(d.getBoardpw()==null || "admin".equals(sid) || d.getBoardwriter().equals(sid) || (d.getOriginalwriter() != null && d.getOriginalwriter().equals(sid))) {
								//옵션 == 1이면 a 태그 걸어서 읽을수있게
								if(option==1){
%>									<a href="/wouldyoulike_final/board/boardCommonQna/list.jsp?boardnum=<%=d.getBoardnum()%>&option=2">
<%								} %>
								제목: <%=d.getBoardtitle() %>
								<%=d.getBoardpw() == null ? "" : " (비밀글)" %>
<%								if(option==1){ %>
									</a> 
<%									if(dao.countReply(d.getBoardnum()) > 0){ %>
										 (<%=dao.countReply(d.getBoardnum())%>개의 관리자 답변)
<%									}
								} 
							}else{%>
								제목: 비밀글입니다.
<%							}%>
						</td>
						<td width="10%">
<%							//글쓴이만 수정 가능
							if(d.getBoardwriter().equals(sid)){ %>
								<input type="button" value="수정" onclick="window.location='/wouldyoulike_final/board/boardCommonQna/updateForm.jsp?boardnum=<%=d.getBoardnum() %>&option=<%=option %>'" />
<%							}%>
						</td>
						<td width="10%">
<%							//글쓴이와 작성자만 삭제 가능
							if(d.getBoardwriter().equals(sid) || "admin".equals(sid)){ %>
								<input type="button" value="삭제" onclick="confirmDeleteCommon(<%=d.getBoardnum() %>,<%=option %>)" />
<%							}%>
						</td>
						<td width="10%">
<%							//글쓴이와 작성자만 답글 가능 + 답글에는 또 답글 불가능
							if(d.getBoardwriter().equals(sid) || "admin".equals(sid)){ 
								if(d.getOriginalnum() == 0) { 
									if(option != 1) {%>
										<input type="button" value="답글" onclick="window.location='/wouldyoulike_final/board/boardCommonQna/writeForm.jsp?originalnum=<%=d.getBoardnum() %>&option=<%=option %>'" />
<%									}
								}
							} %>
						</td>
					</tr>
					<tr><td>작성자: <%=d.getBoardwriter() %></td>
					<td colspan="3" align="right"><%=String.format("%1$ty.%1$tm.%1$td %1$tH:%1$tM",d.getBoardreg()) %></td></tr>
					<tr><td colspan="4">내용</td></tr>
<%					// 비밀번호가 없거나, 관리자이거나, 글작성자이거나, (답글인경우)원글의 작성자 는 비밀글을 볼수있음
					if(d.getBoardpw() == null || "admin".equals(sid) || d.getBoardwriter().equals(sid) || (d.getOriginalwriter() != null && d.getOriginalwriter().equals(sid))) { 
						//이미지 있으면 이미지 삽입
						if(d.getBoardimage() != null) { %>
						<tr><td colspan="4"><img src="<%="/wouldyoulike_final/img/board/commonqnaimage/" + d.getBoardimage() %>"></td></tr>
<%						} %>
						<tr><td><%=d.getBoardcontent() %></td></tr>
<%						} else{ %>
							<tr><td colspan="4">비밀글입니다.</td></tr>
<%						} %>						
				</table>
			</td>
		</tr>
<%	} %>
	<tr><td colspan="2" align="center">
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
		String strPage = null;
		String strOption = "&option=" + option;
		switch(option){
		case 0:
			strPage = "/wouldyoulike_final/board/boardCommonQna/list.jsp";
			break;
		case 1: //TODO myQna 경우 파라미터 더 있음
			strPage = "/wouldyoulike_final/mypage/myQna.jsp";
			strOption += "&sDayCommon=" + sDayCommon;
			break;
		case 2:
			strPage = "/wouldyoulike_final/mypage/myQna.jsp";
			strOption += "&boardnum=" + request.getParameter("boardnum");
			break;
		default:
			break;
		};
		
		if(startPage > PAGE_BLOCK){
%>			<a href="<%=strPage %>?qnaPageNum=<%=startPage-PAGE_BLOCK%><%=strOption%>">[이전]</a>
<%		}
		for(int i = startPage ; i<=endPage ; i++){
%>			<a href="<%=strPage %>?qnaPageNum=<%=i%><%=strOption%>">[<%=i %>]</a>
<%		}
		if(endPage < pageCount){
%>			<a href="<%=strPage %>?qnaPageNum=<%=startPage+PAGE_BLOCK%><%=strOption%>">[다음]</a>
<%		}
	}
%>
	</td></tr>
</table>


<!-- Footer -->
<% if(request.getParameter("option") == null || request.getParameter("option").equals("0") || request.getParameter("option").equals("2")){%>
	<jsp:include page="../../footer.jsp"></jsp:include>
<%} %>

