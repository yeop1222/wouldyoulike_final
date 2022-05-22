<%--
	list.jsp
	관리자 페이지에서 글 모아보기 하는 페이지
	option에 따라
		option==0 :	ProdQna 페이지 내용 읽음
		option==1 :	CommonQna 페이지 내용 읽음
		option==2 :	Review 페이지 내용 읽음
	
	haveReply 옵션에 따라
		haveReply==0 :	모든 글 보여줌
		haveReply==1 :	관리자가 답글 달지 않은 글만 보여줌
		
	sday 옵션에 따라
		sday==n :	n일 이내에 작성된 글만 보임
 --%>
<%@page import="wouldyoulike.products.ProductDTO"%>
<%@page import="wouldyoulike.products.ProductDAO"%>
<%@page import="wouldyoulike.board.BoardReviewDAO"%>
<%@page import="wouldyoulike.board.BoardReviewDTO"%>
<%@page import="wouldyoulike.board.BoardProdQnaDTO"%>
<%@page import="wouldyoulike.board.BoardProdQnaDAO"%>
<%@page import="wouldyoulike.board.BoardCommonQnaDAO"%>
<%@page import="wouldyoulike.board.BoardDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- Navbar -->
<jsp:include page="../adminmenu.jsp"/>

<%
	String title = request.getParameter("option");
	if(title == null || title.equals("0")){
		title = "상품문의 관리";
	}else if(title.equals("1")){
		title = "문의게시판 관리";
	}else if(title.equals("2")){
		title = "리뷰 관리";
	}
%>
<h1><%=title %></h1>

<script>
	//삭제 버튼 눌렀을때
	function confirmDelete(boardnum, option, sday, haveReply){
		var confirmDelete = confirm("정말로 삭제하시겠습니까?\n삭제한 글은 복구할 수 없습니다.");
		if(confirmDelete){
			var dir;
			if(option == 0){
				dir = "../../board/boardProdQna/";
			}else if(option ==1){
				dir = "../../board/boardCommonQna/";
			}else{
				dir = "../../board/boardReview/";
			}
			window.location = dir + 'deletePro.jsp?boardnum=' + boardnum + '&option=3&sday=' + sday + '&haveReply=' + haveReply + '&productN=0';
		}
	}
</script>

<%
	String sid = (String)session.getAttribute("sid");
	if(sid == null){
		// TODO 잘못된 접근
	}else if(!sid.equals("admin")){
		//TODO 잘못된 접근
	}
	
	//옵션 변수 불러오기 : 어떤 게시판 데이터 읽을 것인지
	int option = 0;
	String strOption = request.getParameter("option");
	if(strOption != null){
		option = Integer.parseInt(strOption);
	}
	
	//답글여부 옵션 변수 불러오기
	boolean haveReply = false;
	String strHaveReply = request.getParameter("haveReply");
	if(strHaveReply != null){
		if(strHaveReply.equals("true")){
			haveReply = true;
		}
	}
	
	//페이징 처리 변수
	final int PAGE_SIZE = 10;
	int currentPage = 1;
	int start = 0;
	int end = 0;
	int count = 0;
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	}
	currentPage = Integer.parseInt(pageNum);
	start = (currentPage-1)*PAGE_SIZE+1;
	end = currentPage * PAGE_SIZE;
	
	//n일이내 글 보기
	int sday = 10000;
	String ssday = request.getParameter("sday");
	if(ssday != null && !ssday.equals("null")){
		sday = Integer.parseInt(ssday);
	}
	
%>	<form name="frm">
		조회 기간 선택 : <select name = "sday" onchange="window.location='list.jsp?option=<%=option %>&sday=' + this.value + '&haveReply=' + document.frm.haveReply.checked" onfocus="this.selectedIndex=-1;">
			<option value="10000">모두보기</option>
			<option value="7">일주일 이내</option>
			<option value="30">30일 이내</option>
			<option value="185">6개월 이내</option>
			<option value="366">1년 이내</option>
		</select>
		<input type="checkbox" name="haveReply" value=<%=haveReply %> onclick="window.location='list.jsp?option=<%=option%>&sday=<%=sday %>&haveReply='+(this.checked)"/> 답글 안달린 글만 보기
	</form>
	<script>
		document.frm.haveReply.checked = <%=haveReply%>;
		document.frm.sday.value = <%=sday%>
	</script>
	
<%
	//count 변수에 값 집어넣고
	//옵션별로 리스트 데이터 불러오기
	ArrayList<? extends BoardDTO> list = new ArrayList();
	if(option==0){ //상품 문의
		BoardProdQnaDAO dao = new BoardProdQnaDAO();
		count = dao.countAdmin(sday, haveReply);
		if(end>count){end=count;}
		list = dao.showAdminList(sday,start,end,haveReply);
	}else if(option==1){ //전체 문의
		BoardCommonQnaDAO dao = new BoardCommonQnaDAO();
		count = dao.countAdmin(sday, haveReply);
		if(end>count){end=count;}
		list = dao.showAdminList(sday, start, end, haveReply);
	}else if(option==2){ //리뷰 관리
		BoardReviewDAO dao = new BoardReviewDAO();
		count = dao.countAdmin(sday, haveReply);
		if(end>count){end=count;}
		list = dao.showAdminList(sday, start, end, haveReply);
	}else{ // TODO 에러처리
		
	}
	
%>

<table border="1">
<%	for(BoardDTO d : list){ %>
		<tr><td><table width="500">
			<tr>
				<td width="75%">
					제목 : 
					<a href="read.jsp?option=<%=option%>&haveReply=<%=haveReply%>&boardnum=<%=d.getBoardnum()%>&sday=<%=sday%>&pageNum=<%=pageNum%>">
						<%=d.getBoardtitle() %>
					</a>
<%					int countReply = 0;
					if(option == 0) { 
						BoardProdQnaDAO dao = new BoardProdQnaDAO();
						countReply = dao.countReply(d.getBoardnum());
					}else if(option == 1){ 
						BoardCommonQnaDAO dao = new BoardCommonQnaDAO();
						countReply = dao.countReply(d.getBoardnum());
					}else { 
						BoardReviewDAO dao = new BoardReviewDAO();
						countReply = dao.countReply(d.getBoardnum());
					} 
					if(countReply > 0){
%>						(<%=countReply %>개의 관리자 답변)
<%					} %>
				</td>
				<td width="25%" align="right">
					<input type="button" value="삭제" onclick="confirmDelete(<%=d.getBoardnum() %>,<%=option %>,<%=sday %>,<%=haveReply %>)" />
				</td>
			</tr>
<%			if(option == 0) { // TODO 제품명 제대로 읽어오기
				ProductDAO pdao = new ProductDAO();
				ProductDTO pdto = pdao.getData(((BoardProdQnaDTO)d).getProductN());
%>				<tr><td colspan="2">
				제품명 : 
				<a href="../../product/product.jsp?productN=<%=pdto.getProductN()%>">
					<img src="/wouldyoulike_final/img/product/<%=pdto.getImg() %>" height="32px" />
					<%=pdto.getName() %>
				</a>
<%			} else if(option == 2){
				ProductDAO pdao = new ProductDAO();
				ProductDTO pdto = pdao.getData(((BoardReviewDTO)d).getProductN());
%>
				<tr><td>
					제품명 :
					<a href="../../product/product.jsp?productN=<%=pdto.getProductN()%>">
						<img src="/wouldyoulike_final/img/product/<%=pdto.getImg() %>" height="32px" />
						<%=pdto.getName() %>
					</a>
				</td>
				<td> 
					별점 : 
<%					for(int i=0; i<5 ; ++i){
						if(i < ((BoardReviewDTO)d).getBoardscore()){
%>							★
<%						}else{ %>
							☆
<%						} 
					}
			} %>
				</td>
			</tr>
			<tr>
				<td>작성자 : <%=d.getBoardwriter() %></td>
				<td align="right"><%=String.format("%1$ty.%1$tm.%1$td %1$tH:%1$tM",d.getBoardreg()) %></td>
			</tr>
			<tr><td colspan="2">내용</td></tr>
<%			if(d.getBoardimage() != null) {
				String dir = "/wouldyoulike_final/board/";
				if(option == 0){
					dir += "prodqnaimage/";
				}else if(option==1){
					dir += "commonqnaimage/";
				}else{
					dir += "reviewimage/";
				}%>
				<tr><td colspan="2">
					<img src="<%=dir+d.getBoardimage()%>">
				</td></tr>
<%			} %>
			<tr><td colspan="2"><%=d.getBoardcontent() %></td></tr>
		</table></td></tr>
<%	} %>
	<tr><td colspan="2" align="center">
<%
	// 페이징 처리
	if(count > 0){
		int pageCount = count / PAGE_SIZE + (count%PAGE_SIZE == 0? 0:1);
		int startPage = (int)(currentPage / PAGE_SIZE)*PAGE_SIZE+1;
		final int PAGE_BLOCK = 10;
		int endPage = startPage + PAGE_BLOCK-1;
		if(endPage > pageCount){
			endPage = pageCount; 
		}
		if(startPage > PAGE_BLOCK){
%>			<a href="list.jsp?option=<%=option %>&pageNum=<%=startPage-PAGE_BLOCK%>">[이전]</a>
<%		}
		for( int i = startPage ; i<=endPage ; i++){
%>			<a href="list.jsp?option=<%=option %>&pageNum=<%=i%>">[<%=i %>]</a>
<%		}
		if(endPage < pageCount){
%>			<a href="list.jsp?option=<%=option %>&pageNum=<%=startPage+PAGE_BLOCK%>">[다음]</a>
<%		}
	}
%>
	</td></tr>
</table>

<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>


