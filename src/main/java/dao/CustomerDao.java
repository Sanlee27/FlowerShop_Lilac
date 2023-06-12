package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

import util.DBUtil;
import vo.*;

public class CustomerDao {
	
	// 회원가입
	// 0) 아이디 중복체크
	// 1) id_list테이블에 값 insert, 동시에 pw_history테이블에 값 insert (id_list - id = pw_history - id / id_list - last_pw = pw_history - pw)
	// 2) 이 후 customer테이블에 회원가입 시 입력한 정보 insert
	
	// 0)
	public int checkId(String id) throws Exception {
		int ckIdRow = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 아이디가 있는지 id_list에서 확인
		String ckIdSql = "SELECT COUNT(*) FROM id_list WHERE id = ?";
		PreparedStatement ckIdStmt = conn.prepareStatement(ckIdSql);
		ckIdStmt.setString(1, id);
		
		ResultSet ckIdRs = ckIdStmt.executeQuery();
		if(ckIdRs.next()) {
			ckIdRow = ckIdRs.getInt(1);
		}
		return ckIdRow;
	}
	
	// 1)
	public int insertId(Id id) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
			// id_list에 id, pw, 활성화여부 Y 입력
			// 가입시 활성화 여부 무조건 Y로
			String idSql = "INSERT INTO id_list(id, last_pw, active, createdate) values (?, PASSWORD(?), 'Y', NOW())"; 
			PreparedStatement idStmt = conn.prepareStatement(idSql);
			idStmt.setString(1, id.getId());
			idStmt.setString(2, id.getLastPw());
			
			// 실행
			int idRow = idStmt.executeUpdate();
			// System.out.println("idRow : " + idRow);
			
			if(idRow == 0) { // id_list 값 입력이 안될경우
				return idRow;
			}
		
			// pw_history에 id, pw 입력
			String pwSql = "INSERT INTO pw_history(id, pw, createdate) values (?, PASSWORD(?), NOW())";
			PreparedStatement pwStmt = conn.prepareStatement(pwSql);
			pwStmt.setString(1, id.getId());
			pwStmt.setString(2, id.getLastPw());
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
		String insertInfoSql = "INSERT INTO customer(id, cstm_name, cstm_address, cstm_email, cstm_birth, cstm_gender, cstm_phone, cstm_agree, cstm_last_login, createdate, updatedate) VALUES (?,?,?,?,?,?,?,?, NOW(), NOW(), NOW())";
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
	// ================================================================
	/* 로그인
		1) id, pw 있는 확인
		2) customer or admin 확인
			2-1 admin에 있으면 관리자 페이지 이동 버튼 오픈
			2-2 customer에 있으면 3)으로 이동
	  		2-3 customer에 없으면 탈퇴회원임을 안내
		3) active(휴면) 여부 확인 - Y/N
			Y - 3개월 지났는지 확인
				Y-1 지났으면 
					1. active N으로 변경 
					2. 비활성화 계정표시 및 비밀번호 재확인
					3. active Y로 변경 후 last_login NOW()로 업데이트
				Y-2 안지났으면
					1. last_login NOW()로 업데이트
			N - 이미 휴면계정이므로
				1. 비활성화 계정표시 및 비밀번호 재확인
				2. 3. active Y로 변경 후 last_login NOW()로 업데이트
	*/
	// 1) id, pw 있는 확인
	public int ckIdPw(String id, String pw) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// id_list에서 로그인하면서 받아온 id, pw가 일치하는게 있는지 확인
		String ckIdPwSql = "SELECT COUNT(*) FROM id_list WHERE id = ? AND last_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(ckIdPwSql);
		stmt.setString(1, id);
		stmt.setString(2, pw);
		
		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
	        row = rs.getInt(1);
	        if (row > 0) {
	            System.out.println("로그인성공");
	        } else {
	            System.out.println("로그인실패");
	        }
		}
		return row;
	}
	
	// 2) customer or admin 확인
	public String ckId(String id) throws Exception {
		String ckId = null;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 로그인하려는 id가 cutomer인지 admin지 확인
		// Employees인지?
		String ckEmpSql = "SELECT * FROM employees WHERE id = ?";
		PreparedStatement empStmt = conn.prepareStatement(ckEmpSql);
		empStmt.setString(1, id);
		
		ResultSet empRs = empStmt.executeQuery();
		
		// Customer인지?
		String ckCstmSql = "SELECT id FROM customer WHERE id = ?";
		PreparedStatement cstmStmt = conn.prepareStatement(ckCstmSql);
		cstmStmt.setString(1, id);
		
		ResultSet cstmRs = cstmStmt.executeQuery();
		if(empRs.next()) {
			// 2-1 admin 이면 관리자 페이지 이동 버튼 오픈
			// emp_level에 따라 관리자이름 설정
			int empLevel = empRs.getInt("emp_level");
	        ckId = (empLevel == 2) ? "관리자2" : "관리자1";
			// 2-2 customer에 있으면 active 확인
		} else if(cstmRs.next()) {
			ckId = "고객";
			// 2-3 customer에 없으면 탈퇴회원임을 안내
		} else {
			ckId = "없는 회원";
		}
		
		return ckId;
	}
	// 3) active 여부 확인, 변경, last_login 업데이트
	// 활성화여부 확인해주는거 하나랑 활성화여부 변경해주는거 하나랑 last_login업데이트 해주는거 하나
	
	// 활성화 여부 확인
	public String ckActive(String id) throws Exception {
		String active = "";	
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 활성화 여부 확인
		String ckActSql = "SELECT active FROM id_list WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(ckActSql);
		stmt.setString(1, id);
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			active = rs.getString(1);
		}
		return active;
	}
	
	// 활성화 여부 변경
	public int updActive(Id id) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 활성화 변경
		if(id.getActive().equals("Y")) {
			String YToNSql = "UPDATE id_list SET active = 'N' WHERE id = ?";
			PreparedStatement YToNStmt = conn.prepareStatement(YToNSql);
			YToNStmt.setString(1, id.getId());
			
			row = YToNStmt.executeUpdate();
		} else {
			String NToYSql = "UPDATE id_list SET active = 'Y' WHERE id = ?";
			PreparedStatement NToYStmt = conn.prepareStatement(NToYSql);
			NToYStmt.setString(1, id.getId());
			
			row = NToYStmt.executeUpdate();
		}
		return row;
	}
	
	// 마지막 로그인 일자 업데이트
	public int updLastLogin(String id) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// last_login 업데이트
		String updLastLoginSql = "UPDATE customer SET cstm_last_login = NOW() WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(updLastLoginSql);
		stmt.setString(1, id);
		
		row = stmt.executeUpdate();
		
		return row;
	}
	
	// 휴면계정(3개월)시 active N으로 변경
	public int ckSleepId(String id) throws Exception {
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		int row = 0;
		String sql = "UPDATE id_list SET active = 'N' WHERE id = '?' AND DATEDIFF(NOW(), (SELECT cstm_last_login FROM customer WHERE id = '?')) > 90";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		stmt.setString(2, id);
		row = stmt.executeUpdate();
		
		return row;
	}
	
	// 입력받은 비밀번호가 맞는지
	public int ckPw(Id id) throws Exception {
		int row = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 비밀번호 확인
		String ckPwSql = "SELECT last_pw FROM id_list WHERE id = ? AND last_pw = PASSWORD(?)";
		PreparedStatement ckPwStmt = conn.prepareStatement(ckPwSql);
		ckPwStmt.setString(1, id.getId());
		ckPwStmt.setString(2, id.getLastPw());
		
		ResultSet ckPwRs = ckPwStmt.executeQuery();
		if(ckPwRs.next()) {
			row = 1;
		}
		return row;
	}
	
	// 중복(이전) 비밀번호 확인(pw_history테이블)
	public int checkPwHistory(Id id) throws Exception {
		int ckPwRow = 0;
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 이전 비밀번호 확인 메소드
		String chPwSql = "SELECT COUNT(*) FROM pw_history WHERE id = ? AND pw = PASSWORD(?)";
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
		System.out.println("newPwRow : " + newPwRow);
		
		// pw_history_비밀번호 이력에 id, pw 입력
		String pwHstrySql = "INSERT INTO pw_history(id, pw, createdate) values (?, PASSWORD(?), NOW())";
		PreparedStatement pwHstryStmt = conn.prepareStatement(pwHstrySql);
		pwHstryStmt.setString(1, id.getId());
		pwHstryStmt.setString(2, id.getLastPw());
		// 실행
		pwHstryRow = pwHstryStmt.executeUpdate();
		System.out.println("pwHstryRow : " + pwHstryRow);
		
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
			System.out.println("delPwHstryRow : " + delPwHstryRow);
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
	public int deleteCustomer(String id) throws Exception{
		int row = 0;
		// 삭제
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 고객 정보 삭제 쿼리 
		PreparedStatement stmt = conn.prepareStatement("DELETE FROM customer WHERE id = ?");
		stmt.setString(1, id);	
			
		row = stmt.executeUpdate();
		// 탈퇴 회원 비활성화 처리
		PreparedStatement stmt2 = conn.prepareStatement("UPDATE id_list SET active = 'N' WHERE id = ?");
		stmt2.setString(1, id);
		
		row += stmt.executeUpdate();
				
		return row;
	}
	
	// 회원통계_연령별
	public HashMap<String, Object> ageStats() throws Exception {
		// 결과값 담길 ArrayList 선언
		HashMap<String, Object> ageList = new HashMap<String, Object>();
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 연령별 인원 통계
		String ageStatsSql = "SELECT"
						+ "			CASE WHEN age < 20 THEN '10대'"
						+ "			    WHEN age BETWEEN 20 AND 29 THEN '20대'"
						+ "			    WHEN age BETWEEN 30 AND 39 THEN '30대'"
						+ "			    WHEN age BETWEEN 40 AND 49 THEN '40대'"
						+ "			    WHEN age BETWEEN 50 AND 59 THEN '50대'"
						+ "			    WHEN age >= 60 THEN '60대 이상'"
						+ "			    END 연령대, COUNT(*) 인원"
						+ "	FROM(SELECT DATE_FORMAT(NOW(), '%Y') - DATE_FORMAT(cstm_birth, '%Y') age FROM customer) a"
						+ "	GROUP BY 연령대"
						+ "	ORDER BY 연령대;";
		PreparedStatement stmt = conn.prepareStatement(ageStatsSql);
		
		ResultSet ageRs = stmt.executeQuery();
		while(ageRs.next()) {
			ageList.put(ageRs.getString("연령대"), ageRs.getInt("인원"));
		}
		return ageList;
	}
	
	// 회원통계_성별별
	public HashMap<String, Object> genStats() throws Exception{
		// 결과값 담길 ArrayList 선언
		HashMap<String, Object> genList = new HashMap<String, Object>();
		// DB메소드
		DBUtil dbUtil = new DBUtil(); 
		Connection conn = dbUtil.getConnection();
		// 연령별 인원 통계
		String genStatsSql = "SELECT cstm_gender 성별, COUNT(*) 인원 FROM customer GROUP BY cstm_gender";
		PreparedStatement stmt = conn.prepareStatement(genStatsSql);
		
		ResultSet genRs = stmt.executeQuery();
		while(genRs.next()) {
			genList.put(genRs.getString("성별"), genRs.getInt("인원"));
		}
		return genList;
	}
	// id 성별 생일 나이 리스트
	/*
	SELECT id, cstm_gender, cstm_birth, DATE_FORMAT(NOW(), '%Y') - DATE_FORMAT(cstm_birth, '%Y') age
	FROM customer;
	 */
}

