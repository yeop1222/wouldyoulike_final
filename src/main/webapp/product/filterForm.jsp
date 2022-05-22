<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<head>
	<meta charset="UTF-8">
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
	<title>필터링 결과</title>
	
	<style>
		#price{
			width: 80px;
			height: 30px;
		}
	</style>
</head>

<script>
	function checkValues(){
		if(isNaN(document.frm.minPrice.value)){
				alert("가격은 숫자만 입력가능합니다!");
				document.frm.minPrice.value="";
				document.frm.minPrice.focus();
				return false;
		}
		if(isNaN(document.frm.maxPrice.value)){
			alert("가격은 숫자만 입력가능합니다!");
			document.frm.maxPrice.value="";
			document.frm.maxPrice.focus();
			return false;
		}
		if(isNaN(document.frm.minSize.value)){
			alert("와인 크기는 숫자만 입력가능합니다!");
			document.frm.minSize.value="";
			document.frm.minSize.focus();
			return false;
		}
		if(isNaN(document.frm.maxSize.value)){
			alert("와인 크기는 숫자만 입력가능합니다!");
			document.frm.maxSize.value="";
			document.frm.maxSize.focus();
			return false;
		}
		if(isNaN(document.frm.maxAbv.value)){
			alert("와인 도수는 숫자만 입력가능합니다!");
			document.frm.maxAbv.value="";
			document.frm.maxAbv.focus();
			return false;
		}
	}

</script>
<body>
	<div id="filtering">
	    <form name="frm" action="filterPro.jsp" method="post" onsubmit="return checkValues();">
	    	<h3>카테고리</h3>
	    		<input type="checkbox" name="category" value="Red"> 레드 <br/>
	    		<input type="checkbox" name="category" value="White"> 화이트 <br/>
	    		<input type="checkbox" name="category" value="Rose"> 로제 <br/>
	    		<input type="checkbox" name="category" value="Sparkling"> 스파클링 <br/>
	    		<input type="checkbox" name="category" value="Champagne"> 샴페인 <br/>
	    	<h3>원산지</h3> 
	    		<input type="checkbox" name="countries" value="France"> 프랑스 <br/>
				<input type="checkbox" name="countries" value="Italy"> 이탈리아 <br/>
				<input type="checkbox" name="countries" value="Spain"> 스페인 <br/>
				<input type="checkbox" name="countries" value="USA"> 미국 <br/>
				<input type="checkbox" name="countries" value="Chile"> 칠레 <br/>
				<input type="checkbox" name="countries" value="Argentina"> 아르헨티나 <br/>
				<input type="checkbox" name="countries" value="Aus"> 호주 <br/>
				<input type="checkbox" name="countries" value="NZ"> 뉴질랜드 <br/>
				<input type="checkbox" name="countries" value="etc"> 기타 <br/>
	    	<h3>가격</h3>
	    		<input type="text" name="minPrice" id="price"/>원 ~
	    		<input type="text" name="maxPrice" id="price"/>원 <br/>
	    	<h3>크기</h3>
	    		<input type="text" name="minSize" id="size"/>ml ~
	    		<input type="text" name="maxSize" id="size"/>ml <br/>
	    	<h3>도수</h3>
	    		<input type="text" name="maxAbv" />% <br/>
	    	<h3>평점</h3>
	    		<input type="radio" name="rating" value="1"> &#9733;&#9734;&#9734;&#9734;&#9734; 이상<br/>
	    		<input type="radio" name="rating" value="2"> &#9733;&#9733;&#9734;&#9734;&#9734; 이상<br/>
	    		<input type="radio" name="rating" value="3"> &#9733;&#9733;&#9733;&#9734;&#9734; 이상<br/>
	    		<input type="radio" name="rating" value="4"> &#9733;&#9733;&#9733;&#9733;&#9734; 이상<br/>
	    		<input type="radio" name="rating" value="5"> &#9733;&#9733;&#9733;&#9733;&#9733; 이상<br/>
			<input type="submit" value="적용"/>    
	    </form>
    </div>
</body>
<!-- Bootstrap core JS-->
<script src="../Bootstrap/bootstrap-4.6.1-dist/js/bootstrap.bundle.min.js"></script>
<!-- Core theme JS-->
<script src="../Bootstrap/shop_home/js/scripts.js"></script>