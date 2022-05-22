package wouldyoulike.member;

import java.sql.*;

import wouldyoulike.jdbc.*;
import java.util.ArrayList;
import java.util.Date;

public class MemberDAO {
	
	   private Connection conn = null;
	   private PreparedStatement pstmt = null;
	   private ResultSet rs = null;

		public int[] countNewMember(int days) {
			int [] result = new int[2];
			
			try {
				Date date = new Date();
				Date date2 = new Date();
				date.setDate(date.getDate()-days);
				date2.setDate(date2.getDate()-2*days);
				
				conn = OracleConnection.getConnection();
				String sql = "select count(*) from member "
						+ " where reg between ? and sysdate ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setTimestamp(1, new Timestamp(date.getTime()));
				rs = pstmt.executeQuery();
				if(rs.next()) {
					result[0] = rs.getInt(1);
				}
				
				sql = "select count(*) from member "
						+ " where reg between ? and ? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setTimestamp(1, new Timestamp(date2.getTime()));
				pstmt.setTimestamp(2, new Timestamp(date.getTime()));
				rs = pstmt.executeQuery();
				if(rs.next()) {
					result[1] = rs.getInt(1);
				}
				
			}catch(Exception e) {
				
			}finally {
				OracleConnection.closeConnection(rs, pstmt, conn);
			}
			
			return result;
		}
		
	   // 회원수 카운트
	   public int memberCount() {
	         int result = 0;
	         try {
	            conn = OracleConnection.getConnection();
	            String sql = "select count(*) from member";
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
	   
	   // 회원 삭제
	   public int memberDelete(String id) {
			int result = 0;
			try {
				conn = OracleConnection.getConnection();
				String sql = "delete from member where id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				result = pstmt.executeUpdate();

			
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				OracleConnection.closeConnection(rs, pstmt, conn);
			}
			return result;
		}
		
		//회원 리스트 (페이지처리)
		public ArrayList<MemberDTO> memberList(int start, int end){
			ArrayList<MemberDTO> list = new ArrayList<MemberDTO>();
			try {
				conn = OracleConnection.getConnection();
				String sql = "select * from (select member.*, rownum r from (select * from member order by reg) member) where r>=? and r<=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					MemberDTO dto = new MemberDTO();
					dto.setId(rs.getString("id"));
					dto.setPw(rs.getString("pw"));
					dto.setName(rs.getString("name"));
					dto.setAddress(rs.getString("address"));
					dto.setBirth1(rs.getString("birth"));
					dto.setPhone1(rs.getString("phone"));
					dto.setEmail1(rs.getString("email"));
					dto.setReg(rs.getTimestamp("reg"));
					list.add(dto);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				OracleConnection.closeConnection(rs, pstmt, conn);
			}
			return list;
		}

	   
	   
	   public ArrayList<MemberDTO> all(){
		      ArrayList<MemberDTO> list = new ArrayList<MemberDTO>();
		      try {
		         conn = OracleConnection.getConnection();
		         String sql = "select * from member";
		         pstmt = conn.prepareStatement(sql);
		         rs = pstmt.executeQuery();
		         while(rs.next()) {
		            MemberDTO dto = new MemberDTO();
		            dto.setId(rs.getString("id"));
		            dto.setPw(rs.getString("pw"));
		            dto.setName(rs.getString("name"));
		            dto.setAddress(rs.getString("address"));
		            dto.setBirth(rs.getString("birth"));
		            dto.setPhone(rs.getString("phone"));
		            dto.setEmail(rs.getString("email"));
		            dto.setReg(rs.getTimestamp("reg"));
		            list.add(dto);
		         }
		      }catch(Exception e) {
		         e.printStackTrace();
		      }finally {
		         if(rs != null)try { rs.close(); }catch(SQLException e) {}
		         if(pstmt != null)try { pstmt.close(); }catch(SQLException e) {}
		         if(conn != null)try { conn.close(); }catch(SQLException e) {}
		      }
		      return list;
		   }

	  // ȸ������ �߰� 
	   public int insert(MemberDTO dto) {
	      int result = 0;
	      try {
	         conn = OracleConnection.getConnection();
	         String sql = "insert into member values(?,?,?,?,?,?,?,sysdate)";
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, dto.getId());
	         pstmt.setString(2, dto.getPw());
	         pstmt.setString(3, dto.getName());
	         pstmt.setString(4, dto.getAddress());
	         pstmt.setString(5, dto.getBirth());
	         pstmt.setString(6, dto.getPhone());
	         pstmt.setString(7, dto.getEmail());
	         result = pstmt.executeUpdate();
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         if(rs != null)try { rs.close(); }catch(SQLException e) {}
	         if(pstmt != null)try { pstmt.close(); }catch(SQLException e) {}
	         if(conn != null)try { conn.close(); }catch(SQLException e) {}
	      }
	      return result;
	   }
	   
	   // �α���
	   public int loginCheck(MemberDTO dto) {
			int result = 0;
			try {
				conn = OracleConnection.getConnection();
				String sql ="select * from member where id=? and pw=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, dto.getId());
				pstmt.setString(2, dto.getPw());
				rs = pstmt.executeQuery();
				if(rs.next()) {
					result=1;
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) {try { rs.close(); }catch(SQLException e) {}}
				if(pstmt != null) {try { pstmt.close(); }catch(SQLException e) {}}
				if(conn != null) {try { conn.close(); }catch(SQLException e) {}}
			}
			return result;
		}
}
