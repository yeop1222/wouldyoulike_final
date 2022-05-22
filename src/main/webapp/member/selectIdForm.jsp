<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<h2>아이디 찾기</h2>    
    
<form action="selectIdPro.jsp" method="post">
	이름:<input type="text" name="name"> <br>
	휴대전화:<select name="phone1">
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
	<input type="submit" value="아이디 찾기">

</form>