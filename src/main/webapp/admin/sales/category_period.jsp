<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="wouldyoulike.products.SalesDAO" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>

<%
	String id = (String) session.getAttribute("sid");
	if(id==null){
%>		<script>
			alert("로그인을 해주세요.");
			window.location="../mainForm.jsp";
		</script>		
<%	}else if(!id.equals("admin")){
%>		<script>
			alert("관리자만 접근 가능한 페이지입니다!");
			window.location="../main.jsp";
		</script>
<%	} %>

<head>
	<title>카테고리별 일간 판매량</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">	
	
	<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js">
	</script>
</head>
	<!-- NavBar -->
	<jsp:include page="../adminmenu.jsp"/>
	<!-- Sidebar -->
	<jsp:include page="./sidebar.jsp"/>
<body>
	<%
		SalesDAO dao = new SalesDAO();
	
		ArrayList<String> dailyPeriod = dao.dayWithSales();
		
		HashMap<String,Integer> dailyCnt = dao.dailyCount();
		
		Map<String,Integer> redCnt = dao.periodCnt_category("daily", "Red");
		Map<String,Integer> whiteCnt = dao.periodCnt_category("daily", "White");
		Map<String,Integer> roseCnt = dao.periodCnt_category("daily", "Rose");
		Map<String,Integer> sparkCnt = dao.periodCnt_category("daily", "Sparkling");
		Map<String,Integer> chamCnt = dao.periodCnt_category("daily", "Champagne");
		
		String days ="";
		
		String dailyTotal ="";
		String red="", white="", rose="", sparkling="", champagne="";
		
		String dailySales ="";
		String redSales="", whiteSales="", roseSales="", sparklingSales="", champagneSales="";
		
		for(String date : dailyPeriod){
			days += "'"+date+"',";
			
			if(dailyCnt.containsKey(date)){ 
				dailyTotal += dailyCnt.get(date)+",";
			}else{ 
				dailyTotal += 0+","; 
			}
			
			if(redCnt.containsKey(date)) { 
				red += redCnt.get(date)+",";
			}else{
				red += 0+",";
			}
			
			if(whiteCnt.containsKey(date)) {
				white += whiteCnt.get(date)+",";
			}else{
				white += 0+",";
			}
			
			if(roseCnt.containsKey(date)) {
				rose += roseCnt.get(date)+",";
			}else{
				rose += 0+",";
			}
			
			if(sparkCnt.containsKey(date)) {
				sparkling += sparkCnt.get(date)+",";
			}else{
				sparkling += 0+",";
			}
			
			if(chamCnt.containsKey(date)) {
				champagne += chamCnt.get(date)+",";
			}else{
				champagne += 0+",";
			}
		}
	%>
	
	<h3 style="margin-left:50%;margin-top:5%;">카테고리별 일간 판매량</h3>
	<canvas id="myChart1" style="width:100%;max-width:800px;margin-left:35%;" ></canvas>
	<script>
		var xValues = ["start",<%=days%>];
		
		new Chart("myChart1", {
		  type: "line",
		  data: {
		    labels: xValues,
		    
		    datasets: [{ 
		    	//총판매량 (일간)
		      data: [0,<%=dailyTotal%>], //일별 판매 개수
		      borderColor: "#1806E9",
		      fill: false
		    },{ 
		    	//레드와인
		      data: [0,<%=red%>], 
		      borderColor: "red",
		      fill: false
		    }, { 
		    	//화이트와인
		      data: [0,<%=white%>],
		      borderColor: "#FAF391",
		      fill: false
		    }, { 
		    	//로제와인
		      data: [0,<%=rose%>],
		      borderColor: "#FB8CC1",
		      fill: false
		    },{   
		    	//스파클링와인
		    	data: [0,<%=sparkling%>],
			    borderColor: "#8EE7E7",
			    fill: false
			},{   
				//샴페인
		    	data: [0,<%=champagne%>],
			    borderColor: "#85FBAB",
			    fill: false
			}]
		  },
		  options: {
		    legend: {display: false}
		  }
		});
	</script>
	
	<canvas id="myChart2" style="width:100%;max-width:800px;margin-left:35%;" ></canvas>
	<script>
		var xValues = ["start",<%=days%>];
		
		new Chart("myChart2", {
		  type: "line",
		  data: {
		    labels: xValues,
		    
		    datasets: [{ 
		    	//총판매량 (일간)
		      data: [0,<%=dailyTotal%>], //일별 판매 개수
		      borderColor: "#1806E9",
		      fill: false
		    },{ 
		    	//레드와인
		      data: [0,<%=red%>], 
		      borderColor: "red",
		      fill: false
		    }, { 
		    	//화이트와인
		      data: [0,<%=white%>],
		      borderColor: "#FAF391",
		      fill: false
		    }, { 
		    	//로제와인
		      data: [0,<%=rose%>],
		      borderColor: "#FB8CC1",
		      fill: false
		    },{   
		    	//스파클링와인
		    	data: [0,<%=sparkling%>],
			    borderColor: "#8EE7E7",
			    fill: false
			},{   
				//샴페인
		    	data: [0,<%=champagne%>],
			    borderColor: "#85FBAB",
			    fill: false
			}]
		  },
		  options: {
		    legend: {display: false}
		  }
		});
	</script>
	
