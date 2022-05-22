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
	<title>월간 판매량 / 매출액</title>
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
		HashMap<String, Integer> monthlyPriceSum = dao.salesByPeriod("monthly");
		HashMap<String, Integer> monthlySalesCnt = dao.salesCntByPeriod("monthly");
		
		String month = "";
		String monthlySum = "";
		String monthlyCnt = "";
		
		for (String key : monthlyPriceSum.keySet()){
			month += "'"+key+"',";
			monthlySum += monthlyPriceSum.get(key)+",";
			monthlyCnt += monthlySalesCnt.get(key)+",";
		}
		month = month.substring(0, month.length()-1);
		monthlySum = monthlySum.substring(0, monthlySum.length()-1);
		monthlyCnt = monthlyCnt.substring(0, monthlyCnt.length()-1);
		
	%>
	<section style="margin-left:20%;margin-top:5%;">
		<form action="monthlyPro.jsp" method="post" style="margin-left:5%;margin-bottom:5%">
			<h5>원하는 기간 검색 : </h5>
			<select name="startYear">
				<option value="2020">2020</option>
				<option value="2021">2021</option>
				<option value="2022">2022</option>
			</select>
			<select name="startMonth">
				<%for(int i=1;i<10;i++){ %>
					<option value="0<%=i%>">0<%=i %></option>
				<%} 
				  for(int i=10;i<13;i++){%>
				  <option value="<%=i%>"><%=i %></option>
				<%} %>
			</select>
			~
			<select name="endYear">
				<option value="2020">2020</option>
				<option value="2021">2021</option>
				<option value="2022">2022</option>
			</select>
			<select name="endMonth">
				<%for(int i=1;i<10;i++){ %>
					<option value="0<%=i%>">0<%=i %></option>
				<%} 
				  for(int i=10;i<13;i++){%>
				  <option value="<%=i%>"><%=i %></option>
				<%} %>
			</select>
			<input type="submit" value="조회"/>
		</form>
		<canvas id="myChart" style="width:100%;max-width:50%;float:left;"></canvas>
		<script>
		var xValues = ["0",<%=month%>];
		var yValues = [0,<%=monthlySum%>];
		
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
		var xValues = ["0",<%=month%>];
		var yValues = [0,<%=monthlyCnt%>];
		
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
		  <tr><th colspan="3"><h3>월간 판매량 / 매출액</h3></th></tr>
		  <tr>
		    <th>팔린 월 (Month)</th>
		    <th>판매수량 (개)</th>
		    <th>매출액 (원)</th>
		  </tr>
		  	<% 
		  	for (String key : monthlyPriceSum.keySet()){
			%>	<tr>
				    <td><%=key %></td>
				    <td><%=monthlySalesCnt.get(key)%></td>
				    <td><%=monthlyPriceSum.get(key)%></td>
			  	</tr>
		<%  }%>
		</table>
	</section>
</body>
</html>