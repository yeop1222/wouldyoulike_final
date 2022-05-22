<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="wouldyoulike.jdbc.OracleConnection" %>
<%@ page import="wouldyoulike.order.cartDAO" %>
<%@ page import="wouldyoulike.order.cartDTO" %>

<% 

request.setCharacterEncoding("UTF-8");
int productN = Integer.parseInt(request.getParameter("productN"));
String id = (String)request.getParameter("id");
cartDAO dao = new cartDAO();
cartDTO dto = dao.deletecartInfo(productN,id);


//response.sendRedirect("cart.jsp");
%>
<script>
alert('삭제가 완료되었습니다!');
//history.go(-1);
window.location = "cart.jsp";
</script>
