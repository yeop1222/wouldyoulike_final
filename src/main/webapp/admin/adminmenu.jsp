<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<head>
   <meta charset="utf-8" />
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
   <meta name="description" content="" />
   <meta name="author" content="" />
   <!-- Favicon-->
   <link rel="icon" type="image/x-icon" href="/wouldyoulike_final/Bootstrap/shop_home/assets/favicon.ico" />
   <!-- Bootstrap icons-->
   <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
   <!-- Core theme CSS (includes Bootstrap)-->
   <link href="/wouldyoulike_final/Bootstrap/shop_home/css/styles.css" rel="stylesheet" />
</head>

<!-- Navigation-->
	<nav class="navbar navbar-expand-lg navbar-light bg-warning">
	    <div class="container px-4 px-lg-5">
	        <a class="navbar-brand" href="/wouldyoulike_final/main.jsp">Would酒like</a>
	        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
	        <div class="collapse navbar-collapse" id="navbarSupportedContent">
	            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
	                <li class="nav-item"><a class="nav-link active" aria-current="page" href="/wouldyoulike_final/admin/main.jsp">Admin Home</a></li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">상품관리</a>
	                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/admin/product/addProductForm.jsp">상품등록</a></li>
	                        <li><hr class="dropdown-divider" /></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/admin/product/productList.jsp">전체상품</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/admin/product/promoList.jsp">할인상품</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/admin/product/soldoutList.jsp">매진상품</a></li>
	                    </ul>
	                </li>
	                <li class="nav-item"><a class="nav-link " aria-current="page" href="/wouldyoulike_final/admin/sales/main.jsp">매출관리</a></li>
	                <li class="nav-item"><a class="nav-link " aria-current="page" href="/wouldyoulike_final/admin/order/order.jsp">주문관리</a></li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">회원관리</a>
	                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/admin/member/memberList.jsp">전체회원</a></li>
	                        <li><hr class="dropdown-divider" /></li>
	                        <li><a class="dropdown-item" href="#">VIP</a></li>
	                        <li><a class="dropdown-item" href="#">BlackList</a></li>
	                    </ul>
	                </li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">게시판관리</a>
	                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/admin/board/list.jsp?option=1">문의게시판 관리</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/admin/board/list.jsp?option=0">상품문의 관리</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/admin/board/list.jsp?option=2">리뷰 관리</a></li>
	                    </ul>
	                </li>
	            </ul>
	        </div>
	    </div>
	</nav>
<!-- Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Core theme JS-->
<script src="/wouldyoulike_final/Bootstrap/shop_home/js/scripts.js"></script>