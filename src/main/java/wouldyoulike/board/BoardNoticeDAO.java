/*
 * BoardNoticeDAO
 * 공지사항 게시판 DAO
 * 
 * implemented Interface
 * BoardDAO			게시판 공통 메서드 구현
 */
package wouldyoulike.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import wouldyoulike.jdbc.OracleConnection;

public class BoardNoticeDAO implements BoardDAO {
	private Connection conn=null;
	private PreparedStatement pstmt=null;
	private ResultSet rs = null;

	/*
	 * int boardCount(int productN)
	 * 	파라미터
	 * 		더미데이터 (0)
	 * 	리턴
	 * 		해당 상품에 달린 리뷰 개수 리턴
	 * 	설명
	 * 		BoardDAO 인터페이스 구현
	 * 		페이징 처리를 위해서 글 개수 카운트
	 * 		productN에는 값 0 들어오고 사용되지는 않음
	 */	
	@Override
	public int boardCount(int productN) {
		int result=0;
		
		try {
			conn = OracleConnection.getConnection();
			String sql="select count(*) from board where boardcategory=3";
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

	/*
	 * int delete(int boardNum)
	 * 	파라미터
	 * 		boardnum 글 번호
	 * 	리턴
	 * 		글이 삭제된 개수(답글이 달린경우 1보다 클수있음), 에러시 0
	 * 	설명
	 * 		BoardDAO 인터페이스 구현
	 * 		글을 삭제하고 해당 글에 답글이 달린 경우 답글까지 모두 삭제함
	 * 		
	 */	
	@Override
	public int delete(int boardNum) {
		int result=0;
		
		try {
			conn = OracleConnection.getConnection();
			String sql="delete from board "
					+ " where boardcategory=3 "
					+ "	and boardnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardNum);
			result = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		
		return result;
	}

	/*
	 * BoardCommonQnaDTO information(int boardnum)
	 * 	파라미터
	 * 		boardnum 글 번호
	 * 	리턴
	 * 		boardnum에 해당하는 글의 모든 정보를 DTO로 넘겨준다
	 * 	설명
	 * 		BoardDAO 인터페이스 구현(다형성)
	 * 		
	 */	
	@Override
	public BoardNoticeDTO information(int boardnum) {
		BoardNoticeDTO dto = new BoardNoticeDTO();
		
		try {
			conn = OracleConnection.getConnection();
			String sql="select * from board "
					+ " where boardcategory=3 "
					+ " and boardnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dto.setBoardcategory(3);
				dto.setBoardcontent(rs.getString("boardcontent"));
				dto.setBoardimage(rs.getString("boardimage"));
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setBoardreg(rs.getTimestamp("boardreg"));
				dto.setBoardtitle(rs.getString("boardtitle"));
				dto.setBoardwriter(rs.getString("boardwriter"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		
		return dto;
	}

	/*
	 * ArrayList<BoardCommonQnaDTO> showList(int productN, int start, int end)
	 * 	파라미터
	 * 		productN 상품명 
	 * 		start/end 페이징 처리를 위한 변수들
	 * 	리턴
	 * 		productN 상품에 달린 문의글 목록을 리스트형태로 리턴(다형성)
	 * 	설명
	 * 		BoardDAO 인터페이스 구현
	 * 		list.jsp option==0일때 사용되는 메서드
	 * 		
	 */	
	@Override
	public ArrayList<BoardNoticeDTO> showList(int productN, int start, int end) {
		ArrayList<BoardNoticeDTO> list = new ArrayList<BoardNoticeDTO>();
		
		try {
			conn = OracleConnection.getConnection();
			String sql="select * from board where boardcategory=3 "
					+ " order by boardnum desc";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				BoardNoticeDTO dto = new BoardNoticeDTO();
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setBoardwriter(rs.getString("boardwriter"));
				dto.setBoardreg(rs.getTimestamp("boardreg"));
				//dto.setBoardimage(rs.getString("boardimage"));
				dto.setBoardtitle(rs.getString("boardtitle"));
				//dto.setBoardcontent(rs.getString("boardcontent"));
				list.add(dto);
			}
			
			//페이징 처리는 sublist로 불러오기
			List<BoardNoticeDTO> tempList = new ArrayList<BoardNoticeDTO>(list.subList(start-1, end));
			list = (ArrayList<BoardNoticeDTO>)tempList;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		
		return list;
	}

	/*
	 * int update(BoardDTO bdto)
	 * 	파라미터
	 * 		bdto 수정할 글의 dto => 다형성
	 * 	리턴
	 * 		업데이트 됐으면 1 아니면 0
	 * 	설명
	 * 		BoardDAO 인터페이스 구현
	 * 		게시글 수정에 사용되는 메서드
	 * 		
	 */	
	@Override
	public int update(BoardDTO bdto) {
		BoardNoticeDTO dto = (BoardNoticeDTO)bdto;
		int result=0;
		
		try {
			conn = OracleConnection.getConnection();
			String sql="update board set "
					+ " boardtitle=?, "
					+ " boardcontent=?, "
					+ " boardimage=? "
					+ " where boardnum=?";
			pstmt= conn.prepareStatement(sql);
			pstmt.setString(1, dto.getBoardtitle());
			pstmt.setString(2, dto.getBoardcontent());
			pstmt.setString(3, dto.getBoardimage());
			pstmt.setInt(4, dto.getBoardnum());
			result = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		
		return result;
	}
	
	/*
	 * int write(BoardDTO bdto)
	 * 	파라미터
	 * 		bdto 작성할 글의 정보 (다형성)
	 * 	리턴
	 * 		글이 작성되었으면 1 아니며 0
	 * 	설명
	 * 		BoardDAO 인터페이스 구현
	 * 		table board, table boardcommonqna 에 데이터를 추가함
	 * 		답글이 달릴때도 이 메서드가 사용됨(originalnum에 원글번호가 추가됨)
	 * 		
	 */	
	@Override
	public int write(BoardDTO bdto) {
		BoardNoticeDTO dto = (BoardNoticeDTO)bdto;
		int result=0;
		
		try {
			conn = OracleConnection.getConnection();
			String sql="insert into board "
					+ " values(board_seq.nextval, ?, sysdate, ?, ?, ?, 3)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getBoardwriter());
			pstmt.setString(2, dto.getBoardimage());
			pstmt.setString(3, dto.getBoardtitle());
			pstmt.setString(4, dto.getBoardcontent());
			result = pstmt.executeUpdate();
			if(result != 1) {
				return 0;
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		
		return result;
	}
}
