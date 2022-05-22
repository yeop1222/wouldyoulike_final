package wouldyoulike.board;

public class BoardProdQnaDTO extends BoardDTO {
	private String boardpw;			//비밀번호(있으면 "on" 없으면 null)
	private int originalnum;		//답글인 경우 원글의 글번호
	private int productN;			//상품번호
	private String originalwriter;	//답글인 경우 원글의 작성자(비밀글 보기에 사용)
	
	public void setBoardpw(String boardpw) {this.boardpw = boardpw;}
	public void setOriginalnum(int originalnum) {this.originalnum = originalnum;}
	//overloading
	public void setProductN(int productN) {this.productN = productN;}
	public void setProductN(String productN) {this.productN = Integer.parseInt(productN);}
	
	public void setOriginalwriter(String originalwriter) {this.originalwriter = originalwriter;}

	
	public String getBoardpw() {return boardpw;}
	public int getOriginalnum() {return originalnum;}
	public int getProductN() {return productN;}

	public String getOriginalwriter() {return originalwriter;}
	
}
