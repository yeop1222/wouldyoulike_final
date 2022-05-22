<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>
<%@page import="java.sql.*"%>
<%@ page import="wouldyoulike.order.orderDAO" %>
<%@ page import="wouldyoulike.order.orderDTO" %>

<%
	request.setCharacterEncoding("UTF-8");
	String[] proNum = request.getParameterValues("products");
	String[] count = request.getParameterValues("orderamount");
	String[] price = request.getParameterValues("pricesum");
	
	String memberID = request.getParameter("memberID");
	String receive = request.getParameter("receive");
	String payment = request.getParameter("payment");
	String mobilenum = request.getParameter("mobilenum");
	String ordername = request.getParameter("ordername");
	
	orderDAO dao = new orderDAO();
	int result = 0;	
	for(int i=0; i < proNum.length; i++){
		orderDTO dto = new orderDTO();
		int productN = Integer.parseInt(proNum[i]);
		int orderamount = Integer.parseInt(count[i]);
		int pricesum = Integer.parseInt(price[i]);
		
		dto.setproductNum(productN);
		dto.setorderamount(orderamount);
		dto.setpricesum(pricesum);
		
		dto.setmemberID(memberID);
		dto.setreceive(receive);
		dto.setpayment(payment);
		dto.setmobilenum(mobilenum);
		dto.setordername(ordername);
		
		result += dao.orderUpdate(dto);
		
		out.println(productN+"/"+orderamount+"/"+pricesum);
	}
	response.sendRedirect("../mypage/orderhistory.jsp");
%>
