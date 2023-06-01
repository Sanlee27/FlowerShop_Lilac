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
		// 가입시 활성화 여부 무조건 Y로 <> 비활성화_N일시 회원탈퇴처리된걸로?  id_list 테이블에 updatedate 컬럼 추가 필요 > 비밀번호,비활성화 변경
		String idSql = "INSERT INTO id_list(id, last_pw, active, creatdate) values (?, PASSWORD(?), 'Y', NOW()"; 
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
		String pwSql = "INSERT INTO pw_history(id, pw, createdate) values (?, PASSWORD(?), NOW()";
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
		String insertInfoSql = "INSERT INTO customer(cstm_name, cstm_address, cstm_email, cstm_birth, cstm_gender, cstm_phone, cstm_agree, createdate, updatedate) VALUES (?,?,?,?,?,?,?,?,?,?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(insertInfoSql);
		stmt.setString(1, cstm.getId()); // id는 가입시 id_list테이블에 입력된 값과 동일
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
	// 로그인 시 활성화 여부 Y일때(id_list - active = 'Y') 마지막 로그인 일자 (customer - cstm_last_login) 업데이트
	// 아이디 - 비밀번호 확인
	
	
	// 비밀번호 변경
	// 변경 시 이전 비밀번호 확인(pw_history테이블)
	
	// 변경 실행시
	// id_list테이블에 변경 값 업데이트, pw_history테이블 값 insert
	// pw_history 이력 개수 몇개인지, 3개 이상일 경우 가장 오래된(생성일자 가장 작은_min(createdate)) 번호 삭제 
	
	// ===================
	// 고객 정보 출력
	public Customer selectCustomerInfo(String id) throws Exception {
		Customer customer = null;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 고객 정보 출력 쿼리
		String cstmInfoSql = "SELECT id, cstm_name cstmName, cstm_address cstmtAddress, cstm_email cstmEmail, cstm_birth cstmBirth, cstm_gender cstmGender, cstm_phone cstmPhone, cstm_rank cstmRank, cstm_point cstmPoint, cstm_last_login cstmLastlogin, cstm_agree cstmAgree, createdate FROM customer WHERE id = ?";
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
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 고객 정보 삭제 쿼리 // 수정 필요_현재 쿼리 > 아이디까지 전부 삭제..활성화 여부를 n으로 변경? 사용 못하게,,
		PreparedStatement stmt = conn.prepareStatement("DELETE FROM customer WHERE id = ?");
		stmt.setString(1, cstm.getId());	
		
		row = stmt.executeUpdate();
		
		return row;
	}
}
	
	// 고객 정보 개수
