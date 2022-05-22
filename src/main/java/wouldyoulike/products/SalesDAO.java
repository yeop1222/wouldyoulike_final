package wouldyoulike.products;

import java.sql.*;
import java.util.*;
import wouldyoulike.jdbc.*;

public class SalesDAO {
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	//吏��궃 30�씪媛� �뙋留ㅼ닔�웾 / 留ㅼ텧�븸 議고쉶
	public ArrayList<Integer> past30days(){
		ArrayList<Integer> list = new ArrayList<Integer>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select sum(pricesum), sum(orderamount) "
					+ " from orderinfo where orderdate "
					+" between (sysdate-30) and sysdate";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				list.add(rs.getInt("sum(pricesum)"));
				list.add(rs.getInt("sum(orderamount)"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//吏��궃 7�씪媛� �뙋留ㅼ닔�웾/留ㅼ텧�븸 議고쉶 
	public ArrayList<Integer> past7days(){
		ArrayList<Integer> list = new ArrayList<Integer>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select sum(pricesum), sum(orderamount) "
					+ " from orderinfo where orderdate "
					+" between (sysdate-7) and sysdate";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				list.add(rs.getInt("sum(pricesum)"));
				list.add(rs.getInt("sum(orderamount)"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return list;
	}
	
	//�씪蹂� �뙋留ㅻ웾 議고쉶
	public HashMap<String,Integer> dailyCount(){
		HashMap<String,Integer> map = new HashMap<String,Integer>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select orderdate, sum(orderamount) from "
					+ "(select orderamount, to_char(orderdate, 'YY-MM-DD') as orderdate from orderinfo) "
					+ "group by orderdate";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				map.put(rs.getString("orderdate"), rs.getInt("sum(orderamount)"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return map;
	}
	
	
	//�꽑�깮�븳 湲곌컙�쓽 �뙋留ㅺ툑�븸
	public HashMap<String, Integer> salesInPeriod(String period, String start, String end){
		if(period.equals("daily")) {period="YY-MM-DD";}
		if(period.equals("monthly")) {period="YYYY-MM";}
		if(period.equals("yearly")) {period="YYYY";}
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select orderdate, sum(pricesum) "
					+ " from (select pricesum, to_char(orderdate, '"+period+"') as orderdate "
					+ " from orderinfo "
					+ " where to_char(orderdate, '"+period+"') between ? and ? ) "
					+ " group by orderdate";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, start);
			pstmt.setString(2, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				map.put(rs.getString("orderdate"), rs.getInt("sum(pricesum)"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return map;
	}
	
	//�꽑�깮�븳 湲곌컙�쓽 �뙋留ㅼ닔�웾
	public HashMap<String, Integer> salesCntInPeriod(String period, String start, String end){
		if(period.equals("daily")) {period="YY-MM-DD";}
		if(period.equals("monthly")) {period="YYYY-MM";}
		if(period.equals("yearly")) {period="YYYY";}
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select orderdate, sum(orderamount) "
					+ " from (select orderamount, to_char(orderdate, '"+period+"') as orderdate "
					+ " from orderinfo "
					+ " where to_char(orderdate, '"+period+"') between ? and ? ) "
					+ " group by orderdate";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, start);
			pstmt.setString(2, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				map.put(rs.getString("orderdate"), rs.getInt("sum(orderamount)"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return map;
	}
	
	//�꽑�깮�븳 湲곌컙�쓽 珥� �뙋留ㅺ툑�븸
		public int totalSalesInPeriod(String period, String start, String end) {
			if(period.equals("daily")) {period="YY-MM-DD";}
			if(period.equals("monthly")) {period="YYYY-MM";}
			if(period.equals("yearly")) {period="YYYY";}
			int result = 0;
			try {
				conn = OracleConnection.getConnection();
				String sql = "select sum(priceSum) from (select priceSum, to_char(orderdate, '"+period+"') as orderdate from orderinfo "
						+ " where to_char(orderdate, '"+period+"') between ? and ? )";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, start);
				pstmt.setString(2, end);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					result = rs.getInt(1);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				OracleConnection.closeConnection(rs, pstmt, conn);
			}
			return result;
		}
	
	//�꽑�깮�븳 湲곌컙�쓽 珥� �뙋留ㅼ닔�웾
	public int totalCntInPeriod(String period, String start, String end) {
		if(period.equals("daily")) {period="YY-MM-DD";}
		if(period.equals("monthly")) {period="YYYY-MM";}
		if(period.equals("yearly")) {period="YYYY";}
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select sum(orderamount) from (select orderamount, to_char(orderdate, '"+period+"') as orderdate from orderinfo "
					+ " where to_char(orderdate, '"+period+"') between ? and ? )";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, start);
			pstmt.setString(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//湲곌컙蹂� 珥� �뙋留� �닔�웾
	public HashMap<String, Integer> salesCntByPeriod(String period) {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		if(period.equals("daily")) {period="YY/MM/DD";}
		if(period.equals("monthly")) {period="YYYY/MM";}
		if(period.equals("yearly")) {period="YYYY";}
		try {
			conn = OracleConnection.getConnection();
			String sql = "select sum(orderamount), to_char(orderdate, '"+period+"') as orderdate "
					+ " from orderinfo group by to_char(orderdate, '"+period+"')";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				map.put(rs.getString("orderdate"), rs.getInt("sum(orderamount)"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return map;
	}
	
	
	//湲곌컙蹂� 珥� 留ㅼ텧�븸
	public HashMap<String, Integer> salesByPeriod(String period) {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		if(period.equals("daily")) {period="YY/MM/DD";}
		if(period.equals("monthly")) {period="YYYY/MM";}
		if(period.equals("yearly")) {period="YYYY";}
		try {
			conn = OracleConnection.getConnection();
			String sql = "select sum(pricesum), to_char(orderdate, '"+period+"') as orderdate "
					+ " from orderinfo group by to_char(orderdate, '"+period+"')";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				map.put(rs.getString("orderdate"), rs.getInt("sum(pricesum)"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return map;
	}
	
	//�쁽�옱源뚯� 珥� �뙋留ㅼ닔�웾
	public int totalCnt() {
		int result=0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select sum(orderamount) from orderinfo";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	//�쁽�옱源뚯� 珥� 留ㅼ텧�븸
	public int totalSales() {
		int result=0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select sum(pricesum) from orderinfo";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//移댄뀒怨좊━蹂� 珥� �뙋留ㅼ닔�웾 : category.jsp
		public int totalCnt(String category) {
			int result = 0;
			try {
				conn = OracleConnection.getConnection();
				String sql = "select sum(orderamount) from orderinfo o, products p "
						+ "where o.productnum=p.productn and p.procategory=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, category);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					result += rs.getInt(1);
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				OracleConnection.closeConnection(rs, pstmt, conn);
			}
			return result;
		}
		
	//移댄뀒怨좊━蹂� 珥� 留ㅼ텧�븸 : category.jsp
	public int totalSales(String category) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select sum(pricesum) from orderinfo o, products p "
					+ "where o.productnum=p.productn and p.procategory=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, category);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result += rs.getInt(1);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return result;
	}
	
	//�꽑�깮�븳 移댄뀒怨좊━�쓽 �뙏由곕궇吏쒖� �뙏由곌툑�븸 議고쉶
		public HashMap<String, Integer> periodSales_category(String period, String category){
			HashMap<String, Integer> map = new HashMap<String, Integer>();
			if(period.equals("daily")) {period="YY/MM/DD";}
			if(period.equals("monthly")) {period="YYYY/MM";}
			if(period.equals("yearly")) {period="YYYY";}
			try {
				conn = OracleConnection.getConnection();
				String sql = "select orderdate, sum(pricesum) from "
						+ "				    (select o.pricesum, to_char(o.orderdate,'"+period+"') as orderdate, p.procategory "
						+ "					from products p, orderinfo o "
						+ "				    where p.productn=o.productnum and procategory=?)"
						+ "				    group by orderdate";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, category);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					map.put(rs.getString("orderdate"), rs.getInt("sum(pricesum)"));
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally{
				OracleConnection.closeConnection(rs, pstmt, conn);
			}
			return map;
		}
	
	//�꽑�깮�븳 移댄뀒怨좊━�쓽 �뙏由곕궇吏쒖� �뙏由곗닔�웾 議고쉶
	public HashMap<String, Integer> periodCnt_category(String period, String category){
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		if(period.equals("daily")) {period="YY/MM/DD";}
		if(period.equals("monthly")) {period="YYYY/MM";}
		if(period.equals("yearly")) {period="YYYY";}
		try {
			conn = OracleConnection.getConnection();
			String sql = "select orderdate, sum(orderamount) from "
					+ "				    (select o.orderamount, to_char(o.orderdate,'"+period+"') as orderdate, p.procategory "
					+ "					from products p, orderinfo o "
					+ "				    where p.productn=o.productnum and procategory=?)"
					+ "				    group by orderdate";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, category);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				map.put(rs.getString("orderdate"), rs.getInt("sum(orderamount)"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally{
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return map;
	}
	
	//�썝�븯�뒗 �떖�쓽 �궇吏� 由ы꽩 
	public ArrayList<String> daysInMonth(String month){
		int daycount = 31;
		if(month.equals("02")) {daycount = 28;}
		String[] month30 = {"04", "06", "09", "11"};
		if(Arrays.asList(month30).contains(month)) {daycount = 30;}
		ArrayList<String> days = new ArrayList<String>();
		for(int i=1; i<10; i++) {
			days.add("0"+i);
		}
		for(int i=10;i<daycount+1;i++) {
			days.add(i+"");
		}
		return days;
	}
	
	//留ㅼ텧�엳�뒗 �궇吏� 紐⑥븘蹂닿린
	public ArrayList<String> dayWithSales(){
		ArrayList<String> daily = new ArrayList<String>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from (select to_char(orderdate,'YY/MM/DD') as soldDay from orderinfo "
					+ " group by to_char(orderdate,'YY/MM/DD')) "
					+ " order by soldday";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				daily.add(rs.getString("soldDay"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return daily; 
	}
	
	
	//�썝�궛吏�蹂� 珥� 留ㅼ텧�븸 - �뙏由� 湲덉븸 �빀怨�
	public HashMap<String,Integer> countrySales() {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select p.country, sum(o.pricesum) as salesSum from products p, orderinfo o "
					+ " where o.productnum=p.productn "
					+ " group by p.country order by p.country";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				map.put(rs.getString("country"), rs.getInt("salesSum"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return map;
	}
	
	//�썝�궛吏�蹂� 珥� �뙋留ㅻ웾 - �뙏由� �긽�뭹�닔
	public Map<String, Integer> countryCount() {
		Map<String, Integer> map = new HashMap<String, Integer>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select sum(o.orderamount) as orderamount, p.country from products p, orderinfo o "
					+ "	where p.productn=o.productnum "
					+ "	group by p.country order by p.country";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				map.put(rs.getString("country"), rs.getInt("orderamount"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally{
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return map;
	}
	
	
}
