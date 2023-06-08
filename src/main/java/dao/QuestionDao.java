package dao;

import java.sql.*;
import java.util.*;
import util.*;
import vo.*;


public class QuestionDao {
	
	//페이징을 위한 메서드 만들기
	public int selectQuestionCnt() throws Exception {
		int row = 0;
		
		//db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
	
		//총 행을 구하는 sql문
		String pageSql = "SELECT COUNT(*) FROM question";
		PreparedStatement pageStmt = conn.prepareStatement(pageSql);
		ResultSet pageRs = pageStmt.executeQuery();
		if(pageRs.next()) {
			row = pageRs.getInt(1);
		}
		return row;
	}
			
	//페이징을 위한 메서드 만들기
	public int selectNoAnswerCnt() throws Exception {
		int row = 0;
		
		//db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
	
		//총 행을 구하는 sql문
		String pageSql = "SELECT COUNT(*) FROM question where q_answer = 'N";
		PreparedStatement pageStmt = conn.prepareStatement(pageSql);
		ResultSet pageRs = pageStmt.executeQuery();
		if(pageRs.next()) {
			row = pageRs.getInt(1);
		}
		return row;
	}

	//미답변한 q&a '만' 출력하는 메서드 -> employees.jsp
	//쿼리문: SELECT * FROM question WHERE q_answer LIKE 'N';
	public ArrayList<Question> selectQuestionByPage (int beginRow, int rowPerPage) throws Exception{
		//반환할 리스트
				ArrayList<Question> list = new ArrayList<>();
				
		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환해 리스트에 저장
		String sql = "SELECT q_no qNo, product_no productNo, id, q_category qCategory, q_answer qAnswer, q_title qTitle, q_content qContent, createdate, updatedate FROM question WHERE q_answer LIKE 'N' ORDER BY q_no DESC LIMIT ?, ?";
		PreparedStatement selectStmt = conn.prepareStatement(sql);
		selectStmt.setInt(1, beginRow);
		selectStmt.setInt(2, rowPerPage);
		ResultSet selectRs = selectStmt.executeQuery();
		while(selectRs.next()) {
			Question m = new Question();
			
				m.setqNo(selectRs.getInt("qNo"));
				m.setProductNo(selectRs.getInt("productNo"));
				m.setId(selectRs.getString("id"));
				m.setqCategory(selectRs.getString("qCategory"));
				m.setqAnswer(selectRs.getString("qAnswer"));
				m.setqTitle(selectRs.getString("qTitle"));
				m.setqContent(selectRs.getString("qContent"));
				m.setCreatedate(selectRs.getString("createdate"));
				m.setCreatedate(selectRs.getString("updatedate"));
				
				list.add(m);
		}
		
		return list;
	}
		
	
	// q_no 받아서 q_no에 해당하는 q_answer값 Y로 변경해주는 메서드
	
	public int updatdQuestionByPage(int qNo) throws Exception {
		//sql 실행시 영향받은 행의 수
		int row = 0;
		
		//db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환 후 저장
		PreparedStatement updateStmt = conn.prepareStatement("UPDATE question SET q_answer='Y', updatedate = NOW() WHERE q_no = ?");
		
		//물음표 1개
		updateStmt.setInt(1, qNo);

		row = updateStmt.executeUpdate();
		
		return row;
	}
	
	
	
	
	

	//고객 별 문의내역 출력하는 메서드 -> cstmQnaList.jsp(id를 받아서 그 아이디에 해당하는 question리스트 불러오기)
	//쿼리문 : SELECT q_no, product_no, id, q_category, q_answer, q_title, q_content, createdate, updatedate FROM question WHERE q_no=? ORDER BY q_no
	public ArrayList<Question> Questioncust (String id, int beginRow, int rowPerPage) throws Exception{
		//반환할 리스트
				ArrayList<Question> list = new ArrayList<>();
				
		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환해 리스트에 저장
		String sql =  "SELECT q_no qNo, product_no productNo, id , q_category qCategory, q_answer qAnswer, q_title qTitle, q_content qContent, createdate, updatedate FROM question  WHERE id=? ORDER BY q_no DESC LIMIT ?, ?";
		PreparedStatement custStmt = conn.prepareStatement(sql);
		custStmt.setString(1, id);
		custStmt.setInt(2, beginRow);
		custStmt.setInt(3, rowPerPage);
		ResultSet custRs = custStmt.executeQuery();
		while(custRs.next()) {
			Question m = new Question();
			
				m.setqNo(custRs.getInt("qNo"));
				m.setProductNo(custRs.getInt("productNo"));
				m.setId(custRs.getString("id"));
				m.setqCategory(custRs.getString("qCategory"));
				m.setqAnswer(custRs.getString("qAnswer"));
				m.setqTitle(custRs.getString("qTitle"));
				m.setqContent(custRs.getString("qContent"));
				m.setCreatedate(custRs.getString("createdate"));
				m.setCreatedate(custRs.getString("updatedate"));
				
				list.add(m);
		}
		
		return list;
	}
	
	//전체 문의 리스트 출력하는 메서드
	
	public  ArrayList <Question> questionList(int beginRow, int rowPerPage) throws Exception{
		//반환할 리스트
		ArrayList<Question> list = new ArrayList<>();
		
		//db접속
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection();
			
			//sql 전송, 결과셋 반환해 리스트에 저장
			String sql = " SELECT q_no qNo, product_no productNo, id, q_category qCategory, q_answer qAnswer, q_title qTitle, q_content qContent, createdate, updatedate FROM question WHERE q_no ORDER BY q_no DESC LIMIT ?, ?";
			PreparedStatement qListStmt = conn.prepareStatement(sql);
			
			qListStmt.setInt(1, beginRow);
			qListStmt.setInt(2, rowPerPage);
			ResultSet qListRs = qListStmt.executeQuery();
			
			while(qListRs.next()) {
				Question q = new Question();

					q.setqNo(qListRs.getInt("qNo"));
					q.setProductNo(qListRs.getInt("productNo"));
					q.setId(qListRs.getString("setId"));
					q.setqCategory(qListRs.getString("qCategory"));
					q.setqAnswer(qListRs.getString("qAnswer"));
					q.setqTitle(qListRs.getString("qTitle"));
					q.setqContent(qListRs.getString("qContent"));
					q.setCreatedate(qListRs.getString("createdate"));
					q.setUpdatedate(qListRs.getString("updatedate"));
					list.add(q);
			}
			
			return list;
		}
	
		
	

	//상품 상세페이지에서 문의 출력하는 메서드 -> product.jsp 
	// 매개변수에 product_no추가해서 product_no에 해당하는 리스트만 받아오도록 변경, 답변은 Y/N 관계없이 전부나오게
	
	public ArrayList<Question> QuestionProduct (int productNo, int beginRow, int rowPerPage) throws Exception{
		//반환할 리스트
				ArrayList<Question> list = new ArrayList<>();
				
		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환해 리스트에 저장
		String sql =   "SELECT q_no qNo, product_no productNo, id, q_category qCategory, q_answer qAnswer, q_title qTitle, q_content qContent, createdate, updatedate FROM question WHERE product_no=? ORDER BY q_no DESC LIMIT ?, ?";
		PreparedStatement prodStmt = conn.prepareStatement(sql);
		prodStmt.setInt(1, productNo);
		prodStmt.setInt(2, beginRow);
		prodStmt.setInt(3,rowPerPage);
		ResultSet prodRs = prodStmt.executeQuery();
		while(prodRs.next()) {
			Question m = new Question();
			
				m.setqNo(prodRs.getInt("qNo"));
				m.setProductNo(prodRs.getInt("productNo"));
				m.setId(prodRs.getString("id"));
				m.setqCategory(prodRs.getString("qCategory"));
				m.setqAnswer(prodRs.getString("qAnswer"));
				m.setqTitle(prodRs.getString("qTitle"));
				m.setqContent(prodRs.getString("qContent"));
				m.setCreatedate(prodRs.getString("createdate"));
				m.setCreatedate(prodRs.getString("updatedate"));
				
				list.add(m);
		}
		
		return list;
	}
	
	
	
	//문의글 입력하는 메서드 -> addQuestionAction.jsp 
		//입력페이지에 표시될 항목: //q_no, product_no, id, q_category, q_answer, q_title, q_content, createdate, updatedate
	public int addQuestion(Question question) throws Exception {
		//영향받은 행의 수
		int row = 0;
		
		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환 후 저장
		PreparedStatement addStmt = conn.prepareStatement("INSERT INTO question (q_no qNo, product_no productNo, id, q_category, q_title, q_content, createdate, updatedate) VALUES (?, ?, ?, ?, ?, ?, NOW(),NOW()");
		addStmt.setInt(1, question.getqNo());
		addStmt.setInt(2, question.getProductNo());
		addStmt.setString(3, question.getId());
		addStmt.setString(4, question.getqCategory());
		addStmt.setString(5, question.getqTitle());
		addStmt.setString(6, question.getqContent());
		
		row = addStmt.executeUpdate();
		

		return row;
		
		
	}
	
	
	
	
	//문의 상세페이지 출력, 수정 폼-> question.jsp
		//불러올 항목: q_no, product_no, id q_category, q_answer, q_title, q_content, createdate, updatedate
	public Question questionOne(int qNo) throws Exception {
		
		Question question = null;
		
		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환 후 저장
		PreparedStatement oneStmt = conn.prepareStatement("SELECT q_no qNo, product_no productNo, id, q_category qCategory, q_answer qAnswer, q_title qTitle, q_content qContent, createdate, updatedate FROM question WHERE q_no = ?");
		oneStmt.setInt(1, qNo);
		ResultSet questionRs = oneStmt.executeQuery();
		
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
		PreparedStatement modStmt = conn.prepareStatement("UPDATE question SET q_no = ?, id=?, q_category=?, q_answer=?, q_title = ?, q_content = ?, updatedate = NOW() WHERE q_no = ?");
		//물음표 6개
		modStmt.setInt(1, question.getqNo());
		modStmt.setString(2, question.getId());
		modStmt.setString(3, question.getqCategory());
		modStmt.setString(4, question.getqAnswer());
		modStmt.setString(5, question.getqTitle());
		modStmt.setString(6, question.getqContent());
		row = modStmt.executeUpdate();
		
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
		PreparedStatement delStmt = conn.prepareStatement("DELETE FROM question WHERE q_no = ?");
		delStmt.setInt(1, qNo);
		row = delStmt.executeUpdate();
		
		return row;
	}
	

	
	
	
	
}
