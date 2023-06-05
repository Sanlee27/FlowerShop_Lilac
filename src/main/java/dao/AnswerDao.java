package dao;

import java.sql.*;
import util.DBUtil;
import vo.*;

public class AnswerDao {
	// qNo를 받아서 그 번호에 해당하는 Answer데이터를 가져오는 메소드 추가 필요
	
	//답변 추가
	public int insertAnswer(Answer answer) throws Exception {
		//유효성검사
		if(answer == null || answer.getAnswerContent() == null) {
			System.out.println("answer클래스, AnswerContent값 확인");
			return 0;
		}
		
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement answerInsStmt = conn.prepareStatement(
				"INSERT INTO answer(q_no, id, answer_content, createdate, updatedate) VALUES(?, ?, ?, now(), now())"
			);
		answerInsStmt.setInt(1, answer.getqNo());
		answerInsStmt.setString(2, answer.getId());
		answerInsStmt.setString(3, answer.getAnswerContent());
		
		row = answerInsStmt.executeUpdate();
		
		return row; 
	}
	//답변 수정
	public int updateAnswer(Answer answer) throws Exception {
		//유효성검사
		if(answer == null || answer.getAnswerContent() == null) {
			System.out.println("answer클래스, AnswerContent값 확인");
			return 0;
		}
		
		int row = 0; 
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement answerUpStmt = conn.prepareStatement(
				"UPDATE answer SET answer_content = ? WHERE answer_no = ?"
			);
		answerUpStmt.setString(1, answer.getAnswerContent());
		answerUpStmt.setInt(2, answer.getAnswerNo());
		
		row = answerUpStmt.executeUpdate();
		
		return row; 
	}
	
	//답변 삭제
	public int deleteAnswer(int answerNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement answerDelStmt = conn.prepareStatement(
				"DELETE FROM answer WHERE answer_no = ?"
			);
		answerDelStmt.setInt(1, answerNo);
		
		answerNo = answerDelStmt.executeUpdate();
		
		return answerNo;
	}
}	
