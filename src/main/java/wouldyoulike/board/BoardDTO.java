package wouldyoulike.board;

import java.sql.Timestamp;

public class BoardDTO {

	private int boardnum;			//글번호(sequence)
	private String boardwriter;		//작성자
	private Timestamp boardreg;		//작성시간
	private String boardimage;		//이미지 주소
	private String boardtitle;		//글 제목
	private String boardcontent;	//글내용
	private int boardcategory;		//게시판 종류
	
	public void setBoardnum(int boardnum) {this.boardnum = boardnum;}
	public void setBoardwriter(String boardwriter) {this.boardwriter = boardwriter;}
	public void setBoardreg(Timestamp boardreg) {this.boardreg = boardreg;}
	public void setBoardimage(String boardimage) {this.boardimage = boardimage;}
	public void setBoardtitle(String boardtitle) {this.boardtitle = boardtitle;}
	public void setBoardcontent(String boardcontent) {	
		//content가 null로 들어오면 ""로 리턴한다. 
		//null그대로 리턴할 경우 input tag에서 문자열 "null"로 나옴
		if(boardcontent == null) {
			this.boardcontent = "";
		}else {
			this.boardcontent = boardcontent;
		}
	}
	public void setBoardcategory(int boardcategory) {this.boardcategory = boardcategory;}
	
	
	public int getBoardnum() {return boardnum;}
	public String getBoardwriter() {return boardwriter;}
	public Timestamp getBoardreg() {return boardreg;}
	public String getBoardimage() {return boardimage;}
	public String getBoardtitle() {return boardtitle;}
	public String getBoardcontent() {return boardcontent;}
	public int getBoardcategory() {return boardcategory;}

	
}
