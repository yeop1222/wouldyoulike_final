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

<jsp:useBean id="dto" class="wouldyoulike.board.BoardReviewDTO" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardReviewDAO" />

<%
	String dir = request.getRealPath("/img/board/reviewimage/");
	File file = new File(dir);
	if(!file.exists()){
		file.mkdirs();
	}
	int size = 5*1024*1024;
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request,dir,size,enc,dp);
	
	//이미지 파일 타입 확인
	if(mr.getParameter("boardimage") != null){
		String ext = mr.getContentType("boardimage").split("/")[0];
		
		if(!ext.equals("image")){
			//이미지가 아니면 업로드된 파일 삭제
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
	dto.setBoardscore(mr.getParameter("boardscore"));
	dto.setBoardcontent(mr.getParameter("boardcontent"));
	dto.setProductN(mr.getParameter("productN"));
	dto.setBoardwriter(mr.getParameter("boardwriter"));
	
	//세션 있는지 확인
	if(session.getAttribute("sid") == null){
%>		<script>
			alert("잘못된 접근입니다.");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	// 받은 parameter (boardnum productN boardwrtier boardtitle 4개 유효한값인지 확인)
	}else if(dto.getBoardnum() == 0 || dto.getProductN() == 0 || dto.getBoardwriter() == null || dto.getBoardtitle() == null){
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
		
		if(option == null || "0".equals(option)){
			strOption += "&productN=" + dto.getProductN();
		}else if("2".equals(option)){
			strOption += "&boardnum=";
			if(dao.originalNum(dto.getBoardnum()) == 0){
				strOption += dto.getBoardnum();
			}else{
				strOption += dao.originalNum(dto.getBoardnum());
			}
		}else if("1".equals(option)){
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
					String sday = mr.getParameter("sday");
					String haveReply = mr.getParameter("haveReply");
					response.sendRedirect("/wouldyoulike_final/admin/board/read.jsp?option=2&sday=" + sday + "&haveReply=" + haveReply + "&boardnum=" + dto.getOriginalnum());
				}else if(option != null && !option.equals("0")){
					response.sendRedirect("/wouldyoulike_final/board/boardReview/list.jsp" + strOption);
				}else{
					response.sendRedirect("/wouldyoulike_final/product/product.jsp" + strOption);
				}
%>			</script>
<%		} else{ %>
			<script>
				alert("글 수정시 오류가 발생했습니다.");
				history.go(-1);
			</script>
<%		}
	}
%>
