package wouldyoulike.board;

import java.util.ArrayList;

public interface MyPageable {
	int originalNum(int boardnum);
	int countWriter(String sid, int sDay);
	int countReply(int boardnum);
	ArrayList<? extends BoardDTO> showReply(int boardnum);
	ArrayList<? extends BoardDTO> showMyList(String id, int sDay, int start, int end);
}
