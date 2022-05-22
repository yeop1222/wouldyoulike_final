<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="wouldyoulike.products.*" %>
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
	<title>국가별 매출액 / 판매량</title>
	
	<style>
		table {
		  border-collapse: collapse;
		  width: 100%;
		}
		
		th, td {
		  padding: 8px;
		  text-align: left;
		  border-bottom: 1px solid #DDD;
		}
		
		tr:hover {background-color: #D6EEEE;}
	</style>
	
	<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js">
	</script>
</head>

<body>
	<!-- NavBar -->
	<jsp:include page="../adminmenu.jsp"/>
	<!-- Sidebar -->
	<jsp:include page="./sidebar.jsp"/>
	<%
		SalesDAO dao = new SalesDAO();
		//판매량
		Map<String, Integer> saleCnt = dao.countryCount();
		//매출액
		HashMap<String, Integer> saleAmount = dao.countrySales();
		
		String country = "";
		String salesCount = ""; //판매량
		String amount = "";	//매출액
		
		for(String key: saleCnt.keySet()){
			country += "'"+key+"'"+",";
			salesCount += saleCnt.get(key)+",";
			amount += saleAmount.get(key)+",";
		} 
		country = country.substring(0, country.length()-1);
		salesCount = salesCount.substring(0, salesCount.length()-1);
		amount = amount.substring(0, amount.length()-1);
	%>
	<section style="margin-left:35%;margin-top:5%;margin-bottom:10%">
		<!-- 원산지별 총 판매량 -->
		<canvas id="myChart" style="width:100%;max-width:800px"></canvas>
		<script>
			var xValues = [<%=country%>];
			var yValues = [<%=salesCount%>];
			var barColors = ["red", "green","blue","orange","brown","pink","skyblue","purple"];
			
			new Chart("myChart", {
			  type: "bar",
			  data: {
			    labels: xValues,
			    datasets: [{
			      backgroundColor: barColors,
			      data: yValues
			    }]
			  },
			  options: {
				    legend: {display: false},
				    title: {
				      display: true,
				      text: "원산지별 와인 판매량 (sales-count by country)"
				    }
			  }
			});
		</script>
		
		<!-- 원산지별 총 매출액 -->
		<canvas id="myChart2" style="width:100%;max-width:800px;margin-top:10%;"></canvas>
		<script>
			var xValues = [<%=country%>];
			var yValues = [<%=amount%>];
			var barColors = ["red", "green","blue","orange","brown","pink","skyblue","purple"];
			
			new Chart("myChart2", {
			  type: "bar",
			  data: {
			    labels: xValues,
			    datasets: [{
			      backgroundColor: barColors,
			      data: yValues
			    }]
			  },
			  options: {
			    legend: {display: false},
			    title: {
			      display: true,
			      text: "원산지별 와인 매출액 (sales-amount by country)"
			    }
			  }
			});
		</script>
		<br>
		<h2>원산지별 판매량 / 매출액</h2>
		
		<table>
		  <tr>
		    <th>원산지</th>
		    <th>판매량 (개)</th>
		    <th>매출액 (원)</th>
		  </tr>
		  	<% 
		  	for(String key: saleCnt.keySet()){
			%>	<tr>
				    <td><%=key %></td>
				    <td><%=saleCnt.get(key) %></td>
				    <td><%=saleAmount.get(key) %></td>
			  	</tr>
		<%  }%>
		</table>
	</section>
</body>
</html>