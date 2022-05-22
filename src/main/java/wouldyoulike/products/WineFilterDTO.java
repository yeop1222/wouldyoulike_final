package wouldyoulike.products;

public class WineFilterDTO {
	private int productN; // 상품번호
	private String variental; // 세분화된 와인 종류
	private int sweetness; 	//단맛 (1~5)
	private int wineBody;	//바디감 (1~5)
	private int acidity;	//산미 (1~5)
	private int tannins;	//탄닌 (1~5)
	private int vqa; // VQA 인증됨 -1 , 안됨 -1
	
	
	public int getProductN() {
		return productN;
	}
	public void setProductN(int productN) {
		this.productN = productN;
	}
	public String getVariental() {
		return variental;
	}
	public void setVariental(String variental) {
		/* 와인 variental을 어떻게 저장하면 좋을지 고민
		String[] a = variental.split(" ");
		for(int i=0;i<a.length;i++) {
			String first = a[i].substring(0, 1);
			
		}
		*/
		this.variental = variental;
	}
	public int getSweetness() {
		return sweetness;
	}
	public void setSweetness(int sweetness) {
		this.sweetness = sweetness;
	}
	public int getWineBody() {
		return wineBody;
	}
	public void setWineBody(int wineBody) {
		this.wineBody = wineBody;
	}
	public int getAcidity() {
		return acidity;
	}
	public void setAcidity(int acidity) {
		this.acidity = acidity;
	}
	public int getTannins() {
		return tannins;
	}
	public void setTannins(int tannins) {
		this.tannins = tannins;
	}
	public int getVQA() {
		return vqa;
	}
	public void setVQA(int vqa) {
		this.vqa = vqa;
	}
	
	
}
