package dao;

import vo.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

import util.DBUtil;

public class DiscountDao {
	// 상품리스트 조회
	public ArrayList<HashMap<String, Object>> getAllProduct() throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 조회 쿼리
		String getSql = "SELECT p.product_no, p.product_name, p.product_price, p.product_status, p.product_sale_cnt, IFNULL(date_format(d.discount_start, '%Y-%m-%d'), '-') discount_start, IFNULL(date_format(d.discount_end, '%Y-%m-%d'),'-') discount_end, d.discount_rate FROM product p LEFT OUTER JOIN discount d ON p.product_no = d.product_no ORDER BY p.product_no, d.discount_start ASC";
		PreparedStatement stmt = conn.prepareStatement(getSql);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> map = new HashMap<>();
			
			Product p = new Product();
			p.setProductNo(rs.getInt("product_no"));
			p.setProductName(rs.getString("product_name"));
			p.setProductPrice(rs.getInt("product_price"));
			p.setProductStatus(rs.getString("product_status"));
			p.setProductSaleCnt(rs.getInt("product_sale_cnt"));
			
			Discount d = new Discount();
			d.setDiscountStart(rs.getString("discount_start"));
			d.setDiscountEnd(rs.getString("discount_end"));
			d.setDiscountRate(rs.getDouble("discount_rate"));
			
			map.put("product", p);
			map.put("discount", d);
			
			list.add(map);
		}
		
		return list;
	}
	
	
	// 할인율 입력
	// public int addDiscountRate(int productNo, String discountStart, String discountEnd, double discountRate) throws Exception {
	public int addDiscountRate(Discount discount) throws Exception {	
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 추가 쿼리
		String addSql = "INSERT INTO discount(product_no, discount_start, discount_end, discount_rate, createdate, updatedate) VALUES (?,?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(addSql);
		stmt.setInt(1, discount.getProductNo());
		stmt.setString(2, discount.getDiscountStart());
		stmt.setString(3, discount.getDiscountEnd());
		stmt.setDouble(4, discount.getDiscountRate());
		
		row = stmt.executeUpdate();
		
		return row;
	}
	
	// 할인율 수정
	public int uptDiscountRate(Discount discount) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 할인율(만) 수정
		String updSql = "UPDATE discount SET discount_start = ?, discount_end = ?, discount_rate = ?, updatedate = NOW() WHERE product_no = ?";
		PreparedStatement updStmt = conn.prepareStatement(updSql);
		updStmt.setString(1, discount.getDiscountStart());
		updStmt.setString(2, discount.getDiscountEnd());
		updStmt.setDouble(3, discount.getDiscountRate());
		updStmt.setInt(4, discount.getProductNo());
		
		row = updStmt.executeUpdate();
		
		return row;
	}
	
	// 할인율 개별 삭제(기간 관계 없이)
	public int delDiscountRate(int productNo) throws Exception {
		int row = 0;
	    // DB메소드
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
		
	    // 할인 삭제 > discount_end <= 오늘 날짜 인 것들 일괄 삭제 할수 있게.
	    // String delSql = "UPDATE discount SET discount_rate = 0, updatedate = NOW() WHERE product_no = ? AND (discount_start > ? OR discount_end < ?)";
	    String delSql = "DELETE FROM discount WHERE product_no = ?";
	    PreparedStatement stmt = conn.prepareStatement(delSql);
	    stmt.setInt(1, productNo);
	    
	    // 실행
	    row = stmt.executeUpdate();
	    
	    return row;
	}
	
	// 할인율 삭제(기간 지난것만)
		public int delDiscountRateByDate() throws Exception {
			int row = 0;
		    // DB메소드
		    DBUtil dbUtil = new DBUtil();
		    Connection conn = dbUtil.getConnection();
		    // 할인 삭제 > discount_end <= 오늘 날짜 인 것들 일괄 삭제 할수 있게.
		    String delSql = "DELETE FROM discount WHERE discount_end < NOW()";
		    PreparedStatement stmt = conn.prepareStatement(delSql);
		    // 실행
		    row = stmt.executeUpdate();
		    
		    return row;
		}
}
