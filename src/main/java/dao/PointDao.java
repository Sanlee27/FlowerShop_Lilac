package dao;

import java.sql.*;
import util.*;
import vo.*;

public class PointDao {
	// 고객 포인트 내역
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
		String customerRankSql = "UPDATE customer SET cstm_rank = CASE WHEN cstm_point < 1000 THEN '씨앗' WHEN cstm_point BETWEEN 1000 AND 3000 THEN '새싹' WHEN cstm_point > 5000 THEN '꽃' ELSE cstm_rank END WHERE id = ?";
		PreparedStatement cstmRankStmt = conn.prepareStatement(customerRankSql);
		cstmRankStmt.setString(1, id);
		
		row += cstmRankStmt.executeUpdate();
		
		return row;
		
	}
	// 등급별 포인트 적립 반영은 jsp에서 처리
	
}
