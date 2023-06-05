package dao;

import vo.*;
import java.sql.*;
import java.time.LocalDate;

import util.DBUtil;

public class DiscountDao {
	// Discount.java 파일 추가
	// 제품별 할인기간 중복 확인 필요..
	
	// 제품별 할인율 조회
	public double selectDiscountRate(int productNo) throws Exception {
		double discountRate = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 할인율을 조회
		// 할인기간도 확인해서 기간에 해당하는것만 조회되게 해야되지않을까
		String selectSql = "SELECT discount_rate FROM discount WHERE product_no = ? ";
		PreparedStatement selStmt = conn.prepareStatement(selectSql);
		selStmt.setInt(1, productNo);
		
		ResultSet selRs = selStmt.executeQuery();
		if(selRs.next()) {
			discountRate = selRs.getDouble("discount_rate");
		}
		return discountRate;
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
	public int delDiscountRate(int discountNo) throws Exception {
		int row = 0;
	    // DB메소드
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
		
	    // 할인 삭제 > discount_end <= 오늘 날짜 인 것들 일괄 삭제 할수 있게.
	    // String delSql = "UPDATE discount SET discount_rate = 0, updatedate = NOW() WHERE product_no = ? AND (discount_start > ? OR discount_end < ?)";
	    String delSql = "DELETE FROM discount WHERE discount_no = ?";
	    PreparedStatement stmt = conn.prepareStatement(delSql);
	    stmt.setInt(1, discountNo);
	    
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
		    // 현재 날짜 구하기
			LocalDate now = LocalDate.now();
			// 현재 날짜에서 3개월 이전의 날짜 계산
	        LocalDate limitDate = now.minusMonths(3);
	        // 3개월 이전 날짜 String 변수에 저장
	        String sleeplimitDate = limitDate.toString();
	        
		    // 할인 삭제 > discount_end <= 오늘 날짜 인 것들 일괄 삭제 할수 있게.
		    String delSql = "DELETE FROM discount WHERE discount_end < ?";
		    PreparedStatement stmt = conn.prepareStatement(delSql);
		    stmt.setString(1, sleeplimitDate);
		    
		    // 실행
		    row = stmt.executeUpdate();
		    
		    return row;
		}
}
