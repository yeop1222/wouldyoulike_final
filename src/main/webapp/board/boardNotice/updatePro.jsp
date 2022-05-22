<%--
updatePro.jsp
	각종 글작성에 필요한 파라미터들 MultipartRequest 형식으로 받아서 사용
	(이미지 업로드때문에 필요한 부분)
	
	dao.update 메서드 호출해서 DB에서 데이터를 수정한다
 --%>

<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<jsp:useBean id="dto" class="wouldyoulike.board.BoardNoticeDTO" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardNoticeDAO" />

<%
	String dir = request.getRealPath("/img/board/noticeimage/");
	File file = new File(dir);
	if(!file.exists()){
		file.mkdirs();
	}
	int size = 5*1024*1024;
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, dir, size, enc, dp);
	
	//이미지 파일타입 확인
	if(mr.getParameter("boardimage") != null) {
		String ext = mr.getContentType("boardimage").split("/")[0];
		
		if(!ext.equals("image")){
			//이미지 아니면 업로드한 파일 삭제
			mr.getFile("boardimage").delete();
%>			<script>
				alert("이미지 파일만 업로드 가능합니다.");
				history.go(-1);
			</script>
<%		}
	}

	String boardnum = mr.getParameter("boardnum");
	
	dto.setBoardimage(mr.getFilesystemName("boardimage"));
	dto.setBoardnum(Integer.parseInt(boardnum));
	dto.setBoardtitle(mr.getParameter("boardtitle"));
	dto.setBoardcontent(mr.getParameter("boardcontent"));
	dto.setBoardwriter(mr.getParameter("boardwriter"));


	//세션 있는지 확인
	if(session.getAttribute("sid") == null){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="../../main.jsp";
		</script>
<%	// 받은 parameter (boardnum productn boardwrtier boardtitle 4개 유효한값인지 확인)
	}else if(dto.getBoardnum() == 0 || dto.getBoardwriter() == null || dto.getBoardtitle() == null){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="../../main.jsp";
		</script>
<%	// 이 글의 작성자(boardwriter) admin인지 확인
	}else if(!dto.getBoardwriter().equals("admin")){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="../../main.jsp";
		</script>
<%	
	}else{
		int result = dao.update(dto);

		if(result==1){
%>			<script>
				alert("글이 수정되었습니다.");
				window.location="list.jsp";
			</script>
<%		} else{ %>
			<script>
				alert("글 수정시 오류가 발생했습니다.");
				history.go(-1);
			</script>
<%		} 
	}
%>
