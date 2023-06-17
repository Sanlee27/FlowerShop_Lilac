package dao;

import java.sql.*;
import java.util.ArrayList;

import util.*;
import vo.*;

public class PointDao {
	// 고객의 현재 포인트
	public Customer selectCstmPoint(Customer cstm) throws Exception {
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 현재 포인트 내역만 확인할때
		String pointSql = "SELECT id, cstm_point FROM customer WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(pointSql);
		stmt.setString(1, cstm.getId());
		
		ResultSet pointRs = stmt.executeQuery();
		if(pointRs.next()) {
			cstm.setId(pointRs.getString("id"));
			cstm.setCstmPoint(pointRs.getInt("cstm_point"));
		}
		return cstm;
	}
	
	// 고객의 포인트 증감 이력
	public ArrayList<Point> selectPointHistory(String id) throws Exception {
		ArrayList<Point> list = new ArrayList<>();
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 고객 포인트 증감이력 출력
		String sql = "SELECT o.id, p.point_no, p.order_no, p.point_pm, p.point, p.createdate FROM orders o	JOIN point_history p ON o.order_no = p.order_no	WHERE o.id = ? ORDER BY createdate DESC";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Point point = new Point();
			point.setOrderNo(rs.getInt("p.order_no"));
			point.setPointPm(rs.getString("p.point_pm"));
			point.setPoint(rs.getInt("p.point"));
			point.setCreatedate(rs.getString("p.createdate"));
			
			// 상품이름, 이미지 출력 쿼리
			String productSql = "SELECT p.product_name, pi.product_save_filename FROM point_history ph JOIN orders o ON ph.order_no = o.order_no JOIN product p ON o.product_no = p.product_no JOIN product_img pi ON p.product_no = pi.product_no WHERE ph.order_no = ?";
			PreparedStatement stmt2 = conn.prepareStatement(productSql);
			stmt2.setInt(1, point.getOrderNo());
			ResultSet rs2 = stmt2.executeQuery();
			
			if(rs2.next()) {
				String productName = rs2.getString("product_name");
				String productSaveFileName = rs2.getString("product_save_filename");
				point.setProductName(productName);
				point.setProductSaveFileName(productSaveFileName);
			}
			list.add(point);
		}
		return list;
	}
	
	// 포인트 이력 추가 & 고객 포인트 반영, 고객 포인트에 따른 등급 변경
	public int updatePoint(Point point, String id) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 포인트 증감 이력 추가
		String addPtHistorySql = "INSERT INTO point_history(order_no, point_pm, point, createdate) VALUES (?,?,?,NOW())";
		PreparedStatement addPtHistoryStmt = conn.prepareStatement(addPtHistorySql);
		addPtHistoryStmt.setInt(1, point.getOrderNo());
		addPtHistoryStmt.setString(2, point.getPointPm());
		addPtHistoryStmt.setInt(3, point.getPoint());
		
		row = addPtHistoryStmt.executeUpdate();
		
		int changePoint = point.getPointPm().equals("-") ? point.getPoint() * -1 : point.getPoint();
		
		// 고객 포인트에 포인트 반영
		String customerSql = "update customer set cstm_point = cstm_point + ? where id = ?";
		PreparedStatement customerStmt = conn.prepareStatement(customerSql);
		// ?값 세팅
		customerStmt.setInt(1, changePoint);
		customerStmt.setString(2, id);
		
		row += customerStmt.executeUpdate();
		
		// 고객 포인트에 따라 등급 변경
		// customer에 저장된 point를 기준으로 rank값을 변경해주는 쿼리 필요.
		String customerRankSql = "UPDATE customer SET cstm_rank = CASE WHEN cstm_point < 5000 THEN '씨앗' WHEN cstm_point BETWEEN 5000 AND 10000 THEN '새싹' WHEN cstm_point > 10000 THEN '꽃' ELSE cstm_rank END WHERE id = ?";
		PreparedStatement cstmRankStmt = conn.prepareStatement(customerRankSql);
		cstmRankStmt.setString(1, id);
		
		row += cstmRankStmt.executeUpdate();
		
		return row;
		
	}
	// 등급별 포인트 적립 반영은 jsp에서 처리
	
	// 주문취소시 적립 / 사용 포인트 취소 처리
	public int cancelPoint(Point point, String id) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 새롭게 취소내역 추가
		// 취소된 주문번호 조회
		String selectSql = "SELECT * FROM point_history WHERE order_no = ?";
		PreparedStatement selectStmt = conn.prepareStatement(selectSql);
		selectStmt.setInt(1, point.getOrderNo()); // 조회할 order_no를 지정
		ResultSet rs = selectStmt.executeQuery();
		
		if(rs.next()) {
			int orderNo = rs.getInt("order_no");
		    String prePm = rs.getString("point_pm");
		    int prePoint = rs.getInt("point");

		    // 반대로 할 부호 계산
		    String cancelPm = (prePm.equals("+")) ? "-" : "+";

		    // 새로운 데이터로 insert
		    String cancelSql = "INSERT INTO point_history (order_no, point_pm, point, createdate) VALUES (?, ?, ?, NOW())";
		    PreparedStatement stmt2 = conn.prepareStatement(cancelSql);
		    stmt2.setInt(1, orderNo);
		    stmt2.setString(2, cancelPm);
		    stmt2.setInt(3, prePoint);
		    
		    row = stmt2.executeUpdate();
		    
		    int cancelPoint = cancelPm.equals("-") ? prePoint * -1 : prePoint;
		    String cancelPointSql = "UPDATE customer SET cstm_point = cstm_point + ? WHERE id = ?";
		    PreparedStatement stmt3 = conn.prepareStatement(cancelPointSql);
		    stmt3.setInt(1, cancelPoint);
		    stmt3.setString(2, id);
		    
		    row += stmt3.executeUpdate();
		}
		return row;
	}
}
