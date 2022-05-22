package wouldyoulike.products;

import java.sql.*;
import java.util.*;

import wouldyoulike.jdbc.*;

public class ProductDAO {
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	//재고 count보다 적은것들 목록
	public HashMap<String, Integer> closeSoldOut(int count){
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		
		try {
			conn = OracleConnection.getConnection();
			String sql = "select name, stock from products "
					+ " where stock<=? and stock > 0"
					+ " order by stock asc";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, count);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				map.put(rs.getString(1), rs.getInt(2));
			}
		}catch(Exception e) {
			
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		
		return map;
	}

	// 상품 삭제
	public int productDelete(int productN) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "delete from products where productn=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			result = pstmt.executeUpdate();

		
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	// 상품 정보
	public ProductDTO getData(int productN) {
		ProductDTO dto = new ProductDTO();
		try {
			conn = OracleConnection.getConnection();
			
			String sql = "select * from products where productN=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
			}		
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return dto;
	}
	
	// 상품 정보 수정
	public int productUpdate(ProductDTO dto, WineFilterDTO wineDTO) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
	
			String sql="update products set name=?,brand=?,country=?,proCategory=?,abv=?,wineSize=?,stock=?,price=?,promotion=?,promoPrice=?,reg=?,loc=?,img=? where productN=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getBrand());
			pstmt.setString(3, dto.getCountry());
			pstmt.setString(4, dto.getProCategory());
			pstmt.setDouble(5, dto.getAbv());
			pstmt.setInt(6, dto.getWineSize());
			pstmt.setInt(7, dto.getStock());
			pstmt.setInt(8, dto.getPrice());
			pstmt.setString(9, dto.getPromotion());
			pstmt.setInt(10, dto.getPromoPrice());
			pstmt.setString(11, dto.getReg());
			pstmt.setString(12, dto.getLoc());
			pstmt.setString(13, dto.getImg());
			pstmt.setInt(14, dto.getProductN());
			result = pstmt.executeUpdate();
			
			sql ="select productn from (select rownum r, productn from (select * from products order by productn desc)) where rownum=1";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			int productN = 0;
			if(rs.next()) {
				productN = rs.getInt(1);
			}
			
			sql = "update winefilter set variental=?,sweetness=?,winebody=?,acidity=?,tannins=?,VQA=? where productN=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, wineDTO.getVariental());
			pstmt.setInt(2, wineDTO.getSweetness());
			pstmt.setInt(3, wineDTO.getWineBody());
			pstmt.setInt(4, wineDTO.getAcidity());
			pstmt.setInt(5, wineDTO.getTannins());
			pstmt.setInt(6, wineDTO.getVQA());
			pstmt.setInt(7, productN);
	
			result = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//장바구니에 담긴 상품개수 조회
	public int cartCount(String memberId) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select count(*) from user_cart where user_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memberId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//판매량 ?위의 sales 값 -> 상품에 베스트셀러 badge표시할 때
	public int isBestSeller(int rank) {
		int result = 5; 	//result 값이 0이면 안되므로 
		try {
			conn = OracleConnection.getConnection();
			String sql = "select sales from (select rownum r, sales from "
					+ "(select * from products order by sales desc nulls last)) "
					+ "where r = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, rank);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getInt(1) > result)	result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//상품별 판매량 조회
	public int productSales(int productN) {
		int result=0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select sum(orderamount) from orderinfo where productnum=? group by productnum";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//카테고리별 판매량순 상품목록 **판매량 null값 아닌 상품만 조회 -> 실제로 팔린 상품
	public ArrayList<ProductDTO> bestSeller(String category) {
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from (select rownum r, res.*  from (select o.orderamount, p.* from products p, "
					+ "            (select sum(orderamount) as orderamount, productnum from orderinfo group by productnum) o "
					+ " where p.productn=o.productnum order by o.orderamount desc) res where procategory= ? ) "
					+ " where r<=5";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, category);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoprice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//베스트셀러 목록 조회 (판매량 5위까지) **판매량이 null값이 아닌 상품만 조회가능.. 
	public ArrayList<ProductDTO> bestSeller() {
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from (select rownum r, res.*  from (select o.orderamount, p.* from products p, "
					+ "            (select sum(orderamount) as orderamount, productnum from orderinfo group by productnum) o "
					+ "where p.productn=o.productnum order by o.orderamount desc) res) "
					+ "where r<=5";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoprice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//정렬기준 보여주기
	public String sortBy(String sort, String order) {
		String sortby="";
		//사용자 페이지
		if(sort.equals("name") && order.equals("asc")) sortby = "기본순";
		if(sort.equals("reg") && order.equals("desc")) sortby = "신상품순";
		if(sort.equals("price") && order.equals("asc"))	sortby = "가격 낮은순";
		if(sort.equals("price") && order.equals("desc")) sortby = "가격 높은순";
		if(sort.equals("rating") && order.equals("desc")) sortby = "평점 높은순";
		if(sort.equals("review") && order.equals("desc")) sortby = "리뷰 많은순";
		if(sort.equals("sales") && order.equals("desc")) sortby = "판매량순";
		
		//관리자 페이지
		if(sort.equals("sales") && order.equals("asc")) sortby = "판매량 낮은순";
		if(sort.equals("stock") && order.equals("desc")) sortby = "재고 높은순";
		if(sort.equals("stock") && order.equals("asc")) sortby = "재고 높은순";
		return sortby;
	}
	
	//재고가 ? 이하인 상품 검색 결과 
	public ArrayList<ProductDTO> productList(int start, int end, int stockCount){
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from (select products.*, rownum r from "
					+" (select * from products where stock <= ? ) products) where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, stockCount);
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoprice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//관리자페이지 - 매진상품관리 : 매진상품개수
	public int soldoutCount() {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select count(*) from products where stock=0";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//관리자 페이지 - 매진상품리스트
	public ArrayList<ProductDTO> soldoutList(int start, int end, String sort, String order){
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from (select products.*, rownum r from "
						+" (select * from products where stock=0 order by "
						+sort+" "+order+" nulls last) products) "
						+" where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoprice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//상품별 별점 조회 (실시간 평균 별점)
	public int getRating(int productN) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select round(avg(boardscore)) from boardreview where productN=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//별점,리뷰 업데이트 -> 상품평이 하나 등록될때마다 호출
	public int setRating(int productN) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "update products set "
						+" rating=(select round(avg(boardscore)) from boardreview "
						+ " where productN=? and originalnum is null)"
						+", review=(select count(*) from boardreview where productn=? "
						+ " and originalnum is null group by productn)"
						+" where productN=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			pstmt.setInt(2, productN);
			pstmt.setInt(3, productN);
			result = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//관리자페이지 - 할인상품관리 : 선택한 상품 할인종료
	public int endSale(String productN) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "update products set promotion=null, promoprice=null "
						+" where productN in ("+productN+")";
			pstmt = conn.prepareStatement(sql);
			result = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//관리자페이지 - 상품관리/할인상품관리 : 선택한 상품에 할인적용(%) 
	public int setDiscount(String productN, int discount) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "update products set promotion='Y', promoprice=round((price/100*(100-?)),-2) " //10원 단위 반올림
						+" where productN in ("+productN+")";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, discount);
			result = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//관리자페이지 - 할인상품관리 : 선택한 상품 일괄삭제
	public int delCheckedProducts(String productN) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "delete from products where productN in ("+productN+")";
			pstmt = conn.prepareStatement(sql);
			result = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//페이징처리 -> 받은 parameter중 pageNum은 제외하고 다른 parameter만 남겨서 return 
	public String getHref(String param) {
		String href = "";
		String[] params = param.split("&");
		for(int i=0;i<params.length;i++) {
			String first = params[i].split("=")[0];
			if(!(first.equals("pageNum"))) {
				if(i<=(param.length()-1)) {
					href += params[i]+"&";
				}
				if(i==param.length()) {
					href += params[i];
				}
			}
		}
		return href;
	}
	
	//winefilter테이블의 와인 상세정보 이용해 비슷한 상품 추천 
	public ArrayList<ProductDTO> relatedProducts(int productN){
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		try {
			conn = OracleConnection.getConnection();
			
			//포도 품종이 같은 와인 추천
			String v = "";
			String sql = "select variental from winefilter where productn = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				v = rs.getString(1);
			}
			
			String var[] = v.split(",");
			String variental = var[0];
			System.out.println(v);
			System.out.println(variental);
			
			sql = "select * from winefilter w, products p "
					+ " where p.productN = w.productN "
					+ " and w.variental like '"+variental+"%' "
					+ " and p.productn not in (?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoprice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
				list.add(dto);
				if(list.size()==4) {break;}
			}
			
			//세부종류가 같은 와인이 4개 이하일 경우, 맛이 비슷한 와인 추천
			if(list.size()<4) {
				sql = "select * from winefilter w, products p "
						+" where p.productN = w.productN and w.sweetness=(select sweetness from winefilter where productn = ? ) " 
                    	+" and w.winebody=(select winebody from winefilter where productn = ?) "
                    	+" and p.procategory=(select procategory from products where productn = ?) "
                    	+" and p.productn not in (?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, productN);
				pstmt.setInt(2, productN);
				pstmt.setInt(3, productN);
				pstmt.setInt(4, productN);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					ProductDTO dto = new ProductDTO();
					dto.setProductN(rs.getInt("productN"));
					dto.setName(rs.getString("name"));
					dto.setBrand(rs.getString("brand"));
					dto.setCountry(rs.getString("country"));
					dto.setProCategory(rs.getString("procategory"));
					dto.setWineSize(rs.getInt("wineSize"));
					dto.setPrice(rs.getInt("price"));
					dto.setRating(rs.getInt("rating"));
					dto.setStock(rs.getInt("stock"));
					dto.setAbv(rs.getDouble("abv"));
					dto.setPromotion(rs.getString("promotion"));
					dto.setPromoPrice(rs.getInt("promoprice"));
					dto.setLoc(rs.getString("loc"));
					dto.setImg(rs.getString("img"));
					dto.setReg(rs.getString("reg"));
					dto.setSales(rs.getInt("sales"));
					dto.setReviews(rs.getInt("review"));
					list.add(dto);
					if(list.size()==4) {break;}
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//할인상품 전체목록 
	public ArrayList<ProductDTO> promoList(int start, int end, String sort, String order){
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from (select products.*, rownum r from (select * from products where promotion = 'Y' "
						+ " order by "+sort+" "+order+" nulls last) products) where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoPrice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//할인중인 상품 개수
	public int promoCount() {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select count(*) from products where promotion = 'Y'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//가격대별 상품개수
	public int productCount(int price) {
		int result=0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select count(*) from products where price ";
			if(price<500000) {
				sql += " <= ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, price);
				rs = pstmt.executeQuery();
			}else {
				sql += " >= ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, price);
				rs = pstmt.executeQuery();
			}
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//선물-가격대별 상품목록
	public ArrayList<ProductDTO> giftList(int start, int end, int price, String sort, String order){
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from (select rownum r, p.* from (select * from products where price "
					+ ((price<500000) ? "<= "+price+" " : ">="+price+" ")
					+ " order by "+sort+" "+order+" nulls last) p ) where r>="+start+" and r<="+end+" ";
			System.out.println(sql);
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoPrice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//신상품 전체 목록 
	public ArrayList<ProductDTO> newProductsList(int start, int end, String sort, String order){
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from (select products.*, rownum r "
					+" from (select * from products where reg between (sysdate-30) and sysdate " //한달이내에 등록된 상품 검색
					+" order by "+sort+" "+order+" nulls last) products) where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoPrice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//신상품 전체 개수
	public int newCount() {
		int result=0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select count(*) from products where reg between (sysdate-30) and sysdate";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//카테고리별 신상품 개수
	public int newCount(String category) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select count(*) from products where procategory=? "
						+" and reg between (sysdate-30) and sysdate";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, category);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//메뉴바-신상품-카테고리별
	public ArrayList<ProductDTO> newProductsList(int start, int end, String category, String sort, String order){
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from (select products.*, rownum r "
					+" from (select * from products where procategory=? and reg between (sysdate-30) and sysdate " 
					+" order by "+sort+" "+order+" nulls last) products) where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, category);
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoPrice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//상품상세정보
	public ProductDTO product(int productN) {
		ProductDTO dto = new ProductDTO();
		try {
			conn=OracleConnection.getConnection();
			String sql = "select * from products where productN=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoprice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return dto;
	}
	
	//상품필터링
	public ArrayList<ProductDTO> filter (ProductDTO dto){
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		HashSet<ProductDTO> set1 = new HashSet<ProductDTO>();
		int filterCount = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "", category="", country="";
			if(dto.getCategory() != null) {
				++filterCount;
				for(int i=0;i<dto.getCategory().length;i++) {
					if(i!=(dto.getCategory().length)-1) {
						category += "'"+dto.getCategory()[i]+"',";
					}else {
						category += "'"+dto.getCategory()[i]+"'";
					}
				}
				sql = "select * from products where procategory in("+category+")";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					ProductDTO result = new ProductDTO();
					result.setProductN(rs.getInt("productN"));
					result.setName(rs.getString("name"));
					result.setBrand(rs.getString("brand"));
					result.setCountry(rs.getString("country"));
					result.setProCategory(rs.getString("procategory"));
					result.setWineSize(rs.getInt("wineSize"));
					result.setPrice(rs.getInt("price"));
					result.setRating(rs.getInt("rating"));
					result.setStock(rs.getInt("stock"));
					result.setAbv(rs.getDouble("abv"));
					result.setPromotion(rs.getString("promotion"));
					result.setPromoPrice(rs.getInt("promoprice"));
					result.setLoc(rs.getString("loc"));
					result.setImg(rs.getString("img"));
					result.setReg(rs.getString("reg"));
					result.setSales(rs.getInt("sales"));
					result.setReviews(rs.getInt("review"));
					set1.add(result);
					list.add(result);
				}//while
			}//if
			if(dto.getCountries()!=null) {
				filterCount += 1;
				for(int i=0;i<dto.getCountries().length;i++) {
					if(i!=(dto.getCountries().length)-1) {
						country += "'"+dto.getCountries()[i]+"',";
					}else {
						country += "'"+dto.getCountries()[i]+"'";
					}
				}
				sql = "select * from products where country in("+country+")";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					ProductDTO result = new ProductDTO();
					result.setProductN(rs.getInt("productN"));
					result.setName(rs.getString("name"));
					result.setBrand(rs.getString("brand"));
					result.setCountry(rs.getString("country"));
					result.setProCategory(rs.getString("procategory"));
					result.setWineSize(rs.getInt("wineSize"));
					result.setPrice(rs.getInt("price"));
					result.setRating(rs.getInt("rating"));
					result.setStock(rs.getInt("stock"));
					result.setAbv(rs.getDouble("abv"));
					result.setPromotion(rs.getString("promotion"));
					result.setPromoPrice(rs.getInt("promoprice"));
					result.setLoc(rs.getString("loc"));
					result.setImg(rs.getString("img"));
					result.setReg(rs.getString("reg"));
					result.setSales(rs.getInt("sales"));
					result.setReviews(rs.getInt("review"));
					if(filterCount==1) { 
						set1.add(result);
						list.add(result);
					}else {
						if(set1.add(result)==false) list.add(result);
					}
				}//while
			}//if
			if(dto.getMinPrice()!=0 || dto.getMaxPrice()!=0) {
				filterCount += 1;
				int maxPrice = dto.getMaxPrice();
				if(maxPrice==0) {
					sql = "select max(price) from products";
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					maxPrice = rs.getInt(1);
				}
				sql = "select * from products where price between ? and ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, dto.getMinPrice());
				pstmt.setInt(2, maxPrice);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					ProductDTO result = new ProductDTO();
					result.setProductN(rs.getInt("productN"));
					result.setName(rs.getString("name"));
					result.setBrand(rs.getString("brand"));
					result.setCountry(rs.getString("country"));
					result.setProCategory(rs.getString("procategory"));
					result.setWineSize(rs.getInt("wineSize"));
					result.setPrice(rs.getInt("price"));
					result.setRating(rs.getInt("rating"));
					result.setStock(rs.getInt("stock"));
					result.setAbv(rs.getDouble("abv"));
					result.setPromotion(rs.getString("promotion"));
					result.setPromoPrice(rs.getInt("promoprice"));
					result.setLoc(rs.getString("loc"));
					result.setImg(rs.getString("img"));
					result.setReg(rs.getString("reg"));
					result.setSales(rs.getInt("sales"));
					result.setReviews(rs.getInt("review"));
					if(filterCount==1) { 
						set1.add(result);
						list.add(result);
					}else {
						if(set1.add(result)==false) list.add(result);
					}
				}//while
			}//if
			if(dto.getMinSize()!=0 || dto.getMaxSize() !=0) {
				filterCount += 1;
				int maxSize = dto.getMaxSize();
				if(maxSize == 0) {
					sql = "select max(winesize) from products";
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					maxSize = rs.getInt(1);
				}
				sql = "select * from products where winesize between ? and ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, dto.getMinSize());
				pstmt.setInt(2, maxSize);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					ProductDTO result = new ProductDTO();
					result.setProductN(rs.getInt("productN"));
					result.setName(rs.getString("name"));
					result.setBrand(rs.getString("brand"));
					result.setCountry(rs.getString("country"));
					result.setProCategory(rs.getString("procategory"));
					result.setWineSize(rs.getInt("wineSize"));
					result.setPrice(rs.getInt("price"));
					result.setRating(rs.getInt("rating"));
					result.setStock(rs.getInt("stock"));
					result.setAbv(rs.getDouble("abv"));
					result.setPromotion(rs.getString("promotion"));
					result.setPromoPrice(rs.getInt("promoprice"));
					result.setLoc(rs.getString("loc"));
					result.setImg(rs.getString("img"));
					result.setReg(rs.getString("reg"));
					result.setSales(rs.getInt("sales"));
					result.setReviews(rs.getInt("review"));
					if(filterCount==1) { 
						set1.add(result);
						list.add(result);
					}else {
						if(set1.add(result)==false) list.add(result);
					}
				}//while
			}//if
			if(dto.getMaxAbv()!=0){
				filterCount += 1;
				sql = "select * from products where abv<=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setDouble(1, dto.getMaxAbv());
				rs = pstmt.executeQuery();
				while(rs.next()) {
					ProductDTO result = new ProductDTO();
					result.setProductN(rs.getInt("productN"));
					result.setName(rs.getString("name"));
					result.setBrand(rs.getString("brand"));
					result.setCountry(rs.getString("country"));
					result.setProCategory(rs.getString("procategory"));
					result.setWineSize(rs.getInt("wineSize"));
					result.setPrice(rs.getInt("price"));
					result.setRating(rs.getInt("rating"));
					result.setStock(rs.getInt("stock"));
					result.setAbv(rs.getDouble("abv"));
					result.setPromotion(rs.getString("promotion"));
					result.setPromoPrice(rs.getInt("promoprice"));
					result.setLoc(rs.getString("loc"));
					result.setImg(rs.getString("img"));
					result.setReg(rs.getString("reg"));
					result.setSales(rs.getInt("sales"));
					result.setReviews(rs.getInt("review"));
					if(filterCount==1) { 
						set1.add(result);
						list.add(result);
					}else {
						if(set1.add(result)==false) list.add(result);
					}
				}//while
			}//if
			if(dto.getRating()!=0) {
				filterCount += 1;
				sql = "select * from products where rating >= ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1,dto.getRating());
				rs = pstmt.executeQuery();
				while(rs.next()) {
					ProductDTO result = new ProductDTO();
					result.setProductN(rs.getInt("productN"));
					result.setName(rs.getString("name"));
					result.setBrand(rs.getString("brand"));
					result.setCountry(rs.getString("country"));
					result.setProCategory(rs.getString("procategory"));
					result.setWineSize(rs.getInt("wineSize"));
					result.setPrice(rs.getInt("price"));
					result.setRating(rs.getInt("rating"));
					result.setStock(rs.getInt("stock"));
					result.setAbv(rs.getDouble("abv"));
					result.setPromotion(rs.getString("promotion"));
					result.setPromoPrice(rs.getInt("promoprice"));
					result.setLoc(rs.getString("loc"));
					result.setImg(rs.getString("img"));
					result.setReg(rs.getString("reg"));
					result.setSales(rs.getInt("sales"));
					result.setReviews(rs.getInt("review"));
					if(filterCount==1) { 
						set1.add(result);
						list.add(result);
					}else {
						if(set1.add(result)==false) list.add(result);
					}
				}//while
			}//if
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		
		//필터별로 검색 후 중복된 결과 걸러내기 
		Set<ProductDTO> set2 = new HashSet<>();
		ArrayList<ProductDTO> newlist = new ArrayList<ProductDTO>();
		if(1<filterCount) {
			for(ProductDTO p : list) {
				if(set2.add(p)==true) {
					newlist.add(p);
				}
			}
			list = newlist;
		}
		System.out.println("set1"+set1);
		System.out.println("set2"+set2);
		System.out.println("최종 : "+newlist);
		System.out.println("return : "+list);
		System.out.println("필터개수 :"+filterCount);
		return list;
	}	
	
	//카테고리별 상품 개수
	public int categoryCount(String category) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select count(*) from products where procategory=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, category);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//전체상품 개수
	public int productCount() {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select count(*) from products";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//카테고리별 상품리스트
	public ArrayList<ProductDTO> productList(int start, int end, String category, String sort, String order){
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from (select product.*, rownum r from "
					+" (select * from products where procategory=? order by "+sort+" "+order
					+" nulls last ) product) "
					+" where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, category);
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoprice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//전체상품 조회 
	public ArrayList<ProductDTO> productList(int start, int end, String sort, String order){
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from (select products.*, rownum r from "
					+" (select * from products order by "+sort+" "+order+" nulls last) products) "
					+" where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProductN(rs.getInt("productN"));
				dto.setName(rs.getString("name"));
				dto.setBrand(rs.getString("brand"));
				dto.setCountry(rs.getString("country"));
				dto.setProCategory(rs.getString("procategory"));
				dto.setWineSize(rs.getInt("wineSize"));
				dto.setPrice(rs.getInt("price"));
				dto.setRating(rs.getInt("rating"));
				dto.setStock(rs.getInt("stock"));
				dto.setAbv(rs.getDouble("abv"));
				dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoprice"));
				dto.setLoc(rs.getString("loc"));
				dto.setImg(rs.getString("img"));
				dto.setReg(rs.getString("reg"));
				dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//상품등록 - products
	public int addProduct(ProductDTO dto, WineFilterDTO wineDTO) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "insert into products values (products_seq.nextval,?,?,?,?,?,?,?,?,?,?,?,?,'','','',?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getBrand());
			pstmt.setString(3, dto.getCountry());
			pstmt.setString(4, dto.getProCategory());
			pstmt.setDouble(5, dto.getAbv());
			pstmt.setInt(6, dto.getWineSize());
			pstmt.setInt(7, dto.getStock());
			pstmt.setInt(8, dto.getPrice());
			pstmt.setString(9, dto.getPromotion());
			pstmt.setInt(10, dto.getPromoPrice());
			pstmt.setString(11, dto.getReg());
			pstmt.setString(12, dto.getLoc());
			pstmt.setString(13, dto.getImg());
			
			result = pstmt.executeUpdate();
			
			sql ="select productn from (select rownum r, productn from (select * from products order by productn desc)) where rownum=1";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			int productN = 0;
			if(rs.next()) {
				productN = rs.getInt(1);
			}
			
			sql = "insert into winefilter values (?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			pstmt.setString(2, wineDTO.getVariental());
			pstmt.setInt(3, wineDTO.getSweetness());
			pstmt.setInt(4, wineDTO.getWineBody());
			pstmt.setInt(5, wineDTO.getAcidity());
			pstmt.setInt(6, wineDTO.getTannins());
			pstmt.setInt(7, wineDTO.getVQA());
			result = pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//주문페이지 상품정보 불러오기
	public ArrayList<ProductDTO> getProductInfo(int num) {
        ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
        try {
            conn = OracleConnection.getConnection();
            String sql = "select * from products where productN = " + num;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while(rs.next()){
                ProductDTO dto = new ProductDTO();
                dto.setProductN(rs.getInt("productN"));
                dto.setName(rs.getString("name"));
                dto.setBrand(rs.getString("brand"));
                dto.setCountry(rs.getString("country"));
                dto.setProCategory(rs.getString("procategory"));
                dto.setWineSize(rs.getInt("wineSize"));
                dto.setPrice(rs.getInt("price"));
                dto.setRating(rs.getInt("rating"));
                dto.setStock(rs.getInt("stock"));
                dto.setAbv(rs.getDouble("abv"));
                dto.setPromotion(rs.getString("promotion"));
				dto.setPromoPrice(rs.getInt("promoprice"));
                dto.setLoc(rs.getString("loc"));
                dto.setImg(rs.getString("img"));
                dto.setReg(rs.getString("reg"));
                dto.setSales(rs.getInt("sales"));
				dto.setReviews(rs.getInt("review"));
                list.add(dto);
            }
        }catch(Exception e) {
            e.printStackTrace();
        }finally {
            OracleConnection.closeConnection(rs, pstmt, conn);
        }return list;
	}

}
