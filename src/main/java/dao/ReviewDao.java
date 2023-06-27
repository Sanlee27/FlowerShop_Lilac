package dao;

import java.sql.*;


import java.util.*;

import util.DBUtil;
import vo.*;


public class ReviewDao {
	
	//product 상세 페이징
	public int selectReviewProductNoCnt(int productNo) throws Exception {
		int row = 0;
		
		//db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
	
		//총 행을 구하는 sql문
		String pageSql = "SELECT * FROM review r \r\n"
				+ "INNER JOIN orders o \r\n"
				+ "ON r.order_no = o.order_no \r\n"
				+ "WHERE o.product_no = ? \r\n"
				+ "ORDER BY o.order_no \r\n";

		PreparedStatement stmt = conn.prepareStatement(pageSql);
		stmt.setInt(1, productNo);
		ResultSet pageRs = stmt.executeQuery();
		
		if(pageRs.next()) {
			row = pageRs.getInt(1);
		}
		return row;
	}
	
	
	
	
	//reviewList 페이징
	public int selectReviewCnt() throws Exception {
		int row = 0;
		//db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
	
		//총 행을 구하는 sql문
		String pageSql = "SELECT COUNT(*) FROM review";
		PreparedStatement pageStmt = conn.prepareStatement(pageSql);
		ResultSet pageRs = pageStmt.executeQuery();
		if(pageRs.next()) {
			row = pageRs.getInt(1);
		}
		return row;
	}


	//상품 상세페이지에 보이는 후기->product.jsp 
		//보이는 이미지 없음
		//정렬 날짜 최신순으로
		//id 추가되게
	public ArrayList<HashMap<String, Object>> reviewProductList (int productNo, int reBeginRow, int reRowPerPage) throws Exception{

		//반환할 리스트
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		
		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환해 리스트에 저장
		String sql = "SELECT R.order_no orderNo, R.review_title reviewTitle,O.product_no productNo, O.id id, R.createdate, R.updatedate\r\n"
				+ "FROM review R\r\n"
				+ "LEFT OUTER JOIN orders O\r\n"
				+ "ON R.order_no = O.order_no\r\n"
				+ "WHERE O.product_no = ?\r\n"
				+ "ORDER BY R.order_no DESC\r\n"
				+ "limit ?, ?";
		PreparedStatement reviewStmt = conn.prepareStatement(sql);
		
		reviewStmt.setInt(1, productNo);
		reviewStmt.setInt(2, reBeginRow);
		reviewStmt.setInt(3, reRowPerPage);
		ResultSet reviewRs = reviewStmt.executeQuery();
		
		while(reviewRs.next()) {
			HashMap<String, Object> map = new HashMap<>();
			Review review = new Review();
			
			review.setOrderNo(reviewRs.getInt("orderNo"));
			review.setReviewTitle(reviewRs.getString("reviewTitle"));
			review.setUpdatedate(reviewRs.getString("updatedate"));
			review.setCreatedate(reviewRs.getString("createdate"));

			map.put("review", review);
			map.put("id", reviewRs.getString("id"));
			map.put("productNo", reviewRs.getInt("productNo"));
			
		    list.add(map);
			
		}
		return list;
	}

	
	
	//후기 전체 리스트 출력
	public  ArrayList <HashMap<String, Object>> reviewList(int beginRow, int rowPerPage) throws Exception{
		//반환할 리스트
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();

		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		
		String sql = "SELECT R.order_no orderNo, R.review_title reviewTitle, P.product_name productName, R.createdate, R.updatedate\r\n"
				+ " FROM review R\r\n"
				+ "LEFT OUTER JOIN orders O\r\n"
				+ "ON R.order_no = O.order_no\r\n"
				+ "LEFT OUTER JOIN product P\r\n"
				+ "ON P.product_no = O.product_no\r\n"
				+ "ORDER BY R.order_no DESC\r\n"
				+ "limit ?, ?";
		
		PreparedStatement rListStmt = conn.prepareStatement(sql);

		rListStmt.setInt(1, beginRow);
		rListStmt.setInt(2, rowPerPage);
		ResultSet rListRs = rListStmt.executeQuery();
		
		while(rListRs.next()) {
			HashMap<String, Object> map = new HashMap<>();
			Review review = new Review();
			review.setOrderNo(rListRs.getInt("orderNo"));
			review.setReviewTitle(rListRs.getString("reviewTitle"));
			review.setUpdatedate(rListRs.getString("updatedate"));
			review.setCreatedate(rListRs.getString("createdate"));

			map.put("review", review);
			map.put("productName", rListRs.getString("productName"));
			
		    list.add(map);
			
		}
		return list;

		
	}
	

	//후기 상세페이지 후기 출력 ->review.jsp
	public HashMap<String, Object> reviewOne(int orderNo) throws Exception{
		
		Review review = null;
		ReviewImg reviewImg = null;


		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환해 리스트에 저장
		//select 쿼리
		String sql = "SELECT R.order_no orderNo, R.review_title reviewTitle, R.review_content reviewContent, O.id, R.createdate, R.updatedate \r\n"
				+ "FROM review R \r\n"
				+ "LEFT OUTER JOIN orders O\r\n"
				+ "ON R.order_no = O.order_no\r\n"
				+ "WHERE R.order_no = ? \r\n"
				+ "ORDER BY R.order_no";
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
		
		//디버깅
		System.out.println(imageRs + "imageRs");
		
		// 생성한 hashmap에 데이터 넣어주기
		HashMap<String, Object> map = new HashMap<>();
		
		map.put("review", review);
		map.put("reviewImg", reviewImg);
		map.put("id", oneRs.getString("id"));	
		
		return map;
	}
	
	
	
	//후기 입력 액션페이지 
	/*addReviewAction.jsp
	 * hashmap (string, object)
	 * 이미지가 같이 나오게
	 * 1. 리뷰insert 쿼리문 
	 * 2. 리뷰img 쿼리문
	 */
	
	public int addReview (HashMap<String, Object> map) throws Exception{
		//매개변수가 해쉬맵: 내가 선언하지 않아도 쓸 수 있는 변수가 해쉬맵이다
		
		//vo 저장
		Review review = (Review)map.get("review");
		ReviewImg reviewImg = (ReviewImg)map.get("reviewImg");
		
		
		//sql 실행시 영향받은 행
		int row = 0;

		//db접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		//sql 전송, 결과셋 반환해 리스트에 저장
		PreparedStatement addStmt = conn.prepareStatement(
				"insert into review (order_no, review_title, review_content, createdate, updatedate) VALUES ( ?, ?, ?, NOW(), NOW())"
				);
		addStmt.setInt(1, review.getOrderNo());
		addStmt.setString(2, review.getReviewTitle());
		addStmt.setString(3, review.getReviewContent());
		row += addStmt.executeUpdate();
		
		//리뷰이미지 INSERT 쿼리
		PreparedStatement imgStmt = conn.prepareStatement(
				"insert into review_img VALUES (?, ?, ?, ?, NOW(), NOW())"
				);
		//? 4개
		imgStmt.setInt(1, reviewImg.getOrderNo());
		imgStmt.setString(2, reviewImg.getReviewOriFilename());
		imgStmt.setString(3, reviewImg.getReviewSaveFilename());
		imgStmt.setString(4, reviewImg.getReviewFiletype());
		
		row += imgStmt.executeUpdate();
		
		return row;
		
	}
	
	
	
	
	//후기 수정 액션페이지 -> modifyReviewAction.jsp 
	/* hashmap (string, object)
	 * 이미지가 같이 나오게!
	 */
		public int modReview (HashMap<String, Object> map) throws Exception{
		
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
				"UPDATE review SET review_title= ?, review_content=?, createdate= NOW(), updatedate = NOW() WHERE order_no = ?"
				);
		
		modStmt.setString(1, review.getReviewTitle());
		modStmt.setString(2, review.getReviewContent());
		modStmt.setInt(3, review.getOrderNo());
		
		row = modStmt.executeUpdate();
		
		//리뷰이미지 update 쿼리
		PreparedStatement imgStmt = conn.prepareStatement(
				"UPDATE review_img SET review_ori_filename = ?, review_save_filename = ?, review_filetype = ?, updatedate=NOW() WHERE order_no = ?"
				);
		//? 4개
		imgStmt.setString(1, reviewImg.getReviewOriFilename());
		imgStmt.setString(2, reviewImg.getReviewSaveFilename());
		imgStmt.setString(3, reviewImg.getReviewFiletype());
		imgStmt.setInt(4, reviewImg.getOrderNo());
		
		row += imgStmt.executeUpdate();
		
		
		return row;
	}
	
	
	
	//후기 삭제 액션 ->removeReviewAction.jsp
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
