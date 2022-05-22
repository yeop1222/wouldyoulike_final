<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="wouldyoulike.jdbc.OracleConnection" %>
<%@ page import="wouldyoulike.member.MemberDTO" %>
<%@ page import="wouldyoulike.member.MemberDAO" %>

<% request.setCharacterEncoding("UTF-8"); %>


<!-- Navbar -->
<jsp:include page="../menu.jsp"/>

<aside>
<jsp:include page="../mypageForm.jsp"/>
</aside>


<section style="margin-left:25%;">
<div class="col-md-7">
<h2>회원정보 수정</h2>

<% String id = (String)session.getAttribute("sid");
	
	if(session.getAttribute("sid") == null) { %>
	<script>
		alert("로그인 후 사용 가능합니다.");
		window.location="../member/loginForm.jsp";
	</script>
	<% }
	
	MemberDTO dto=new MemberDTO();
	
	Connection conn = OracleConnection.getConnection();

	String sql = "select * from member where id=?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, id);
	ResultSet rs = pstmt.executeQuery();
	
	String birth=null, phone=null, email=null;
	if(rs.next()) {
         dto.setPw(rs.getString("pw"));
         dto.setName(rs.getString("name"));
         dto.setAddress(rs.getString("address"));
         birth=rs.getString("birth");
         phone=rs.getString("phone");
         email=rs.getString("email");
	}

	String [] bresult =birth.split("-| |:");
	String birth1 = bresult[0];
	String birth2 = bresult[1];
	String birth3 = bresult[2];
	String birth4 = bresult[3];
	String birth5 = bresult[4];
	String birth6 = bresult[5];
	
	String [] presult =phone.split("-");
	String phone1 = presult[0];
	String phone2 = presult[1];
	String phone3 = presult[2];
	String phone4 = presult[3];
	
	String [] eresult =email.split("@");
	String email1 = eresult[0];
	String email2 = eresult[1];

	rs.close();
	pstmt.close();
	conn.close();

%>
<script>
	function check(){
		pw = document.frm.pw.value;
		name = document.frm.name.value;
		birth1 = document.frm.birth1.value;
		birth2 = document.frm.birth2.value;
		birth3 = document.frm.birth3.value;
		phone3 = document.frm.phone3.value;
		phone4 = document.frm.phone4.value;

		if(pw == ""){
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
			alert("미성년자는 가입하실 수 없습니다.");
			return false;
		}else if(document.frm.birth2.value > 12 || document.frm.birth3.value > 31){
			alert("생년월일을 올바르게 기입하십시오.");
			return false;
		}else if(phone3 == "" || phone4 == ""){
			alert("휴대폰 번호를 입력하세요");
			return false;
		}else if(document.frm.phone3.value > 9999 || document.frm.phone4.value > 9999 || document.frm.phone4.value < 1000){
			alert("휴대폰 번호를 올바르게 기입하십시오.");
			return false;
		}
	}
</script>

<form name="frm" action="updatePro.jsp" method="post" onSubmit="return check();">
	아이디 :  <%=id %><br/>
	비밀번호 :   <input type="password" name="pw" /><br/>
	비밀번호 확인 :  <input type="password" name="pw2"/><br/>
	이름 : <input type="text" name="name" value="<%=dto.getName()%>"/><br/>
	생년월일 :  <input type="text" name="birth1"  value="<%=birth1%>"/>/<input type="text" name="birth2" value="<%=birth2%>"/>/<input type="text" name="birth3" value="<%=birth3%>"/><br/>
	주소 : <input type="text" name="address" value="<%=dto.getAddress()%>"/><br/>
	휴대전화 : <select name="phone1" onChange="phone1(this.value);">
			<option <%=phone1.equals("SKT")?"selected":""%>>SKT</option>
			<option <%=phone1.equals("KT")?"selected":""%>>KT</option>
			<option <%=phone1.equals("U+")?"selected":""%>>U+</option>
			<option <%=phone1.equals("알뜰폰")?"selected":""%>>알뜰폰</option>
			</select>
			<select name="phone2" onChange="phone2(this.value);">
			<option <%=phone2.equals("010")?"selected":""%>>010</option>
			<option <%=phone2.equals("011")?"selected":""%>>011</option>
			<option <%=phone2.equals("016")?"selected":""%>>016</option>
			<option <%=phone2.equals("017")?"selected":""%>>017</option>
			<option <%=phone2.equals("018")?"selected":""%>>018</option>
			<option <%=phone2.equals("019")?"selected":""%>>019</option>
			</select>
	-<input type="text" name="phone3" value="<%=phone3%>" />-<input type="text" name="phone4"  value="<%=phone4 %>" /><br/>
	이메일 : <input type="text" name="email1" value="<%=email1%>"/>
	@ <select name="email2" onChange="email2(this.value);">
			<option <%=email2.equals("naver.com")?"selected":""%>>naver.com</option>
			<option <%=email2.equals("gmail.com")?"selected":""%>>gmail.com</option>
			<option <%=email2.equals("hanmail.net")?"selected":""%>>hanmail.net</option>
			<option <%=email2.equals("nate.com")?"selected":""%>>nate.com</option>
	</select><br/>
	<br>
		<input type="submit" value="수정" />
		<input type="button" value="회원탈퇴" onclick="window.location='deleteForm.jsp'" />
</form>
</div>
</section>

<!-- Footer -->
<jsp:include page="../footer.jsp"></jsp:include>