/*
 * 관리자 페이지에서 읽을수 있는 게시판 구현 목록
 * 메서드 목록
 * 	int originalNum (int boardnum);
 * 		파라미터로 글 번호를 받아와서 해당글이 답글이면 원글 번호 리턴(원글일 경우 0리턴)
 * 	
 * 	int countReply(int boardnum); 
 * 		파라미터로 글 번호를 받아와서 해당 글에 달린 답글 개수 리턴
 * 		페이징 처리할 때 사용되는 메서드
 * 
 * 	int countAdmin(int sDay, boolean haveReply);
 * 		showAdminList에 대해 페이징 처리할때 사용됨
 * 		글 개수 리턴
 *
 *	ArrayList showAdminList(int sDay ,int start, int end, boolean haveReply);
 *		관리자모드에서 글 읽을때 설정
 *		sDay파라미터는 최근 n일간의 글을 보여주는데 사용되는 변수
 *		haveReply 파라미터는 답글 달리지 않은 글만 보기 할때 사용되는 변수
 *		start,end 변수로 페이징처리까지 해준다
 */

package wouldyoulike.board;

import java.util.ArrayList;

public interface AdminPageable {
	int countNew(int sDay);
	int originalNum(int boardnum);
	int countReply(int boardnum);
	int countAdmin(int sDay, boolean haveReply);
	ArrayList<? extends BoardDTO> showAdminList(int sDay, int start, int end, boolean haveReply);
}
