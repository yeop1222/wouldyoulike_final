<%--
writePro.jsp
	각종 글작성에 필요한 파라미터들 MultipartRequest 형식으로 받아서 사용
	(이미지 업로드때문에 필요한 부분)
	
	dao.write 메서드 호출해서 DB에 글을 등록한다
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
	int size = 5*1024*1024; //5MB 파일 제한
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request,dir,size,enc,dp);
	
	//유효성 검사
	if ( session.getAttribute("sid") == null){
		//로그인이 안된경우
%>		<script>
			alert("로그인후 글 작성이 가능합니다.");
			window.location="../../member/loginForm.jsp";
		</script>
<%	}
	if(mr.getParameter("boardtitle") == null){
		//제목 안적은경우
%>		<script>
			alert("제목을 입력하세요.");
			history.go(-1);
		</script>
<%	}
	if(mr.getParameter("boardwriter") == null){
		//작성자 null
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="../../main.jsp";
		</script>
<%	}
	if(!mr.getParameter("boardwriter").equals("admin")){
		//관리자 아닌 작성자
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="../../main.jsp";
		</script>
<%	}
	
	//파일 타입 확인
	if(mr.getParameter("boardimage") != null) {
		String ext = mr.getContentType("boardimage").split("/")[0];
	
		if(!ext.equals("image")){
			//이미지가 아니라면 업로드 된 파일 삭제
			mr.getFile("boardimage").delete();
%>			<script>
				alert("이미지 파일만 업로드 가능합니다.");
				history.go(-1);
			</script>
<%		}
	}
	
	//이미지 경로 저장
	dto.setBoardimage(mr.getFilesystemName("boardimage"));
	
	dto.setBoardwriter(mr.getParameter("boardwriter"));
	dto.setBoardtitle(mr.getParameter("boardtitle"));
	dto.setBoardcontent(mr.getParameter("boardcontent"));

	int result = dao.write(dto);

	if(result==1){
%>		<script>
			alert("게시글이 작성되었습니다.");
			window.location="list.jsp";
		</script>
<%	} else{ %>
		<script>
			alert("글 작성시 오류가 발생했습니다.");
			history.go(-1);
		</script>
<%	} %>