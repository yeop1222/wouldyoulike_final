<%--
writePro.jsp
	각종 글작성에 필요한 파라미터들 MultipartRequest 형식으로 받아서 사용
	(이미지 업로드때문에 필요한 부분)
	
	dao.write 메서드 호출해서 DB에 글을 등록한다
 --%>

<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>


<jsp:useBean id="dto" class="wouldyoulike.board.BoardCommonQnaDTO" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardCommonQnaDAO" />

<%
	String dir = request.getRealPath("/img/board/commonqnaimage/");
	File file = new File(dir);
	if(!file.exists()){
		file.mkdirs();
	}
	int size = 5*1024*1024; //5MB 파일 제한
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request,dir,size,enc,dp);
	
	//유효성검사
if ( session.getAttribute("sid") == null){
		//로그인이 안된경우
%>		<script>
			alert("로그인후 글 작성이 가능합니다.");
			window.location="/wouldyoulike_final/member/loginForm.jsp";
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
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	}
	if(mr.getParameter("originalnum") != null && 
			!(session.getAttribute("sid").equals(mr.getParameter("boardwriter")) || session.getAttribute("sid").equals("admin"))){
		//답글이면 (세션 == 작성자 or 관리자일때)만 가능
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	}
	
	
	//파잍 타입 확인
	if(mr.getParameter("boardimage") != null){
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
	
	//이미지 경로
	dto.setBoardimage(mr.getFilesystemName("boardimage"));
	//나머지 파라미터 저장
	dto.setBoardwriter(mr.getParameter("boardwriter"));
	dto.setBoardtitle(mr.getParameter("boardtitle"));
	dto.setBoardpw(mr.getParameter("boardpw"));
	dto.setBoardcontent(mr.getParameter("boardcontent"));
	dto.setOriginalnum(Integer.parseInt(mr.getParameter("originalnum")));
	
	int result = dao.write(dto);
	int option = 0;
	if(mr.getParameter("option") != null){
		option = Integer.parseInt(mr.getParameter("option"));
	}
	String strOption = "?option=" + option;
	if(option == 2){
		strOption += "&boardnum=" + dto.getOriginalnum();
	}

	if(result==1){
%>		<script>
			alert("게시글이 작성되었습니다.");
<%			if(option == 3 && session.getAttribute("sid").equals("admin")){
				String sday = mr.getParameter("sday");
				String haveReply = mr.getParameter("haveReply");
				response.sendRedirect("/wouldyoulike_final/admin/board/read.jsp?option=1&sday=" + sday + "&haveReply=" + haveReply + "&boardnum=" + dto.getOriginalnum());
			} else if(option == 2){
				response.sendRedirect("/wouldyoulike_final/board/boardCommonQna/list.jsp" + strOption);
			}else{
				response.sendRedirect("/wouldyoulike_final/board/boardCommonQna/list.jsp" + strOption);
			}
%>
		</script>
<%	} else{ %>
		<script>
			alert("글 작성시 오류가 발생했습니다.");
			history.go(-1);
		</script>
<%	} %>