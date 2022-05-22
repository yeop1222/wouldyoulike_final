package wouldyoulike.order;

import java.sql.*;
import java.util.*;

import wouldyoulike.jdbc.*;

public class cartDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	

	public int productPrice (int productN) {
		int price = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select price, promotion, promoprice from products where productn=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString("promotion").equals("Y")) {
					price = rs.getInt("promoprice");
				}else {
					price = rs.getInt("price");
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally{
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return price;
	}

	
	public int cartUpdate(int productN, String id, int amount) {
        int result = 0;
        cartDTO dto = new cartDTO();
        
        try {
           conn = OracleConnection.getConnection();
           String sql = "select * from products where productn=?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, productN);
           rs = pstmt.executeQuery();
           if(rs.next()) {
        	   if(rs.getString("promotion").equalsIgnoreCase("y")) {
        		   dto.setprice(rs.getInt("promoprice"));
        	   }else {
        		   dto.setprice(rs.getInt("price"));
        	   }
              dto.setproductN(rs.getInt("productn"));
              dto.setname(rs.getString("name"));
              dto.setimg(rs.getString("img"));
           }

           sql = "select * from user_cart where productn=? and user_id=?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, productN);
           pstmt.setString(2,id);
           rs= pstmt.executeQuery();
           
           if(rs.next()) { 
        	   
              sql = "update user_cart set amount =?  where productn=? and user_id =?";
              pstmt = conn.prepareStatement(sql);
              pstmt.setInt(1, rs.getInt("amount") + amount);
              pstmt.setInt(2, productN);
              pstmt.setString(3,id);
                result = pstmt.executeUpdate();
           }else {

               sql = "insert into user_cart values(?,?,?,?,?,?)";
               pstmt = conn.prepareStatement(sql);
               
               pstmt.setInt(1, productN); //
               pstmt.setString(2, id); //
               pstmt.setInt(3, dto.getprice()); //
               pstmt.setString(4, dto.getname());
               pstmt.setString(5, dto.getimg());//
               pstmt.setInt(6, amount);
               
               result = pstmt.executeUpdate();
           }
           
           
           
        }catch(Exception e) {
           e.printStackTrace();
        }finally {
           OracleConnection.closeConnection(rs, pstmt, conn);
        }
        return result;
     
	}
	
	
	
	public ArrayList<cartDTO> getcartInfo(String id){
		ArrayList<cartDTO> list = new ArrayList<cartDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from user_cart where user_id = '" + id + "'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
			cartDTO dto = new cartDTO();
			dto.setproductN(rs.getInt("productn"));
			dto.setprice(rs.getInt("price"));
			dto.setname(rs.getString("name"));
			dto.setimg(rs.getString("img"));
			dto.setmemberID(rs.getString("user_id"));
			dto.setamount(rs.getInt("amount"));
			list.add(dto);
			
			}
		
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	
	
}
	
	public cartDTO cartInfo(int num){
		cartDTO dto = new cartDTO();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from user_cart where productN =?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
			dto.setproductN(rs.getInt("productn"));
			dto.setprice(rs.getInt("price"));
			dto.setname(rs.getString("name"));
			dto.setimg(rs.getString("img"));
			dto.setmemberID(rs.getString("user_id"));
			
			}
		
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return dto;
	
	
}
	
	
	public cartDTO deletecartInfo(int productN,String id){
		cartDTO dto = new cartDTO();
		try {
			conn = OracleConnection.getConnection();
			String sql = "delete from user_cart where productN = " + productN + " and user_id = '"+id+ "'" ;
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
		
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return dto;
	
	
}
}