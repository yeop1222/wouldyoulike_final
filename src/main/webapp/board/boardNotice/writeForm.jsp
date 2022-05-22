<%--
writeForm.jsp
	글 작성 form 페이지 (답글기능은 없음)
	글 작성자는 세션 아이디로 설정하고, 관리자만 작성 가능
	
 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- Navbar -->
<jsp:include page="../../menu.jsp"/>


<jsp:useBean id="dao" class="wouldyoulike.board.BoardNoticeDAO" />

<script>
	function check(){
		if(document.frm.boardwriter.value == null){
			alert("잘못된 접근입니다.");
			window.location="../../main.jsp"; 
			return false;
		}
		if(document.frm.boardtitle.value == ""){
			alert("제목을 입력하세요.")
			return false;
		}
	}
</script>

<%
	//로그인 세션 확인
	String boardwriter = (String)session.getAttribute("sid");

	//로그인 안됐으면 글작성 불가
	if(!"admin".equals(boardwriter)){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="../../main.jsp"; 
		</script>
<%	}
%>

<form name="frm" action="writePro.jsp" method="post" enctype="multipart/form-data" onsubmit="return check()">
		<input type="hidden" name="boardwriter" value="<%=boardwriter %>" />
	제목 : <input type="text" name="boardtitle" /> <br />
	내용 : <textarea rows="8" cols="40" name="boardcontent"></textarea> <br />
	사진 업로드 : <input type="file" name="boardimage" /> <br />
		<input type="submit" value="작성완료" />
</form>

<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>
