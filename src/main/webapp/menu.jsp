<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="wouldyoulike.products.ProductDAO" %>
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

<script>
	function myCart(){
		if(document.getElementById("memberId").value == "null" || document.getElementById("memberId").value == null){
			alert("로그인을 먼저 해주세요!");
			window.location='/wouldyoulike_final/member/loginForm.jsp';
		}else if(confirm("장바구니로 이동하시겠습니까?")){
			window.location='/wouldyoulike_final/order/cart.jsp';
		}else{
			return false;
		}
	}
</script>
<%
   String sid = (String)session.getAttribute("sid");
   String cid=null, cpw=null, cauto=null;
   Cookie [] cookies = request.getCookies();
   if(sid == null){
      if(cookies != null){
         for(Cookie c :cookies){
	         String cname = c.getName();
	         if(cname.equals("cid")) cid=c.getValue();
	         if(cname.equals("cpw")) cpw=c.getValue();
	         if(cname.equals("cauto")) cauto=c.getValue();
         }
      }
      if(cauto != null && cid != null && cpw != null){
         response.sendRedirect("/wouldyoulike_final/member/loginPro.jsp");
      }
   }
%>
<!-- Navigation-->
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
	    <div class="container px-4 px-lg-5">
	        <a class="navbar-brand" href="/wouldyoulike_final/main.jsp">Would酒like</a>
	        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
	        <div class="collapse navbar-collapse" id="navbarSupportedContent">
	            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
	                <li class="nav-item"><a class="nav-link active" aria-current="page" href="/wouldyoulike_final/main.jsp">Home</a></li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">전체상품</a>
	                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp">전체상품</a></li>
	                        <li><hr class="dropdown-divider" /></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?category=Red">레드와인</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?category=White">화이트와인</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?category=Rose">로제와인</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?category=Sparkling">스파클링와인</a></li>
	                    </ul>
	                </li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">신상품</a>
	                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?new=1">전체상품</a></li>
	                        <li><hr class="dropdown-divider" /></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?category=Red&new=Y">레드와인</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?category=White&new=Y">화이트와인</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?category=Rose&new=Y">로제와인</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?category=Sparkling&new=Y">스파클링와인</a></li>
	                    </ul>
	                </li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">프로모션</a>
	                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp">선물</a></li>
	                        <li><hr class="dropdown-divider" /></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?price=1">5만원 이하</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?price=2">10만원 이하</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?price=3">20만원 이하</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?price=4">50만원 이하</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?price=5">50만원 이상</a></li>
	                        <li><hr class="dropdown-divider" /></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/product/searchList.jsp?promo=Y">할인상품</a></li>
	                    </ul>
	                </li>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">커뮤니티</a>
	                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/board/boardNotice/list.jsp">공지사항</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/board/boardCommonQna/list.jsp">문의게시판</a></li>
	                    </ul>
	                </li>
	                <%
	                String memberId = (String)session.getAttribute("sid");
	                if( memberId != null ){
	                %>
	                <li class="nav-item dropdown">
	                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">마이페이지</a>
	                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
	                    	<li><a class="dropdown-item" href="/wouldyoulike_final/mypage/updateForm.jsp">나의 정보</a></li>
	                    	<li><hr class="dropdown-divider" /></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/mypage/orderhistory.jsp?option=0">주문내역 조회</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/mypage/orderhistory.jsp?option=1">구매내역 조회</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/mypage/myQna.jsp">문의내역 조회</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/board/boardReview/list.jsp?option=1">리뷰내역 조회</a></li>
	                        <li><a class="dropdown-item" href="/wouldyoulike_final/order/cart.jsp">장바구니</a></li>
	                        
	                    </ul>
	                </li>
	             <% } %>
	            </ul>
	            <form class="d-flex">
	            	<% 
	            		ProductDAO dao = new ProductDAO();
	            		int cartCnt = dao.cartCount(memberId);
	            		
	            	if( memberId == null ){%>
	            	<button class="btn btn-outline-dark" type="button" onclick="window.location='/wouldyoulike_final/member/loginForm.jsp'">로그인</button>
	            	<button class="btn btn-outline-dark" type="button" onclick="window.location='/wouldyoulike_final/member/insertForm.jsp'">회원가입</button>
	            <%  }else{%>
	            	<%	if( memberId.equals("admin")) { %>
	            			<button class="btn btn-outline-dark" type="button" onclick="window.location='/wouldyoulike_final/admin/main.jsp'">관리</button>
	            	<%	} %>
	            	<button class="btn btn-outline-dark" type="button" onclick="window.location='/wouldyoulike_final/member/logout.jsp'">로그아웃</button>
	            <%  } %>
	            	<input type="hidden" id="memberId" value="<%=memberId %>"/>
	                <button class="btn btn-outline-dark" type="button" onclick="myCart();">
	                    <i class="bi-cart-fill me-1"></i>
	                    Cart
	                    <span class="badge bg-dark text-white ms-1 rounded-pill"><%=cartCnt %></span>
	                </button>
	            </form>
	        </div>
	    </div>
	</nav>
<!-- Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Core theme JS-->
<script src="/wouldyoulike_final/Bootstrap/shop_home/js/scripts.js"></script>