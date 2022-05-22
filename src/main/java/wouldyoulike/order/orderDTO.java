package wouldyoulike.order;

import java.sql.Timestamp;


public class orderDTO {
	private int orderNum;		//�ֹ���ȣ(sequence)
	private int productNum;		//��ǰ��ȣ
	private String orderDate;//�ۼ��ð�	
	private String memberID; 	// �ֹ��� ��ID
	private String receive;		//���ɹ��
	private String payment; 	//�������;]
	private String ordercomplete;
	private int orderamount;
	private int pricesum;
	private int price;
	private String ordername;
	private String mobilenum;
	
	public void setordername(String ordername) {
		this.ordername = ordername;
		}

	public void setmobilenum(String mobilenum) {
		this.mobilenum = mobilenum;
		}
	
	public void setorderNum(int orderNum) {
		this.orderNum = orderNum;
		}
	public void setprice(int price) {
		this.price = price;
		}
	public void setorderamount(int orderamount) {
		this.orderamount = orderamount;
		}
	public void setpricesum(int pricesum) {
		this.pricesum = pricesum;
		}
	public void setordercomplete(String ordercomplete) {
		this.ordercomplete = ordercomplete;
		}
	public void setproductNum(int productNum) {
		this.productNum = productNum;
		}
	public void setorderDate(String orderDate) {
		this.orderDate = orderDate;
		}
	public void setmemberID(String memberID) {
		this.memberID = memberID;
		}
	public void setreceive(String receive) {
		this.receive = receive;
		}
	public void setpayment(String payment) {
		this.payment = payment;
		}
	
	
	public String getordername() {
		return ordername;
		}
	
	public String getmobilenum() {
		return mobilenum;
		}
	
	public int getorderamount() {
		 return orderamount;
		}
	public int getprice() {
		return price;
		}
	public int getpricesum() {
		return pricesum;
		}
	public String getordercomplete() {
		return ordercomplete;
	}	
	public int getorderNum() {
		return orderNum;
	}
	public int getproductNum() {
		return productNum;
	}
	public String getorderDate() {
		return orderDate;
	}
	public String getmemberID() {
		return memberID;
	}
	public String getreceive() {
		return receive;
	}
	public String getpayment() {
		return payment;
	}
	
	public String toString() {
		return ""+orderNum + " "
		+productNum + " "
		+ orderDate + " "
		+memberID + " "
		+ receive + " "
		+ payment + " "
		+ ordercomplete + " "
		+orderamount + " "
		+ pricesum + " "
		+ price + " "
		+mobilenum + " "
		+ ordername;
	}
}



