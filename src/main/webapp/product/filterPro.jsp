<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="wouldyoulike.products.ProductDTO" %>

<head>
	<meta charset="utf-8" />
   	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
   	<meta name="description" content="" />
   	<meta name="author" content="" />
	
	<!-- Favicon-->
	<link rel="icon" type="image/x-icon" href="../Bootstrap/shop_home/assets/favicon.ico" />
    <!-- Bootstrap icons-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="../Bootstrap/shop_home/css/styles.css" rel="stylesheet" />
    
    <style>
		section {
			display: -webkit-flex;
			display: flex;
			margin-left:5%;
		}
		aside {
			-webkit-flex: 1;
		  	-ms-flex: 1;
		  	flex: 0.5;
		  	padding: 20px;
		}
		.filter{
			margin-left:20%;
			margin-top:10px;
		}
	</style>
</head>

<jsp:useBean id="dto" class="wouldyoulike.products.ProductDTO"/>
<jsp:setProperty property="*" name="dto"/>
<jsp:useBean id="dao" class="wouldyoulike.products.ProductDAO"/>

<header>
	<jsp:include page="../menu.jsp"/>
</header>
<%
	ArrayList<ProductDTO> list = dao.filter(dto);
	String category = "";
	if(dto.getCategory() !=null){
		for(int i=0;i<dto.getCategory().length;i++) {
			if(i!=(dto.getCategory().length)-1) {
				category += "'"+dto.getCategory()[i]+"',";
			}else {
				category += "'"+dto.getCategory()[i]+"'";
			}
		}
	}
	String country = "";
	if(dto.getCountries()!=null){
		for(int i=0;i<dto.getCountries().length;i++) {
			if(i!=(dto.getCountries().length)-1) {
				country += "'"+dto.getCountries()[i]+"',";
			}else {
				country += "'"+dto.getCountries()[i]+"'";
			}
		}
	}
 %>
<div class="filter">
	<h5>선택한 필터</h5>
	<div style="font:italic;color:blue;">
	<%if(request.getParameter("category")!=null) {%> 
		종류 : <%=category %> <br>
	<%} %>
	<%if(request.getParameter("countries")!=null) {%> 
		원산지 : <%=country %><br>
	<%} 
		String minPrice = request.getParameter("minPrice");
		String maxPrice = request.getParameter("maxPrice");
		
		String minSize = request.getParameter("minSize");
		String maxSize = request.getParameter("maxSize");
	%>
	<%if(minPrice != "" || maxPrice != "") {%> 
		가격 : <%=minPrice %>원 ~ <%=maxPrice %>원
	<%} 
	  if(minSize != "" || maxSize != ""){
	%> 	크기 : <%=minSize %>ml ~ <%=maxSize %>ml
<%    } %>	
	<%if(request.getParameter("maxAbv")!="" && request.getParameter("maxAbv")!=null) {%>
		도수 : <%=request.getParameter("maxAbv") %>이하<br>
	<%} %>
	<%if(request.getParameter("rating")!=null) {%>
		평점 : <%=request.getParameter("rating") %>점 이상
	<%} %>
	</div>
</div>
<section class="py-5">
	<aside>
		<jsp:include page="filterForm.jsp"/>
	</aside>
	<div class="container px-4 px-lg-5 mt-5">
	검색결과 : 총 <%=list.size() %>개 
<%
	if(list.size()>0){
%>		<div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">	
<%		for(ProductDTO result : list){ %>
			<div class="col mb-5">
	              <div class="card h-100">
	                  <!-- Product image-->
	                  <img class="card-img-top" src="/wouldyoulike_final/img/product/<%=result.getImg() %>" alt="" />
	                  <!-- Product details-->
	                  <div class="card-body p-4">
	                      <div class="text-center">
	                          <!-- Product name-->
	                          <h5 class="fw-bolder"><a href="product.jsp?productN=<%=result.getProductN()%>"><%=result.getName()%></a></h5>
	                          <!-- Product reviews-->
	                          <div class="d-flex justify-content-center small text-warning mb-2">
		                          <%if(result.getRating()>0){
		                        	  for(int i=0;i<result.getRating();i++){ %>
		                        			<div class="bi-star-fill"></div>
		                        <%	  }
		                          	} %>	
	                                   </div>
	                          <%=result.getWineSize() %>ml / <%=result.getAbv() %> % <br/>
	                          <%=result.getPrice()%>원
	                      </div>
	                  </div>
	                  <!-- Product actions-->
	                  <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
	                      <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="#">장바구니 담기</a></div>
	                  </div>
	              </div>
			</div>				
<%		}%>
		</div>		
<%	}else{ %>
		<h2>등록된 상품이 없습니다.</h2>
<%	}%>
	</div>			
</section>

<!-- Bootstrap core JS-->
<script src="../Bootstrap/bootstrap-4.6.1-dist/js/bootstrap.bundle.min.js"></script>
<!-- Core theme JS-->
<script src="../Bootstrap/shop_home/js/scripts.js"></script>