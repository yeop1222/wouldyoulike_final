<%--
writeForm.jsp
	글 작성 (+답글 작성) form 페이지
	파라미터로 boardnum 받음(답글일경우 원글의 번호를 받는 파라미터)
	글 작성자는 세션 아이디로 설정한다
	
	그외 option ,sDayCommon, haveReply 파라미터 /admin/read.jsp 에서 받아서 다음페이지에 그냥 넘겨주는 역할
 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- Navbar -->
<% if(request.getParameter("option") == null || request.getParameter("option").equals("0")){%>
	<jsp:include page="../../menu.jsp"/>
<% } %>


<jsp:useBean id="dao" class="wouldyoulike.board.BoardCommonQnaDAO" />

<script>
	function check(){
		if(document.frm.boardwriter.value == null){
			alert("로그인 후 글 작성이 가능합니다.");
			window.location="/wouldyoulike_final/member/loginForm.jsp";
			return false;
		}
		if(document.frm.boardtitle.value == ""){
			alert("제목을 입력하세요.")
			return false;
		}
	}
</script>

<%
	//로그인 여부 확인하고
	String boardwriter = (String)session.getAttribute("sid");

	//로그인 안되었으면 글작성 불가
	if(boardwriter==null){
%>		<script>
			alert("로그인 후 글 작성이 가능합니다.");
			window.location="/wouldyoulike_final/member/loginForm.jsp"; //로그인 페이지
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
		
		if(option == 3 && !("admin".equals(session.getAttribute("sid")))){
%>			<script>
				alert("잘못된 접근입니다.");
				window.location="/wouldyoulike_final/main.jsp";
			</script>
<%		}
	//관리자 페이지에서 답글 바로 달수없음
	}else if(option == 3){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	}
%>

<form name="frm" action="/wouldyoulike_final/board/boardCommonQna/writePro.jsp" method="post" enctype="multipart/form-data" onsubmit="return check()">
		<input type="hidden" name="originalnum" value="<%=originalnum %>" />
		<input type="hidden" name="option" value="<%=option %>" />
		<input type="hidden" name="boardwriter" value="<%=boardwriter %>" />
		<input type="hidden" name="sDayCommon" value="<%=request.getParameter("sDayCommon") %>" />
		<input type="hidden" name="haveReply" value="<%=request.getParameter("haveReply") %>" />
	제목 : <input type="text" name="boardtitle" />
	<input type="checkbox" name="boardpw"
<% 	//답글이면서 원글이 비밀글인 경우 답글도 비밀글로 설정
	if(originalnum != 0 && dao.information(originalnum).getBoardpw() != null) {
%>	checked readonly
<%	} %>
	/> 비밀글 설정 <br />
	내용 : <textarea rows="8" cols="40" name="boardcontent"></textarea> <br />
	사진 업로드 : <input type="file" name="boardimage" /> <br />
			<input type="submit" value="작성완료" />
</form>


<!-- Footer -->
<% if(request.getParameter("option") == null || request.getParameter("option").equals("0")){%>
	<jsp:include page="../../footer.jsp"></jsp:include>
<% } %>

