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
	
	// 포인트 이력 추가
	public int pointHistory(Point point) throws Exception {
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
		
		return row;
	}
	
	// 상품별 포인트? 하나 살때마다 몇포인트씩 > 등급별 퍼센티지로?
	public int productPoint(Product product) throws Exception {
		Product procduct = new Product();
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 상품별로 포인트 얼마씩 적립할지
	return 0;
	}
}
