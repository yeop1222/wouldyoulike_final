package wouldyoulike.jdbc;

import java.sql.*;

public class OracleConnection {
	public static Connection getConnection() throws Exception{
		Class.forName("oracle.jdbc.driver.OracleDriver");
//		String url = "jdbc:oracle:thin:@nullmaster.iptime.org:1521:xe";
//		String user = "project03";
//		String pwd = "project";
		String url = "jdbc:oracle:thin:@javaking.iptime.org:1521:orcl";
		String user = "test14";
		String pwd = "test";
		Connection conn = DriverManager.getConnection(url,user,pwd);
		return conn;
	}
	
	public static void closeConnection(ResultSet rs, PreparedStatement pstmt, Connection conn) {
		if(rs != null) {try{rs.close();}catch(SQLException e) {}}
		if(pstmt != null) {try{pstmt.close();}catch(SQLException e) {}}
		if(conn != null) {try{conn.close();}catch(SQLException e) {}}
	}
}
