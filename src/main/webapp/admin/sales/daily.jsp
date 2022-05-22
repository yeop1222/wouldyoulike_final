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
	<meta charset="UTF-8">
	<title>일간 판매량 / 매출액</title>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
	
	<style>
		table {
		  border-collapse: collapse;
		  width: 100%;
		  margin-left:10%;
		  margin-top: 15%;
		}
		
		th, td {
		  padding: 8px;
		  text-align: left;
		  border-bottom: 1px solid #DDD;
		}
		
		tr:hover {background-color: #D6EEEE;}
	</style>
</head>
<body>
	<!-- NavBar -->
	<jsp:include page="../adminmenu.jsp"/>
	<!-- Sidebar -->
	<jsp:include page="./sidebar.jsp"/>
	<%
		SalesDAO dao = new SalesDAO();
		HashMap<String, Integer> dailyPriceSum = dao.salesByPeriod("daily");
		HashMap<String, Integer> dailySalesCnt = dao.salesCntByPeriod("daily");
		
		String date = "";
		String dailySum = "";
		String dailyCnt = "";
		
		for (String key : dailyPriceSum.keySet()){
			date += "'"+key+"',";
			dailySum += dailyPriceSum.get(key)+",";
			dailyCnt += dailySalesCnt.get(key)+",";
		}
		date = date.substring(0, date.length()-1);
		dailySum = dailySum.substring(0, dailySum.length()-1);
		dailyCnt = dailyCnt.substring(0, dailyCnt.length()-1);
		
	%>
	<section style="margin-left:20%;margin-top:5%;">
		<form action="dailyPro.jsp" method="post" style="margin-left:5%;margin-bottom:5%">
			<h5>원하는 기간 검색 : </h5>
			<input type="date" name="startDate"/>~
			<input type="date" name="endDate"/>
			<input type="submit" value="조회"/>
		</form>
		<canvas id="myChart" style="width:100%;max-width:50%;float:left;"></canvas>
		<script>
		var xValues = ["0",<%=date%>];
		var yValues = [0,<%=dailySum%>];
		
		new Chart("myChart", {
		  type: "line",
		  data: {
		    labels: xValues,
		    datasets: [{
		      fill: false,
		      lineTension: 0,
		      backgroundColor: "rgba(0,0,255,1.0)",
		      borderColor: "rgba(0,0,255,0.1)",
		      data: yValues
		    }]
		  },
		  options: {
		    legend: {display: false},
		    
		  }
		});
		</script>
		
		<canvas id="myChart2" style="width:100%;max-width:50%;float:left;"></canvas>
		<script>
		var xValues = ["0",<%=date%>];
		var yValues = [0,<%=dailyCnt%>];
		
		new Chart("myChart2", {
		  type: "line",
		  data: {
		    labels: xValues,
		    datasets: [{
		      fill: false,
		      lineTension: 0,
		      backgroundColor: "rgba(0,0,255,1.0)",
		      borderColor: "rgba(0,0,255,0.1)",
		      data: yValues
		    }]
		  },
		  options: {
		    legend: {display: false},
		    
		  }
		});
		</script>
	</section>
	<section style="margin-left:20%;margin-top:10%;margin-right:10%">
		<table>
		  <tr><th colspan="3"><h3>일간 판매량 / 매출액</h3></th></tr>
		  <tr>
		    <th>팔린 날짜</th>
		    <th>판매수량 (개)</th>
		    <th>매출액 (원)</th>
		  </tr>
		  	<% 
		  	for (String key : dailyPriceSum.keySet()){
			%>	<tr>
				    <td><%=key %></td>
				    <td><%=dailySalesCnt.get(key)%></td>
				    <td><%=dailyPriceSum.get(key)%></td>
			  	</tr>
		<%  }%>
		</table>
	</section>
</body>
</html>