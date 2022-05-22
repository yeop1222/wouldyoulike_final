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
	<title>카테고리별 월간 판매량</title>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
	<style>
		table {
		  border-collapse: collapse;
		  font-family: arial, sans-serif;
		  text-align: center;
		  width: 100%;
		}
		
		td, th {
		  border: 1px solid #dddddd;
		  border-collapse: collapse;
		  padding: 8px;
		}
		
		tr:nth-child(even) {
		  background-color: #dddddd;
		}
	</style>
</head>
<body>
	<!-- NavBar -->
	<jsp:include page="../adminmenu.jsp"/>
	<!-- Sidebar -->
	<jsp:include page="./sidebar.jsp"/>
	<%	
		//2022년의 월이 담긴 list => xValues
		ArrayList<String> months = new ArrayList<String>();
		for(int i=1;i<10;i++){
			months.add("2022/0"+i);
		}
		for(int i=10;i<13;i++){
			months.add("2022/"+i);
		}
		
		//각 카테고리의 월간 판매수량 조회
		SalesDAO dao = new SalesDAO();
		HashMap<String,Integer> redCnt = dao.periodCnt_category("monthly", "Red");
		HashMap<String,Integer> whiteCnt = dao.periodCnt_category("monthly", "White");
		HashMap<String,Integer> roseCnt = dao.periodCnt_category("monthly", "Rose");
		HashMap<String,Integer> sparkCnt = dao.periodCnt_category("monthly", "Sparkling");
		HashMap<String,Integer> champCnt = dao.periodCnt_category("monthly", "Champagne");
		
		String period="";
		String redCount = "", whiteCount="", roseCount="", sparkCount="", champCount="";
		for(String month : months){
			period += "'"+month+"',";
			if(redCnt.containsKey(month)){
				redCount += redCnt.get(month)+",";
			}else{
				redCount += 0+",";
			}
			if(whiteCnt.containsKey(month)){
				whiteCount += whiteCnt.get(month)+",";
			}else{
				whiteCount += 0+",";
			}
			if(roseCnt.containsKey(month)){
				roseCount += roseCnt.get(month)+",";
			}else{
				roseCount += 0+",";
			}
			if(sparkCnt.containsKey(month)){
				sparkCount += sparkCnt.get(month)+",";
			}else{
				sparkCount += 0+",";
			}
			if(champCnt.containsKey(month)){
				champCount += champCnt.get(month)+",";
			}else{
				champCount += 0+",";
			}
		}
	
	%>
	<h3 style="margin-left:50%;margin-top:5%;">카테고리별 월간 판매수량</h3>
	<section style="margin-left:35%;">
		<canvas id="myChart1" style="width:100%;max-width:800px;" ></canvas>
		<script>
			var xValues = ["start",<%=period%>];
			
			new Chart("myChart1", {
			  type: "line",
			  data: {
			    labels: xValues,
			    
			    datasets: [{ 
			      //레드와인 월별 판매수량
			      data: [0,<%=redCount%>], 
			      borderColor: "red",
			      fill: false
			    },{ 
		    	  //화이트와인
			      data: [0,<%=whiteCount%>],
			      borderColor: "#FAF391",
			      fill: false
			    }, { 
			      //로제와인
			      data: [0,<%=roseCount%>],
			      borderColor: "#FB8CC1",
			      fill: false
			    },{   
			    	//스파클링와인
			    	data: [0,<%=sparkCount%>],
				    borderColor: "#8EE7E7",
				    fill: false
				},{   
					//샴페인
			    	data: [0,<%=champCount%>],
				    borderColor: "#85FBAB",
				    fill: false
				}]
			  },
			  options: {
			    legend: {display: false}
			  }
			});
		</script>
	</section>
	<%
		//각 카테고리의 월간 판매금액 조회
		HashMap<String,Integer> redSales = dao.periodSales_category("monthly", "Red");
		HashMap<String,Integer> whiteSales = dao.periodSales_category("monthly", "White");
		HashMap<String,Integer> roseSales = dao.periodSales_category("monthly", "Rose");
		HashMap<String,Integer> sparkSales = dao.periodSales_category("monthly", "Sparkling");
		HashMap<String,Integer> champSales = dao.periodSales_category("monthly", "Champagne");
		
		String redSale = "", whiteSale="", roseSale="", sparkSale="", champSale="";
		for(String month : months){
			if(redSales.containsKey(month)){
				redSale += redSales.get(month)+",";
			}else{
				redSale += 0+",";
			}
			if(whiteSales.containsKey(month)){
				whiteSale += whiteSales.get(month)+",";
			}else{
				whiteSale += 0+",";
			}
			if(roseSales.containsKey(month)){
				roseSale += roseSales.get(month)+",";
			}else{
				roseSale += 0+",";
			}
			if(sparkSales.containsKey(month)){
				sparkSale += sparkSales.get(month)+",";
			}else{
				sparkSale += 0+",";
			}
			if(champSales.containsKey(month)){
				champSale += champSales.get(month)+",";
			}else{
				champSale += 0+",";
			}
		}
	%>
	<h3 style="margin-left:50%;margin-top:5%;">카테고리별 월간 판매금액</h3>
	<section style="margin-left:35%;">
		<canvas id="myChart2" style="width:100%;max-width:800px;" ></canvas>
		<script>
			var xValues = ["start",<%=period%>];
			
			new Chart("myChart2", {
			  type: "line",
			  data: {
			    labels: xValues,
			    
			    datasets: [{ 
			      //레드와인 월별 매출액
			      data: [0,<%=redSale%>], 
			      borderColor: "red",
			      fill: false
			    },{ 
		    	  //화이트와인
			      data: [0,<%=whiteSale%>],
			      borderColor: "#FAF391",
			      fill: false
			    }, { 
			      //로제와인
			      data: [0,<%=roseSale%>],
			      borderColor: "#FB8CC1",
			      fill: false
			    },{   
			    	//스파클링와인
			    	data: [0,<%=sparkSale%>],
				    borderColor: "#8EE7E7",
				    fill: false
				},{   
					//샴페인
			    	data: [0,<%=champSale%>],
				    borderColor: "#85FBAB",
				    fill: false
				}]
			  },
			  options: {
			    legend: {display: false}
			  }
			});
		</script>
	</section>
	<section style="margin-top:5%;margin-left:25%;margin-right:10%;margin-bottom:10%">
		<table>
		  <tr><th colspan="3"><h3>카테고리별 월간 판매량 / 매출액</h3></th></tr>
		  <tr>
		    <th>기간</th>
		    <th colspan="2">레드와인</th>
		    <th colspan="2">화이트와인</th>
		    <th colspan="2">로제와인</th>
		    <th colspan="2">스파클링와인</th>
		    <th colspan="2">샴페인</th>
		  </tr>
		  <tr>
		    <th></th>
		    <th>판매수량</th>
		    <th>판매금액</th>
		    <th>판매수량</th>
		    <th>판매금액</th>
		    <th>판매수량</th>
		    <th>판매금액</th>
		    <th>판매수량</th>
		    <th>판매금액</th>
		    <th>판매수량</th>
		    <th>판매금액</th>
		  </tr>
		  	<% 
		  	int redC=0, whC=0, rosC=0, sparkC=0, champC=0;
		  	int redS=0, whS=0, roseS=0, sparkS=0, champS=0;
		  	for (String key : months){
		  		if(redCnt.containsKey(key)){ redC = redCnt.get(key);}else{redC=0;}
		  		if(redSales.containsKey(key)){redS=redSales.get(key);}else{redS=0;}
		  		
		  		if(whiteCnt.containsKey(key)){ whC = whiteCnt.get(key);}else{whC=0;}
		  		if(whiteSales.containsKey(key)){whS = whiteSales.get(key);}else{whS=0;}
		  		
		  		if(roseCnt.containsKey(key)){ rosC = roseCnt.get(key);}else{rosC=0;}
		  		if(roseSales.containsKey(key)){roseS=roseSales.get(key);}else{roseS=0;}
		  		
		  		if(sparkCnt.containsKey(key)){ sparkC = sparkCnt.get(key);}else{sparkC=0;}
		  		if(sparkSales.containsKey(key)){sparkS=sparkSales.get(key);}else{sparkS=0;}
		  		
		  		if(champCnt.containsKey(key)){ champC = champCnt.get(key);}else{champC=0;}
		  		if(champSales.containsKey(key)){champS=champSales.get(key);}else{champS=0;}
			%>	<tr>
				    <td><%=key%></td>
				    <td><%=redC%></td>
				    <td><%=redS %></td>
				    <td><%=whC%></td>
				    <td><%=whS %></td>
				    <td><%=rosC%></td>
				    <td><%=roseS %></td>
				    <td><%=sparkC%></td>
				    <td><%=sparkS %></td>
				    <td><%=champC%></td>
				    <td><%=champS %></td>
			  	</tr>
		<%  }%>
		</table>
	</section>
</body>
</html>