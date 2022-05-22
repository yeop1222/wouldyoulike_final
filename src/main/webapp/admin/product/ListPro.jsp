<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="dao" class="wouldyoulike.products.ProductDAO"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품관리 pro</title>
	</head>
<body>
<%
	String[] checked = request.getParameterValues("product"); 
	
	String method = request.getParameter("method");
	String goPage = request.getParameter("page");
	int result = 0;
	
	String productN = "";
	if(checked!=null){
		for(int i=0;i<checked.length;i++){
			if(i==(checked.length-1)){ 
				productN += checked[i]; 
				break;
			}else{
				productN += checked[i]+",";
			}
		}
		
		//선택한 상품 삭제
		if(method.equals("del")){ 
			result = dao.delCheckedProducts(productN);	
		}
		
		//선택한 상품에 일괄 할인 적용
		if(method.equals("discount")){
			String sale = request.getParameter("salePercent");
			int discount=0;
			goPage = "promo";
			if(sale != null && sale != "") {
				discount = Integer.parseInt(sale);
			}
			result = dao.setDiscount(productN, discount); 
		}
		
		//선택한 상품 할인적용 해제
		if(method.equals("endSale")){
			goPage = "promo";
			result = dao.endSale(productN);	
		}
	}
	
	
	if(result>1){
		if(goPage.equals("promo")) response.sendRedirect("promoList.jsp");
		if(goPage.equals("soldout")) response.sendRedirect("soldoutList.jsp");
	}else{
%>		
		<script>
			alert("수정 실패!");
			history.go(-1);
		</script>
<%	} %>
</body>
</html>