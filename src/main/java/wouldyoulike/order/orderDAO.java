package wouldyoulike.order;

import java.sql.*;
import wouldyoulike.order.orderDTO;
import java.util.ArrayList;

import wouldyoulike.jdbc.*;

public class orderDAO {
   private Connection conn = null;
   private PreparedStatement pstmt = null;
   private ResultSet rs = null;
   
   public int orderComplete(String strParam) {
	   int result = 0;
	   
	   try {
		   conn = OracleConnection.getConnection();
		   String sql = "update orderinfo set ordercomplete='수령완료'"
		   		+ "	where ordern in (" + strParam + ")";
		   pstmt = conn.prepareStatement(sql);
		   result = pstmt.executeUpdate();
		   
	   }catch(Exception e) {
		   e.printStackTrace();
	   }finally {
		   OracleConnection.closeConnection(rs, pstmt, conn);
	   }
	   
	   return result;
   }
   
   public int newOrderCount() {
	   int result = 0;
	   
	   try {
		   conn = OracleConnection.getConnection();
		   String sql = "select count(*) from orderinfo "
		   		+ " where ordercomplete != '수령완료'";
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
   
   public ArrayList<orderDTO> newOrderList(int start, int end){
	   ArrayList<orderDTO> list = new ArrayList<orderDTO>();
	   
	   try {
		   conn = OracleConnection.getConnection();
		   String sql = "select * from "
		   		+ " (select rownum r, oo.* from (select * from orderinfo "
		   		+ " where ordercomplete != '수령완료' order by orderdate desc) oo) "
		   		+ " where r>=? and r<=?";
		   pstmt = conn.prepareStatement(sql);
		   pstmt.setInt(1, start);
		   pstmt.setInt(2, end);
		   rs = pstmt.executeQuery();
		   while(rs.next()) {
			   orderDTO dto = new orderDTO();
			   dto.setmemberID(rs.getString("memberid"));
			   dto.setmobilenum(rs.getString("mobilenum"));
			   dto.setorderamount(rs.getInt("orderamount"));
			   dto.setordercomplete(rs.getString("ordercomplete"));
			   dto.setorderDate(rs.getString("orderdate"));
			   dto.setordername(rs.getString("ordername"));
			   dto.setorderNum(rs.getInt("ordern"));
			   dto.setpayment(rs.getString("payment"));
			   dto.setpricesum(rs.getInt("pricesum"));
			   dto.setproductNum(rs.getInt("productnum"));
			   dto.setreceive(rs.getString("receive"));
			   list.add(dto);
		   }
	   }catch(Exception e) {
		   e.printStackTrace();
	   }finally {
		   OracleConnection.closeConnection(rs, pstmt, conn);
	   }
	   
	   return list;
   }
   
   public int [] recentSales(int days) {
	   int [] result= new int[2];
	   
	   try {
		   conn = OracleConnection.getConnection();
		   String sql = "select a.s1, b.s2 from "
		   		+ " (select sum(pricesum) s1 from orderinfo "
		   		+ " where orderdate between sysdate-? and sysdate) a , "
		   		+ " (select sum(pricesum) s2 from orderinfo "
		   		+ " where orderdate between sysdate-? and sysdate-?) b ";
		   pstmt = conn.prepareStatement(sql);
		   pstmt.setInt(1, days);
		   pstmt.setInt(2, 2*days);
		   pstmt.setInt(3, days);
		   rs = pstmt.executeQuery();
		   if(rs.next()) {
			   result[0] = rs.getInt(1);
			   result[1] = rs.getInt(2);
		   }
	   }catch(Exception e) {
		   e.printStackTrace();
	   }finally {
		   OracleConnection.closeConnection(rs, pstmt, conn);
	   }
	   
	   return result;
   }
   
   public boolean isOrderUser(int productN, String id) {
	   boolean result = false;
	   
	   try {
		   conn = OracleConnection.getConnection();
		   String sql = "select * from orderinfo "
		   		+ " where productnum=? "
		   		+ " and memberid=? "
		   		+ " and ordercomplete = '수령완료' "
		   		+ " and orderdate between sysdate-7 and sysdate ";
		   pstmt = conn.prepareStatement(sql);
		   pstmt.setInt(1, productN);
		   pstmt.setString(2, id);
		   rs = pstmt.executeQuery();
		   result = rs.next();
	   }catch(Exception e) {
		   
	   }finally {
		   OracleConnection.closeConnection(rs, pstmt, conn);
	   }
	   
	   return result;
   }
   
   public int orderUpdate(orderDTO dto) { //�ֹ����� ����
      int result = 0;
      
      try {
         conn = OracleConnection.getConnection();
         //주문완료시 orderinfo 테이블에 추가
         String sql = "insert into orderinfo values(orderinfo_seq.nextval,?,?,?,?,sysdate,?,?,'주문진행',?,?)";
         pstmt = conn.prepareStatement(sql);
         pstmt.setInt(1, dto.getproductNum()); //��ǰ��ȣ
         pstmt.setString(2, dto.getmemberID()); //�ֹ���ID
         pstmt.setString(3, dto.getreceive()); //���ɹ��
         pstmt.setString(4, dto.getpayment()); //��������
         pstmt.setInt(5, dto.getpricesum());
         pstmt.setInt(6, dto.getorderamount());
         pstmt.setString(7, dto.getordername());
         pstmt.setString(8, dto.getmobilenum());
         result += pstmt.executeUpdate();
         
         //구매완료된 상품은 장바구니에서 삭제
         sql = "delete from user_cart where user_cart.user_id=? and productn=?";
         pstmt= conn.prepareStatement(sql);
         pstmt.setString(1, dto.getmemberID());
         pstmt.setInt(2, dto.getproductNum());
         result += pstmt.executeUpdate();
         
         //구매완료된 상품의 판매량과 재고수량 수정
         sql = "update products set sales = "
         		+ " (select sum(orderamount) from orderinfo where productnum = ? ) "
         		+ ", stock = (stock-?) where productn = ?";
         pstmt = conn.prepareStatement(sql);
         pstmt.setInt(1, dto.getproductNum());
         pstmt.setInt(2, dto.getorderamount());
         pstmt.setInt(3, dto.getproductNum());
         result += pstmt.executeUpdate();
         
         System.out.println(result);
      }catch(Exception e) {
         e.printStackTrace();
      }finally {
         OracleConnection.closeConnection(rs, pstmt, conn);
      }
      return result;
   }
   
   public ArrayList<orderDTO> getorder(String id) { //주문내역 조회
      ArrayList<orderDTO> list = new ArrayList<orderDTO>();
      try {
         conn = OracleConnection.getConnection();
         String sql = "select * from orderinfo where memberid =?" ;
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, id);
         rs = pstmt.executeQuery();

         while(rs.next()) {
            orderDTO dto = new orderDTO();
            dto.setproductNum(rs.getInt("productNum"));
            dto.setmemberID(rs.getString("memberid"));
            dto.setreceive(rs.getString("receive"));
            dto.setpayment(rs.getString("payment"));
            dto.setorderDate(rs.getString("orderdate"));
            dto.setordercomplete(rs.getString("ordercomplete"));
            dto.setpricesum(rs.getInt("pricesum"));
            dto.setordername(rs.getString("ordername"));
            dto.setmobilenum(rs.getString("mobilenum"));
            list.add(dto);
         }
      }catch(Exception e) {
         e.printStackTrace();
      }finally {
         if(rs != null) {try {rs.close();}catch(SQLException e) {}}
         if(conn != null) {try {conn.close();}catch(SQLException e) {}}
         if(pstmt != null) {try {pstmt.close();}catch(SQLException e) {}}
      }
      return list;
   }
   public ArrayList<orderDTO> getBuyInfo(String id) { //구매내역 조회
	      ArrayList<orderDTO> list = new ArrayList<orderDTO>();
	      try {
	         conn = OracleConnection.getConnection();
	         String sql = "select * from orderinfo where memberid=? and ordercomplete ='수령완료' order by orderdate desc" ;
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1,id);
	         rs = pstmt.executeQuery();

	         while(rs.next()) {
	            orderDTO dto = new orderDTO();
	            dto.setproductNum(rs.getInt("productNum"));
	            dto.setmemberID(rs.getString("memberid"));
	            dto.setreceive(rs.getString("receive"));
	            dto.setpayment(rs.getString("payment"));
	            dto.setorderDate(rs.getString("orderdate"));
	            dto.setordercomplete(rs.getString("ordercomplete"));
	            dto.setpricesum(rs.getInt("pricesum"));
	            dto.setordername(rs.getString("ordername"));
	            dto.setmobilenum(rs.getString("mobilenum"));
	            dto.setorderamount(rs.getInt("orderamount"));
	            list.add(dto);
	         }
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         if(rs != null) {try {rs.close();}catch(SQLException e) {}}
	         if(conn != null) {try {conn.close();}catch(SQLException e) {}}
	         if(pstmt != null) {try {pstmt.close();}catch(SQLException e) {}}
	      }
	      return list;
	   }
   public ArrayList<orderDTO> getCheckBuyInfo(String id) { //구매내역 조회 수령완료가 아닌것들
	      ArrayList<orderDTO> list = new ArrayList<orderDTO>();
	      try {
	         conn = OracleConnection.getConnection();
	         String sql = "select * from orderinfo where memberid=? and not ordercomplete = '수령완료' order by orderdate desc" ;
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1,id);
	         rs = pstmt.executeQuery();

	         while(rs.next()) {
	            orderDTO dto = new orderDTO();
	            dto.setproductNum(rs.getInt("productNum"));
	            dto.setmemberID(rs.getString("memberid"));
	            dto.setreceive(rs.getString("receive"));
	            dto.setpayment(rs.getString("payment"));
	            dto.setorderDate(rs.getString("orderdate"));
	            dto.setordercomplete(rs.getString("ordercomplete"));
	            dto.setpricesum(rs.getInt("pricesum"));
	            dto.setorderamount(rs.getInt("orderamount"));
	            dto.setordername(rs.getString("ordername"));
	            dto.setmobilenum(rs.getString("mobilenum"));
	            list.add(dto);
	         }
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         if(rs != null) {try {rs.close();}catch(SQLException e) {}}
	         if(conn != null) {try {conn.close();}catch(SQLException e) {}}
	         if(pstmt != null) {try {pstmt.close();}catch(SQLException e) {}}
	      }
	      return list;
	   }
}