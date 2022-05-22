<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- Navbar -->
<jsp:include page="../adminmenu.jsp"/>

<jsp:useBean id="odao" class="wouldyoulike.order.orderDAO"/>
<%
	String [] array = request.getParameterValues("orderNo");
	String strParam="";

	for(int i=0 ; i<array.length; i++){
		if(i!=0){
			strParam += ", ";
		}
		strParam += array[i];
	}

	int result = odao.orderComplete(strParam);
	
	
%>

<script>
	alert("<%=result%>개의 주문을 완료처리 하였습니다.")
	window.location = "order.jsp";
</script>

<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>