<%--
writeForm.jsp
	글 작성 (+답글 작성) form 페이지
	파라미터로 boardnum 받음(답글일경우 원글의 번호를 받는 파라미터)
	파라미터 productN 은 리뷰 올리는 상품의 번호
	글 작성자는 세션 아이디로 설정한다
	
	그외 option ,sDayReview, haveReply 파라미터 /admin/read.jsp 에서 받아서 다음페이지에 그냥 넘겨주는 역할
 --%>

<%@page import="wouldyoulike.order.orderDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- Navbar -->
<% if( "1".equals(request.getParameter("option")) || "2".equals(request.getParameter("option"))){%>
	<jsp:include page="../../menu.jsp"/>
<% } %>

<jsp:useBean id="dao" class="wouldyoulike.board.BoardReviewDAO" />

<script>
	function check(){
		if(document.frm.boardwriter.value == null){
			alert("로그인 후 글 작성이 가능합니다.");
			window.location="/wouldyoulike_final/member/loginForm.jsp";
			return false;
		}
		if(document.frm.productN.value == "null" || document.frm.productN.value == null){
			alert("잘못된 접근입니다.")
			window.location="/wouldyoulike_final/main.jsp";
			return false;
		}
		if(document.frm.boardtitle.value == ""){
			alert("제목을 입력하세요.")
			return false;
		}
	}
</script>

<%
	//로그인 새션 여부 확인
	String boardwriter = (String)session.getAttribute("sid");
	String productN = (String)request.getParameter("productN");
	
	//로그인 안됐으면 글작성 불가
	if(boardwriter == null){
%>		<script>
			alert("로그인 후 글 작성이 가능합니다.");
			window.location="/wouldyoulike_final/member/loginForm.jsp";
		</script>
<%	} 

	// orderinfo 테이블에서 값 불러와서 주문자인지 확인
	orderDAO odao = new orderDAO();
	if(!odao.isOrderUser(Integer.parseInt(productN), boardwriter)){
%>		<script>
			alert("리뷰 작성은 상품 구매후 7일 이내에만 가능합니다.");
			window.location="/wouldyoulike_final/product/product.jsp?productN=<%=productN%>";
		</script>
<%	}
	int option = 0;
	if(request.getParameter("option") != null){
		option = Integer.parseInt(request.getParameter("option"));
	}
	
	//답글인지 여부 확인
	int originalnum = 0;
	if(request.getParameter("originalnum") != null){
		originalnum = Integer.parseInt(request.getParameter("originalnum"));

		//답글에 답글은 금지
		if(dao.information(originalnum).getOriginalnum() != 0){
%>			<script>
				alert("잘못된 접근입니다.");
				window.location="/wouldyoulike_final/main.jsp";
			</script>	
<%		}
		
		//답글은 원글 작성자랑 관리자만 가능
		if(!boardwriter.equals(dao.information(originalnum).getBoardwriter()) && !boardwriter.equals("admin")){
%>			<script>
				alert("잘못된 접근입니다.");
				window.location="/wouldyoulike_final/main.jsp";
			</script>			
<%		}
	}
%>

<form name="frm" action="/wouldyoulike_final/board/boardReview/writePro.jsp" method="post" enctype="multipart/form-data" onsubmit="return check()">
		<input type="hidden" name="originalnum" value="<%=originalnum %>" />
		<input type="hidden" name="option" value="<%=option %>" />
		<input type="hidden" name="boardwriter" value="<%=boardwriter %>" />
		<input type="hidden" name="productN" value="<%=productN %>" />
	제목 : <input type="text" name="boardtitle" />
<%	//답글인경우는 별점 없음
	if(originalnum == 0) {%>	
		별점 : <select name="boardscore">
			<option value="5">★★★★★</option>
			<option value="4">★★★★☆</option>
			<option value="3">★★★☆☆</option>
			<option value="2">★★☆☆☆</option>
			<option value="1">★☆☆☆☆</option>
			<option value="0">☆☆☆☆☆</option>
		</select>
<%	}%> 
	<br />
	내용 : <textarea rows="8" cols="40" name="boardcontent"></textarea> <br />
	사진 업로드 : <input type="file" name="boardimage" /> <br />
			<input type="submit" value="작성완료" />
</form>


<!-- Footer -->
<% if( "1".equals(request.getParameter("option")) || "2".equals(request.getParameter("option"))){%>
	<jsp:include page="../../footer.jsp"></jsp:include>
<% } %>
