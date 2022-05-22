package wouldyoulike.board;

import java.util.ArrayList;

public interface BoardDAO {
	int boardCount(int productN);	// 페이징 처리에 사용. 글 개수 카운트하는 메서드
	int update(BoardDTO bdto);		// 글 수정시 사용되는 메서드
	BoardDTO information(int boardnum);	// 글번호에 해당하는 게시글의 모든 데이터를 읽어옴
	int delete(int boardNum);	// 글 삭제
	ArrayList<? extends BoardDTO> showList(int productN, int start, int end); //글 목록 보여주기(페이징 처리)
	int write(BoardDTO bdto);	//글 작성(댓글도 작성)
}
	