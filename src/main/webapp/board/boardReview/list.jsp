<%--
	list.jsp
	각종 Review와 관련된 글 목록 불러오는 페이지
	option에 따라
		option==0 :	일반적으로 게시판에서 볼때
		option==1 :	마이페이지에서 작성자가 질문한 내역 볼때
		option==2 :	마이페이지에서 질문한 내역 클릭해서 답변까지 볼때
	
 --%>
<%@page import="wouldyoulike.products.ProductDTO"%>
<%@page import="wouldyoulike.products.ProductDAO"%>
<%@page import="wouldyoulike.board.BoardReviewDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- Navbar -->
<% if( "1".equals(request.getParameter("option")) || "2".equals(request.getParameter("option"))){%>
	<jsp:include page="../../menu.jsp"/>
	<aside>
	<jsp:include page="../../mypageForm.jsp"/>
	</aside>
<% } %>


<jsp:useBean id="dto" class="wouldyoulike.board.BoardReviewDTO" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardReviewDAO" />

<script>
	function confirmDeleteReview(p, n, o){
		var confirmDeleteReview = confirm("정말로 삭제하시겠습니까?\n삭제한 글은 복구할 수 없습니다.");
		if(confirmDeleteReview){
			window.location = "/wouldyoulike_final/board/boardReview/deletePro.jsp?productN=" + p + "&boardnum=" + n + "&option=" + o;
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
	String sProductN = request.getParameter("productN");
	int productN = 0;
	
	//페이징 관련 변수
	final int PAGE_SIZE; //1페이지당 글 개수
	int currentPage = 1;
	int start = 0;
	int end = 0;
	int count = 0;

	if(option == 1){
		PAGE_SIZE = 10;
	}else if(option == 2){
		PAGE_SIZE = 1000;
	}else{
		PAGE_SIZE = 5;
	}
	
	if(sProductN != null){
		productN = Integer.parseInt(sProductN);
	}else if(option == 0){
%>		<script>
			alert("잘못된 접근입니다.");
			<%end=0;%>
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	}

	String reviewPageNum = request.getParameter("reviewPageNum");
	if(reviewPageNum == null){
		reviewPageNum = "1";
	}
	
	currentPage = Integer.parseInt(reviewPageNum);
	start = (currentPage-1)*PAGE_SIZE+1;
	end = currentPage*PAGE_SIZE;
	
	int sDayReview = 10000;
	if(option == 1){
		String ssday = request.getParameter("sDayReview");
		if(ssday != null){
			sDayReview = Integer.parseInt(ssday);
		}
	}
	
	if(option == 1){
		count = dao.countWriter(sid, sDayReview);
	}else if(option == 2){
		count = dao.countReply(Integer.parseInt(request.getParameter("boardnum"))) + 1;
	}else{
		count = dao.boardCount(productN);
	}
	
	if(end > count){
		end=count;
	}
		
	//글은 로그인한 사람만 작성가능
	if(sid!=null && option == 0){
%>		<input type="button" value="리뷰 작성" onclick="window.location='/wouldyoulike_final/board/boardReview/writeForm.jsp?productN=<%=sProductN%>'"/>	
<%	} %>
	<section style="margin-left:25%;">
	<div class="col-md-12">
	<table border="1">
<% 	if(sid != null && option==1){ //TODO myqna 파라미터 더 불러와서 인수 넣어주기
%>		<form name="frm2">
			조회 기간 선택 : 
			<select name = "sDayReview" onchange="window.location='/wouldyoulike_final/board/boardReview/list.jsp?option=1&sDayReview=' +this.value" onfocus="this.selectedIndex=-1;">
				<option value="10000">모두보기</option>
				<option value="7">일주일 이내</option>
				<option value="30">30일 이내</option>
				<option value="185">6개월 이내</option>
				<option value="366">1년 이내</option>
			</select>
		</form>
		<script>
			document.frm2.sDayReview.value = <%=sDayReview%>;
		</script>

<%	}
	ArrayList<BoardReviewDTO> list = null;
	if(option == 1){
		String ssday = request.getParameter("sDayReview");
		if(ssday != null){
			sDayReview = Integer.parseInt(ssday);
		}
		list = dao.showMyList(sid, sDayReview, start, end);
	}else if(option==2){
		list = dao.showReply(Integer.parseInt(request.getParameter("boardnum")));
	}else{
		list = dao.showList(productN,start,end);
	}
	
%>

<%
	for(BoardReviewDTO d : list){
%>		<tr>
<%		if(d.getOriginalnum() != 0){
%>			<td width="5%"></td>
			<td>
<%		} else {%>
			<td colspan="2">
<%		} %>
				<table width="500">
					<tr>
						<td width="70%">
<% 							if(option == 1){ %>
								<a href="/wouldyoulike_final/board/boardReview/list.jsp?boardnum=<%=d.getBoardnum()%>&option=2">
<%							}%>
							제목: <%=d.getBoardtitle()%>
<% 							if(option == 1){ %>
								</a>
<%								if(dao.countReply(d.getBoardnum()) > 0){ %>
									(<%=dao.countReply(d.getBoardnum()) %>개의 관리자 답변)
<%								}
							} %>

						</td>
						<td width="10%">
<%							//글쓴이만 수정 가능
							if(d.getBoardwriter().equals(sid)){ %>
								<input type="button" value="수정" onclick="window.location='/wouldyoulike_final/board/boardReview/updateForm.jsp?productN=<%=d.getProductN() %>&boardnum=<%=d.getBoardnum() %>&option=<%=option %>'" />
<%							} %>
						</td>
						<td width="10%">
<%							//삭제는 글쓴이와 관리자만 가능
							if(d.getBoardwriter().equals(sid) || "admin".equals(sid)) { %>
								<input type="button" value="삭제" onclick="confirmDeleteReview(<%=d.getProductN()%>,<%=d.getBoardnum()%>,<%=option %>)" />
<%							} %>
						</td>
						<td width="10%">
<%							//답글은 글쓴이와 관리자만 가능 & 답글에는 또 답글 못달음
							if(d.getBoardwriter().equals(sid) || "admin".equals(sid)) {
								if(d.getOriginalnum() == 0) { 
									if(option != 1) {%>
										<input type="button" value="답글" onclick="window.location='/wouldyoulike_final/board/boardReview/writeForm.jsp?productN=<%=d.getProductN() %>&originalnum=<%=d.getBoardnum() %>&option=<%=option %>'" />
<%									}
								} 
							}%>
						</td>
					</tr>
					<tr>
<%						if(option == 1){  
							ProductDAO pdao = new ProductDAO();
							ProductDTO pdto = pdao.getData(d.getProductN());
%>
							<td>
								제품명: <a href="/wouldyoulike_final/product/product.jsp?productN=<%=pdto.getProductN()%>">
								<img src="/wouldyoulike_final/img/product/<%=pdto.getImg()%>" height="32" > <%=pdto.getName() %></a> 
							</td>
<%						}else{ %>
							<td>작성자: <%=d.getBoardwriter() %></td>
<%						} %>
						<td colspan="3" align="right"><%=String.format("%1$ty.%1$tm.%1$td %1$tH:%1$tM",d.getBoardreg()) %></td></tr>
					<tr>
						<td>내용</td>
						<td colspan="3" align="right">
<% 							if(d.getOriginalnum() == 0){%>
								별점: 
<%								for(int j=0; j<5; j++){
									if(j<d.getBoardscore()){ %>
										★
<%									}else{ %>
										☆
<%									} %>
<%								}
							}%>
						</td>
					</tr>
<%					if(d.getBoardimage() != null) { %>
						<tr><td colspan="4"><img src="<%="/wouldyoulike_final/img/board/reviewimage/" + d.getBoardimage() %>"></td></tr>
<%					} %>
					<tr><td><%=d.getBoardcontent() %></td></tr>
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
			if(endPage > pageCount){
				endPage = pageCount;
			}
			String strPage = null;
			String strOption = "&option=" + option;
			switch(option){
			case 0:
				strPage = "/wouldyoulike_final/product/product.jsp";
				strOption += "&productN=" + sProductN;
				break;
			case 1:
				strPage = "/wouldyoulike_final/board/boardReview/list.jsp";
				strOption += "&sDayReview=" + sDayReview ;
				break;
			case 2:
				strPage = "/wouldyoulike_final/board/boardReview/list.jsp";
				strOption += "&boardnum=" + request.getParameter("boardnum");
				break;
			};
			if(startPage > PAGE_BLOCK){
%>				<a href="<%=strPage%>?reviewPageNum=<%=startPage-PAGE_BLOCK%><%=strOption%>">[이전]</a>
<%			}
			for(int i = startPage ; i<=endPage ; i++){
%>				<a href="<%=strPage%>?reviewPageNum=<%=i%><%=strOption%>">[<%=i %>]</a>
<%			}
			if(endPage<pageCount){
%>				<a href="<%=strPage%>?reviewPageNum=<%=startPage+PAGE_BLOCK%><%=strOption%>">[다음]</a>
<%			}
		}
%>
	</td></tr>
</table>
</div>
</section>

<!-- Footer -->
<% if( "1".equals(request.getParameter("option")) || "2".equals(request.getParameter("option"))){%>
	<jsp:include page="../../footer.jsp"></jsp:include>
<% } %>
