<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="wouldyoulike.products.ProductDAO" %>
<%@ page import="wouldyoulike.products.ProductDTO" %>
<%@ page import="wouldyoulike.products.WineFilterDTO" %>
<%@ page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	
	String dir = request.getRealPath("/img/product/");
	File file = new File(dir);
	if(!file.exists()){
		file.mkdirs();
	}
	
	int size = 1024*1024*10;
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, dir, size, "utf-8", dp);
	
	String ex = mr.getContentType("img").split("/")[0];
	if(!ex.equals("image")){
		mr.getFile("img").delete(); 
		out.println("<h2>사진만 업로드 가능</h2>");
	}
	else{
		out.println("<h2>업로드 완료</h2>");
	}
	
	ProductDTO dto = new ProductDTO();
	
	dto.setName(mr.getParameter("name"));
	dto.setBrand(mr.getParameter("brand"));
	dto.setCountry(mr.getParameter("country"));
	dto.setProCategory(mr.getParameter("proCategory"));
	dto.setAbv(Double.parseDouble(mr.getParameter("abv")));
	dto.setWineSize(Integer.parseInt(mr.getParameter("wineSize")));
	dto.setStock(Integer.parseInt(mr.getParameter("stock")));
	dto.setPrice(Integer.parseInt(mr.getParameter("price")));
	dto.setPromotion(mr.getParameter("promotion"));
	dto.setPromoPrice(Integer.parseInt(mr.getParameter("promoPrice")));
	dto.setReg(mr.getParameter("reg"));
	dto.setLoc(mr.getParameter("loc"));
	dto.setImg(mr.getFilesystemName("img"));
	dto.setProductN(Integer.parseInt(mr.getParameter("productN")));
	
	WineFilterDTO wineDTO = new WineFilterDTO();
	wineDTO.setVariental(mr.getParameter("variental"));
	wineDTO.setSweetness(Integer.parseInt(mr.getParameter("sweetness")));
	wineDTO.setWineBody(Integer.parseInt(mr.getParameter("body")));
	wineDTO.setAcidity(Integer.parseInt(mr.getParameter("acidity")));
	wineDTO.setTannins(Integer.parseInt(mr.getParameter("tannins")));
	wineDTO.setVQA(Integer.parseInt(mr.getParameter("vqa")));
	
	ProductDAO dao = new ProductDAO();
	int result = dao.productUpdate(dto, wineDTO); 
	if(result==1){
%>	
		<script>
			alert("수정되었습니다.");
			window.location = "productList.jsp"
		</script>
<% 
	}
	else{ %>
		<script>
			alert("상품 정보를 다시 확인하세요");
			history.go(-1);
		</script>
	
<% } %>



