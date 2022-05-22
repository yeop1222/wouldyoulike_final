<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="wouldyoulike.products.ProductDTO" %>
<%@ page import="wouldyoulike.products.ProductDAO" %>
<%@ page import="java.sql.*" %> 

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

  
<head>
	<title>전체상품 관리</title>
	<style>
		img{
			width: auto;
			height: 100px;
		}
		select{
			width: 15%;
			height: 30px;
		}
	</style>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
</head>
 
<!-- NavBar -->
<jsp:include page="../adminmenu.jsp"/>

<h1>제품 리스트</h1>
    
<%
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum="1";
	}
	
	int pageSize = 10; // 한 페이지 글 개수
	int currentPage = Integer.parseInt(pageNum);
	int start = (currentPage - 1) * pageSize + 1;
	int end = currentPage * pageSize;
	
	ProductDAO dao = new ProductDAO();
	int count = dao.productCount();
	
	String sort = request.getParameter("sort");
	String order = request.getParameter("order");
	if(sort==null || order==null){
		sort = "sales";
		order = "asc";
	}
	String sortBy = dao.sortBy(sort, order);
%>
<h4> [전체 상품 개수 : <%=count %>]</h4> 

<select name="list" onchange="location.href=this.value" style="float:right">
	<option>===<%=sortBy %>===</option>
	<option value="productList.jsp?sort=sales&order=desc"> 판매량 높은순 </option>
	<option value="productList.jsp?sort=sales&order=asc"> 판매량 낮은순 </option>
	<option value="productList.jsp?sort=stock&order=desc"> 재고 높은순 </option>
	<option value="productList.jsp?sort=stock&order=asc"> 재고 낮은순 </option>
	<option value="productList.jsp?sort=price&order=asc"> 가격 낮은순 </option>
	<option value="productList.jsp?sort=price&order=desc"> 가격 높은순 </option>
	<option value="productList.jsp?sort=rating&order=desc"> 평점 높은순 </option>
	<option value="productList.jsp?sort=review&order=desc"> 리뷰 많은순 </option>
</select>

<table border="1" style="width:100%;">
	<tr>
		<th>번호</th>	<th>제품이름</th><th>브랜드</th><th>원산지</th><th>카테고리</th><th>사이즈(용량)</th><th>가격</th>
		<th>평점</th><th>재고</th><th>알콜도수</th><th>할인여부</th><th>판매 지점</th><th>이미지</th>
		<th>할인가격</th><th>입고날짜</th><th>수정</th><th>삭제</th>
	</tr>
	<%
	
	ArrayList<ProductDTO> list = dao.productList(start, end, sort, order);
	if(list.size() > 0){
		for(ProductDTO dto : list){
	%>
			<tr>
				<td><%=dto.getProductN() %></td>
				<td><a href="../../product/product.jsp?productN=<%=dto.getProductN()%>"><%=dto.getName()%></a></td>
				<td><%=dto.getBrand()%></td>
				<td><%=dto.getCountry() %></td>
				<td><%=dto.getProCategory() %></td>
				<td><%=dto.getWineSize() %></td>
				<td><%=dto.getPrice()%></td>
				<td><%=dto.getRating()%></td>
				<td><%=dto.getStock()%></td>
				<td><%=dto.getAbv()%></td>
				<td><%=dto.getPromotion()%></td>
				<td><%=dto.getLoc()%></td>
				<td><img src="../../img/product/<%=dto.getImg()%>"/></td>
				<td><%=dto.getPromoPrice()%></td>
				<td><%=dto.getReg()%></td>
				<td><a href="productUpdateForm.jsp?productN=<%=dto.getProductN() %>" >수정</a></td>
				<td><a href="productDelete.jsp?productN=<%=dto.getProductN() %>" >삭제</a></td>
				
			</tr>
	
		<% } 
		}else{ 
		%>
	<tr><td colspan="16" align="center">등록된 제품이 없습니다.</td></tr>
<% } %>
</table>
<br>
<nav aria-label="Page navigation example">
	<ul class="pagination justify-content-center">
<% // 페이징 처리 공식
	if(count > 0){
		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
		int startPage = (int)(currentPage / 10)*10+1;
		int pageBlock = 10;
		int endPage = startPage + pageBlock-1;
		if(endPage > pageCount){
			endPage = pageCount;
		}
		if(startPage > 10){ %>
			<li class="page-item disabled">
     			<a class="page-link" href="productList.jsp?pageNum=<%=startPage%>" tabindex="-1">이전</a>
   	 		</li>
	<%}
		for(int i = startPage; i <= endPage; i++){%>
			<li class="page-item">
				<a class="page-link" href="productList.jsp?pageNum=<%=i%>"><%=i %></a>
			</li>
	<%}
		if(endPage < pageCount){ %>
			<li class="page-item">
      			<a class="page-link" href="productList.jsp?pageNum=<%=startPage +10%>">다음</a>
    		</li>
		<%}
	}
%>
	</ul>
</nav>

<!-- Bootstrap core JS-->
<script src="../Bootstrap/bootstrap-4.6.1-dist/js/bootstrap.bundle.min.js"></script>
