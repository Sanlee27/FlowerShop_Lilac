package dao;

import java.sql.*;
import util.DBUtil;
import vo.*;

public class CustomerDao {
	
	// 회원가입
	// 1) id_list테이블에 값 insert, 동시에 pw_history테이블에 값 insert (id_list - id = pw_history - id / id_list - last_pw = pw_history - pw)
	// 2) 이 후 customer테이블에 회원가입 시 입력한 정보 insert
	
	// 1)
	public int insertId(String id, String lastPw) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// id_list에 id, pw, 활성화여부 Y 입력
		// 가입시 활성화 여부 무조건 Y로
		String idSql = "INSERT INTO id_list(id, last_pw, active, createdate) values (?, PASSWORD(?), 'Y', NOW())"; 
		PreparedStatement idStmt = conn.prepareStatement(idSql);
		idStmt.setString(1, id);
		idStmt.setString(2, lastPw);
		// 실행
		int idRow = idStmt.executeUpdate();
		// System.out.println("idRow : " + idRow);
		
		if(idRow == 0) { // id_list 값 입력이 안될경우
			return idRow;
		}
		
		// pw_history에 id, pw 입력
		String pwSql = "INSERT INTO pw_history(id, pw, createdate) values (?, PASSWORD(?), NOW())";
		PreparedStatement pwStmt = conn.prepareStatement(pwSql);
		pwStmt.setString(1, id);
		pwStmt.setString(2, lastPw);
		// 실행
		int pwRow = pwStmt.executeUpdate();
		// System.out.println("pwRow : " + pwRow);
		
		if(pwRow == 0) { // pw_history 값 입력이 안될경우
			return pwRow;
		}
		
		// id_list, pw_history에 값이 동시에 정상 입력될 경우 정상 실행
		if(idRow > 0 && pwRow > 0) {  
			row = 1;
		}
		
		return row;
	}
	
	// 2)
	public int insertCstm(Customer cstm) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 값 입력 쿼리
		String insertInfoSql = "INSERT INTO customer(id, cstm_name, cstm_address, cstm_email, cstm_birth, cstm_gender, cstm_phone, cstm_agree, createdate, updatedate) VALUES (?,?,?,?,?,?,?,?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(insertInfoSql);
		stmt.setString(1, cstm.getId());
		stmt.setString(2, cstm.getCstmName());
		stmt.setString(3, cstm.getCstmAddress());
		stmt.setString(4, cstm.getCstmEmail());
		stmt.setString(5, cstm.getCstmBirth());
		stmt.setString(6, cstm.getCstmGender());
		stmt.setString(7, cstm.getCstmPhone());
		stmt.setString(8, cstm.getCstmAgree());
		// 실행
		row = stmt.executeUpdate();
		
		if(row == 0) {
			System.out.println("insert customerInfo error : " + row);
		}
		
		return row;
	}
	
	// 로그인
	public int loginCstm(Id id) throws Exception {
		// 아이디 - 비밀번호 확인
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 로그인정보 확인 쿼리
		String loginSql = "SELECT id FROM id_list WHERE id = ? AND last_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(loginSql);
		stmt.setString(1, id.getId());
		stmt.setString(2, id.getLastPw());
		// 실행
		ResultSet loginRs = stmt.executeQuery();
		
		if(loginRs.next()){ // 로그인 성공
			System.out.println("로그인성공");
		}
		return row;
	}
	
	// 로그인 시 활성화 여부 Y일때(id_list - active = 'Y') 마지막 로그인 일자 (customer - cstm_last_login) 업데이트
	public int updateLastlogin(Id id) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 활성화 여부 Y인지?
		String active = null;
		String ckActiveSql = "SELECT active FROM id_list WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(ckActiveSql);
		stmt.setString(1, id.getId());
		// 결과
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			active = rs.getString(1);
		}
		
		// 활성화 여부 Y라면 마지막 로그인 일자 현재로 업데이트
		if(active.equals("Y")) {
			int updateRow = 0;
			// 마지막 일자 업데이트 쿼리
			String updateLoginDateSql = "UPDATE customer SET cstm_last_login = NOW() WHERE id = ?";
			PreparedStatement updLogStmt = conn.prepareStatement(updateLoginDateSql);
			updLogStmt.setString(1, id.getId());
			// 결과
			updateRow = updLogStmt.executeUpdate();
			
			return updateRow;
		}
		
		return row;
	}
	
	// 중복(이전) 비밀번호 확인(pw_history테이블)
	public int checkPw(Id id) throws Exception {
		int ckPwRow = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 이전 비밀번호 확인 메소드
		String chPwSql = "SELECT COUNT(*) FROM pw_history WHERE id = ? AND pw = ?";
		PreparedStatement chPwStmt = conn.prepareStatement(chPwSql);
		chPwStmt.setString(1, id.getId());
		chPwStmt.setString(2, id.getLastPw());
		// 실행
		ResultSet chPwRs = chPwStmt.executeQuery();
		if(chPwRs.next()) {
			ckPwRow = chPwRs.getInt(1);
		}
		return ckPwRow;
	}
	
	// 비밀번호 변경
	public int updatePw(Id id) throws Exception {
		// id_list 변경
		int newPwRow = 0;
		//  pw_history 입력
		int pwHstryRow = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// id_list_비밀번호 변경에 변경값 업데이트
		String newPwSql = "UPDATE id_list SET last_pw = PASSWORD(?) WHERE id = ?"; // 비밀번호 변경값 입력
		PreparedStatement newPwStmt = conn.prepareStatement(newPwSql);
		newPwStmt.setString(1, id.getLastPw());
		newPwStmt.setString(2, id.getId());
		// 실행
		newPwRow = newPwStmt.executeUpdate();
		// System.out.println("newPwRow : " + row);
		
		// pw_history_비밀번호 이력에 id, pw 입력
		String pwHstrySql = "INSERT INTO pw_history(id, pw, createdate) values (?, PASSWORD(?), NOW())";
		PreparedStatement pwHstryStmt = conn.prepareStatement(pwHstrySql);
		pwHstryStmt.setString(1, id.getId());
		pwHstryStmt.setString(2, id.getLastPw());
		// 실행
		pwHstryRow = pwHstryStmt.executeUpdate();
		// System.out.println("pwHstryRow : " + pwHstryRow);
		
		// pw_history 이력 개수 몇개인지
		int pwCnt = 0;
		String pwCntSql = "SELECT COUNT(*) FROM pw_history WHERE id = ?";
		PreparedStatement pwCntStmt = conn.prepareStatement(pwCntSql);
		pwCntStmt.setString(1, id.getId());
		// 실행
		ResultSet pwCntRs = pwCntStmt.executeQuery();
		if(pwCntRs.next()) {
			pwCnt = pwCntRs.getInt(1);
		}
		// 3개 이상일 경우 가장 오래된(생성일자 가장 작은_min(createdate)) 번호 삭제 
		if(pwCnt > 3) {
			int delPwHstryRow = 0;
			// 이력 중 가장 오래된거 하나 삭제
			String delPwHstrySql = "DELETE FROM pw_history WHERE id = ? AND createdate = (SELECT min(createdate) FROM pw_history WHERE id = ?)";
			PreparedStatement delPwHstryStmt = conn.prepareStatement(delPwHstrySql);
			delPwHstryStmt.setString(1, id.getId());
			delPwHstryStmt.setString(2, id.getId());
			// 실행
			delPwHstryRow = delPwHstryStmt.executeUpdate();
			// System.out.println("delPwHstryRow : " + delPwHstryRow);
		}
		return newPwRow;
	}
	
	// ===================
	// 고객 정보 출력
	public Customer selectCustomerInfo(String id) throws Exception {
		Customer customer = null;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 고객 정보 출력 쿼리
		String cstmInfoSql = "SELECT id, cstm_name cstmName, cstm_address cstmAddress, cstm_email cstmEmail, cstm_birth cstmBirth, cstm_gender cstmGender, cstm_phone cstmPhone, cstm_rank cstmRank, cstm_point cstmPoint, cstm_last_login cstmLastlogin, cstm_agree cstmAgree, createdate FROM customer WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(cstmInfoSql);
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
		// 고객 정보 수정 쿼리
		String updateCstmSql = "UPDATE customer SET cstm_name = ?, cstm_address = ?, cstm_email = ?, cstm_birth = ?, cstm_gender = ?, cstm_phone = ?, cstm_agree = ?, updatedate = NOW() WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(updateCstmSql);
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
	
	// 고객삭제_회원탈퇴_아이디가 남게,, 
	public int deleteCustomer(Customer cstm) throws Exception{
		int row = 0;
		// 삭제
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 고객 정보 삭제 쿼리 
		PreparedStatement stmt = conn.prepareStatement("DELETE FROM customer WHERE id = ?");
		stmt.setString(1, cstm.getId());	
			
		row = stmt.executeUpdate();
		
		return row;
	}
		
	
	// 탈퇴하면 id_list active 비활성화 처리
	public int updActId(String id) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 비활성화로 변경
		PreparedStatement stmt = conn.prepareStatement("UPDATE id_list SET active = 'N' WHERE id = ?");
		stmt.setString(1, id);
		
		row = stmt.executeUpdate();
				
		return row;
	}
}
