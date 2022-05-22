<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*" %>
<%@ page import="wouldyoulike.order.cartDAO" %>
<%@ page import="wouldyoulike.order.cartDTO" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>장바구니 페이지입니다.</title>
	<style>
		table{
			margin-top:5%;
			margin-left:10%;
			margin-right:10%;
			margin-bottom:5%;
			
			width:70%;
		}
		
	</style>
</head>

<body>
<!-- Navbar -->
<jsp:include page="../menu.jsp"/>

<aside style="float:left;">
	<jsp:include page="../mypageForm.jsp"/>
</aside>


<section style="margin-left:20%;">
<div class="col-md-10">

<%
request.setCharacterEncoding("UTF-8");

String id =(String)session.getAttribute("sid");

String cid=null, cpw=null, cauto=null;
Cookie [] cookies = request.getCookies();

if(id==null){
	if(cookies != null){
		for(Cookie c :cookies){
			String cname = c.getName();
			if(cname.equals("cid")) cid=c.getValue();
			if(cname.equals("cpw")) cpw=c.getValue();
			if(cname.equals("cauto")) cauto=c.getValue();
		}
	}
	if(cauto != null && cid != null && cpw != null){
		response.sendRedirect("/wouldyoulike_final/member/loginPro.jsp");
	}
	response.sendRedirect("../member/loginForm.jsp");
}

cartDAO dao = new cartDAO();
ArrayList<cartDTO> list = dao.getcartInfo(id);


%>
	<h2 style="margin-top:5%; margin-left:10%"><%=id %>님의 장바구니</h2>
	<form action="reservationPage2.jsp" name="frm" method="post">
		<input type="hidden" name="id" value="<%=id%>"/>
		<table>
			<tr align="center">
				<th></th> <!-- 열맞추기용  -->
				<th>상품이름</th>
				<th>상품금액</th>
				<th>수량</th>
				<th></th>
			</tr>
	         	<%
         		if(list.size()>0){
	         		for(cartDTO dto : list){ 
	         			int price = dao.productPrice(dto.getproductN());
	         	%>
					<tr id ="tr1" align="center">
						<td><input type="checkbox" name="cartlist" value="<%=dto.getproductN()%>"/></td>
    					<td><a href="../product/product.jsp?productN=<%=dto.getproductN()%>"><%=dto.getname()%></a></td>
    					<td><%=price%></td>
	         			<td><input type="number" name ="<%=dto.getproductN()%>" value ="<%=dto.getamount()%>" id="option" min="1" max="9"></td>
	          			<td align="left">
	          				<input type="button" onclick="location.href='deleteCart.jsp?id=<%=dto.getmemberID()%>&productN=<%=dto.getproductN()%>';"value="삭제하기" />
						</td>
					</tr>
	           <%	}%>
	        <tr>  
				<td colspan="7">
					<input type="submit" value="선택상품 구매" style="float:right;"/>
					<input type="button" value="뒤로가기" onclick="back()"/>
				</td>
			</tr>
			<%}else{%>
				<tr>
					<td></td>
					<td colspan=3>장바구니가 비었습니다.</td>
				</tr>
			<%} %>
		</table>
	</form>
<script>
function back(){
	
	history.go(-1);
	
}
</script>
</div>
</section>

<!-- Footer -->
<jsp:include page="../footer.jsp"></jsp:include>

</body>
</html>