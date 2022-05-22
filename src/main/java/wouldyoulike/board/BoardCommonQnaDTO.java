package wouldyoulike.board;

public class BoardCommonQnaDTO extends BoardDTO {
	private String boardpw;			//글 비밀번호
	private int originalnum;		//답글인경우 원글의 글번호
	private String originalwriter;	//답글인경우 원글의 작성자
	
	public void setBoardpw(String boardpw) {this.boardpw = boardpw;}
	public void setOriginalnum(int originalnum) {this.originalnum = originalnum;}
	public void setOriginalwriter(String originalwriter) {this.originalwriter = originalwriter;}
	
	public String getBoardpw() {return boardpw;}
	public int getOriginalnum() {return originalnum;}
	public String getOriginalwriter() {return originalwriter;}
	
}
