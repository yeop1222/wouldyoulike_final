<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	
<% request.setCharacterEncoding("UTF-8"); %>  

<!-- Navbar -->
<jsp:include page="../menu.jsp"/>

<h1>회원 가입</h1>
<h2>회원정보 입력 </h2> <h4>(* 표시는 필수 항목 입니다. 반드시 기입하여 주십시오.)</h4>

<script>
	function idCheck(){		// id 중복확인
		id = document.frm.id.value;
		var idv = /^[a-zA-Z0-9]+$/;
		if(id == ""){
			alert("아이디를 입력하세요");
			return false;
		}else if(!idv.test(id)){
			alert("아이디는 영문 대소문자와 숫자로만 입력할 수 있습니다");
			return false;
		}
		window.open("idConfirm.jsp?id="+id,'idcheck','width=300,height=70');
	}
</script>

<script>
	function check(){
		pw = document.frm.pw.value;
		name = document.frm.name.value;
		birth1 = document.frm.birth1.value;
		birth2 = document.frm.birth2.value;
		birth3 = document.frm.birth3.value;
		phone3 = document.frm.phone3.value;
		phone4 = document.frm.phone4.value;
		id = document.frm.id.value;
		email = document.frm.email1.value;
		var idv = /^[a-zA-Z0-9]+$/; // id 영소문자&숫자만 가능
		var birth1v = /^[0-9]+$/;	// 생년월일 숫자만 가능
		var birth2v = /^[0-9]+$/;
		var birth3v = /^[0-9]+$/;
		var phone3v = /^[0-9]+$/;	// 휴대폰번호 숫자만 가능
		var phone4v = /^[0-9]+$/;
		var emailv = /^[a-zA-Z0-9]+$/;	// 이메일 영소문자&숫자만 가능

		if(id == ""){
			alert("아이디를 입력하세요");
			return false;
		}else if(!idv.test(id)){
			alert("아이디는 영문 대소문자와 숫자로만 입력할 수 있습니다");
			return false;
		}else if(pw == ""){
			alert("비밀번호를 입력하세요");
			return false;
		}else if(pw != document.frm.pw2.value){
			alert("비밀번호를 동일하게 입력하세요");
			return false;
		}else if(name == ""){
			alert("이름을 입력하세요");
			return false;
		}else if(birth1 == "" || birth2 == "" || birth3 == ""){
			alert("생년월일을 입력하세요");
			return false;
		}else if(document.frm.birth1.value > 2003){
			alert("미성년자는 가입하실 수 없습니다");
			return false;
		}else if(document.frm.birth2.value > 12 || document.frm.birth3.value > 31){
			alert("생년월일을 올바르게 기입하세요");
			return false;
		}else if(!birth1v.test(birth1) || !birth2v.test(birth2) || !birth3v.test(birth3)){
			alert("생년월일을 올바르게 기입하세요");
			return false;
		}else if(phone3 == "" || phone4 == ""){
			alert("휴대폰 번호를 입력하세요");
			return false;
		}else if(document.frm.phone3.value > 9999 || document.frm.phone4.value > 9999 || document.frm.phone4.value < 1000){
			alert("휴대폰 번호를 올바르게 기입하세요");
			return false;
		}else if(!phone3v.test(phone3) || !phone4v.test(phone4)){
			alert("휴대폰 번호를 올바르게 기입하세요");
			return false;
		}else if(email !="" && !emailv.test(email)){
			alert("이메일은 영문 대소문자와 숫자로만 입력할 수 있습니다");
			return false;
		}
	}
</script>

<form action="insertPro.jsp" name="frm" method="post" onSubmit="return check();" >
	아이디* :   <input type="text" name="id" maxlength="16" minlength="4"/>
			<input type="button" value="아이디중복확인" onclick="return idCheck();"/> (영문 소문자/숫자, 4~16자)<br/>
	비밀번호* :   <input type="password" name="pw" minlength="8" /> (영문 대소문자/숫자, 8자 이상)<br/>
	비밀번호 확인* :  <input type="password" name="pw2"/><br/>
	이름* : <input type="text" name="name" minlength="2"/><br/>
	생년월일* :  <input type="text" name="birth1" />/<input type="text" name="birth2"/>/<input type="text" name="birth3"/>(생년월일 입력 예) 1992/11/05<br/>
	주소 : <input type="text" name="address" /><br/>
	휴대전화* : <select name="phone1">
			<option>SKT</option>
			<option>KT</option>
			<option>U+</option>
			<option>알뜰폰</option>
			</select>
			<select name="phone2">
			<option>010</option>
			<option>011</option>
			<option>016</option>
			<option>017</option>
			<option>018</option>
			<option>019</option>
			</select>
	-<input type="text" name="phone3" />-<input type="text" name="phone4" /><br/>
	이메일 : <input type="text" name="email1" />
	@ <select name="email2">
			<option>naver.com</option>
			<option>gmail.com</option>
			<option>hanmail.net</option>
			<option>nate.com</option>
	</select>
	<input type="checkbox" name="notice" value="yes"/>이메일수신<br/>
		   <input type="submit" value="가입" />
</form>

<!-- Footer -->
<jsp:include page="../footer.jsp"></jsp:include>