<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="EUC-KR">
	<title>WouldYouLike에 오신 것을 환영합니다</title>
	<style>
		section{
			text-align:center;
			margin-left:20%;
			margin-right:20%;
			margin-top:10%;
			margin-bottom:10%;
		}
	</style>
</head>
<script>
	function ageCheck(){
		if(document.frm.birthYear.value == "" || document.frm.birthYear.value==null){
			alert("생년월일을 입력해주세요!");
			document.frm.birthYear.focus();
			return false;
		}else if(isNaN(document.frm.birthYear.value)){
			alert("생년월일은 숫자만 입력가능합니다!");
			document.frm.birthYear.value="";
			document.frm.birthYear.focus();
			return false;
		}else if(document.frm.birthYear.value < 1920 || document.frm.birthYear.value > 2022){
			alert("생년월일을 확인해주세요!");
			document.frm.birthYear.value="";
			document.frm.birthYear.focus();
			return false;
		}else if(document.frm.birthYear.value > 2003){
			alert("만 19세 이상만 입장가능합니다!");
			document.frm.birthYear.value="";
			document.frm.birthYear.focus();
			return false;
		}
		
		if(document.frm.birthMonth.value == ""){
			alert("생년월일을 입력해주세요!");
			document.frm.birthMonth.focus();
			return false;
		}else if(isNaN(document.frm.birthMonth.value)){
			document.frm.birthMonth.value="";
			document.frm.birthMonth.focus();
			alert("생년월일은 숫자만 입력가능합니다!");
			return false;
		}else if(document.frm.birthMonth.value < 1 || document.frm.birthMonth.value > 12){
			alert("생년월일을 확인해주세요!");
			document.frm.birthMonth.value="";
			document.frm.birthMonth.focus();
			return false;
		}
		
		if(document.frm.birthDay.value == ""){
			alert("생년월일을 입력해주세요!");
			document.frm.birthDay.focus();
			return false;
		}else if(isNaN(document.frm.birthDay.value)){
			alert("생년월일은 숫자만 입력가능합니다!");
			document.frm.birthDay.value="";
			document.frm.birthDay.focus();
			return false;
		}else if(document.frm.birthDay.value <1 || document.frm.birthDay.value > 31){
			alert("생년월일을 확인해주세요!");
			document.frm.birthDay.value="";
			document.frm.birthDay.focus();
			return false;
		}
		
			
	}
</script>

<body>
	<section>
		<h1>WouldYouLike에 오신 것을 환영합니다!</h1>
		<h2>만 19세 이상 음주 가능한 연령이십니까?</h2>
		<h3>생년월일을 입력해주세요!</h3>
		<form action="main.jsp" name="frm" onsubmit="return ageCheck();">
			<input type="tel" name="birthYear" style="width:50px;height:20px;font-size:15px;" />년
			<input type="tel" name="birthMonth" style="width:50px;height:20px;font-size:15px;" />월
			<input type="tel" name="birthDay" style="width:50px;height:20px;font-size:15px;"/>일
			<input type="submit" value="입력"/>
		</form>
		<h4>이미 회원이신가요? <a href="./member/loginForm.jsp">여기</a>를 눌러 로그인하세요!</h4>
	</section>
</body>
</html>