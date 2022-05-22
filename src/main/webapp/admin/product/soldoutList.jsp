<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="wouldyoulike.products.ProductDTO" %>
<%@ page import="wouldyoulike.products.ProductDAO" %>

<!DOCTYPE html>
<html>

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
		<meta charset="UTF-8">
		<title>매진상품 관리</title>
		<style>
			img{
				width: auto;
				height: 100px;
			}
			.selectSort{
				width: 15%;
				height: 30px;
				float:right;
			}
		</style>
		<script>
			function chBg(t){
				td = t.parentNode;
				td.style.backgroundColor = (t.checked) ? "#D8D8D8" : "";
				tr = td.parentNode;
				tr.style.backgroundColor = (t.checked) ? "#D8D8D8" : "";
			}
			
			function chkAll(){
				size = document.frm.product.length;
				checkall = document.getElementById("checkAll");
				if(checkall.checked==true){
					for(i=0;i<size;i++){
						document.frm.product[i].checked=true;
						document.frm.product[i].parentNode.style.backgroundColor= "#D8D8D8";
						document.frm.product[i].parentNode.parentNode.style.backgroundColor= "#D8D8D8";
					}
					
				}
				if(checkall.checked==false){
					for(i=0;i<size;i++){
						document.frm.product[i].checked=false;
						document.frm.product[i].parentNode.style.backgroundColor= "";
						document.frm.product[i].parentNode.parentNode.style.backgroundColor= "";
					}
				}
			}
			
			function delCheck(){
				if(document.frm.product.length<1){
					alert("상품을 먼저 선택해주세요!");
				}else if(confirm("선택한 상품을 삭제하시겠습니까?")==true){
					document.frm.action="ListPro.jsp?method=del&page=soldout";
					document.frm.submit();
				}else{
					return false;
				}
			}
			
			
		</script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	</head>
<body>
	<!-- Navbar -->
	<jsp:include page="../adminmenu.jsp"/>
	
	<h1>매진상품 목록</h1>
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
	int count = dao.soldoutCount();
	
	String sort = request.getParameter("sort");
	String order = request.getParameter("order");
	if(sort==null || order==null){
		sort = "sales";
		order = "asc";
	}
	String sortBy = dao.sortBy(sort, order);
%>
<select class="selectSort" name="list" onchange="location.href=this.value" >
	<option>===<%=sortBy %>===</option>
	<option value="soldoutList.jsp?sort=sales&order=desc"> 판매량 높은순 </option>
	<option value="soldoutList.jsp?sort=sales&order=asc"> 판매량 낮은순 </option>
	<option value="soldoutList.jsp?sort=stock&order=desc"> 재고 높은순 </option>
	<option value="soldoutList.jsp?sort=stock&order=asc"> 재고 낮은순 </option>
	<option value="soldoutList.jsp?sort=price&order=asc"> 가격 낮은순 </option>
	<option value="soldoutList.jsp?sort=price&order=desc"> 가격 높은순 </option>
	<option value="soldoutList.jsp?sort=rating&order=desc"> 평점 높은순 </option>
	<option value="soldoutList.jsp?sort=review&order=desc"> 리뷰 많은순 </option>
</select>
<form method="post" name="frm">
	<table border="1" style="width:100%;margin-top:5%">
		<tr><th>[총 개수 : <%=count %>]</th></tr>
		<tr>
			<th>번호</th>	<th>제품이름</th><th>브랜드</th><th>원산지</th><th>카테고리</th><th>사이즈(용량)</th><th>가격</th>
			<th>평점</th><th>재고</th><th>할인여부</th><th>판매 지점</th><th>이미지</th>
			<th>할인가격</th><th>입고날짜</th><th>수정</th><th>삭제</th><th>전체선택<br><input type="checkbox" onclick="chkAll();" name="checkAll" id="checkAll" value=""/></th>
		</tr>
		<%
		
		ArrayList<ProductDTO> list = dao.soldoutList(start, end, sort, order);
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
					<td><%=dto.getPromotion()%></td>
					<td><%=dto.getLoc()%></td>
					<td><img src="../../img/product/<%=dto.getImg()%>"/></td>
					<td><%=dto.getPromoPrice()%></td>
					<td><%=dto.getReg()%></td>
					<td><a href="productUpdateForm.jsp" >수정</a></td>
					<td><a href="productDeleteForm.jsp" >삭제</a></td>
					<td><input type="checkbox" name="product" onclick="chBg(this)" value="<%=dto.getProductN() %>"/></td>
				</tr>
		
			<% } 
			}else{ 
			%>
				<tr><td colspan="17" align="center">매진된 상품이 없습니다.</td></tr>
		 <% } %>
	</table>
	<br/>
	<input type="button" value="선택한 상품 삭제" style="float:right;" onclick="delCheck();" />
</form>
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
     			<a class="page-link" href="soldoutList.jsp?pageNum=<%=startPage%>" tabindex="-1">이전</a>
   	 		</li>
	<%}
		for(int i = startPage; i <= endPage; i++){%>
			<li class="page-item">
				<a class="page-link" href="soldoutList.jsp?pageNum=<%=i%>"><%=i %></a>
			</li>
	<%}
		if(endPage < pageCount){ %>
			<li class="page-item">
      			<a class="page-link" href="soldoutList.jsp?pageNum=<%=startPage +10%>">다음</a>
    		</li>
		<%}
	}

%>
	</ul>
</nav>
<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>

<!-- Bootstrap core JS-->
<script src="../Bootstrap/bootstrap-4.6.1-dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>