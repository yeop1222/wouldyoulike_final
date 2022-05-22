<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="wouldyoulike.products.ProductDTO" %>
<%@ page import="wouldyoulike.products.ProductDAO" %>
<%@ page import="java.util.ArrayList" %>
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

<%
	int productN = Integer.parseInt(request.getParameter("productN"));
	
	ProductDAO dao = new ProductDAO();
	ProductDTO dto = dao.getData(productN); 
%>
<!-- Navbar -->
<jsp:include page="../adminmenu.jsp"/>

<h1>등록 수정</h1>

<form action="productUpdatePro.jsp" method="post" enctype="multipart/form-data">
	<input type="hidden" name="productN" value="<%=productN %>" />
	<table border="1">
		<tr>
			<td>
				제품 이미지
			</td>
			<td>
				<input type="file" name="img" value="<%=dto.getImg() %>">
			</td>
		</tr>
		<tr>
			<td>
				상품 이름  
			</td>
			<td>
				<input type="text" name="name" value="<%=dto.getName() %>" > 
			</td>
		</tr>
			
		<tr>
			<td>
				상품 브랜드 
			</td>
			<td>
				<input type="text" name="brand" value="<%=dto.getBrand() %>">
			</td>
		</tr>
		<tr>
			<td>
				생산 국가 
			</td>
			<td>
				<input type="text" name="country" value="<%=dto.getCountry() %>">
			</td>
		</tr>
		<tr>
			<td>
				분류 카테고리
			</td>
			<td>
				<input type="text" name="procategory" value="<%=dto.getProCategory() %>"> 
			</td>
		</tr>
		<tr>
			<td>
				사이즈(용량)
			</td>
			<td>
				<input type="text" name="wineSize" value="<%=dto.getWineSize() %>"> 
			</td>
		</tr>
		<tr>
			<td>
				가격 
			</td>
			<td>
				<input type="text" name="price"value="<%=dto.getPrice() %>"> 
			</td>
		</tr>
		<tr>
			<td>
				재고 
			</td>
			<td>
				<input type="text" name="stock" value="<%=dto.getStock() %>">
			</td>
		</tr>
		<tr>
			<td>
				입고날짜 
			</td>
			<td>
				<input type="date" name="reg" value="<%=dto.getReg() %>">
			</td>
		</tr>
		<tr>
			<td>
				알콜 도수
			</td>
			<td>
				<input type="text" name="abv" value="<%=dto.getAbv() %>"> 
			</td>
		</tr>
		<tr>
			<td>
				할인 여부 
			</td>
			<td>
				<input type="text" name="promotion" value="<%=dto.getPromotion() %>">
			</td>
		</tr>
		<tr>
			<td>
				할인 가격 
			</td>
			<td>
				<input type="text" name="promoPrice"value="<%=dto.getPromoPrice() %>">
			</td>
		</tr>
		<tr>
			<td>
				판매 지점 
			</td>
			<td>
				<input type="text" name="loc" value="<%=dto.getLoc() %>">
			</td>
		</tr>
	</table>
	
	<h2>상세정보</h2>
	<table border="1">
		<tr>
			<td>와인 종류</td>
			<td><input type="text" name="variental"></td>
		</tr>
		<tr>
			<td>단맛</td>
			<td>
				<input type="radio" name="sweetness" value="1"> 1
				<input type="radio" name="sweetness" value="2"> 2
				<input type="radio" name="sweetness" value="3"> 3
				<input type="radio" name="sweetness" value="4"> 4
				<input type="radio" name="sweetness" value="5"> 5
			</td>
		</tr>
		<tr>
			<td>바디감</td>
			<td>
				<input type="radio" name="body" value="1"> 1
				<input type="radio" name="body" value="2"> 2
				<input type="radio" name="body" value="3"> 3
				<input type="radio" name="body" value="4"> 4
				<input type="radio" name="body" value="5"> 5
			</td>
		</tr>
		<tr>
			<td>산미</td>
			<td>
				<input type="radio" name="acidity" value="1"> 1
				<input type="radio" name="acidity" value="2"> 2
				<input type="radio" name="acidity" value="3"> 3
				<input type="radio" name="acidity" value="4"> 4
				<input type="radio" name="acidity" value="5"> 5
			</td>
		</tr>
		<tr>
			<td>탄닌</td>
			<td>
				<input type="radio" name="tannins" value="1"> 1
				<input type="radio" name="tannins" value="2"> 2
				<input type="radio" name="tannins" value="3"> 3
				<input type="radio" name="tannins" value="4"> 4
				<input type="radio" name="tannins" value="5"> 5
			</td>
		</tr>
		<tr>
			<td>VQA 인증</td>
			<td>
				<input type="radio" name="vqa" value="1"> 인증
				<input type="radio" name="vqa" value="2"> 미인증
			</td>
		</tr>
	</table>
	<input type="submit" value="수정">
	<input type="button" value="취소" onclick="location='productList.jsp'">
</form>

<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>