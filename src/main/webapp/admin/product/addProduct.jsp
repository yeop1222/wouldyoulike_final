<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="wouldyoulike.products.ProductDAO" %>
<%@ page import="wouldyoulike.products.ProductDTO" %>
<%@ page import="wouldyoulike.products.WineFilterDTO" %>
<%@ page import="wouldyoulike.products.WineFilterDAO" %>

<!-- Navbar -->
<jsp:include page="../adminmenu.jsp"/>

<%
	request.setCharacterEncoding("UTF-8");
	int result = 0;
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
		out.println("<h2>상품사진 업로드 완료</h2>");
	}
	

	ProductDTO dto = new ProductDTO();
	dto.setName(mr.getParameter("name"));
	dto.setBrand(mr.getParameter("brand"));
	dto.setCountry(mr.getParameter("country"));
	dto.setProCategory(mr.getParameter("procategory"));
	dto.setWineSize(Integer.parseInt(mr.getParameter("wineSize")));
	dto.setPrice(Integer.parseInt(mr.getParameter("price")));
	dto.setStock(Integer.parseInt(mr.getParameter("stock")));
	dto.setAbv(Double.parseDouble(mr.getParameter("abv")));
	dto.setPromotion(mr.getParameter("promotion"));
	String promoPrice = mr.getParameter("promoPrice");
	if(promoPrice != null && promoPrice != "" && !(promoPrice.equals("0"))){
		int price = Integer.parseInt(promoPrice);
		dto.setPromoPrice(price);
	}
	dto.setImg(mr.getFilesystemName("img"));
	dto.setReg(mr.getParameter("reg"));
	
	WineFilterDTO wineDTO = new WineFilterDTO();
	wineDTO.setVariental(mr.getParameter("variental"));
	if(mr.getParameter("sweetness")!=null && mr.getParameter("sweetness")!="") 
		wineDTO.setSweetness(Integer.parseInt(mr.getParameter("sweetness")));
	if(mr.getParameter("body")!=null && mr.getParameter("body")!="") 
		wineDTO.setWineBody(Integer.parseInt(mr.getParameter("body")));
	if(mr.getParameter("acidity")!=null && mr.getParameter("acidity")!="") 
		wineDTO.setAcidity(Integer.parseInt(mr.getParameter("acidity")));
	if(mr.getParameter("tannins")!=null && mr.getParameter("tannins")!="") 
		wineDTO.setTannins(Integer.parseInt(mr.getParameter("tannins")));
	if(mr.getParameter("vqa")!=null && mr.getParameter("vqa")!="") 
		wineDTO.setVQA(Integer.parseInt(mr.getParameter("vqa")));
	
	ProductDAO dao = new ProductDAO();
	result += dao.addProduct(dto, wineDTO);
%>	사진파일 저장된 실제 경로: <%=dir %><br/>
	* 중복된 사진파일 너무 많은 경우 삭제 필요			
<%	if(result==1){
%>		
		<h2>상품 등록이 완료되었습니다.</h2>
		<input type="button" value="상품 등록 계속하기" onclick="window.location='addProductForm.jsp'"/> <br>
		<input type="button" value="관리자 페이지로 돌아가기" onclick="window.location='../main.jsp'"/> <br/>
<%	}else{
%>		<script>
			alert("상품정보를 다시 확인해주세요!");
			history.go(-1);
		</script>
<%	} %>


<!-- Footer -->
<jsp:include page="../../footer.jsp"></jsp:include>