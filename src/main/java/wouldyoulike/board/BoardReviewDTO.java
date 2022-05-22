package wouldyoulike.board;

public class BoardReviewDTO extends BoardDTO{
	private int boardscore;		//리뷰 별점
	private int originalnum;	//답글인 경우 원글의 글번호
	private int productN;		//상품번호
	private String originalwriter; //답글인경우 원글의 작성자(비밀글 보기에 사용)
	
	public void setBoardscore(int boardscore) {this.boardscore = boardscore;}
	public void setBoardscore(String boardscore) {
		if(boardscore != null) {
			this.boardscore = Integer.parseInt(boardscore);
		}
	}
	public void setOriginalnum(int originalnum) {this.originalnum = originalnum;}
	public void setProductN(int productN) {this.productN = productN;}
	public void setProductN(String productN) {this.productN = Integer.parseInt(productN);}
	public void setOriginalwriter(String originalwriter) {this.originalwriter = originalwriter;}
	
	public int getBoardscore() {return boardscore;}
	public int getOriginalnum() {return originalnum;}
	public int getProductN() {return productN;}
	public String getOriginalwriter() {return originalwriter;}
	
}
