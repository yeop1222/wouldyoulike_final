<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page import="wouldyoulike.order.cartDAO" %>
<%@ page import="wouldyoulike.order.cartDTO" %>

<%
	request.setCharacterEncoding("UTF-8");
	String productN = request.getParameter("productN");
	String memberID = (String)session.getAttribute("sid");
	int amount = 1;
	if(request.getParameter("amount") != null){
		amount = Integer.parseInt(request.getParameter("amount"));
	}
	int nproductN=0;
	if(productN != null){
		nproductN = Integer.parseInt(productN);
	}

	cartDAO dao = new cartDAO();
	int result = dao.cartUpdate(nproductN, memberID,amount); 
	
	
	response.sendRedirect("cart.jsp");
%>