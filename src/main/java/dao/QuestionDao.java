package dao;

import java.sql.*;
import java.util.*;
import util.*;
import vo.*;


public class QuestionDao {
	
	//미답변한 q&a '만' 출력 -> employees.jsp
	//쿼리문: SELECT * FROM question WHERE q_answer LIKE 'N';
	
	public ArrayList<HashMap<String, Object>> selectQuestionByPage(int beginRow, int rowPerPage) throws Exception{
		
		//반환할 리스트
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		
		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환해 리스트에 저장
		String sql = "SELECT q_no, product_no, id, q_category, q_answer, q_title, q_content, createdate, updatedate FROM question WHERE q_answer LIKE 'N' LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();

		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			
				m.put("qNo", rs.getInt("qNo"));
				m.put("productNo", rs.getInt("productNo"));
				m.put("id", rs.getString("id"));
				m.put("qCategory", rs.getString("qCategory"));
				m.put("qAnswer", rs.getString("qAnswer"));
				m.put("qTitle", rs.getString("qTitle"));
				m.put("qContent", rs.getString("qContent"));
				m.put("createdate", rs.getString("createdate"));
				m.put("updatedate", rs.getString("updatedate"));
				
				list.add(m);
		}
		
		
		return list;
	}
		
		
	
	
	//고객 별 문의내역 출력 -> cstmQnaList.jsp
	//쿼리문: SELECT * FROM question where id = ?;
	
	
	
	//상품 상세페이지에서 문의 출력
		
	
	//문의글 입력 -> addQuestion.jsp
	
	
	//문의 상세페이지 출력, 수정 폼-> question.jsp
		//불러올 항목: q_no, product_no, id q_category, q_answer, q_title, q_content, createdate, updatedate
	public Question questionOne(int qNo) throws Exception {
		
		Question question = null;
		
		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환 후 저장
		PreparedStatement stmt = conn.prepareStatement("SELECT q_no qNo, product_no productNo, id, q_category qCategory, q_answer qAnswer, q_title qTitle, q_content qContent, createdate, updatedate FROM question WHERE q_no = ?");
		stmt.setInt(1, qNo);
		ResultSet questionRs = stmt.executeQuery();
		
		if(questionRs.next()) {
			question = new Question();
			question.setqNo(questionRs.getInt("qNo"));
			question.setProductNo(questionRs.getInt("productNo"));
			question.setId(questionRs.getString("id"));
			question.setqCategory(questionRs.getString("qCategory"));
			question.setqAnswer(questionRs.getString("qAnswer"));
			question.setqTitle(questionRs.getString("qTitle"));
			question.setUpdatedate(questionRs.getString("updatedate"));
			question.setCreatedate(questionRs.getString("createdate"));

		}
	
		return question;
		
		
	}

	//문의글 수정 폼(상세페이지 출력과 동일) -> modifyQuestion.jsp
	
	//문의글 수정 액션 -> modifyQuestionAction.jsp
	
	public int modifyQuestion(Question question) throws Exception {
		//sql 실행시 영향받은 행의 수
		int row = 0;
		
		//db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환 후 저장
		PreparedStatement stmt = conn.prepareStatement("UPDATE question SET q_no = ?, id=?, q_category=?, q_answer=?, q_title = ?, q_content = ?, updatedate = NOW() WHERE q_no = ?");
		//물음표 6개
		stmt.setInt(1, question.getqNo());
		stmt.setString(2, question.getId());
		stmt.setString(3, question.getqCategory());
		stmt.setString(4, question.getqAnswer());
		stmt.setString(5, question.getqTitle());
		stmt.setString(6, question.getqContent());
		row = stmt.executeUpdate();
		
		return row;
	}
	
	
	//문의글 삭제 액션 -> removeQuestionAction.jsp
	
	public int deleteQuestion(int qNo) throws Exception {
		//sql 실행시 영향받은 행의 수
		int row = 0;
		
		//db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환 후 저장
		PreparedStatement stmt = conn.prepareStatement("DELETE FROM question WHERE q_no = ?");
		stmt.setInt(1, qNo);
		row = stmt.executeUpdate();
		
		return row;
	}
}
