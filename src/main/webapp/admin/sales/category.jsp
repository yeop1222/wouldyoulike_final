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
	<title>카테고리별 매출액 / 판매량 </title>
	
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
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js">
	</script>
</head>


<body>
	<!-- NavBar -->
	<jsp:include page="../adminmenu.jsp"/>
	<!-- Sidebar -->
	<jsp:include page="./sidebar.jsp"/>
	
		<%
			SalesDAO dao = new SalesDAO();
			String[] cate = {"Red","White","Rose","Sparkling","Champagne"};
			int totalSales = 0, totalCnt = 0;
			int red=0,white=0,rose=0,sparkling=0,champagne=0;
			int redCnt=0, whiteCnt=0, roseCnt=0, sparklingCnt=0, champagneCnt=0;
			String category="";
			
			for(String s: cate){
				category += "'"+s+"',";
				totalSales = dao.totalSales(s);
				totalCnt = dao.totalCnt(s);
				if(s.equals("Red")){
					red=totalSales;
					redCnt=totalCnt;
				}
				if(s.equals("White")){
					white=totalSales;
					whiteCnt=totalCnt;
				}
				if(s.equals("Rose")){
					rose=totalSales;
					roseCnt=totalCnt;
				}
				if(s.equals("Sparkling")){
					sparkling=totalSales;
					sparklingCnt=totalCnt;
				}
				if(s.equals("Champagne")){
					champagne=totalSales;
					champagneCnt=totalCnt;
				}
			}
			
		%>
	<section style="margin-left:35%;margin-top:5%;margin-bottom:10%">
		<canvas id="myChart1" style="width:100%;max-width:800px"></canvas>
		<script>
			var xValues = [<%=category%>];
			var yValues = [<%=red%>,<%=white%>,<%=rose%>,<%=sparkling%>,<%=champagne%>];
			var barColors = ["red", "green","pink","skyblue","purple"];
			
			new Chart("myChart1", {
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
			      text: "카테고리별 와인 매출액 (TOTAL)"
			    }
			  }
			});
		</script>
		
		<canvas id="myChart2" style="width:100%;max-width:800px"></canvas>
		<script>
			var xValues = [<%=category%>];
			var yValues = [<%=redCnt%>,<%=whiteCnt%>,<%=roseCnt%>,<%=sparklingCnt%>,<%=champagneCnt%>];
			var barColors = ["red", "green","pink","skyblue","purple"];
			
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
			      text: "카테고리별 와인 판매수량 (TOTAL)"
			    }
			  }
			});
		</script>
		
		<br>
		<h2>카테고리별 판매량 / 매출액 (전체기간) </h2>
		<table>
		  	<tr>
			    <th>카테고리</th>
			    <th>판매량 (개)</th>
			    <th>매출액 (원)</th>
		  	</tr>
		  	<tr>
			    <td><%=cate[0] %></td>
			    <td><%=redCnt%></td>
			    <td><%=red%></td>
			</tr>
			<tr>
			    <td><%=cate[1] %></td>
			    <td><%=whiteCnt%></td>
			    <td><%=white%></td>
			</tr>
			<tr>
			    <td><%=cate[2] %></td>
			    <td><%=roseCnt %></td>
			    <td><%=rose %></td>
			</tr>
			<tr>
			    <td><%=cate[3] %></td>
			    <td><%=sparklingCnt %></td>
			    <td><%=sparkling %></td>
			</tr>
			<tr>
			    <td><%=cate[4] %></td>
			    <td><%=champagneCnt %></td>
			    <td><%=champagne %></td>
			</tr>
		</table>
	</section>
</body>
</html>