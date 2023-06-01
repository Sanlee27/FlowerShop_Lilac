package dao;

import java.sql.*;
import util.DBUtil;
import vo.*;

public class CustomerDao {
	
	// 회원가입
	
	// 고객 정보 출력
	public Customer selectCustomerInfo(String id) throws Exception {
		Customer customer = null;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 쿼리
		PreparedStatement stmt = conn.prepareStatement(
				"SELECT id, cstm_name cstmName, cstm_address cstmtAddress, cstm_email cstmEmail, cstm_birth cstmBirth, cstm_gender cstmGender, cstm_phone cstmPhone, cstm_rank cstmRank, cstm_point cstmPoint, cstm_last_login cstmLastlogin, cstm_agree cstmAgree, createdate FROM customer WHERE id = ?");
		stmt.setString(1, id);
		// rs.set
		ResultSet rs = stmt.executeQuery();
		// 데이터
		if(rs.next()) {
			customer= new Customer();
			customer.setId(rs.getString("id"));
			customer.setCstmName(rs.getString("cstmName"));
			customer.setCstmAddress(rs.getString("cstmAddress"));
			customer.setCstmEmail(rs.getString("cstmEmail"));
			customer.setCstmBirth(rs.getString("cstmBirth"));
			customer.setCstmGender(rs.getString("cstmGender"));
			customer.setCstmPhone(rs.getString("cstmPhone"));
			customer.setCstmRank(rs.getString("cstmRank"));
			customer.setCstmPoint(rs.getInt("cstmPoint"));
			customer.setCstmLastlogin(rs.getString("cstmLastlogin"));
			customer.setCstmAgree(rs.getString("cstmAgree"));
			customer.setUpdatedate(rs.getString("createdate"));
		}
		
		return customer;
	}
	
	// 고객 정보 수정
	public int updateCustomer(Customer cstm) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 쿼리
		PreparedStatement stmt = conn.prepareStatement(
				"UPDATE customer SET cstm_name = ?, cstm_address = ?, cstm_email = ?, cstm_birth = ?, cstm_gender = ?, cstm_phone = ?, cstm_agree = ?, updatedate = NOW() WHERE id = ?");
		stmt.setString(1, cstm.getCstmName());
		stmt.setString(2, cstm.getCstmAddress());
		stmt.setString(3, cstm.getCstmEmail());
		stmt.setString(4, cstm.getCstmBirth());
		stmt.setString(5, cstm.getCstmGender());
		stmt.setString(6, cstm.getCstmPhone());
		stmt.setString(7, cstm.getCstmAgree());
		stmt.setString(8, cstm.getId());
		
		row = stmt.executeUpdate();
		
		return row;
	}
	
	// 고객 삭제
	public int deleteCustomer(Customer cstm) throws Exception{
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 쿼리
		PreparedStatement stmt = conn.prepareStatement("DELETE FROM customer WHERE id = ?");
		stmt.setString(1, cstm.getId());	
		
		row = stmt.executeUpdate();
		
		return row;
	}
}
	
	// 고객 정보 개수
