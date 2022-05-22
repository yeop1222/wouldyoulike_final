<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="wouldyoulike.products.ProductDTO" %>
<%@ page import="wouldyoulike.products.ProductDAO" %>

<%
	String id = (String) session.getAttribute("sid");
	if(id==null){
%>		<script>
			alert("로그인을 해주세요.");
			window.location="../mainForm.jsp";
		</script>		
<%	}else if(!id.equals("admin")){
%>		<script>
			alert("관리자만 접근 가능한 페이지입니다!");
			window.location="../main.jsp";
		</script>
<%	} %>

<head>
	<title>상품 등록하기</title>
	
	<style>
		.wineInfo {
			font-size:13px;
		}
	</style>
	<script>
		function checkValues(){
			//이미지 업로드 체크
			if(document.frm.img.value==null || document.frm.img.value==""){
				alert("사진 파일을 업로드해주세요!");
				return false;
			}
			
			if(document.frm.country.value=="" || document.frm.country.value==null){
				alert("상품의 원산지를 선택해주세요!");
				return false;
			}
			
			if(document.frm.procategory.value=="" || document.frm.procategory.value==null){
				alert("와인 종류를 선택해주세요!");
				return false;
			}
			
			//wineSize체크
			if(document.frm.wineSize.value==""){
				alert("와인 크기를 입력해주세요!");
				document.frm.wineSize.focus();
				return false;
			}else if(isNaN(document.frm.wineSize.value)){
				alert("와인 크기는 숫자만 입력가능합니다!");
				document.frm.wineSize.value="";
				document.frm.wineSize.focus();
				return false;
			}
			//Price 체크
			if(document.frm.price.value==""){
				alert("가격을 입력해주세요!");
				document.frm.price.focus();
				return false;
			}else if(isNaN(document.frm.price.value)){
				alert("가격은 숫자만 입력가능합니다!");
				document.frm.price.value="";
				document.frm.price.focus();
				return false;
			}
			
			//stock 체크
			if(document.frm.stock.value==""){
				alert("재고수량을 입력해주세요!");
				document.frm.stock.focus();
				return false;
			}else if(isNaN(document.frm.stock.value)){
				alert("수량은 숫자만 입력가능합니다!");
				document.frm.stock.value="";
				document.frm.stock.focus();
				return false;
			}
			
			//ABV(알콜농도) 체크
			if(document.frm.abv.value==""){
				alert("도수를 입력해주세요!");
				document.frm.abv.focus();
				return false;
			}else if(isNaN(document.frm.abv.value)){
				alert("알콜 도수는 숫자만 입력가능합니다!");
				document.frm.abv.value="";
				document.frm.abv.focus();
				return false;
			}
			//할인여부 체크
			if(document.frm.promotion.value==null || document.frm.promotion.value==""){
				document.getElementById("checkPromo").innerHTML="<font color='red'>할인여부를 선택해주세요.</font>";
				return false;
			}
			//할인가격 체크 
			if(document.frm.promotion.value=="Y"){
				if(document.frm.promoPrice.value=="0"){
					alert("할인가격을 정확히 입력해주세요!");
					document.frm.promoPrice.value="";
					document.frm.promoPrice.focus();
					return false;
				}else if(document.frm.promoPrice.value=="" || document.frm.promoPrice.value==null){
					alert("할인가격을 입력해주세요.");
					document.frm.promoPrice.focus();
					return false;
				}else if(isNaN(document.frm.promoPrice.value)){
					alert("가격은 숫자만 입력가능합니다!");
					document.frm.promoPrice.value="";
					document.frm.promoPrice.focus();
					return false;
				}
			}
			if(document.frm.promotion.value=="N"){
				if(document.frm.promoPrice.value != "" || document.frm.promoPrice.value != null){
					if(document.frm.promoPrice.value != "0"){
						alert("할인여부를 다시 확인해주세요!");
						return false;
					}
				}
			}
			
			//wineFilter- Variental 검사
			variental = document.frm.variental.value
			wineVariental = /[a-z|A-Z]/;
			if(!wineVariental.test(variental)) {
				alert("와인 종류는 알파벳으로 입력해주세요!");
				document.frm.variental.value="";
				document.frm.variental.focus();
				return false;
			}
		}
	</script>
</head>

<!-- NavBar -->
<jsp:include page="../adminmenu.jsp"/>

<div style="height:auto;margin-left:25%; margin-top:50px">
	<h1>상품 등록</h1>
	<form name="frm" action="addProduct.jsp" method="post" enctype="multipart/form-data" onsubmit="return checkValues();">
		<h2>필수 정보</h2>
		<table border="1">
			<tr>
				<td>
					제품 이미지
				</td>
				<td>
					<input type="file" name="img" >
				</td>
			</tr>
			<tr>
				<td>
					상품 이름  
				</td>
				<td>
					<input type="text" name="name"> 
				</td>
			</tr>
				
			<tr>
				<td>
					상품 브랜드 
				</td>
				<td>
					<input type="text" name="brand">
				</td>
			</tr>
			<tr>
				<td>
					생산 국가 
				</td>
				<td>
					<select name="country">
						<option value="">==원산지==</option>
						<option value="France">프랑스</option>
						<option value="Italy">이탈리아</option>
						<option value="Spain">스페인</option>
						<option value="USA">미국</option>
						<option value="Chile">칠레</option>
						<option value="Argentina">아르헨티나</option>
						<option value="Aus">호주</option>
						<option value="NZ">뉴질랜드</option>
						<option value="etc">기타</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>
					분류 카테고리
				</td>
				<td>
					<select name="procategory">
						<option value="">==종류==</option>
						<option value="Red">레드</option>
						<option value="White">화이트</option>
						<option value="Rose">로제</option>
						<option value="Sparkling">스파클링</option>
						<option value="Champagne">샴페인</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>
					사이즈(용량)
				</td>
				<td>
					<input type="text" name="wineSize"> 
				</td>
			</tr>
			<tr>
				<td>
					가격 
				</td>
				<td>
					<input type="text" name="price"> 
				</td>
			</tr>
			<tr>
				<td>
					재고 
				</td>
				<td>
					<input type="text" name="stock">
				</td>
			</tr>
			<tr>
				<td>
					입고날짜 
				</td>
				<td>
					<input type="date" name="reg">
				</td>
			</tr>
			<tr>
				<td>
					알콜 도수
				</td>
				<td>
					<input type="text" name="abv"> 
				</td>
			</tr>
			<tr>
				<td>
					할인 여부 
				</td>
				<td>
					<input type="radio" name="promotion" value="Y"> 예
					<input type="radio" name="promotion" value="N"> 아니오
					<div id="checkPromo"></div>
				</td>
			</tr>
			<tr>
				<td>
					할인 가격 
				</td>
				<td>
					<input type="text" name="promoPrice" value="0">
				</td>
			</tr>
		</table>
		
		<h2>상세정보 (등록권장)</h2>
		<table border="1">
			<tr>
				<td>와인 종류</td>
				<td>
					<input type="text" name="variental">
					<div class="wineInfo">알파벳만 입력가능합니다. <br>예시) Pinot Noir, Syrah</div>
				</td>
			</tr>
			<tr>
				<td>단맛</td>
				<td>
					<input type="radio" name="sweetness" value="1"> 1
					<input type="radio" name="sweetness" value="2"> 2
					<input type="radio" name="sweetness" value="3"> 3
					<input type="radio" name="sweetness" value="4"> 4
					<input type="radio" name="sweetness" value="5"> 5
				</td>
			</tr>
			<tr>
				<td>바디감</td>
				<td>
					<input type="radio" name="body" value="1"> 1
					<input type="radio" name="body" value="2"> 2
					<input type="radio" name="body" value="3"> 3
					<input type="radio" name="body" value="4"> 4
					<input type="radio" name="body" value="5"> 5
				</td>
			</tr>
			<tr>
				<td>산미</td>
				<td>
					<input type="radio" name="acidity" value="1"> 1
					<input type="radio" name="acidity" value="2"> 2
					<input type="radio" name="acidity" value="3"> 3
					<input type="radio" name="acidity" value="4"> 4
					<input type="radio" name="acidity" value="5"> 5
				</td>
			</tr>
			<tr>
				<td>탄닌</td>
				<td>
					<input type="radio" name="tannins" value="1"> 1
					<input type="radio" name="tannins" value="2"> 2
					<input type="radio" name="tannins" value="3"> 3
					<input type="radio" name="tannins" value="4"> 4
					<input type="radio" name="tannins" value="5"> 5
				</td>
			</tr>
			<tr>
				<td>VQA 인증</td>
				<td>
					<input type="radio" name="vqa" value="1"> 인증
					<input type="radio" name="vqa" value="2"> 미인증
				</td>
			</tr>
		</table>
		<input type="submit" value="등록" >
	</form>
</div>

<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>