<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<head>
	<title>로그인</title>
	<style>
		section{
			width:30%;
			margin:0 auto;
			margin-top:10%;
			margin-bottom:10%;
		}
	</style>
</head>	
<% request.setCharacterEncoding("UTF-8"); %>

<script>
	function Check(){
		id = document.frm.id.value;
		if(id == ""){
			alert("아이디를 입력하세요");
			return false;
		}
	}
	
	function chkAuto(){
		if(document.frm.auto.checked==true){
			document.getElementById("autoLogin").innerHTML = "<font color=red>보안을 위해 개인기기에서만 체크해주세요.</font>";
		}else{
			document.getElementById("autoLogin").innerHTML = "";
		}
	}
</script>

<body>
	<!-- Navbar -->
	<jsp:include page="../menu.jsp"/>
	
	<section>
		<h1 style="align:center;">WouldYouLike?</h1>
		<form name="frm" action="loginPro.jsp" method="post" onSubmit="return Check();" >
			아이디 : <input type="text" name="id" /> <br/>
			비밀번호 : <input type="password" name="pw" /> <br/>
			<input type="submit" value="로그인" /> <br/>
			<input type="checkbox" name="auto" value="1" onClick="chkAuto()"/>자동로그인
			<div id="autoLogin"></div> <br>
			<input type="button" value="아이디 찾기" onclick="window.open('selectIdForm.jsp','아이디 찾기','width=600, height=200')">
			<input type="button" value="비밀번호 찾기" onclick="window.open('selectPwForm.jsp','비밀번호 찾기','width=600, height=150')">
			<br/><br>
			아직 회원이 아니신가요? <br>
			<a href="insertForm.jsp">회원가입 하러가기</a>
		</form>
	</section>
	<!-- Footer -->
	<jsp:include page="../footer.jsp"></jsp:include>

</body>