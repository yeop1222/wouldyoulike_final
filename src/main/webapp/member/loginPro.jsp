<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="dto" class="wouldyoulike.member.MemberDTO" />
<jsp:setProperty name="dto" property="*"/>
<jsp:useBean id="dao" class="wouldyoulike.member.MemberDAO" />

<%	
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String auto = request.getParameter("auto"); 
	
	//메인에서 넘어왔을 경우
	Cookie [] cookies = request.getCookies();
	if(cookies != null){
		for(Cookie c :cookies){
			String cname = c.getName();
			if(cname.equals("cid")) dto.setId(c.getValue());
			if(cname.equals("cpw")) dto.setPw(c.getValue());
			if(cname.equals("cauto")) auto=c.getValue();
			
		}
	}
	
	
	//로그인 페이지에서 넘어왔을 경우 
	int result = dao.loginCheck(dto);
	if(result != 0 ){ //로그인 성공 시
		session.setAttribute("sid", dto.getId());
		if(auto!=null){ // 자동로그인 체크 했을 경우 - 쿠키 갱신
			Cookie cid = new Cookie("cid",dto.getId());
			Cookie cpw = new Cookie ("cpw",dto.getPw());
			Cookie cauto = new Cookie("cauto",auto);
			cid.setPath("/wouldyoulike_final/");
			cpw.setPath("/wouldyoulike_final/");
			cauto.setPath("/wouldyoulike_final/");
			cid.setMaxAge(60*60*24*3); 
			cpw.setMaxAge(60*60*24*3);
			cauto.setMaxAge(60*60*24*3);
			response.addCookie(cid);
			response.addCookie(cpw);
			response.addCookie(cauto);
		}
		
		response.sendRedirect("../main.jsp");
	}else{ //로그인 실패 시 
%>		<script >
			alert("아이디 및 비밀번호를 확인하세요");
			history.go(-1);
		</script>
<%	} %>
