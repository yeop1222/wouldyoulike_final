<%@page import="wouldyoulike.order.orderDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<head>
	<title>관리자 메인</title>
	<style>
		section{
			width:40%;
			margin-left:20%;
			margin-bottom:10%;
		}
	</style>
</head>
<%
	String id = (String) session.getAttribute("sid");
	if(id==null){
%>		<script>
			alert("로그인을 해주세요.");
			window.location="../mainForm.jsp";
		</script>		
<%	}else if(!id.equals("admin")){
%>		<script>
			alert("관리자만 접근 가능한 페이지입니다!");
			window.location="../main.jsp";
		</script>
<%	} %>	
	    
    
    
<h1>/admin/main.jsp</h1>

<jsp:useBean id="mdao" class="wouldyoulike.member.MemberDAO" />
<jsp:useBean id="pdao" class="wouldyoulike.products.ProductDAO" />
<jsp:useBean id="odao" class="wouldyoulike.order.orderDAO" />

<jsp:useBean id="bcdao" class="wouldyoulike.board.BoardCommonQnaDAO" />
<jsp:useBean id="bpdao" class="wouldyoulike.board.BoardProdQnaDAO" />
<jsp:useBean id="brdao" class="wouldyoulike.board.BoardReviewDAO" />

<!-- Navbar -->
<jsp:include page="adminmenu.jsp"/>

<section>
<table border="1">
	<tr>
		<th>매출관리</th>
		<th>재고관리</th>
	</tr>
	<tr>
		<td>
			최근 7일 매출 <%=odao.recentSales(7)[0] %><br />
			지난 7일 대비 (<%=String.format("%+d",odao.recentSales(7)[0]-odao.recentSales(7)[1] )%>)
			<br /><br />
			최근 30일 매출 <%=odao.recentSales(30)[0] %><br />
			지난 30일 대비 (<%=String.format("%+d",odao.recentSales(30)[0]-odao.recentSales(30)[1] )%>)
			<br /><br />
		</td>
		<td>
			<h6>매진임박</h6>
<%			HashMap<String, Integer> map = pdao.closeSoldOut(10);
%>			<table>
				<tr><th>상품명</th><th>재고</th></tr>
<%			Iterator<String> keys = map.keySet().iterator();
			while(keys.hasNext()){
				String key = keys.next();
%>				<tr>
					<td>
						<%=key %>
					</td>
					<td align="center">
						<%=map.get(key) %>
					</td>
				</tr>
<%			}
			//페이징처리 가능하면 하기
%>
			</table>
		</td>
	</tr>	
	<tr>
		<th>회원관리</th>
		<th>게시판관리</th>
	</tr>
	<tr>
		<td>
<%			int [] newMemberCount = mdao.countNewMember(7);
%>			최근 7일 신규 가입자수 <%= newMemberCount[0] %> <br />
			지난 7일 대비 (<%=String.format("%+d",newMemberCount[0]-newMemberCount[1] )%>)
			<br /><br />
<%			newMemberCount = mdao.countNewMember(30);
%>			최근 30일 신규 가입자수 <%= newMemberCount[0] %> <br />
			지난 30일 대비 (<%=String.format("%+d",newMemberCount[0]-newMemberCount[1] )%>)
		</td>
		<td>
			<%int boardNew = 7; %>
			최근 <%=boardNew %>일이내 답글 안달린 <br />
			문의게시판 글 갯수: <%=bcdao.countNew(boardNew) %> <br/>
			상품문의 갯수: <%=bpdao.countNew(boardNew) %> <br/>
			리뷰 갯수: <%=brdao.countNew(boardNew) %> 
		</td>
	</tr>
	<tr>
		<td colspan="2">
			신규 주문 내역<br/>
			총 <%= odao.newOrderCount()%>개의 신규 주문이 있습니다!
		</td>
	</tr>
</table>
</section>
<!-- Footer -->
<jsp:include page="../footer.jsp"></jsp:include>