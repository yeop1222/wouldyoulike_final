<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>   
<%@ page import="wouldyoulike.products.ProductDTO"%>
<jsp:useBean id="dao" class="wouldyoulike.products.ProductDAO"/>

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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
  	<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>
  	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
	
	<style>
		section {
			display: -webkit-flex;
			display: flex;
			margin-left:10%;
		}
		aside {
			-webkit-flex: 1;
		  	-ms-flex: 1;
		  	flex: 0.5;
		  	padding: 20px;
		}
		article{
			 float: left;
			 padding: 20px;
			 width: 70%;
		}
	</style>
</head>

<script>
	function addCart(){
		if(document.getElementById("memberId").value=="" || document.getElementById("memberId").value=="null" || document.getElementById("memberId").value == null){
			alert("로그인을 먼저 해주세요!");
			document.getElementById("add").href="../member/loginForm.jsp";
		}
	}
</script>

<!-- Navbar -->
<jsp:include page="../menu.jsp"/>

<%
	String memberId = (String)session.getAttribute("sid");	

	//페이징 처리 
	String pageN = request.getParameter("pageNum");
	if(pageN == null){
		pageN= "1";
	}
	int pageSize = 12;
	int currentPage = Integer.parseInt(pageN);
	int start = (currentPage-1) * pageSize + 1;
	int end = currentPage * pageSize;
	
	//상품정렬 처리
	String sort = request.getParameter("sort");
	String order = request.getParameter("order");
	if(sort==null || order==null){
		sort = "name";
		order = "asc";
	}
	String sortBy = dao.sortBy(sort, order);
	
	String category = request.getParameter("category");
	String newProducts = request.getParameter("new");
	
	int count=0;
	
	ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
	if(category!=null){
		if(newProducts != null){
			count = dao.newCount(category);
			list = dao.newProductsList(start, end, category, sort, order);
%>			<head>
				<title>New - <%=category%> Wine</title>
			</head>
<%		}else{
			count = dao.categoryCount(category);
			list = dao.productList(start, end, category, sort, order);
%>			<head>
				<title><%=category%> Wine</title>
			</head>
<%		}
	}
	if(category==null && newProducts != null){
		count = dao.newCount();
		list = dao.newProductsList(start, end, sort, order);
%>			<head>
				<title>신상품</title>
			</head>
<%	}
	
	String priceParam = request.getParameter("price");
	if(priceParam!=null){
		int price = Integer.parseInt(priceParam);
		if(price>=1 && price<=5){
			switch(price){
				case 1:
					price = 50000;
					break;
				case 2:
					price = 100000;
					break;
				case 3: 
					price = 200000;
					break;
				case 4: 
					price = 499999;
					break;
				case 5: 
					price = 500000;	
					break;
			}
			count = dao.productCount(price);
			list = dao.giftList(start, end, price, sort, order);
%>		<head>
			<title>선물용 - 가격대별 와인</title>
		</head>
<%		}
	}
	
	String promotion = request.getParameter("promo");
	if(promotion!=null && promotion.equals("Y")){
		count = dao.promoCount();
		list = dao.promoList(start, end, sort, order);
%>		<head>
			<title>할인상품 - 전체</title>
		</head>		
<%	}
	if(category == null && newProducts == null && priceParam == null && promotion == null){
		count = dao.productCount();
		list = dao.productList(start, end, sort, order);
	%>	<head>
			<title>전체상품</title>
		</head>
<%	} %>

<section class="py-5">
	<!-- SideBar -->
	<aside>
		<jsp:include page="filterForm.jsp"/>
	</aside>
	<article>
		검색결과 : [<%=count %>]
		 
		<select name="list" onchange="location.href=this.value" style="float:right">
			<option>==<%=sortBy %>==</option>
			<option value="searchList.jsp?sort=name&order=asc">기본순 </option>
			<option value="searchList.jsp?sort=reg&order=desc"> 신상품순 </option>
			<option value="searchList.jsp?sort=price&order=asc"> 가격 낮은순 </option>
			<option value="searchList.jsp?sort=price&order=desc"> 가격 높은순 </option>
			<option value="searchList.jsp?sort=rating&order=desc"> 평점 높은순 </option>
			<option value="searchList.jsp?sort=review&order=desc"> 리뷰 많은순 </option>
			<option value="searchList.jsp?sort=sales&order=desc"> 판매량순 </option>
		</select>
		<div class="container px-4 px-lg-5 mt-5">
	<%
		if(list.size()>0){
	%>		<div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">	
	<%		for(ProductDTO dto : list){ 
				%>
				<div class="col mb-5">
		              <div class="card h-100">
		              	<%if(dto.getStock()==0){ %>
		              		<span class="badge badge-danger">Sold Out</span>
		              	<%} 
		              	  if(dto.getStock()<10 && dto.getStock()!=0){%>
		              	  	<span class="badge badge-warning">Selling Fast!</span>
		              	<%}
		              	  if(dto.getSales()>dao.isBestSeller(5)){%>
		              	  	<span class="badge badge-success">Best Seller</span>
		              	<%}%>
		                  <!-- Product image-->
		                  <img class="card-img-top" src="/wouldyoulike_final/img/product/<%=dto.getImg() %>" alt="아직 상품사진이 등록되지 않았습니다." />
		                  <!-- Product details-->
		                  <div class="card-body p-4">
		                      <div class="text-center">
		                          <!-- Product name-->
		                          <h5 class="fw-bolder"><a href="product.jsp?productN=<%=dto.getProductN()%>"><%=dto.getName()%></a></h5>
		                          <!-- Product reviews-->
		                          <div class="d-flex justify-content-center small text-warning mb-2">
			                        <%
			                          if(dto.getRating()>0){
			                        	  for(int i=0;i<dto.getRating();i++){ %>
			                        			<div class="bi-star-fill"></div>
			                        <%	  }
			                          	} %>	
		                                   </div>
		                          <%=dto.getWineSize() %>ml / <%=dto.getAbv() %>% <br/>
		                          <%if(dto.getPromotion().equals("Y")){ 
	                          	  %>
                            		<span class="text-decoration-line-through"> 가격 : <%=dto.getPrice() %>원</span><br/>
		                            <span>세일가 : <%=dto.getPromoPrice() %>원</span>
		                    	 <%}else{ %>
		                            <span> 가격 : <%=dto.getPrice() %>원</span>
		                   		 <%} %>
		                      </div>
		                  </div>
		                  <!-- Product actions-->
		                  <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
		                  	  <input type="hidden" id="memberId" value="<%=memberId %>"/>
		                      <div class="text-center"><a class="btn btn-outline-dark mt-auto" id="add" href="../order/addCartPro.jsp?productN=<%=dto.getProductN()%>&memberId=<%=memberId%>" onclick="addCart();">장바구니 담기</a></div>
		                  </div>
		              </div>
				</div>				
	<%		}%>
			</div>		
	<%	}else{ %>
			<h2>등록된 상품이 없습니다.</h2>
	<%	}%>
		</div>	
		<nav aria-label="Page navigation example">
  			<ul class="pagination justify-content-center">
		<%	//페이징 처리 공식
		if(count>0){
			int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1); //화면 밑에 보이는 페이지 수 
			int startPage = (int)(currentPage / 10)*10+1;
			int pageBlock = 10;
			int endPage = startPage + pageBlock - 1;
			String param = request.getQueryString();
			String href = "";
			if(param!=null){
				href = dao.getHref(param);
			}
			String url = "searchList.jsp?"+href+"pageNum=";
			if(endPage > pageCount){
				endPage = pageCount;
			}
			if(startPage > 10){ //페이지수가 10이 넘어갈때만 [이전] 생김
	%> 			<li class="page-item disabled">
      				<a class="page-link" href="<%=url+(startPage - 10)%>" tabindex="-1">이전</a>
   	 			</li>
	<%		} 
			for(int i = startPage; i <= endPage; i++){ 
	%>			<li class="page-item">
					<a class="page-link" href="<%=url+i%>"><%=i %></a>
				</li>
	<%		}
			if(endPage < pageCount){ 
	%>			<li class="page-item">
      				<a class="page-link" href="<%=url+(startPage + 10)%>">다음</a>
    			</li>			
	<%		}
		}%>
			</ul>
		</nav>
	</article>
</section>
  
<!-- Bootstrap core JS-->
<script src="../Bootstrap/bootstrap-4.6.1-dist/js/bootstrap.bundle.min.js"></script>
<!-- Core theme JS-->
<script src="../Bootstrap/shop_home/js/scripts.js"></script>
