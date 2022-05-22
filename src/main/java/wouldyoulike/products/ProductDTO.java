package wouldyoulike.products;

import java.sql.Timestamp;
import java.util.Objects;

public class ProductDTO {
	//Products Table
	private int productN;	// 상품번호
	private String name;	// 상품이름
	private String brand;	// 상품 회사
	private String country;
	private String proCategory;	// 와인 카테고리
	private int wineSize;	// 용량
	private int price;	// 가격
	private int rating;	// 평점
	private int stock;	// 재고
	private double abv;	// 알콜농도
	private String promotion;	// 할인 여부
	private String loc;	// 판매 가능한 지점
	private String img; // 상품 이미지 저장경로
	private String reg; // 상품 입고날짜
	private int promoPrice; //할인 가격
	
	private String[] category; // 카테고리 필터
	private String[] countries;	// 원산지 필터
	private int minPrice; //최소가격
	private int maxPrice; //최대가격
	private int minSize; //최소 크기
	private int maxSize; //최대 크기
	private double maxAbv;	//최대 알콜
	
	private int reviews;	//리뷰개수
	private int sales;		//판매량

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getProCategory() {
		return proCategory;
	}
	public void setProCategory(String proCategory) {
		this.proCategory = proCategory;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public int getRating() {
		return rating;
	}
	public void setRating(int rating) {
		this.rating = rating;
	}
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
	public double getAbv() {
		return abv;
	}
	public void setAbv(double abv) {
		this.abv = abv;
	}
	public String getPromotion() {
		return promotion;
	}
	public void setPromotion(String promotion) {
		this.promotion = promotion;
	}
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
	public String getReg() {
		return reg;
	}
	public void setReg(String reg) {
		this.reg = reg;
	}
	public int getProductN() {
		return productN;
	}
	public void setProductN(int productN) {
		this.productN = productN;
	}
	public int getWineSize() {
		return wineSize;
	}
	public void setWineSize(int wineSize) {
		this.wineSize = wineSize;
	}
	public String getLoc() {
		return loc;
	}
	public void setLoc(String loc) {
		this.loc = loc;
	}
	public String[] getCountries() {
		return countries;
	}
	public void setCountries(String[] countries) {
		this.countries = countries;
	}
	public String[] getCategory() {
		return category;
	}
	public void setCategory(String[] category) {
		this.category = category;
	}
	public int getMinPrice() {
		return minPrice;
	}
	public void setMinPrice(int minPrice) {
		this.minPrice = minPrice;
	}
	public int getMaxPrice() {
		return maxPrice;
	}
	public void setMaxPrice(int maxPrice) {
		this.maxPrice = maxPrice;
	}
	public int getMinSize() {
		return minSize;
	}
	public void setMinSize(int minSize) {
		this.minSize = minSize;
	}
	public int getMaxSize() {
		return maxSize;
	}
	public void setMaxSize(int maxSize) {
		this.maxSize = maxSize;
	}
	public double getMaxAbv() {
		return maxAbv;
	}
	public void setMaxAbv(double maxAbv) {
		this.maxAbv = maxAbv;
	}
	public int getPromoPrice() {
		return promoPrice;
	}
	public void setPromoPrice(int promoPrice) {
		this.promoPrice = promoPrice;
	}
	public int getReviews() {
		return reviews;
	}
	public void setReviews(int reviews) {
		this.reviews = reviews;
	}
	public int getSales() {
		return sales;
	}
	public void setSales(int sales) {
		this.sales = sales;
	}
	
	
	@Override
	public int hashCode() {
		return Objects.hash(productN,proCategory); 
	}
	@Override 
	public boolean equals(Object o) {
		if(o instanceof ProductDTO) {
			ProductDTO dto = (ProductDTO) o;
			if(this.productN==dto.productN && this.proCategory.equals(dto.proCategory)) {
				return true;
			}
		}
		return false;
	}
	
	/*
	@Override
	public boolean equals(Object obj) {
		if(obj instanceof ProductDTO) {
			ProductDTO dto = (ProductDTO) obj;
			if(this.productN == dto.productN && this.name == dto.name) {
				return true;
			}
		}
		return false;
	}
	*/
	/*
	@Override
	public boolean equals(Object obj){
		if(this == obj) return true;
		if(obj == null || obj.getClass() != this.getClass())
			return false;
		
		ProductDTO dto = (ProductDTO) obj;
		
		return(dto.productN==this.productN && dto.name==this.name);
	}
	*/
	
}
