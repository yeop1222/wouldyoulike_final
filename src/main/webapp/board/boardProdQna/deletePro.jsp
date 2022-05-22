<%--
deletePro.jsp
	글 삭제에 필요한 조건을 검사한 후(작성자 or 관리자)
	
	조건에 맞으면 dao.delete 메서드 호출해서 DB에서 데이터를 삭제한다
 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:useBean id="dto" class="wouldyoulike.board.BoardProdQnaDTO" />
<jsp:setProperty name="dto" property="*" />
<jsp:useBean id="dao" class="wouldyoulike.board.BoardProdQnaDAO" />

<%
	//세션 없는경우
	if(session.getAttribute("sid") == null){
%>		<script>
			alert("비정상적인 접근입니다.");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	// productN / boardnum 파라미터가 없는경우
	}else if(dto.getBoardnum() == 0){
%>		<script>
			alert("비정상적인 접근입니다.");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	//글 작성자와 세션 비교해서 다른경우 + 다를때 관리자는 아님
	}else if(!dao.information(dto.getBoardnum()).getBoardwriter().equals((String)session.getAttribute("sid")) && !((String)session.getAttribute("sid")).equals("admin")){
%>		<script>
			alert("비정상적인 접근입니다.");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	}else{
		int originalNum = dao.originalNum(dto.getBoardnum());
		int result = dao.delete(dto.getBoardnum());
		String option = request.getParameter("option");
		String strOption = "?option=" + option;
		if(option == null || option.equals("0")){
			strOption += "&productN=" + dto.getProductN();
		}else if(option.equals("1")){
			int sday = 10000;
			if(request.getParameter("sday") != null){
				sday = Integer.parseInt(request.getParameter("sday"));
			}
			strOption += "&sday=" + sday;
		}else if(option.equals("2")){
			if(originalNum == 0){
				strOption = "?option=1";
			}else{
				strOption += "&boardnum=" + originalNum;
			}
		}
		
		if(result != 0){
%>			<script>
				alert("게시글이 삭제되었습니다.");
<%				if(option.equals("3") && session.getAttribute("sid").equals("admin")){
					String sday = request.getParameter("sday");
					String haveReply = request.getParameter("haveReply");
					response.sendRedirect("/wouldyoulike_final/admin/board/list.jsp?option=0&sday=" + sday + "&haveReply=" + haveReply);
				}else if(option == null || option.equals("0")){
					response.sendRedirect("/wouldyoulike_final/product/product.jsp" + strOption);
				} else if(option.equals("2") && originalNum != 0){
					response.sendRedirect("/wouldyoulike_final/board/boardProdQna/list.jsp" + strOption);
				}else{
					response.sendRedirect("/wouldyoulike_final/mypage/myQna.jsp" + strOption);
				}
%>
			</script>
<%		} else {%>
			<script>
				alert("오류가 발생했습니다.");
				history.go(-1);
			</script>
<%		} 
	} %>