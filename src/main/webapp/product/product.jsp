<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="wouldyoulike.products.ProductDTO" %>
<%@ page import="wouldyoulike.products.WineFilterDTO" %>
<jsp:useBean id="dao" class="wouldyoulike.products.ProductDAO"/>
<jsp:useBean id="wineDAO" class="wouldyoulike.products.WineFilterDAO"/>

<%
 	int productN = Integer.parseInt(request.getParameter("productN"));
	dao.setRating(productN);
	ProductDTO dto = dao.product(productN);
	WineFilterDTO wineInfo = wineDAO.getWineInfo(productN);
	
	String memberId = (String)session.getAttribute("sid");
%>

<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
	<title>상품상세정보 - <%=dto.getName()%></title>
	<!-- Favicon-->
	<link rel="icon" type="image/x-icon" href="../Bootstrap/itemPage/assets/favicon.ico" />
	<!-- Bootstrap icons-->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
	<!-- Core theme CSS (includes Bootstrap)-->
	<link href="../Bootstrap/itemPage/css/styles.css" rel="stylesheet" />
	
	
</head>

<script>
	function addCart(){
		if(document.getElementById("memberId").value == "null" || document.getElementById("memberId").value == null){
			alert("로그인을 먼저 해주세요!");
			window.location='../member/loginForm.jsp';
		}else if(confirm("해당 상품을 장바구니에 추가하시겠습니까?")){
			document.frm.action='../order/addCartPro.jsp';
			document.frm.submit();
		}else{
			return false;
		}
	}
	
	function buy(){
		if(document.getElementById("memberId").value == "null" || document.getElementById("memberId").value == null){
			alert("로그인을 먼저 해주세요!");
			window.location='../member/loginForm.jsp';
		}else if(confirm("해당 상품을 바로 구매하시겠습니까?")){
			document.frm.action='../order/reservationPage.jsp';
			document.frm.submit();
		}else{
			return false;
		}
	}
	
	function addRelated(){
		if(document.frm.memberId.value == "null" ){
			alert("로그인을 먼저 해주세요!");
			document.getElementById("related").href='../member/loginForm.jsp';
		}
	}
	
	function addRecommended(){
		if(document.frm.memberId.value == "null" ){
			alert("로그인을 먼저 해주세요!");
			document.getElementById("recommended").href='../member/loginForm.jsp';
		}
	}
	
	function addBest(){
		if(document.frm.memberId.value == "null" ){
			alert("로그인을 먼저 해주세요!");
			document.getElementById("best").href='../member/loginForm.jsp';
		}
	}
</script>

<body>
<jsp:include page="../menu.jsp"/>

<!-- Product section-->
        <section class="py-5">
            <div class="container px-4 px-lg-5 my-5">
                <div class="row gx-4 gx-lg-5 align-items-center">
                    <div class="col-md-6"><img class="card-img-top mb-5 mb-md-0" src="/wouldyoulike_final/img/product/<%=dto.getImg() %>" alt="..." /></div>
                    <div class="col-md-6">
                        <div class="small mb-1">상품번호 : <%=dto.getProductN() %></div>
                        <h1 class="display-5 fw-bolder"><%=dto.getName()%></h1>
                        <div class="fs-5 mb-5">
	                        <%
	                          int price = dto.getPrice();
	                          if(dto.getPromotion().equals("Y")){ 
	                          		price = dto.getPromoPrice();%>
		                            <span class="text-decoration-line-through"> 가격 : <%=dto.getPrice() %>원</span><br/>
		                            <span>세일가 : <%=dto.getPromoPrice() %>원</span>
		                    <%}else{ %>
		                            <span> 가격 : <%=dto.getPrice() %>원</span>
		                    <%} 
		                      if(dto.getRating()>0){ %>
		                      	<div class="d-flex justify-content small text-warning mb-2">
	                        <% for(int i=0;i<dto.getRating();i++){ %>
	                    			<div class="bi-star-fill"></div>
	                    	  <%}%>
	                        	</div>
	                    	 <% }%>
		                </div>
                        <p><%=dto.getWineSize() %>ml / <%=dto.getAbv() %>%</p>
                        <p class="lead">
                        	간단한 와인 설명
                        </p>
                        <div>
                        	당도 <progress max="5" value="<%=wineInfo.getSweetness()%>"></progress><br/>
                        	바디 <progress max="5" value="<%=wineInfo.getWineBody()%>"></progress><br/>
                        	산미 <progress max="5" value="<%=wineInfo.getAcidity()%>"></progress><br/>
                        	탄닌 <progress max="5" value="<%=wineInfo.getTannins()%>"></progress><br/>
                        </div>
                        <form name="frm" method="post" >
	                        <div class="d-flex">
	                        	<input type="hidden" name="productN" value="<%=dto.getProductN()%>"/>
	                        	<input type="hidden" name="memberId" id="memberId" value="<%=memberId%>"/>
	                            수량 : <input class="form-control text-center me-3" id="inputQuantity" name="amount" type="number" min="1" max="9" value="1" style="max-width: 3rem" /> <br>
	                        </div> 
	                            <button class="btn btn-outline-dark flex-shrink-0" type="button" onclick="addCart();">
	                                <i class="bi-cart-fill me-1"></i>
	                                장바구니 담기
	                            </button>
	                            <button class="btn btn-outline-dark flex-shrink-0" type="button" onclick="buy();">
	                                바로 구매하기
	                        	</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>
        
        <%
        	String strOption = request.getParameter("option");
        	int option = 0;
        	if(strOption != null){
        		option = Integer.parseInt(strOption);
        	}
        	String strReviewPageNum = request.getParameter("reviewPageNum");
        	int reviewPageNum = 1;
        	if(strReviewPageNum != null){
        		reviewPageNum = Integer.parseInt(strReviewPageNum);
        	}
        	String strQnaPageNum = request.getParameter("qnaPageNum");
        	int qnaPageNum = 1;
        	if(strQnaPageNum != null){
        		qnaPageNum = Integer.parseInt(strQnaPageNum);
        	}
        %>
        <jsp:include page="../board/boardReview/list.jsp">
        	<jsp:param value="<%=productN %>" name="productn"/>
        	<jsp:param value="<%=option %>" name="option"/>
        	<jsp:param value="<%=reviewPageNum %>" name="reviewPageNum"/>
        </jsp:include>
        
        <jsp:include page="../board/boardProdQna/list.jsp">
        	<jsp:param value="<%=productN %>" name="productn"/>
        	<jsp:param value="<%=option %>" name="option"/>
        	<jsp:param value="<%=qnaPageNum %>" name="qnaPageNum"/>
        </jsp:include>
        
        <!-- Related items section-->
        <section class="py-5 bg-light">
            <div class="container px-4 px-lg-5 mt-5">
            	<% 
            	ArrayList<ProductDTO> list = dao.relatedProducts(productN);
            	ArrayList<ProductDTO> best = dao.bestSeller(); 
           		if(list.size()>3){ %>
                   	<h2 class="fw-bolder mb-4">Related products</h2>
		            <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
       			<%	for(ProductDTO products : list){
       					if(products.getProductN() != productN){
       			 %>		<div class="col mb-5">
                        	<div class="card h-100">
	                            <!-- Product image-->
	                            <img class="card-img-top" src="/wouldyoulike_final/img/product/<%=products.getImg() %>" alt="..." />
	                            <!-- Product details-->
	                            <div class="card-body p-4">
	                                <div class="text-center">
	                                    <!-- Product name-->
	                                    <h5 class="fw-bolder"><a href="product.jsp?productN=<%=products.getProductN()%>"><%=products.getName() %></a></h5>
	                                    <!-- Product reviews-->
	                                    <%if(products.getRating()!=0){%>
	                                    	<div class="d-flex justify-content-center small text-warning mb-2">
	                                	   	<%for(int i=1; i<products.getRating(); i++){ %>
	                                   			<div class="bi-star-fill"></div>
	                                   		<%}%>
	                                   		 </div>
	                                	<%}%>	
	                                    <!-- Product price-->
	                                    <%= products.getPrice()%>원
	                                </div>
	                            </div>
	                            <!-- Product actions-->
	                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                               		<div class="text-center"><a class="btn btn-outline-dark mt-auto" id="related" href="../order/addCartPro.jsp?productN=<%=products.getProductN() %>&amount=1" onclick="addRelated();">Add to cart</a></div>
                           		</div>
	                        </div>
                    	</div>
                    <%}//if
                    }//for%>
       				</div>
                  <%}else{ %> 
                  	<h2 class="fw-bolder mb-4">Recommended products</h2>
		            <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
       			<%	for(int i=0; i<list.size(); i++){
       					if(list.get(i).getProductN() != productN){
       			 %>		<div class="col mb-5">
                        	<div class="card h-100">
	                            <!-- Product image-->
	                            <img class="card-img-top" src="/wouldyoulike_final/img/product/<%=list.get(i).getImg() %>" alt="..." />
	                            <!-- Product details-->
	                            <div class="card-body p-4">
	                                <div class="text-center">
	                                    <!-- Product name-->
	                                    <h5 class="fw-bolder"><a href="product.jsp?productN=<%=list.get(i).getProductN()%>"><%=list.get(i).getName() %></a></h5>
	                                    <!-- Product reviews-->
	                                    <%if(list.get(i).getRating()!=0){%>
	                                    	<div class="d-flex justify-content-center small text-warning mb-2">
	                                	   	<%for(int j=1; j<list.get(i).getRating(); j++){ %>
	                                   			<div class="bi-star-fill"></div>
	                                   		<%}%>
	                                   		 </div>
	                                	<%}%>	
	                                    <!-- Product price-->
	                                    <%= list.get(i).getPrice()%>원
	                                </div>
	                            </div>
	                            <!-- Product actions-->
	                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                               		<div class="text-center"><a class="btn btn-outline-dark mt-auto" id="recommended" href="../order/addCartPro.jsp?productN=<%=list.get(i).getProductN() %>&amount=1" onclick="addRecommended();">Add to cart</a></div>
                           		</div>
	                        </div>
                    	</div>
                    <%}}
       				  for(int i=0; i<(4-list.size());i++){
       				  	if(best.get(i).getProductN() != productN){ %>
       				  	<div class="col mb-5">
                        	<div class="card h-100">
	                            <!-- Product image-->
	                            <img class="card-img-top" src="/wouldyoulike_final/img/product/<%=best.get(i).getImg() %>" alt="..." />
	                            <!-- Product details-->
	                            <div class="card-body p-4">
	                                <div class="text-center">
	                                    <!-- Product name-->
	                                    <h5 class="fw-bolder"><a href="product.jsp?productN=<%=best.get(i).getProductN()%>"><%=best.get(i).getName() %></a></h5>
	                                    <!-- Product reviews-->
	                                    <%if(best.get(i).getRating()!=0){%>
	                                    	<div class="d-flex justify-content-center small text-warning mb-2">
	                                	   	<%for(int j=1; j<best.get(i).getRating(); j++){ %>
	                                   			<div class="bi-star-fill"></div>
	                                   		<%}%>
	                                   		 </div>
	                                	<%}%>	
	                                    <!-- Product price-->
	                                    <%= best.get(i).getPrice()%>원
	                                </div>
	                            </div>
	                            <!-- Product actions-->
	                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                               		<div class="text-center"><a class="btn btn-outline-dark mt-auto" id="best" href="../order/addCartPro.jsp?productN=<%=best.get(i).getProductN() %>&amount=1" onclick="addBest();">Add to cart</a></div>
                           		</div>
	                        </div>
                    	</div>
                    <%}}%>
       				</div>
       			<%}//else %>
            </div>
        </section>
        
        
        
        
        <!-- Footer-->
        <jsp:include page="../footer.jsp"></jsp:include>
        
        <!-- Bootstrap core JS-->
        <script src="../Bootstrap/bootstrap-4.6.1-dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="../Bootstrap/itemPage/js/scripts.js"></script>
</body>