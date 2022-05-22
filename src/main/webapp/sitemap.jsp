<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- Navbar -->
<jsp:include page="menu.jsp"/>

<div class="container">
	<div class="row">
		<div class="col">
			<table class="table">
				<thead>
					<tr>
						<th><a href="/wouldyoulike_final/product/searchList.jsp">전체상품</a></th>
						<th><a href="/wouldyoulike_final/product/searchList.jsp?new=1">신상품</a></th>
						<th>프로모션</th>
						<th>커뮤니티</th>
						<th>마이페이지</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?category=Red">레드와인</a></td>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?category=Red&new=Y">레드와인</a></td>
						<td><a href="/wouldyoulike_final/product/searchList.jsp">선물</a></td>
						<td><a href="/wouldyoulike_final/board/boardNotice/list.jsp">공지사항</a></td>
						<td><a href="/wouldyoulike_final/mypage/updateForm.jsp">나의 정보</a></td>
					</tr>
					<tr>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?category=White">화이트와인</a></td>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?category=White&new=Y">화이트와인</a></td>
						<td></td>
						<td><a href="/wouldyoulike_final/board/boardCommonQna/list.jsp">문의게시판</a></td>
						<td></td>
					</tr>
					<tr>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?category=Rose">로제와인</a></td>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?category=Rose&new=Y">로제와인</a></td>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?price=1">5만원 이하</a></td>
						<td></td>
						<td><a href="/wouldyoulike_final/mypage/orderhistory.jsp?option=0">주문내역 조회</a></td>
					</tr>
					<tr>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?category=Sparkling">스파클링와인</a></td>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?category=Sparkling&new=Y">스파클링와인</a></td>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?price=2">10만원 이하</a></td>
						<td></td>
						<td><a href="/wouldyoulike_final/mypage/orderhistory.jsp?option=1">구매내역 조회</a></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?price=3">20만원 이하</a></td>
						<td></td>
						<td><a href="/wouldyoulike_final/mypage/myQna.jsp">문의내역 조회</a></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?price=4">50만원 이하</a></td>
						<td></td>
						<td><a href="/wouldyoulike_final/board/boardReview/list.jsp?option=1">리뷰내역 조회</a></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?price=5">50만원 이상</a></td>
						<td></td>
						<td><a href="/wouldyoulike_final/order/cart.jsp">장바구니</a></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td>　</td>
						<td></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td><a href="/wouldyoulike_final/product/searchList.jsp?promo=Y">할인상품</a></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>

<!-- Footer -->
<jsp:include page="footer.jsp"></jsp:include>