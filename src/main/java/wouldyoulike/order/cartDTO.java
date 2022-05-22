package wouldyoulike.order;

import java.sql.*;
import java.util.*;


public class cartDTO {
	private int productN;		//臾쇳뭹踰덊샇
	private int price;			//臾쇳뭹媛�寃�	
	private String memberID; 	// 二쇰Ц�븳怨좉컼ID
	private String name;		//臾쇳뭹�씠由�
	private String img; 		//�씠誘몄�;
	private int amount;
	
	 public void setamount(int amount) {
	      this.amount = amount;
	      }
	   
	   public int getamount() {
	      return amount;
	   }
	
	public void setproductN(int productN) {
		this.productN = productN;
		}
	public void setprice(int price) {
		this.price = price;
	}
	
	public void setmemberID(String memberID) {
		this.memberID = memberID;
		}
	public void setname(String name) {
		this.name = name;
		}
	public void setimg(String img) {
		this.img = img;
		}
	
	
	public int getprice() {
			return price;
		}
	public int getproductN() {
		return productN;
	}
	public String getname() {
		return name;
	}
	public String getmemberID() {
		return memberID;
	}
	public String getimg() {
		return img;
	}

	
	
}



