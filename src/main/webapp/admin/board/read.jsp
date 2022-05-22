<%--
	read.jsp
	list.jsp에서 글 누르면 해당 글과 답글 불러오는 페이지
	답글 추가로 달 수 있음
	
	option에 따라
		option==0 :	ProdQna 페이지 내용 읽음
		option==1 :	CommonQna 페이지 내용 읽음
		option==2 :	Review 페이지 내용 읽음
	
 --%>
<%@page import="wouldyoulike.board.BoardCommonQnaDTO"%>
<%@page import="wouldyoulike.board.BoardReviewDTO"%>
<%@page import="wouldyoulike.board.BoardProdQnaDTO"%>
<%@page import="wouldyoulike.board.BoardReviewDAO"%>
<%@page import="wouldyoulike.board.BoardCommonQnaDAO"%>
<%@page import="wouldyoulike.board.BoardProdQnaDAO"%>
<%@page import="wouldyoulike.board.BoardDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- Navbar -->
<jsp:include page="../adminmenu.jsp"/>

<script>
	//삭제 버튼 눌렀을때
	function confirmDelete(boardnum, option, sday, haveReply){
		var confirmDelete = confirm("정말로 삭제하시겠습니까?\n삭제한 글은 복구할 수 없습니다.");
		if(confirmDelete){
			var dir;
			var vsday;
			if(option == 0){
				dir = "../../board/boardProdQna/";
				vsday = "sday";
			}else if(option ==1){
				dir = "../../board/boardCommonQna/";
				vsday = "sDayCommon";
			}else{
				dir = "../../board/boardReview/";
				vsday = "sDayReview";
			}
			window.location = dir + 'deletePro.jsp?boardnum=' + boardnum + '&option=3&' + vsday + '=' + sday + '&haveReply=' + haveReply + '&productN=0';
		}
	}
</script>

<%
	String strOption = request.getParameter("option");
	String strHaveReply = request.getParameter("haveReply");
	String strBoardnum = request.getParameter("boardnum");
	String sid = (String)session.getAttribute("sid");
	String vsday = null;
	switch(strOption){
	case "0":
		vsday="sday";
		break;
	case "1":
		vsday="sDayCommon";
		break;
	case "2":
		vsday="sDayReview";
		break;
	}
	String sday = request.getParameter(vsday);
	int pageNum = 1;
	String strPageNum = request.getParameter("pageNum");
	if(strPageNum != null){
		pageNum = Integer.parseInt(strPageNum);
	}
	
	if(sid == null){
		//TODO 에러
	}
	if(!sid.equals("admin")){
		//TODO 에러
	}
	
	
	int option=0;
	if(strOption != null){
		option = Integer.parseInt(strOption);
	}
	boolean haveReply=false;
	if(strHaveReply != null){
		if(strHaveReply.equals("true")){
			haveReply = true;
		}
	}
	int boardnum = 0;
	if(strBoardnum != null){
		boardnum = Integer.parseInt(strBoardnum);
	}
	
	ArrayList<? extends BoardDTO> list = null;
	int productN = 0;
	if(option == 0){
		BoardProdQnaDAO dao = new BoardProdQnaDAO();
		list = dao.showReply(boardnum);
		BoardProdQnaDTO tdto = (BoardProdQnaDTO)list.get(0);
		productN = tdto.getProductN();
	}else if(option == 1){
		BoardCommonQnaDAO dao = new BoardCommonQnaDAO();
		list = dao.showReply(boardnum);
	}else if (option == 2){
		BoardReviewDAO dao = new BoardReviewDAO();
		list = dao.showReply(boardnum);
		BoardReviewDTO tdto = (BoardReviewDTO)list.get(0);
		productN = tdto.getProductN();
	}else{
		// TODO 에러
	}
%>

<table border="1">
	<tr>
		<td align="right" colspan="2">
			<input type="button" value="목록" onclick="window.location='list.jsp?option=<%=option %>&pageNum=<%=pageNum %>'" />
		</td>
	</tr>
<%	if(option != 1) { %>
		<tr>
			<td colspan="2">
				제품명: <img src="" />
				<a href="#">
					<%=productN %>
				</a>
			</td>
		</tr>
<%	} 
	for(BoardDTO d : list){ %>
		<tr>
<%			int originalnum = 0;
			if(option == 0){
				originalnum = ((BoardProdQnaDTO)d).getOriginalnum();
			}else if(option ==1){
				originalnum = ((BoardCommonQnaDTO)d).getOriginalnum();
			}else{
				originalnum = ((BoardReviewDTO)d).getOriginalnum();
			}
			if(originalnum != 0){
%>				<td width="5%"></td>
				<td>
<%			} else {%>
				<td colspan="2">
<%			} %>
			<table width="500">
				<tr>
					<td width="70%">
						제목: <%=d.getBoardtitle() %>	
					</td>
<%					String dir;
					if(option==0){
						dir = "../../board/boardProdQna/";
					}else if(option == 1){
						dir = "../../board/boardCommonQna/";
					}else{
						dir = "../../board/boardReview/";
					}
					if(d.getBoardwriter().equals("admin")){ %>
						<td width="10%" align="right">
							<input type="button" value="수정" onclick="window.location = '<%=dir%>updateForm.jsp?boardnum=<%=d.getBoardnum() %>&option=3&<%=vsday %>=<%=sday %>&haveReply=<%=haveReply %>&productN=0'" />
						</td>
						<td width="10%" align="right">
<%					}else{ %>
						<td width="20%" align="right" colspan="2">
<%					} %>
							<input type="button" value="삭제" onclick="confirmDelete(<%=d.getBoardnum() %>,<%=option %>,<%=sday %>,<%=haveReply %>)" />
						</td>
<%					if(originalnum == 0) { %>
						<td width="10%" align="right">
							<input type="button" value="답글" onclick="window.location = '<%=dir%>writeForm.jsp?originalnum=<%=d.getBoardnum() %>&option=3&<%=vsday %>=<%=sday %>&haveReply=<%=haveReply %>&productN=<%=productN %>'" />
						</td>
<%					} %>
				</tr>
				<tr>
					<td>
						작성자 : <%=d.getBoardwriter() %>
					</td>
					<td align="right" colspan="3">
<%						if(option == 2 && originalnum == 0){
%>							별점 : 
<%							for(int i=0; i<5 ; ++i) {
								if(i < ((BoardReviewDTO)d).getBoardscore()){
%>									★
<%								}else{
%>									☆
<%								}
							}
%>							<br />
<%						} %>
						<%=String.format("%1$ty.%1$tm.%1$td %1$tH:%1$tM",d.getBoardreg()) %>
					</td>
				</tr>
				<tr><td colspan="4">내용</td></tr>
<%				if(d.getBoardimage() != null) {
					String idir = "/wouldyoulike_final/board/";
					if(option==0){
						idir += "prodqnaimage/";
					}else if(option==1){
						idir += "commonqnaimage/";
					}else{
						idir += "reviewimage/";
					}%>
					<tr><td colspan="4">
						<img src = "<%=idir+d.getBoardimage() %>" />
					</td></tr>
<%				} %>
				<tr><td colspan="4"><%=d.getBoardcontent() %></td></tr>
			</table>
		</td></tr>
<%	} %>
</table>


<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>







