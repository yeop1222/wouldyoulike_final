package wouldyoulike.member;

import java.sql.Timestamp;

public class MemberDTO {
	private String id;
	private String pw;
	private String name;
	private String birth;
	private String birth1;
	private String birth2;
	private String birth3;
	private String address;
	private String email;
	private String email1;
	private String email2;
	private String phone;
	private String phone1;
	private String phone2;
	private String phone3;
	private String phone4;
	private Timestamp reg;
			   			   
	public String getId() {return id;}
	
	public void setPhone(String phone) {this.phone = phone; }
	public void setBirth(String birth) {this.birth = birth; }
	public void setEmail(String email) {this.email = email; }
	
	public void setId(String id) {this.id = id; }

	public void setPw(String pw) {this.pw = pw;}
	public String getPw() {return pw;}
	
	public void setName(String name) {this.name = name;}
	public String getName() {return name;}
	
	public String getAddress() { return address; }
	public void setAddress(String address) {this.address = address;}
	
	public String getBirth1() {return birth1;}
	public void setBirth1(String birth1) {this.birth1 = birth1;}
	
	public String getBirth2() {return birth2;}
	public void setBirth2(String birth2) {this.birth2 = birth2;}
	
	public String getBirth3() {return birth3;}
	public void setBirth3(String birth3) {this.birth3 = birth3;}
	
	public String getEmail1() {return email1;}
	public void setEmail1(String email1) {this.email1 = email1;}
	
	public String getEmail2() { return email2;}
	public void setEmail2(String email2) { this.email2 = email2;}
	
	public String getPhone1() {return phone1;}
	public void setPhone1(String phone1) {this.phone1 = phone1;}
	
	public String getPhone2() {return phone2;}
	public void setPhone2(String phone2) { this.phone2 = phone2;}
	
	public String getPhone3() {return phone3;}
	public void setPhone3(String phone3) {this.phone3 = phone3; }
	
	public String getPhone4() {return phone4;}
	public void setPhone4(String phone4) {this.phone4 = phone4;}
		
	public String getPhone() {return getPhone1()+"-"+getPhone2()+"-"+getPhone3()+"-"+getPhone4();}
	public String getEmail() {return getEmail1()+"@"+getEmail2();}
	public String getBirth() {return getBirth1()+"/"+getBirth2()+"/"+getBirth3();}
			   
	public void setReg(Timestamp reg) {	this.reg = reg;	}
	public Timestamp getReg() { return reg; }
	 }

	



