<%--
updateForm.jsp
	글 수정 form 페이지
	파라미터로 boardnum 받음
	글 수정은 작성자 본인만 가능함
	
	dao.information 메서드 호출해서 해당글 정보를 DTO에 받아온 다음에
	input tag에 넣어줘서 수정하기 전 데이터를 보여줌
	
	그외 option ,sday, haveReply 파라미터 /admin/read.jsp 에서 받아서 다음페이지에 그냥 넘겨주는 역할
 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<!-- Navbar -->
<% if( "1".equals(request.getParameter("option")) || "2".equals(request.getParameter("option"))){%>
	<jsp:include page="../../menu.jsp"/>
<% } %>

<jsp:useBean id="dto" class="wouldyoulike.board.BoardProdQnaDTO" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardProdQnaDAO" />

<%
	String option = request.getParameter("option");

	// boardnum, productN 제대로 파라미터 넘어왔는지 확인
	if(request.getParameter("productN") == null || request.getParameter("boardnum") == null){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	}else if(option.equals("3") && !("admin".equals(session.getAttribute("sid")))){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	}else{
		dto = dao.information(Integer.parseInt(request.getParameter("boardnum")));
		// 세션id = 작성자인지 확인
		if(!dto.getBoardwriter().equals((String)session.getAttribute("sid"))){
%>			<script>
				alert("잘못된 접근입니다.");
				window.location="/wouldyoulike_final/main.jsp";
			</script>
<%		}
	}
%>
			

<form name="frm" action="/wouldyoulike_final/board/boardProdQna/updatePro.jsp" method="post" enctype="multipart/form-data">
			<input type="hidden" name="sday" value="<%=request.getParameter("sday") %>" />
			<input type="hidden" name="haveReply" value="<%=request.getParameter("haveReply") %>" />
			<input type="hidden" name="option" value="<%=option %>" />
			<input type="hidden" name="boardnum" value="<%=dto.getBoardnum() %>" />
			<input type="hidden" name="productN" value="<%=dto.getProductN() %>" /> 
			<input type="hidden" name="boardwriter" value="<%=dto.getBoardwriter() %>" />
	제목 : 	<input type="text" name="boardtitle" value="<%=dto.getBoardtitle() %>" /> 
			<input type="checkbox" name="boardpw"
<%				if(dto.getBoardpw() != null) {%>
					checked
<%				} %>	
			/> 비밀글 설정 <br />
	내용 : 	<textarea rows="8" cols="40" name="boardcontent"><%=dto.getBoardcontent() %></textarea> <br />
	사진 업로드 : <input type="file" name="boardimage" value="<%=dto.getBoardimage() %>" /> <br />
			<input type="submit" value="작성완료" />
</form>

<!-- Footer -->
<% if( "1".equals(request.getParameter("option")) || "2".equals(request.getParameter("option"))){%>
	<jsp:include page="../../footer.jsp"></jsp:include>
<% } %>
