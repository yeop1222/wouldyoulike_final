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
	<title>카테고리별 일간 판매량</title>
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
	SalesDAO dao = new SalesDAO();
	String month = request.getParameter("month");
	if(month==null){
		Date currentMonth = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("MM");
		month = sdf.format(currentMonth);
	}
	ArrayList<String> days = dao.daysInMonth(month); 
	
	HashMap<String,Integer> redCnt = dao.periodCnt_category("daily", "Red");
	HashMap<String,Integer> whiteCnt = dao.periodCnt_category("daily", "White");
	HashMap<String,Integer> roseCnt = dao.periodCnt_category("daily", "Rose");
	HashMap<String,Integer> sparkCnt = dao.periodCnt_category("daily", "Sparkling");
	HashMap<String,Integer> champCnt = dao.periodCnt_category("daily", "Champagne");
	
	String dayValues = "";
	String redCount = "", whiteCount="", roseCount="", sparkCount="", champCount="";
	for(String d : days){
		dayValues += "'22/"+month+"/"+d+"',";
		String day = "22/"+month+"/"+d;
		if(redCnt.containsKey(day)){
			redCount += redCnt.get(day)+",";
		}else{
			redCount += 0+",";
		}
		if(whiteCnt.containsKey(day)){
			whiteCount += whiteCnt.get(day)+",";
		}else{
			whiteCount += 0+",";
		}
		if(roseCnt.containsKey(day)){
			roseCount += roseCnt.get(day)+",";
		}else{
			roseCount += 0+",";
		}
		if(sparkCnt.containsKey(day)){
			sparkCount += sparkCnt.get(day)+",";
		}else{
			sparkCount += 0+",";
		}
		if(champCnt.containsKey(day)){
			champCount += champCnt.get(day)+",";
		}else{
			champCount += 0+",";
		}
	}
	dayValues = dayValues.substring(0,dayValues.length()-1);
	%>
	<div style="margin-left:50%;margin-top:5%;margin-right:15%;">
		<select onchange="location.href='category_daily.jsp?month='+this.value" style="float:right;">
			<option>=<%=month %>월=</option>
			<option value = "03">3월</option>
			<option value = "04">4월</option>
			<option value = "05">5월</option>
		</select>
	</div>
	<h3 style="margin-left:50%;margin-top:5%;">카테고리별 일간 판매수량</h3>
	<section style="margin-left:35%;">
		<canvas id="myChart1" style="width:100%;max-width:800px;" ></canvas>
		<script>
			var xValues = ["start",<%=dayValues%>];
			
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
		HashMap<String,Integer> redSale = dao.periodSales_category("daily", "Red");
		HashMap<String,Integer> whiteSale = dao.periodSales_category("daily", "White");
		HashMap<String,Integer> roseSale = dao.periodSales_category("daily", "Rose");
		HashMap<String,Integer> sparkSale = dao.periodSales_category("daily", "Sparkling");
		HashMap<String,Integer> champSale = dao.periodSales_category("daily", "Champagne");
		
		String redSales = "", whiteSales="", roseSales="", sparkSales="", champSales="";
		for(String d : days){
			String day = "22/"+month+"/"+d;
			if(redSale.containsKey(day)){
				redSales += redSale.get(day)+",";
			}else{
				redSales += 0+",";
			}
			if(whiteSale.containsKey(day)){
				whiteSales += whiteSale.get(day)+",";
			}else{
				whiteSales += 0+",";
			}
			if(roseSale.containsKey(day)){
				roseSales += roseSale.get(day)+",";
			}else{
				roseSales += 0+",";
			}
			if(sparkSale.containsKey(day)){
				sparkSales += sparkSale.get(day)+",";
			}else{
				sparkSales += 0+",";
			}
			if(champSale.containsKey(day)){
				champSales += champSale.get(day)+",";
			}else{
				champSales += 0+",";
			}
		}
	%>
	<h3 style="margin-left:50%;margin-top:5%;">카테고리별 일간 판매금액</h3>
	<section style="margin-left:35%;">
		<canvas id="myChart2" style="width:100%;max-width:800px;" ></canvas>
		<script>
			var xValues = ["start",<%=dayValues%>];
			
			new Chart("myChart2", {
			  type: "line",
			  data: {
			    labels: xValues,
			    
			    datasets: [{ 
			      //레드와인 월별 판매금액
			      data: [0,<%=redSales%>], 
			      borderColor: "red",
			      fill: false
			    },{ 
		    	  //화이트와인
			      data: [0,<%=whiteSales%>],
			      borderColor: "#FAF391",
			      fill: false
			    }, { 
			      //로제와인
			      data: [0,<%=roseSales%>],
			      borderColor: "#FB8CC1",
			      fill: false
			    },{   
			    	//스파클링와인
			    	data: [0,<%=sparkSales%>],
				    borderColor: "#8EE7E7",
				    fill: false
				},{   
					//샴페인
			    	data: [0,<%=champSales%>],
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
		  <tr><th colspan="3"><h3>카테고리별 일간 판매량 / 매출액</h3></th></tr>
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
		  	ArrayList<String> period = dao.dayWithSales();
		  	for (String key : period){
		  		if(redCnt.containsKey(key)){ redC = redCnt.get(key);}else{redC=0;}
		  		if(redSale.containsKey(key)){redS=redSale.get(key);}else{redS=0;}
		  		
		  		if(whiteCnt.containsKey(key)){ whC = whiteCnt.get(key);}else{whC=0;}
		  		if(whiteSale.containsKey(key)){whS = whiteSale.get(key);}else{whS=0;}
		  		
		  		if(roseCnt.containsKey(key)){ rosC = roseCnt.get(key);}else{rosC=0;}
		  		if(roseSale.containsKey(key)){roseS=roseSale.get(key);}else{roseS=0;}
		  		
		  		if(sparkCnt.containsKey(key)){ sparkC = sparkCnt.get(key);}else{sparkC=0;}
		  		if(sparkSale.containsKey(key)){sparkS=sparkSale.get(key);}else{sparkS=0;}
		  		
		  		if(champCnt.containsKey(key)){ champC = champCnt.get(key);}else{champC=0;}
		  		if(champSale.containsKey(key)){champS=champSale.get(key);}else{champS=0;}
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