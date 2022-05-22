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

<jsp:useBean id="dto" class="wouldyoulike.board.BoardCommonQnaDTO" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardCommonQnaDAO" />

<%
	String dir = request.getRealPath("/img/board/commonqnaimage/");
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
	
	//이미지 경로 저장
	dto.setBoardimage(mr.getFilesystemName("boardimage"));
	//나머지 값 저장
	dto.setBoardnum(Integer.parseInt(mr.getParameter("boardnum")));
	dto.setBoardtitle(mr.getParameter("boardtitle"));
	dto.setBoardpw(mr.getParameter("boardpw"));
	dto.setBoardcontent(mr.getParameter("boardcontent"));
	dto.setBoardwriter(mr.getParameter("boardwriter"));
	
	//세션 있는지 확인
	if(session.getAttribute("sid") == null){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	//필수 parameter (boardnum boardwriter boardtitle) 유효성 확인
	}else if(dto.getBoardnum() == 0 || dto.getBoardwriter() == null || dto.getBoardtitle() == null){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	// 이 글의 작성자(boardwriter)랑 세션id(sid) 동일한지 확인
	}else if(!dto.getBoardwriter().equals((String)session.getAttribute("sid"))){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	}else{
		int result = dao.update(dto);
		String option = mr.getParameter("option");
		String strOption = "?option=" + option;
		if("2".equals(option)){
			strOption += "&boardnum=";
			if(dao.originalNum(dto.getBoardnum()) == 0){
				strOption += dto.getBoardnum();
			}else{
				strOption += dao.originalNum(dto.getBoardnum());
			}
		}
		if("1".equals(option)){
			String sDayCommon = "10000";
			if(mr.getParameter("sDayCommon") != null){
				sDayCommon = mr.getParameter("sDayCommon");
			}
			strOption += "&sDayCommon" + sDayCommon;
		}
		
		if(result==1){
%>			<script>
				alert("글이 수정되었습니다.");
<%				if(option.equals("3") && session.getAttribute("sid").equals("admin")){
					String sDayCommon = mr.getParameter("sDayCommon");
					String haveReply = mr.getParameter("haveReply");
					int oriNum = dao.originalNum(dto.getBoardnum());
					if(oriNum == 0){
						oriNum = dto.getBoardnum();
					}
					response.sendRedirect("/wouldyoulike_final/admin/board/read.jsp?option=1&sDayCommon=" +sDayCommon + "&haveReply=" +haveReply + "&boardnum=" +oriNum);
				}else if(option == null || option.equals("0")){
					response.sendRedirect("/wouldyoulike_final/board/boardCommonQna/list.jsp" + strOption);
				}else if(option.equals("1")){
					response.sendRedirect("/wouldyoulike_final/mypage/myQna.jsp" + strOption); //TODO parameter
				}else{
					response.sendRedirect("/wouldyoulike_final/board/boardCommonQna/list.jsp" + strOption);
				}
%>
			</script>
<%		} else{ %>
			<script>
				alert("글 수정시 오류가 발생했습니다.");
				history.go(-1);
			</script>
<%		}
	}%>
