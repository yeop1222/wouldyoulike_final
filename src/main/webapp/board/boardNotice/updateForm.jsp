<%--
updateForm.jsp
	글 수정 form 페이지
	파라미터로 boardnum 받음
	글 수정은 작성자 본인(=관리자)만 가능함
	
	dao.information 메서드 호출해서 해당글 정보를 DTO에 받아온 다음에
	input tag에 넣어줘서 수정하기 전 데이터를 보여줌
	
 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- Navbar -->
<jsp:include page="../../menu.jsp"/>


<jsp:useBean id="dto" class="wouldyoulike.board.BoardNoticeDTO" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardNoticeDAO" />

<%
	String boardnum = request.getParameter("boardnum");
	String sid = (String)session.getAttribute("sid");
	if(boardnum == null){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="../../main.jsp";
		</script>
<%	}else if(sid != null && !sid.equals("admin")){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="../../main.jsp";
		</script>
<%	} else {
		dto = dao.information(Integer.parseInt(boardnum));
	}
%>

<form name="frm" action="updatePro.jsp" method="post" enctype="multipart/form-data">
		<input type="hidden" name="boardnum" value="<%=dto.getBoardnum() %>" />
		<input type="hidden" name="boardwriter" value="<%=dto.getBoardwriter() %>" />
	제목 : <input type="text" name="boardtitle" value="<%=dto.getBoardtitle() %>" /> <br />
	내용 : <textarea rows="8" cols="40" name="boardcontent"><%=dto.getBoardcontent() %></textarea> <br />
	사진 업로드 : <input type="file" name="boardimage" value="<%=dto.getBoardimage()%>"/> <br />
		<input type="submit" value="작성완료" />
</form>

<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>
