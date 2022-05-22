<%@page import="java.util.ArrayList"%>
<%@page import="wouldyoulike.order.orderDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- Navbar -->
<jsp:include page="../adminmenu.jsp"/>

<jsp:useBean id="odao" class="wouldyoulike.order.orderDAO"/>
<jsp:useBean id="pdao" class="wouldyoulike.products.ProductDAO"/>

<%
	String id = (String) session.getAttribute("sid");
	if(id==null){
%>		<script>
			alert("로그인을 해주세요.");
			window.location="/wouldyoulike_final/mainForm.jsp";
		</script>		
<%	}else if(!id.equals("admin")){
%>		<script>
			alert("관리자만 접근 가능한 페이지입니다!");
			window.location="/wouldyoulike_final/main.jsp";
		</script>
<%	} %>

			신규 주문 내역
<%			
			final int PAGE_SIZE = 10;
			int currentPage = 1;
			int start=0;
			int end=0;
			int count=odao.newOrderCount();
			String pageNum = request.getParameter("pageNum");
			if(pageNum == null){
				pageNum = "1";
			}
			currentPage = Integer.parseInt(pageNum);
			start = (currentPage-1)*PAGE_SIZE+1;
			end = currentPage * PAGE_SIZE;
			ArrayList<orderDTO> list = odao.newOrderList(start,end);
%>


			<table border="1">
				<tr>
					<th></th>
					<th>주문번호</th>
					<th>주문자명(ID)</th>
					<th>상품</th>
					<th>수량</th>
					<th>총액</th>
					<th>상태</th>
					<th>주문날짜</th>
					<th>연락처</th>
					<th>수령방법</th>
					<th>결제방법</th>
				</tr>
							
<%			for(orderDTO d : list){
%>				<form name="frm" action="orderComplete.jsp" method="post">
					<tr>
						<td>
							<input type="checkbox" name="orderNo" value="<%=d.getorderNum() %>" />
						</td>
						<td><%=d.getorderNum() %></td>
						<td><%=d.getordername() %>(<%=d.getmemberID() %>)</td>
						<td>
							<img src="/wouldyoulike_final/img/product/<%=pdao.getData(d.getproductNum()).getImg() %>" height="32"/>
							<%=pdao.getData(d.getproductNum()).getName() %>
						</td>
						<td><%=d.getorderamount() %></td>
						<td><%=d.getpricesum() %></td>
						<td><%=d.getordercomplete() %></td>
						<td><%=d.getorderDate() %></td>
						<td><%=d.getmobilenum() %></td>
						<td><%=d.getreceive() %></td>
						<td><%=d.getpayment() %></td>
					</tr>
<%			}
%>				
					<tr align="center">
						<td colspan="2">
							<input type="submit" value="수령완료">
						</td>
						<td colspan="6">
<%
							if(count>0){
								int pageCount = count / PAGE_SIZE + (count%PAGE_SIZE==0?0:1);
								int startPage = (int)(currentPage / PAGE_SIZE)*PAGE_SIZE+1;
								final int PAGE_BLOCK = 10;
								int endPage = startPage + PAGE_BLOCK-1;
								if(endPage > pageCount){
									endPage = pageCount;
								}
								if(startPage > PAGE_BLOCK){
%>									<a href="order.jsp?pageNum=<%=startPage-PAGE_BLOCK%>">[이전]</a> <%
								}
								for(int i=startPage; i<endPage; i++){
%>									<a href="order.jsp?pageNum=<%=i%>">[<%=i %>]</a> <%								
								}
								if(endPage<pageCount){
%>									<a href="order.jsp?pageNum=<%=startPage+PAGE_BLOCK%>">[다음]</a> <%
								}
							}
%>
						</td>
						<td colspan="2">
						</td>
					</tr>
				</form>
			</table>



<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>