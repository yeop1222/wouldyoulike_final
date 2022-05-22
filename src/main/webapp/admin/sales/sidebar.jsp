<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>


<div class="w3-sidebar w3-bar-block w3-light-grey w3-card" style="width:20%">
  <h3 class="w3-bar-item">조건별  매출 / 판매량 조회</h3>
  <div class="w3-dropdown-hover">
    <button class="w3-button">카테고리별
      <i class="fa fa-caret-down"></i>
    </button>
    <div class="w3-dropdown-content w3-bar-block">
      <a href="category.jsp" class="w3-bar-item w3-button">전체</a>
      <hr>
      <a href="category_daily.jsp" class="w3-bar-item w3-button">일간</a>	
      <a href="category_monthly.jsp" class="w3-bar-item w3-button">월간</a>
      <a href="#" class="w3-bar-item w3-button">연간</a>
    </div>
  </div> 
  <div class="w3-dropdown-hover">
    <button class="w3-button">기간별 
      <i class="fa fa-caret-down"></i>
    </button>
    <div class="w3-dropdown-content w3-bar-block">
      <a href="daily.jsp" class="w3-bar-item w3-button">일간</a>
      <a href="monthly.jsp" class="w3-bar-item w3-button">월간</a>
      <a href="yearly.jsp" class="w3-bar-item w3-button">연간</a>
    </div>
  </div> 
  <a href="country.jsp" class="w3-bar-item w3-button">원산지별</a> 
</div>


