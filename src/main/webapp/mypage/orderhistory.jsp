<%@page import="wouldyoulike.products.ProductDTO"%>
<%@page import="wouldyoulike.products.ProductDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="wouldyoulike.order.orderDTO" %>
<%@ page import="wouldyoulike.order.orderDAO" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문내역 페이지입니다.</title>
</head>

<%
	String id = (String) session.getAttribute("sid");
	if(id==null){
%>		<script>
			alert("로그인이 필요한 페이지 입니다!");
			window.location="/wouldyoulike_final/member/loginForm.jsp";
		</script>
<%	}
%>

 <%
request.setCharacterEncoding("UTF-8");
orderDAO dao = new orderDAO();
String memberid = (String)session.getAttribute("sid");
int option = 0;
String strOption = request.getParameter("option");
ArrayList<orderDTO> list=null;
if(strOption != null){
	option = Integer.parseInt(strOption);
}
if(option == 0){
	list = dao.getCheckBuyInfo(memberid);
}else if(option == 1){
	list = dao.getBuyInfo(memberid);
}

%>


<!-- Navbar -->
<jsp:include page="../menu.jsp"/>

<aside>
<jsp:include page="../mypageForm.jsp"/>
</aside>

<body>
	<section style="margin-left:25%;">
	<div class="col-md-12">
	 <table>
	       <colgroup>
	       <col>               <!-- 상품명/옵션 -->
	       <col style="width:5%">  <!-- 수량 -->
	       <col style="width:10%"> <!-- 상품금액 -->
	       <col style="width:13%"> <!-- 할인/적립 -->
	       <col style="width:10%"> <!-- 합계금액 -->
	
	       </colgroup>
	       <thead>
	       <tr>
	       	   <th>주문자 이름</th>
	       	   <th>전화번호</th>
		       <th>상품명</th>
		       <th>수량</th>
		       <th>결제금액</th>
		       <th>수령방법</th>
		       <th>결제수단</th>
		       <th>주문현황</th>
		       <th>결제날짜</th>
	       </tr>
	     <%if(list.size()> 0){
	     for(orderDTO dto : list){ %>
	     	<tr>
	         <th><%=dto.getordername() %></th>
	         <th><%=dto.getmobilenum() %></th>
			<%	ProductDAO pdao = new ProductDAO();
				ProductDTO pdto = pdao.getData(dto.getproductNum());
				String productImg = pdto.getImg();
				String productName = pdto.getName();
			%>
	         <th><a href="../product/product.jsp?productN=<%=dto.getproductNum()%>">
	         	<img src="/wouldyoulike_final/img/product/<%=pdto.getImg() %>" height="32px" /><%=pdto.getName() %>
	         </a></th>
	         <th><%=dto.getorderamount() %></th>
	         <th><%=dto.getpricesum() %></th>
	         <th><%=dto.getreceive()%></th>
	         <th><%=dto.getpayment()%></th>
	         <th><%=dto.getordercomplete()%></th>
	         <th><%=dto.getorderDate()%></th>
	        </tr>
	<%}} %>      
	         
	          </thead>
	            <tbody></tbody>
	
	
	</table>
	</div>
	</section>
	<!-- Footer -->
	<jsp:include page="../footer.jsp"></jsp:include>

</body>
</html>
