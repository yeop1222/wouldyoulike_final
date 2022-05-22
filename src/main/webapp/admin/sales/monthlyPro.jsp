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
	<title>기간조회 - 월별</title>

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
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
</head>
<body>
	<!-- NavBar -->
	<jsp:include page="../adminmenu.jsp"/>
	<!-- Sidebar -->
	<jsp:include page="./sidebar.jsp"/>
	<%
		String start = request.getParameter("startYear")+"-"+request.getParameter("startMonth");
		String end = request.getParameter("endYear")+"-"+request.getParameter("endMonth");
	
	%>
	<section style="margin-left:30%;margin-top:5%;">
		<h3>조회기간 [<%=start %>~<%=end %>]</h3>
		<%
		SalesDAO dao = new SalesDAO();
		HashMap<String,Integer> monthlyCnt = dao.salesCntInPeriod("monthly", start, end);
		HashMap<String,Integer> monthlySales = dao.salesInPeriod("monthly", start, end);
		
		int monthCnt = dao.totalCntInPeriod("monthly", start, end);
		int monthSales = dao.totalSalesInPeriod("monthly", start, end);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		
		Calendar startM = Calendar.getInstance();
		Calendar endM = Calendar.getInstance();
		startM.setTime(sdf.parse(start));
		endM.setTime(sdf.parse(end));
		
		ArrayList<String> period = new ArrayList<String>();
		period.add(start);
		while(!startM.equals(endM)){
			startM.add(Calendar.MONTH, 1);
			String month = sdf.format(startM.getTime());
			period.add(month);
		}
		
		String months="", cnt="", sales="";
		for(String mon : period){
			months += "'"+mon+"',";
			if(monthlyCnt.containsKey(mon)){
				cnt += monthlyCnt.get(mon)+",";
			}else{
				cnt += 0+",";
			}
			if(monthlySales.containsKey(mon)){
				sales += monthlySales.get(mon)+",";
			}else{
				sales += 0+",";
			}
		}
		
		months = months.substring(0, months.length()-1);
		cnt = cnt.substring(0, cnt.length()-1);
		sales = sales.substring(0, sales.length()-1);
		%>
		<h3>선택한 기간의 총 판매수량 : <%=monthCnt %>개</h3>
		<h3>선택한 기간의 총 판매수익 : <%=monthSales %>원</h3>
		<canvas id="myChart1" style="width:100%;max-width:900px;margin-top:5%"></canvas>
		<script>
			new Chart(document.getElementById("myChart1"), {
			  type: 'line',
			  data: {
			    labels: [<%=months%>],
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
			      text: '선택한 기간의 일별 판매량'
			    }
			  }
			});
		</script>
		<canvas id="myChart2" style="width:100%;max-width:900px;margin-top:5%"></canvas>
		<script>
			new Chart(document.getElementById("myChart2"), {
			  type: 'line',
			  data: {
			    labels: [<%=months%>],
			    datasets: [{ 
			        data: [<%=sales%>],
			        label: "판매수익",
			        borderColor: "#3e95cd",
			        fill: false
			      }
			    ]
			  },
			  options: {
			    title: {
			      display: true,
			      text: '선택한 기간의 일별 판매금액'
			    }
			  }
			});
	
		</script>
	</section>
	<section style="margin-left:20%;margin-top:10%;margin-right:10%;margin-bottom:10%">
		<table>
		  <tr><th colspan="3"><h3>월간 판매량 / 매출액</h3></th></tr>
		  <tr>
		    <th>기간</th>
		    <th>판매수량 (개)</th>
		    <th>매출액 (원)</th>
		  </tr>
		  	<% 
		  	for(String m : period){
		  		int monthlycnt = 0, monthlysale = 0;
		  		if(monthlyCnt.get(m)!=null){monthlycnt = monthlyCnt.get(m); }
		  		if(monthlySales.get(m)!=null){monthlysale = monthlySales.get(m); }
			%>	<tr>
				    <td><%=m%></td>
				    <td><%=monthlycnt%></td>
				    <td><%=monthlysale%></td>
			  	</tr>
		<%  }%>
		</table>
	</section>
</body>
</html>