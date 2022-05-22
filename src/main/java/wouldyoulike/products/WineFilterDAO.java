package wouldyoulike.products;

import java.sql.*;
import wouldyoulike.jdbc.*;

public class WineFilterDAO {
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	//와인 상세정보 조회
	public WineFilterDTO getWineInfo(int productN) {
		WineFilterDTO wineInfo = new WineFilterDTO();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from winefilter where productN=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productN);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				wineInfo.setVariental(rs.getString("variental"));
				wineInfo.setSweetness(rs.getInt("sweetness"));
				wineInfo.setWineBody(rs.getInt("winebody"));
				wineInfo.setAcidity(rs.getInt("acidity"));
				wineInfo.setTannins(rs.getInt("tannins"));
				wineInfo.setVQA(rs.getInt("vqa"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeConnection(rs, pstmt, conn);
		}
		return wineInfo;
	}
}
