<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="dto" class="wouldyoulike.products.ProductDTO" />
<jsp:setProperty name="dto" property="*" />
<jsp:useBean id="dao" class="wouldyoulike.products.ProductDAO" />

<%
	int result = dao.productDelete(dto.getProductN()); 
		if(result != 0){
%>			<script>
				alert("상품이 삭제되었습니다.");
				window.location = "productList.jsp";
			</script>
<%		} else {%>
			<script>
				alert("잠시후 다시 실행해주세요.");
				history.go(-1);
			</script>
<% } %>