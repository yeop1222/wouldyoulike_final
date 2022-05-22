<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="wouldyoulike.products.SalesDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
	<title>매출 / 판매량관리</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
	<style type="text/css">
		table {
		  border-collapse: collapse;
		  width: 100%;
		  margin-top: 10%;
		  
		}
		
		th, td {
		  padding: 8px;
		  text-align: left;
		  border-bottom: 1px solid #DDD;
		  font-size: 20px;
		}
		
		tr:hover {background-color: #D6EEEE;}
	</style>
</head>
<body>
	<!-- NavBar -->
	<jsp:include page="../adminmenu.jsp"/>
	
	<!-- Sidebar -->
	<jsp:include page="sidebar.jsp"/>
	
	<section style="margin-left:30%;margin-top:5%;margin-right:15%;margin-bottom:20%">
		<%
		Date now = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat ("yyyy년 MM월 dd일 a hh:mm");
		
		SalesDAO dao = new SalesDAO();
		int totalCnt = dao.totalCnt();
		int totalSales = dao.totalSales();
		
		ArrayList<Integer> lastweekSales = dao.past7days();
		ArrayList<Integer> lastmonthSales = dao.past30days();
		
		%>
		<h1>현재시각 : <%=sdf.format(now) %></h1>
		<h1>현재까지 총 판매수량 : <%=totalCnt %>개</h1>
		<h1>현재까지 총 매출액 : <%=totalSales %>원</h1>
		
		<canvas id="bar-chart" width="800" height="450" style="margin-top:5%;"></canvas>
		<script>
		new Chart(document.getElementById("bar-chart"), {
		    type: 'bar',
		    data: {
		      labels: ["지난 7일", "지난 30일","현재 총 매출액"],
		      datasets: [
		        {
		          label: "매출액 추이",
		          backgroundColor: ["#3e95cd", "#e8c3b9","#c45850"],
		          data: [<%=lastweekSales.get(0)%>,<%=lastmonthSales.get(0)%>,<%=totalSales%>]
		        }
		      ]
		    },
		    options: {
		      legend: { display: false },
		      title: {
		        display: true,
		        text: '지난 기간동안의 매출 증가'
		      }
		    }
		});
		</script>
		<table>
			<tr>
				<th></th>
				<th>지난 7일간</th>
				<th>지난 30일간 </th>
			</tr>
			<tr>
				<th>매출액 (원)</th>
				<td>+<%=lastweekSales.get(0) %></td>
				<td>+<%=lastmonthSales.get(0) %></td>	
			</tr>
			<tr>
				<th>판매수량 (개)</th>
				<td>+<%=lastweekSales.get(1) %></td>
				<td>+<%=lastmonthSales.get(1) %></td>
			</tr>
		</table>
	</section>
	
</body>
</html>