<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="wouldyoulike.products.ProductDAO" %>
<%@ page import="wouldyoulike.products.ProductDTO" %>
<%@ page import="java.util.ArrayList" %>
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
	<title> Homepage - WouldYouLike </title>
	<!-- Favicon-->
	<link rel="icon" type="image/x-icon" href="./Bootstrap/shop_home/assets/favicon.ico" />
	<!-- Bootstrap icons-->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
	<!-- Core theme CSS (includes Bootstrap)-->
	<link href="./Bootstrap/shop_home/css/styles.css" rel="stylesheet" />
</head>


<script>
	function redCart(){
		if(document.redfrm.memberId.value == "null" ){
			window.location ="./member/loginForm.jsp";
			alert("로그인을 먼저 해주세요!");
		}else if(confirm("해당 상품을 장바구니에 추가하시겠습니까?")){
			document.redfrm.action='./order/addCartPro.jsp';
			document.redfrm.submit();
		}else{
			return false;
		}
	}
	
	function whiteCart(){
		if(document.whitefrm.memberId.value == "null" ){
			window.location = "./member/loginForm.jsp";
			alert("로그인을 먼저 해주세요!");
		}else if(confirm("해당 상품을 장바구니에 추가하시겠습니까?")){
			document.whitefrm.action='./order/addCartPro.jsp';
			document.whitefrm.submit();
		}else{
			return false;
		}
	}
	
	function addCart(){
		if(document.frm.memberId.value == "null" ){
			alert("로그인을 먼저 해주세요!");
			document.getElementById("best").href='./member/loginForm.jsp';
		}
	}
</script>

<%
	String id = (String)session.getAttribute("sid");
	String birthYear = request.getParameter("birthYear");
	if(id==null && birthYear==null){
		response.sendRedirect("mainForm.jsp");
	}
%>


<!-- Navbar -->
<jsp:include page="menu.jsp"/>



<section>
	<!-- Header-->
	<header class="bg-dark py-5">
	    <div class="container px-4 px-lg-5 my-5">
	        <div class="text-center text-white">
	            <h1 class="display-4 fw-bolder">Would you(酒) Like?</h1>
	            <p class="lead fw-normal text-white-50 mb-0">Would酒Like의 베스트상품을 확인해보세요!</p>
	        </div>
	    </div>
	</header>
	<% 
		String memberId = (String) session.getAttribute("sid");
		ProductDAO dao = new ProductDAO();
		
		ProductDTO redBest = null, whiteBest = null, roseBest = null, champBest = null;
		if(dao.bestSeller("Red").size()>0){ redBest = dao.bestSeller("Red").get(0); }
		if(dao.bestSeller("White").size()>0){ whiteBest = dao.bestSeller("White").get(0); }
		if(dao.bestSeller("Rose").size()>0){ roseBest = dao.bestSeller("Rose").get(0); }
		if(dao.bestSeller("Champagne").size()>0){ champBest = dao.bestSeller("Champagne").get(0); }
	%>
	<!-- Section-->
		<section class="py-5">
		    <div class="container px-4 px-lg-5 mt-5">
		        <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
		        <%if(redBest!=null){ %>
		            <div class="col mb-5">
		            <h2>레드와인 Best</h2>
		                <div class="card h-100">
		                    <!-- badge-->
		                    <div class="badge bg-dark text-white position-absolute" style="top: 0.5rem; right: 0.5rem">Best!</div>
		                    <!-- Product image-->
		                    <img class="card-img-top" src="/wouldyoulike_final/img/product/<%=redBest.getImg() %>" alt="..." />
		                    <!-- Product details-->
		                    <div class="card-body p-4">
		                        <div class="text-center">
		                            <!-- Product name-->
		                            <h5 class="fw-bolder">
		                            	<a href="./product/product.jsp?productN=<%=redBest.getProductN()%>"><%=redBest.getName() %></a>
		                            </h5>
		                            <!-- Product reviews-->
		                            <% if(redBest.getRating()>0){%>
		                            <div class="d-flex justify-content-center small text-warning mb-2">
		                                <%for(int i=0; i<redBest.getRating();i++){  %>
		                                	<div class="bi-star-fill"></div>
		                                <%}//for %>
		                            </div>
		                            <%}//if %>
		                            <!-- Product price-->
		                            <% if(redBest.getPromotion().equals("Y")){ %>
		                            	<span class="text-muted text-decoration-line-through"><%=redBest.getPrice() %></span>
		                            	<%=redBest.getPromoPrice() %>원
		                            <%}else{ %>
		                            	<%=redBest.getPrice() %>원
		                            <%} %>
		                        </div>
		                    </div>
		                    <!-- Product actions-->
		                    <form name="redfrm" method="post">
		                    <input type="hidden" name="memberId" value="<%=memberId %>" />
							<input type="hidden" name="productN" value="<%=redBest.getProductN()%>"/>
		                    <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
		                        <div class="text-center">
		                        	<button class="btn btn-outline-dark mt-auto" onclick="redCart();">Add to cart</button>
		                        </div>
		                    </div>
		                    </form>
		                </div>
		            </div>
	            <%} %>
	            <%if(whiteBest!=null){ %>
		            <div class="col mb-5">
		            <h2>화이트와인 Best</h2>
		                <div class="card h-100">
		                    <!-- badge-->
		                    <div class="badge bg-dark text-white position-absolute" style="top: 0.5rem; right: 0.5rem">Best!</div>
		                    <!-- Product image-->
		                    <img class="card-img-top" src="/wouldyoulike_final/img/product/<%=whiteBest.getImg() %>" alt="..." />
		                    <!-- Product details-->
		                    <div class="card-body p-4">
		                        <div class="text-center">
		                            <!-- Product name-->
		                            <h5 class="fw-bolder">
		                            	<a href="./product/product.jsp?productN=<%=whiteBest.getProductN()%>"><%=whiteBest.getName() %></a>
		                            </h5>
		                            <!-- Product reviews-->
		                            <% if(whiteBest.getRating()>0){%>
		                            <div class="d-flex justify-content-center small text-warning mb-2">
		                                <%for(int i=0; i<whiteBest.getRating();i++){  %>
		                                	<div class="bi-star-fill"></div>
		                                <%}//for %>
		                            </div>
		                            <%}//if %>
		                            <!-- Product price-->
		                            <% if(whiteBest.getPromotion().equals("Y")){ %>
		                            	<span class="text-muted text-decoration-line-through"><%=whiteBest.getPrice() %></span>
		                            	<%=whiteBest.getPromoPrice() %>원
		                            <%}else{ %>
		                            	<%=whiteBest.getPrice() %>원
		                            <%} %>
		                        </div>
		                    </div>
		                    <!-- Product actions-->
		                    <form name="whitefrm" method="post">
		                    <input type="hidden" name="memberId" value="<%=memberId %>" />
							<input type="hidden" name="productN" value="<%=whiteBest.getProductN()%>"/>
		                    <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
		                        <div class="text-center">
		                        	<button class="btn btn-outline-dark mt-auto" onclick="whiteCart();">Add to cart</button>
		                        </div>
		                    </div>
		                    </form>
		                </div>
		            </div>
	            <%} %>
	            <%if(roseBest != null){ %>
		            <div class="col mb-5">
		            <h2>로제와인 Best</h2>
		                <div class="card h-100">
		                    <!-- badge-->
		                    <div class="badge bg-dark text-white position-absolute" style="top: 0.5rem; right: 0.5rem">Best!</div>
		                    <!-- Product image-->
		                    <img class="card-img-top" src="/wouldyoulike_final/img/product/<%=roseBest.getImg() %>" alt="..." />
		                    <!-- Product details-->
		                    <div class="card-body p-4">
		                        <div class="text-center">
		                            <!-- Product name-->
		                            <h5 class="fw-bolder">
		                            	<a href="./product/product.jsp?productN=<%=roseBest.getProductN()%>"><%=roseBest.getName() %></a>
		                            </h5>
		                            <!-- Product reviews-->
		                            <% if(roseBest.getRating()>0){%>
		                            <div class="d-flex justify-content-center small text-warning mb-2">
		                                <%for(int i=0; i<roseBest.getRating();i++){  %>
		                                	<div class="bi-star-fill"></div>
		                                <%}//for %>
		                            </div>
		                            <%}//if %>
		                            <!-- Product price-->
		                            <% if(roseBest.getPromotion().equals("Y")){ %>
		                            	<span class="text-muted text-decoration-line-through"><%=roseBest.getPrice() %></span>
		                            	<%=roseBest.getPromoPrice() %>원
		                            <%}else{ %>
		                            	<%=roseBest.getPrice() %>원
		                            <%} %>
		                        </div>
		                    </div>
		                    <!-- Product actions-->
		                    <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
		                        <div class="text-center">
		                        	<a class="btn btn-outline-dark mt-auto" href="./order/addCartPro.jsp?productN=<%=roseBest.getProductN() %>" onclick="addCart();">Add to cart</a>
		                        </div>
		                    </div>
		                </div>
		            </div>
	            <%} %>
	            <%if(champBest != null){ %>
		            <div class="col mb-5">
		            <h2>샴페인 Best</h2>
		                <div class="card h-100">
		                    <!-- badge-->
		                    <div class="badge bg-dark text-white position-absolute" style="top: 0.5rem; right: 0.5rem">Best!</div>
		                    <!-- Product image-->
		                    <img class="card-img-top" src="/wouldyoulike_final/img/product/<%=champBest.getImg() %>" alt="..." />
		                    <!-- Product details-->
		                    <div class="card-body p-4">
		                        <div class="text-center">
		                            <!-- Product name-->
		                            <h5 class="fw-bolder">
		                            	<a href="./product/product.jsp?productN=<%=champBest.getProductN()%>"><%=champBest.getName() %></a>
		                            </h5>
		                            <!-- Product reviews-->
		                            <% if(champBest.getRating()>0){%>
		                            <div class="d-flex justify-content-center small text-warning mb-2">
		                                <%for(int i=0; i<champBest.getRating();i++){  %>
		                                	<div class="bi-star-fill"></div>
		                                <%}//for %>
		                            </div>
		                            <%}//if %>
		                            <!-- Product price-->
		                            <% if(champBest.getPromotion().equals("Y")){ %>
		                            	<span class="text-muted text-decoration-line-through"><%=champBest.getPrice() %></span>
		                            	<%=champBest.getPromoPrice() %>원
		                            <%}else{ %>
		                            	<%=champBest.getPrice() %>원
		                            <%} %>
		                        </div>
		                    </div>
		                    <!-- Product actions-->
		                    <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
		                        <div class="text-center">
		                        	<a class="btn btn-outline-dark mt-auto" href="./order/addCartPro.jsp?productN=<%=champBest.getProductN() %>" onclick="addCart();">Add to cart</a>
		                        </div>
		                    </div>
		                </div>
		            </div>
	            <%} %>
	            </div>
	            </div>
	            
	            <form name="frm" method="post">
	            <div class="container px-4 px-lg-5 mt-5">
	            <h2 style="text-align:center;"> 전체 상품 Best 3</h2>
	            <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
		            <input type="hidden" name="memberId" id="memberId" value="<%=memberId %>"/>
		            <% 
		            ArrayList<ProductDTO> bestList = dao.bestSeller();
		            if(bestList.size()>0){
			            for(int i=0; i<3; i++){
			            	ProductDTO dto = bestList.get(i);
		            %>	<div class="col mb-5">
			                <div class="card h-100">
			                	<!-- badge-->
		                    	<div class="badge bg-dark text-white position-absolute" style="top: 0.5rem; right: 0.5rem">Best!</div>
			                    <!-- Product image-->
			                    <img class="card-img-top" src="/wouldyoulike_final/img/product/<%=dto.getImg() %>" alt="..." />
			                    <!-- Product details-->
			                    <div class="card-body p-4">
			                        <div class="text-center">
			                            <!-- Product name-->
			                            <h5 class="fw-bolder">
			                            	<a href="./product/product.jsp?productN=<%=dto.getProductN()%>"><%=dto.getName() %></a>
			                            </h5>
			                            <!-- Product reviews-->
		                            <% if(dto.getRating()>0){%>
				                            <div class="d-flex justify-content-center small text-warning mb-2">
				                                <%for(int j=0; j<dto.getRating(); j++){  %>
				                                	<div class="bi-star-fill"></div>
				                                <%}//for %>
				                            </div>
		                             <%}//if %>
			                            <!-- Product price-->
		                            <% if(dto.getPromotion().equals("Y")){ %>
		                            	<span class="text-muted text-decoration-line-through"><%=dto.getPrice() %></span>
		                            	<%=dto.getPromoPrice() %>원
		                            <%}else{ %>
		                            	<%=dto.getPrice() %>원
		                            <%} %>
			                        </div>
			                    </div>
			                    <!-- Product actions-->
								<input type="hidden" name="productN" value="<%=dto.getProductN()%>"/>
			                    <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
			                        <div class="text-center">
			                        	<a class="btn btn-outline-dark mt-auto" id="best" href="./order/addCartPro.jsp?productN=<%=dto.getProductN() %>" onclick="addCart();">Add to cart</a>
			                        </div>
		                    	</div>
			                </div>
		            	</div>
		          <%} 
		          }%>
		        </div>
		    	</div>
		    </form>	
		</section>
</section>
<!-- Footer -->
<jsp:include page="footer.jsp"></jsp:include>
<!-- Bootstrap core JS-->
<script src="../Bootstrap/bootstrap-4.6.1-dist/js/bootstrap.bundle.min.js"></script>
<!-- Core theme JS-->
<script src="../Bootstrap/shop_home/js/scripts.js"></script>


