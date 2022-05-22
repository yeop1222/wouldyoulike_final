<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="wouldyoulike.products.SalesDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
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
	<title>검색 - daily</title>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js">
	</script>
	
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
		String startDate = request.getParameter("startDate").substring(2);
		String endDate = request.getParameter("endDate").substring(2);
		
		SalesDAO dao = new SalesDAO();
		int totalCnt = dao.totalCntInPeriod("daily",startDate, endDate);
		int totalSales = dao.totalSalesInPeriod("daily",startDate, endDate);
		
		HashMap<String,Integer> dailyCnt = dao.salesCntInPeriod("daily", startDate, endDate);
		HashMap<String,Integer> dailySales = dao.salesInPeriod("daily", startDate, endDate);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd");
		
		Calendar start = Calendar.getInstance();
		Calendar end = Calendar.getInstance();
		start.setTime(sdf.parse(startDate));
		end.setTime(sdf.parse(endDate));
		
		ArrayList<String> period = new ArrayList<String>();
		period.add(startDate);
		while(!start.equals(end)){
			start.add(Calendar.DATE, 1);
			String date = sdf.format(start.getTime());
			period.add(date);
		}
		
		String days ="", cnt = "", sales ="";
		for(String d : period){
			days += "'"+d+"',";
			if(dailyCnt.containsKey(d)){
				cnt += dailyCnt.get(d)+",";
			}else{
				cnt += 0+",";
			}
			if(dailySales.containsKey(d)){
				sales += dailySales.get(d)+",";
			}else{
				sales += 0+",";
			}
		}
		
		days = days.substring(0, days.length()-1);
		cnt = cnt.substring(0, cnt.length()-1);
		sales = sales.substring(0, sales.length()-1);
	%>
	<section style="margin-left:30%;margin-top:5%;">
		<h3>조회기간 [<%=startDate %>~<%=endDate %>]</h3>
		<h3>선택한 기간의 총 판매수량 : <%=totalCnt %>개</h3>
		<h3>선택한 기간의 총 판매수익 : <%=totalSales %>원</h3>
		<canvas id="myChart" style="width:100%;max-width:900px;margin-top:5%"></canvas>
		<script>
			new Chart(document.getElementById("myChart"), {
			  type: 'line',
			  data: {
			    labels: [<%=days%>],
			    datasets: [{ 
			        data: [<%=cnt%>],
			        label: "판매수량",
			        borderColor: "#3e95cd",
			        fill: false
			      }
			    ]
			  },
			  options: {
			    title: {
			      display: true,
			      text: '선택한 기간의 판매량'
			    }
			  }
			});
	
		</script>
	</section>
	<section style="margin-left:20%;margin-top:10%;margin-right:10%;margin-bottom:10%">
		<table>
		  <tr><th colspan="3"><h3>일간 판매량 / 매출액</h3></th></tr>
		  <tr>
		    <th>팔린 날짜</th>
		    <th>판매수량 (개)</th>
		    <th>매출액 (원)</th>
		  </tr>
		  	<% 
		  	for(String d : period){
		  		int dailycnt = 0, dailysale = 0;
		  		if(dailyCnt.get(d)!=null){dailycnt = dailyCnt.get(d); }
		  		if(dailySales.get(d)!=null){dailysale = dailySales.get(d); }
			%>	<tr>
				    <td><%=d %></td>
				    <td><%=dailycnt%></td>
				    <td><%=dailysale%></td>
			  	</tr>
		<%  }%>
		</table>
	</section>
</body>
</html>