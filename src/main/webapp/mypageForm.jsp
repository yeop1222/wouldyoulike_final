<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% request.setCharacterEncoding("UTF-8"); %>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>

<% if(session.getAttribute("sid") == null) { %>
	<script>
		alert("로그인 후 사용 가능합니다.");
		window.location='/wouldyoulike_final/member/loginForm.jsp';
	</script>
<% }%>
	
<div class="w3-sidebar w3-bar-block w3-light-grey w3-card" style="width:20%;height:30%;">
	<h3 class="w3-bar-item">마이 페이지</h3>
 	<button class="w3-button w3-block w3-left-align" onclick="myAccFunc()">
    	쇼핑정보<i class="fa fa-caret-down"></i>
   	</button>
   	<div id="demoAcc" class="w3-hide w3-white w3-card">
   	  <a href="/wouldyoulike_final/order/cart.jsp" class="w3-bar-item w3-button">장바구니</a> 	
      <a href="/wouldyoulike_final/mypage/orderhistory.jsp?option=0" class="w3-bar-item w3-button">주문내역 조회</a>
      <a href="/wouldyoulike_final/mypage/orderhistory.jsp?option=1" class="w3-bar-item w3-button">구매내역 조회</a>	
   	</div>
 	<button class="w3-button w3-block w3-left-align" onclick="myDropFunc()">
    	문의내역<i class="fa fa-caret-down"></i>
   	</button>	  
	<div id="demoDrop" class="w3-hide w3-white w3-card">
      <a href="/wouldyoulike_final/mypage/myQna.jsp" class="w3-bar-item w3-button">1:1 문의내역</a>
      <a href="/wouldyoulike_final/board/boardReview/list.jsp?option=1" class="w3-bar-item w3-button">내가 작성한 후기</a>	
   	</div>
 	<button class="w3-button w3-block w3-left-align" onclick="myInfo()">
     	회원정보<i class="fa fa-caret-down"></i>
   	</button> 
	<div id="info" class="w3-hide w3-white w3-card">
      <a href="/wouldyoulike_final/mypage/updateForm.jsp" class="w3-bar-item w3-button">회원정보 수정</a>
      <a href="/wouldyoulike_final/mypage/deleteForm.jsp" class="w3-bar-item w3-button">회원 탈퇴</a>	
   	</div>
</div>

<script>
	function myAccFunc() {
	  var x = document.getElementById("demoAcc");
	  if (x.className.indexOf("w3-show") == -1) {
	    x.className += " w3-show";
	    x.previousElementSibling.className += " w3-green";
	  } else { 
	    x.className = x.className.replace(" w3-show", "");
	    x.previousElementSibling.className = 
	    x.previousElementSibling.className.replace(" w3-green", "");
	  }
	}
	
	function myDropFunc() {
	  var x = document.getElementById("demoDrop");
	  if (x.className.indexOf("w3-show") == -1) {
	    x.className += " w3-show";
	    x.previousElementSibling.className += " w3-green";
	  } else { 
	    x.className = x.className.replace(" w3-show", "");
	    x.previousElementSibling.className = 
	    x.previousElementSibling.className.replace(" w3-green", "");
	  }
	}
	
	function myInfo() {
		  var x = document.getElementById("info");
		  if (x.className.indexOf("w3-show") == -1) {
		    x.className += " w3-show";
		    x.previousElementSibling.className += " w3-green";
		  } else { 
		    x.className = x.className.replace(" w3-show", "");
		    x.previousElementSibling.className = 
		    x.previousElementSibling.className.replace(" w3-green", "");
		  }
		}
</script>
