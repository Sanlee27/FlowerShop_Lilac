package dao;

import java.sql.*;

import java.util.*;

import util.DBUtil;
import vo.*;


public class ReviewDao {
	
	//상품 상세페이지 후기 출력 ->product.jsp //where 절에 order no가져옴
	//보이는 이미지 없음
		

	public ArrayList<Review> reviewProduct (int beginRow, int rowPerPage) throws Exception{
		//반환할 리스트
		ArrayList<Review> list = new ArrayList<>();
		
		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환해 리스트에 저장
		String sql = "SELECT order_no orderNo, review_title reviewTitle, review_content reviewContent, createdate, updatedate FROM review WHERE order_no ORDER BY order_no LIMIT ?, ?";
		PreparedStatement reviewStmt = conn.prepareStatement(sql);
		
		reviewStmt.setInt(1, beginRow);
		reviewStmt.setInt(2, rowPerPage);
		ResultSet reviewRs = reviewStmt.executeQuery();
		
		while(reviewRs.next()) {
			Review m = new Review();
			
				m.setOrderNo(reviewRs.getInt("orderNo"));
				m.setReviewTitle(reviewRs.getString("reviewTitle"));
				m.setReviewContent(reviewRs.getString("reviewContent"));
				m.setCreatedate(reviewRs.getString("createdate"));
				m.setUpdatedate(reviewRs.getString("updatedate"));
				list.add(m);
		}
		
		return list;
	}

	
	
	//후기 전체 리스트 출력
	//보이는 이미지 없음
	
	public  ArrayList <Review> reviewList(int beginRow, int rowPerPage) throws Exception{
		//반환할 리스트
		ArrayList<Review> list = new ArrayList<>();
		
		//db접속
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection();
			
			//sql 전송, 결과셋 반환해 리스트에 저장
			String sql = " SELECT order_no orderNo, review_title reviewTitle, createdate, updatedate FROM review WHERE order_no ORDER BY order_no LIMIT ?, ?";
			PreparedStatement rListStmt = conn.prepareStatement(sql);
			
			rListStmt.setInt(1, beginRow);
			rListStmt.setInt(2, rowPerPage);
			ResultSet rListRs = rListStmt.executeQuery();
			
			while(rListRs.next()) {
				Review m = new Review();

					m.setOrderNo(rListRs.getInt("orderNo"));
					m.setReviewTitle(rListRs.getString("reviewTitle"));
					m.setCreatedate(rListRs.getString("createdate"));
					m.setUpdatedate(rListRs.getString("updatedate"));
					list.add(m);
			}
			
			return list;
		}
	
		

		

	
	//후기 상세페이지 후기 출력 ->review.jsp // hashmap(string, object)을 매개변수 //이미지가 같이 나오게
	public HashMap<String, Object> reviewOne(int orderNo) throws Exception{
		
		Review review = null;
		ReviewImg reviewImg = null;

		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환해 리스트에 저장
		//select 쿼리
		String sql = "SELECT order_no orderNo, review_title reviewTitle, review_content reviewContent, createdate, updatedate FROM review WHERE order_no=? ORDER BY order_no";
		PreparedStatement oneStmt = conn.prepareStatement(sql);
		oneStmt.setInt(1, orderNo);
		ResultSet oneRs = oneStmt.executeQuery();
		
		if(oneRs.next()) {
			review = new Review();
			review.setOrderNo(oneRs.getInt("orderNo"));
			review.setReviewTitle(oneRs.getString("reviewTitle"));
			review.setReviewContent(oneRs.getString("reviewContent"));
			review.setCreatedate(oneRs.getString("createdate"));
			review.setUpdatedate(oneRs.getString("updatedate"));

		}
		
		//이미지 쿼리
		
		PreparedStatement imageStmt = conn.prepareStatement(
				"SELECT order_no orderNo, review_ori_filename reviewOriFilename, review_save_filename reviewSaveFilename, review_filetype reviewFiletype, createdate, updatedate FROM review_img WHERE order_no=? ORDER BY order_no"
				);
		imageStmt.setInt(1, review.getOrderNo());
		ResultSet imageRs = imageStmt.executeQuery();
		
		if(imageRs.next()) {
			reviewImg = new ReviewImg();
			reviewImg.setOrderNo(imageRs.getInt("orderNo"));
			reviewImg.setReviewOriFilename(imageRs.getString("reviewOriFilename"));
			reviewImg.setReviewSaveFilename(imageRs.getString("reviewSaveFilename"));
			reviewImg.setReviewFiletype(imageRs.getString("reviewFiletype"));
			reviewImg.setCreatedate(imageRs.getString("createdate"));
			reviewImg.setUpdatedate(imageRs.getString("updatedate"));
		}
		
		// 생성한 hashmap에 데이터 넣어주기
		HashMap<String, Object>map = new HashMap<String, Object>();
		
		map.put("review", review);
		map.put("reviewImg", reviewImg);
		
		return map;
	}
	
	//후기 입력 액션페이지 -> addReviewAction.jsp // hashmap (string, object) //이미지가 같이 나오게! //1. 리뷰insert 쿼리문 2. generate key 사용 3. 리뷰img 쿼리문
	
	public int addReview (HashMap<String, Object>map) throws Exception{
		
		//vo 저장
		Review review = (Review)map.get("review");
		ReviewImg reviewImg = (ReviewImg)map.get("reviewImg");
		
		
		//sql 실행시 영향받은 행
		int row = 0;

		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환해 리스트에 저장
		//insert 쿼리
		//insert into review (order_no, review_title, review_content, createdate, updatedate) VALUES (?, ?, ?, NOW(), NOW());
		PreparedStatement addStmt = conn.prepareStatement(
				"insert into review (order_no orderNo, review_title reviewTitle, review_content reviewContent, createdate, updatedate) VALUES (?, ?, ?, NOW(), NOW())"
				);
		addStmt.setInt(1, review.getOrderNo());
		addStmt.setString(2, review.getReviewTitle());
		addStmt.setString(3, review.getReviewContent());
		row = addStmt.executeUpdate();
		
		//쿼리 실행 후 orderNo 값 가져오기
		ResultSet imgRs = addStmt.getGeneratedKeys(); //getGeneratedKeys(): AutoIncrement 키값 가져오기
		int orderNo = 0;
		
		if(imgRs.next()) {
			orderNo = imgRs.getInt(1);
		}
		
		//리뷰이미지 INSERT 쿼리
		PreparedStatement imgStmt = conn.prepareStatement(
				"insert into review_img (order_no, review_ori_filename, review_save_filename, review_filetype, createdate, updatedate) VALUES (?, ?, ?, ?, NOW(), NOW())"
				);
		//?
		imgStmt.setInt(1, orderNo);
		imgStmt.setString(2, reviewImg.getReviewOriFilename());
		imgStmt.setString(3, reviewImg.getReviewSaveFilename());
		imgStmt.setString(4, reviewImg.getReviewFiletype());
		
		row = imgStmt.executeUpdate();
		
		
		return row;
	}
	
	
	
	
	//(후기 입력 폼(후기 상세페이지 출력과 동일) -> addReviewAction.jsp)

	//(후기 수정 폼(후기 상세페이지 출력과 동일) ->modifyReview.jsp)
	
	
	
	//후기 수정 액션페이지 -> modifyReviewAction.jsp // hashmap (string, object) //이미지가 같이 나오게!
		public int modReview (HashMap<String, Object>map) throws Exception{
		
		//vo 저장
		Review review = (Review)map.get("review");
		ReviewImg reviewImg = (ReviewImg)map.get("reviewImg");
		
		
		//sql 실행시 영향받은 행
		int row = 0;

		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환해 리스트에 저장
		//update 쿼리
		
		PreparedStatement modStmt = conn.prepareStatement(
				"UPDATE review SET order_no = ?, review_title= ?, review_content=?, createdate= NOW(), updatedate = NOW() WHERE order_no = ?"
				);
		modStmt.setInt(1, review.getOrderNo());
		modStmt.setString(2, review.getReviewTitle());
		modStmt.setString(3, review.getReviewContent());
		
		row = modStmt.executeUpdate();
		
		//리뷰이미지 update 쿼리
		PreparedStatement imgStmt = conn.prepareStatement(
				"UPDATE review_img SET review_ori_filename = ?, review_save_filename = ?, review_filetype = ?, updatedate=NOW() WHERE order_no = ?"
				);
		//?
		imgStmt.setString(1, reviewImg.getReviewOriFilename());
		imgStmt.setString(2, reviewImg.getReviewSaveFilename());
		imgStmt.setString(3, reviewImg.getReviewFiletype());
		imgStmt.setInt(4, reviewImg.getOrderNo());
		
		row = imgStmt.executeUpdate();
		
		
		return row;
	}
	
	
	
	//후기 삭제 액션 ->removeReviewAction.jsp
	//sql: delete from review where order_no=?;
	
	public int deleteReview(int orderNo) throws Exception {
		//sql 실행시 영향받은 행의 수
		int row = 0;

		//db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환 후 저장		
		PreparedStatement delStmt = conn.prepareStatement(
				"delete from review where order_no=?"
				);
		delStmt.setInt(1, orderNo);
		row = delStmt.executeUpdate();
	return row; 
	}
	
}
