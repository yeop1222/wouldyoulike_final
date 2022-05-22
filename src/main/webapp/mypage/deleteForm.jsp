<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- Navbar -->
<jsp:include page="../menu.jsp"/>
<aside>
<jsp:include page="../mypageForm.jsp"/>
</aside>

<% if(session.getAttribute("sid") == null) { %>
	<script>
		alert("로그인 후 사용 가능합니다.");
		window.location='../member/loginForm.jsp';
	</script>
	<% }
	
	String sid = (String)session.getAttribute("sid"); %>
	
	<script>
	function check(){
		if(document.frm.ch.checked == false){
			alert("탈퇴 안내를 확인하고 동의해주세요.");
			return false;
		}
	}
	</script>
<section style="margin-left:25%;">
<div class="col-md-8">
	
<h4>탈퇴 안내</h4>	
<h5>회원탈퇴를 하기 전에 안내 사항을 꼭 확인해주세요.</h5>
<br>
<h6>1.탈퇴 후 회원정보 및 개인형 서비스 이용기록은 모두 삭제됩니다.</h6>
<h6>2.회원정보 개인형 서비스 이용기록은 모두 삭제되며, 삭제된 데이터는 복구되지 않습니다.</h6> 
<h6>3.탈퇴 후에도 게시판형 서비스에 등록한 게시물은 그대로 남아 있습니다.</h6>
<h6>4.탈퇴 후에도 게시판형 서비스에 등록한 게시물은 그대로 남아 있습니다.</h6>

<h6>!탈퇴 후에는 아이디와 데이터는 복구할 수 없습니다!</h6>
<h6>!게시판형 서비스에 남아 있는 게시글은 탈퇴 후 삭제할 수 없습니다!</h6>
<br>
<form name="frm" action="deletePro.jsp" method="post" onSubmit="return check();" >
	<input type="checkbox" name="ch" value="1" /> 안내사항을 모두 확인하였으며, 이에 동의합니다. <br/>
	비밀번호 : <input type="password" name="pw" /> <br/>
		 <input type="submit" value="탈퇴" />

</form>
</div>
</section>

<!-- Footer -->
<jsp:include page="../footer.jsp"></jsp:include>