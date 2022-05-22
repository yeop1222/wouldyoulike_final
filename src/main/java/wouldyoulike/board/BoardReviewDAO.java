/*
 * BoardReviewDAO
 * 상품 리뷰 게시판 DAO
 * 
 * implemented Interface
 * BoardDAO			게시판 공통 메서드 구현
 * MyPageable		마이페이지 관련 메서드 구현
 * AdminPageable	관리자페이지 관련 메서드 구현
 */
package wouldyoulike.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import wouldyoulike.jdbc.OracleConnection;

public class BoardReviewDAO implements BoardDAO, MyPageable, AdminPageable {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	

	/*
	 * int countNew(int sDay);
	 * 파라미터 
	 * 		nDay = n일전 데이터 읽기
	 * 리턴
	 * 		n일 이내 관리자 답글이 달리지 않은 게시글 갯수 카운트
	 */
	@Override
	public int countNew(int sDay) {
		int result = 0;
		
		try {
			conn = OracleConnection.getConnection();
			String sql = "select count(*) from board b, boardreview q "
							+ " where b.boardnum=q.boardnum "
							+ " and q.originalnum is null "
							+ " and b.boardreg between sysdate-? and sysdate "
							+ " and b.boardnum not in"
								+ "	(select distinct q.originalnum "
								+ " from board b, boardreview q "
									+ " where b.boardnum=q.boardnum "
									+ " and b.boardwriter='admin' "
									+ " and q.originalnum is not null) ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, sDay);
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
	 * int countAdmin(int sDay, boolean haveReply);
	 * 	파라미터
	 * 		sDay = n일 전 데이터 읽기
	 * 		haveReply 관리자 댓글 안달린 글만 보기
	 * 	리턴
	 * 		showAdminList 관련 페이징할때 글 개수 리턴
	 * 	설명
	 * 		AdminPageable 인터페이스 구현
	 * 		showAdminList 관련 페이징할때 글 개수 카운트할때 필요한 메서드
	 */	
	public int countAdmin(int sDay, boolean haveReply) {
		int result = 0;
		
		try {
			Date date = new Date();
			date.setDate(date.getDate()-sDay);
			conn = OracleConnection.getConnection();

			String sql = "select count(*) from board b, boardreview r "
					+ " where b.boardnum=r.boardnum "
					+ " and r.originalnum is null "
					+ " and b.boardreg between ? and sysdate ";
			if(haveReply) {
				sql += " and b.boardnum not in ("
						+ " select r.originalnum "
						+ " from board b, boardreview r "
						+ " where b.boardnum = r.boardnum "
						+ " group by r.originalnum "
						+ " having originalnum is not null) ";
			}
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setTimestamp(1, new Timestamp(date.getTime()));
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
	 * ArrayList<BoardCommonQnaDTO> showAdminList(int sDay, int start, int end, boolean haveReply)
	 * 	파라미터
	 * 		sDay = n일전 데이터 읽기
	 * 		start / end 페이징 처리할때 필요한 변수
	 * 		haveReply 관리자 답글 안달린 글만 보기
	 * 	리턴
	 * 		list = 관리자페이지에서 글 읽을때 내용 리턴
	 * 	설명
	 * 		AdminPageable 인터페이스 구현
	 * 		관리자페이지에서 글 읽을때 내용 리스트 형식으로 리턴
	 * 		
	 */
	public ArrayList<BoardReviewDTO> showAdminList(int sDay, int start, int end, boolean haveReply){
		ArrayList<BoardReviewDTO> list = new ArrayList<BoardReviewDTO>();
		
		try {
			Date date = new Date();
			date.setDate(date.getDate()-sDay);
			conn = OracleConnection.getConnection();
			String sql = "select * from "
					+ " (select bbb.*, rownum r from "
					+ " (select b.*, r.boardscore, r.originalnum, r.productn from board b, boardreview r "
					+ " where b.boardnum=r.boardnum "
					+ " and r.originalnum is null "
					+ " and b.boardreg between ? and sysdate ";
			if(haveReply) {
				sql += " and b.boardnum not in ("
						+ " select r.originalnum "
						+ " from board b, boardreview r "
						+ " where b.boardnum = r.boardnum "
						+ " group by r.originalnum "
						+ " having originalnum is not null) ";
			}
			sql += " order by b.boardnum desc ) bbb ) "
					+ " where r>=? and r<=?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setTimestamp(1, new Timestamp(date.getTime()));
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				BoardReviewDTO dto = new BoardReviewDTO();
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setBoardwriter(rs.getString("boardwriter"));
				dto.setBoardreg(rs.getTimestamp("boardreg"));
				dto.setBoardimage(rs.getString("boardimage"));
				dto.setBoardtitle(rs.getString("boardtitle"));
				dto.setBoardcontent(rs.getString("boardcontent"));
				dto.setOriginalnum(rs.getInt("originalnum"));
				dto.setProductN(rs.getInt("productn"));
				dto.setBoardscore(rs.getInt("boardscore"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		
		return list;
	}
	
	/*
	 * int originalNum(int boardnum)
	 * 	파라미터
	 * 		boardnum 글 번호
	 * 	리턴
	 * 		답글인경우 원글 번호 리턴
	 * 	설명
	 * 		AdminPageable 인터페이스 구현
	 * 		MyPageable 인터페이스 구현
	 * 		원글인경우 0 리턴
	 * 		
	 */	
	@Override
	public int originalNum(int boardnum) {
		int result = 0;
		
		try {
			conn = OracleConnection.getConnection();
			String sql="select originalnum from boardreview "
					+ " where boardnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
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
	 * int countWriter(String sid, int sDay)
	 * 	파라미터
	 * 		sid 작성자 아이디
	 * 		sDay 최근 n일간 글 읽음
	 * 	리턴
	 * 		작성자 글 개수 리턴
	 * 	설명
	 * 		MyPageable 인터페이스 구현
	 * 		페이징 처리에 사용되는 메서드(글 개수 카운트)
	 * 		
	 */	
	@Override
	public int countWriter(String sid, int sDay) {
		int result = 0;
		
		try {
			conn = OracleConnection.getConnection();
			Date date = new Date();
			date.setDate(date.getDate()-sDay);
			
			String sql="select count(*) from board b, boardreview r "
					+ " where b.boardnum=r.boardnum "
					+ " and b.boardwriter=? "
					+ " and r.originalnum is null "
					+ " and b.boardreg between ? and sysdate";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, sid);
			pstmt.setTimestamp(2, new Timestamp(date.getTime()));
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
	 * int countReply(int boardnum)
	 * 	파라미터
	 * 		boardnum 게시글 번호
	 * 	리턴
	 * 		해당 글에 달린 관리자 답글 개수 리턴
	 * 	설명
	 * 		MyPageable 인터페이스 구현
	 * 		AdminPageable 인터페이스 구현
	 * 		글에서 관리자 답글 달린것의 개수 구하는 메서드
	 * 		마이페이지에서 제목옆에 답글 달린것 확인할수도 있고
	 * 		관리자페이지에서 답글 안달린 글(새글) 관리하는데도 사용될수 있음
	 * 		
	 */	
	@Override
	public int countReply(int boardnum) {
		int result = 0;
		
		try {
			conn = OracleConnection.getConnection();
			String sql=" select count(*) from board b, boardreview r "
					+ " where b.boardnum = r.boardnum "
					+ " and r.originalnum=? "
					+ " and b.boardwriter = 'admin' ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
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
	 * ArrayList<BoardCommonQnaDTO> showReply(int boardnum)
	 * 	파라미터
	 * 		boardnum 게시글 번호
	 * 	리턴
	 * 		해당 게시글(원글)과 그 글에 달린 답글을 sorting해서 보여줌
	 * 	설명
	 * 		MyPageable 인터페이스 구현
	 * 		list페이지 option==2 일때 이 메서드로 목록 읽어옴(다형성)
	 * 		페이징 처리 필요없어서 start/end 파라미터는 없다
	 * 		
	 */	
	@Override
	public ArrayList<BoardReviewDTO> showReply(int boardnum) {
		ArrayList<BoardReviewDTO> list = new ArrayList<BoardReviewDTO>();
		
		try {
			conn = OracleConnection.getConnection();
			String sql="select * from board b, boardreview r "
					+ " where b.boardnum=r.boardnum "
					+ " and (b.boardnum=? "
					+ " or r.originalnum=? ) "
					+ " order by b.boardnum asc ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
			pstmt.setInt(2, boardnum);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				BoardReviewDTO dto = new BoardReviewDTO();
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setBoardwriter(rs.getString("boardwriter"));
				dto.setBoardreg(rs.getTimestamp("boardreg"));
				dto.setBoardimage(rs.getString("boardimage"));
				dto.setBoardtitle(rs.getString("boardtitle"));
				dto.setBoardcontent(rs.getString("boardcontent"));
				dto.setBoardscore(rs.getInt("boardscore"));
				dto.setOriginalnum(rs.getInt("originalnum"));
				dto.setProductN(rs.getInt("productn"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		
		return list;
	}
	
	/*
	 * ArrayList<BoardCommonQnaDTO> showMyList(String id, int sDay, int start, int end)
	 * 	파라미터
	 * 		id = 목록 불러올 작성자 id
	 * 		sDay = n일 이내 글만 불러오기
	 * 		start/end 페이징 처리 관련 파라미터
	 * 	리턴
	 * 		list페이지 option==1일때 이 메서드로 목록 읽어옴
	 * 	설명
	 * 		MyPageable 인터페이스 구현
	 * 		마이페이지에서 자기가 작성한 글 읽어오는 메서드(다형성)
	 * 		
	 */	
	@Override
	public ArrayList<BoardReviewDTO> showMyList(String id, int sDay, int start, int end) {
		ArrayList<BoardReviewDTO> list = new ArrayList<BoardReviewDTO>();
		
		try {
			conn = OracleConnection.getConnection();
			Date date = new Date();
			date.setDate(date.getDate()-sDay);
			
			String sql="select * from "
					+ " (select bbb.*, rownum r from "
					+ " (select b.*, r.boardscore, r.originalnum, r.productn from board b, boardreview r "
					+ " where b.boardnum = r.boardnum "
					+ " and b.boardwriter = ?"
					+ " and b.boardreg between ? and sysdate "
					+ " and r.originalnum is null "
					+ " order by b.boardnum desc) bbb) "
					+ " where r>=? and r<=? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setTimestamp(2, new Timestamp(date.getTime()));
			pstmt.setInt(3, start);
			pstmt.setInt(4, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				BoardReviewDTO dto = new BoardReviewDTO();
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setBoardwriter(rs.getString("boardwriter"));
				dto.setBoardreg(rs.getTimestamp("boardreg"));
				dto.setBoardimage(rs.getString("boardimage"));
				dto.setBoardtitle(rs.getString("boardtitle"));
				dto.setBoardcontent(rs.getString("boardcontent"));
				dto.setBoardscore(rs.getInt("boardscore"));
				dto.setOriginalnum(rs.getInt("originalnum"));
				dto.setProductN(rs.getInt("productn"));
				list.add(dto);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		
		return list;
	}

	/*
	 * int boardCount(int productN)
	 * 	파라미터
	 * 		상품 번호
	 * 	리턴
	 * 		해당 상품에 달린 리뷰 개수 리턴
	 * 	설명
	 * 		BoardDAO 인터페이스 구현
	 * 		페이징 처리를 위해서 글 개수 카운트
	 * 		
	 */		
	@Override
	public int boardCount(int productN) {
		int result = 0;
		
		try {
			conn = OracleConnection.getConnection();
			String sql = "select count(*) from boardreview where productn=?";
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
		int result = 0;
		
		try {
			conn = OracleConnection.getConnection();
			//원글인지 답글인지 확인하는 변수
			//원글이면 밑에 딸린 답글까지 모두 삭제할거임
			boolean isOriginal = false; 
			String sql = "select originalnum from boardreview where boardnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardNum);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1) == null) {
					isOriginal = true;
				}
			}
			
			//board table에서 삭제
			sql = "delete from board "
					+ " where boardnum in (select boardnum from boardreview "
					+ " where boardnum=? "
					+ (isOriginal ? "or originalnum=? ) " : " ) ") ;
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardNum);
			if(isOriginal) {
				pstmt.setInt(2, boardNum);
			}
			result = pstmt.executeUpdate();
			if(result == 0) {
				return 0;
			}
			
			//boardreview table에서 삭제
			sql = "delete from boardreview where boardnum=? "
					+ (isOriginal ? " or originalnum=? " : " ");
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardNum);
			if(isOriginal) {
				pstmt.setInt(2, boardNum);
			}
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
	public BoardReviewDTO information(int boardnum) {
		BoardReviewDTO dto = new BoardReviewDTO();
		
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from board b, boardreview r "
					+ " where b.boardnum=r.boardnum "
					+ " and b.boardnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
			rs= pstmt.executeQuery();
			if(rs.next()) {
				dto.setBoardcategory(1);
				dto.setBoardcontent(rs.getString("boardcontent"));
				dto.setBoardimage(rs.getString("boardimage"));
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setBoardreg(rs.getTimestamp("boardreg"));
				dto.setBoardscore(rs.getInt("boardscore"));
				dto.setBoardtitle(rs.getString("boardtitle"));
				dto.setBoardwriter(rs.getString("boardwriter"));
				dto.setOriginalnum(rs.getInt("originalnum"));
				dto.setProductN(rs.getInt("productn"));
				
				sql = "select boardwriter from board b, boardreview r "
						+ " where b.boardnum = r.originalnum "
						+ " and r.boardnum=? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, boardnum);
				ResultSet rs2 = pstmt.executeQuery();
				if(rs2.next()) {
					dto.setOriginalwriter(rs2.getString(1));					
				}
				if(rs2 != null) {
					rs2.close();
				}
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
	public ArrayList<BoardReviewDTO> showList(int productN, int start, int end) {
		ArrayList<BoardReviewDTO> list = new ArrayList<BoardReviewDTO>();

		try {
			conn = OracleConnection.getConnection();
			String sql = " select * from board b, boardreview r "
					+ " where b.boardnum = r.boardnum "
					+ " and r.productn=? "
					+ " order by r.boardnum desc";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			rs = pstmt.executeQuery();
			
			ArrayList<BoardReviewDTO> reply = new ArrayList<BoardReviewDTO>();
			while(rs.next()) {
				BoardReviewDTO dto = new BoardReviewDTO();
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setBoardwriter(rs.getString("boardwriter"));
				dto.setBoardreg(rs.getTimestamp("boardreg"));
				dto.setBoardimage(rs.getString("boardimage"));
				dto.setBoardtitle(rs.getString("boardtitle"));
				dto.setBoardcontent(rs.getString("boardcontent"));
				dto.setBoardscore(rs.getInt("boardscore"));
				dto.setOriginalnum(rs.getInt("originalnum"));
				dto.setProductN(rs.getInt("productn"));
				
				//답글인 경우 원글의 작성자를 찾아서 originalwriter 에 대입
				sql = "select boardwriter from board b, boardreview r "
						+ " where b.boardnum = r.originalnum "
						+ " and r.boardnum=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, rs.getInt("boardnum"));
				ResultSet rs2 = pstmt.executeQuery();
				
				if(rs2.next()) {
					dto.setOriginalwriter(rs2.getString(1));
				}
				if(rs2!=null) {
					rs2.close();
				}
				
				//원글 아래에 답글이 달리도록 list배치
				if(dto.getOriginalnum() != 0) {
					reply.add(0,dto);
				}else {
					list.add(dto);
					for(Iterator<BoardReviewDTO> i = reply.iterator(); i.hasNext();) {
						BoardReviewDTO d = i.next();
						if(d.getOriginalnum() == dto.getBoardnum()) {
							list.add(d);
							i.remove();
						}
					}
				}
			}
			
			//페이징을 위한 subList
			List<BoardReviewDTO> tempList = new ArrayList<BoardReviewDTO>(list.subList(start-1, end));
			list = (ArrayList<BoardReviewDTO>)tempList;
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
		BoardReviewDTO dto = (BoardReviewDTO)bdto;
		int result = 0;
		
		try {
			conn = OracleConnection.getConnection();
			//board table에 데이터 업데이트
			String sql = "update board set "
					+ " boardtitle = ?, boardcontent=?, boardimage=? "
					+ " where boardnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getBoardtitle());
			pstmt.setString(2, dto.getBoardcontent());
			pstmt.setString(3, dto.getBoardimage());
			pstmt.setInt(4, dto.getBoardnum());
			result = pstmt.executeUpdate();
			if(result!=1) {
				return 0;
			}
			
			//boardreview table에 데이터 업데이트
			sql = "update boardreview set boardscore=? where boardnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getBoardscore());
			pstmt.setInt(2, dto.getBoardnum());
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
		BoardReviewDTO dto = (BoardReviewDTO)bdto;
		int result = 0;
		
		try {
			conn = OracleConnection.getConnection();
			//board table에 저장
			String sql = "insert into board "
					+ " values(board_seq.nextval, ?, sysdate, ?, ?, ?, 1)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getBoardwriter());
			pstmt.setString(2, dto.getBoardimage());
			pstmt.setString(3, dto.getBoardtitle());
			pstmt.setString(4, dto.getBoardcontent());
			result = pstmt.executeUpdate();
			if(result != 1) {
				return 0;
			}
			
			//방금 저장한 글의 boardnum 값 maxnum변수에 저장
			int maxnum = 0;
			sql = "select max(boardnum) from board";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				maxnum = rs.getInt(1);
			}
			if(maxnum == 0) {
				return 0;
			}
			
			//table boardreview에 저장
			sql = "insert into boardreview(boardnum, boardscore, productn) "
					+ " values (?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, maxnum);
			pstmt.setInt(2, dto.getBoardscore());
			pstmt.setInt(3, dto.getProductN());
			result = pstmt.executeUpdate();
			// board에는 들어갔는데 boardreview에는 삽입 오류 => board에 데이터를 지운다
			if(result != 1) {
				sql = "delete from board where boardnum=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, maxnum);
				return 0;
			}
			
			//답글인경우 원글의 boardnum을 originalnum에 대입
			if(dto.getOriginalnum() > 0) {
				sql = "update boardreview set originalnum=? where boardnum=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, dto.getOriginalnum());
				pstmt.setInt(2, maxnum);
				result = pstmt.executeUpdate();
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		
		return result;
	}
}
