<%--
deletePro.jsp
	글 삭제에 필요한 조건을 검사한 후(작성자 or 관리자)
	
	조건에 맞으면 dao.delete 메서드 호출해서 DB에서 데이터를 삭제한다
 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<h1>/boardNotice/deletePro.jsp</h1>

<jsp:useBean id="dto" class="wouldyoulike.board.BoardNoticeDTO" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardNoticeDAO" />

<%
	//세션 없는경우
	if(session.getAttribute("sid") == null){
%>		<script>
			alert("비정상적인 접근입니다.");
			window.location="../../main.jsp";
		</script>
<%	// 세션!=관리자
	} else if(!session.getAttribute("sid").equals("admin")){
%>		<script>
			alert("비정상적인 접근입니다.");
			window.location="../../main.jsp";
		</script>
<%
	}

	String bn = request.getParameter("boardnum");
	int boardnum=0;
	
	//boardnum 파라미터가 없는경우
	if(bn == null){
%>		<script>
			alert("비정상적인 접근입니다.");
			window.location="../../main.jsp";
		</script>
<%	} else{
		boardnum = Integer.parseInt(bn);
		
		int result = dao.delete(boardnum);
		if(result != 0){
%>			<script>
				alert("게시글이 삭제되었습니다.");
				window.location = "list.jsp";
			</script>
<%		} else {%>
			<script>
				alert("오류가 발생했습니다.");
				history.go(-1);
			</script>
<%		}
	}
%>
