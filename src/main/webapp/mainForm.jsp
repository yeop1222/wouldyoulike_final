<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="EUC-KR">
	<title>WouldYouLike�� ���� ���� ȯ���մϴ�</title>
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
			alert("��������� �Է����ּ���!");
			document.frm.birthYear.focus();
			return false;
		}else if(isNaN(document.frm.birthYear.value)){
			alert("��������� ���ڸ� �Է°����մϴ�!");
			document.frm.birthYear.value="";
			document.frm.birthYear.focus();
			return false;
		}else if(document.frm.birthYear.value < 1920 || document.frm.birthYear.value > 2022){
			alert("��������� Ȯ�����ּ���!");
			document.frm.birthYear.value="";
			document.frm.birthYear.focus();
			return false;
		}else if(document.frm.birthYear.value > 2003){
			alert("�� 19�� �̻� ���尡���մϴ�!");
			document.frm.birthYear.value="";
			document.frm.birthYear.focus();
			return false;
		}
		
		if(document.frm.birthMonth.value == ""){
			alert("��������� �Է����ּ���!");
			document.frm.birthMonth.focus();
			return false;
		}else if(isNaN(document.frm.birthMonth.value)){
			document.frm.birthMonth.value="";
			document.frm.birthMonth.focus();
			alert("��������� ���ڸ� �Է°����մϴ�!");
			return false;
		}else if(document.frm.birthMonth.value < 1 || document.frm.birthMonth.value > 12){
			alert("��������� Ȯ�����ּ���!");
			document.frm.birthMonth.value="";
			document.frm.birthMonth.focus();
			return false;
		}
		
		if(document.frm.birthDay.value == ""){
			alert("��������� �Է����ּ���!");
			document.frm.birthDay.focus();
			return false;
		}else if(isNaN(document.frm.birthDay.value)){
			alert("��������� ���ڸ� �Է°����մϴ�!");
			document.frm.birthDay.value="";
			document.frm.birthDay.focus();
			return false;
		}else if(document.frm.birthDay.value <1 || document.frm.birthDay.value > 31){
			alert("��������� Ȯ�����ּ���!");
			document.frm.birthDay.value="";
			document.frm.birthDay.focus();
			return false;
		}
		
			
	}
</script>

<body>
	<section>
		<h1>WouldYouLike�� ���� ���� ȯ���մϴ�!</h1>
		<h2>�� 19�� �̻� ���� ������ �����̽ʴϱ�?</h2>
		<h3>��������� �Է����ּ���!</h3>
		<form action="main.jsp" name="frm" onsubmit="return ageCheck();">
			<input type="tel" name="birthYear" style="width:50px;height:20px;font-size:15px;" />��
			<input type="tel" name="birthMonth" style="width:50px;height:20px;font-size:15px;" />��
			<input type="tel" name="birthDay" style="width:50px;height:20px;font-size:15px;"/>��
			<input type="submit" value="�Է�"/>
		</form>
		<h4>�̹� ȸ���̽Ű���? <a href="./member/loginForm.jsp">����</a>�� ���� �α����ϼ���!</h4>
	</section>
</body>
</html>