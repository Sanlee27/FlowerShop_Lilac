package dao;

import java.util.*;
import java.sql.*;
import util.*;
import vo.*;

public class OrderDao {
	// 일주일치 판매량을 반환하는 메서드 
	public ArrayList<HashMap<String, Object>> getWeekSaleCnt() throws Exception{
		// 결과값을 담아줄 HashMap ArrayList 선언
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 일주일치 판매량을 가져오는 쿼리 **주문 취소건이 아닌건 모두 집계
		String sql = "SELECT sum(order_cnt) cnt, substring(createdate, 1, 10) orderdate FROM orders WHERE order_status != '취소' AND DATEDIFF(NOW(), createdate) + 1 <= 7 GROUP BY substring(createdate, 1, 10)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리 실행후 결과 저장
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> map = new HashMap<>();
			map.put("orderdate", rs.getString("orderdate"));
			map.put("cnt", rs.getInt("cnt"));
			list.add(map);
		}
		
		return list;
	}
	
	// 전체 주문 내역을 가져오는 메서드
	public ArrayList<HashMap<String, Object>> getAllOrderList(String searchUser, String searchProduct, int startRow, int rowPerPage) throws Exception{
		// 결과값을 담아줄 HashMap ArrayList 선언
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		
		// 요청값 있으면 쿼리에 추가
		String searchQuery = "";
		
		if(searchUser != null && !searchUser.equals("")) {
			searchQuery += "where o.id like '%" + searchUser + "%'";
		}
		if(searchProduct != null && !searchProduct.equals("")) {
			if(!searchQuery.equals("")) {
				searchQuery += " and ";
			}else {
				searchQuery += "where ";
			}
			searchQuery += "p.product_name like '%" + searchProduct + "%'";
		}
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 전체 주문개수를 가져오는 쿼리
		String cntSql = "SELECT COUNT(*) FROM orders o LEFT OUTER JOIN product p  ON p.product_no = o.product_no" + searchQuery;
		PreparedStatement cntStmt = conn.prepareStatement(cntSql);
		
		//쿼리 실행 후 결과 값 저장
		ResultSet cntRs = cntStmt.executeQuery();
		
		HashMap<String,Object> cntMap = new HashMap<>();
		
		if(cntRs.next()) {
			cntMap.put("totalCnt", cntRs.getInt(1));
		}
		
		list.add(cntMap);
		
		// 전체 주문내역을 가져오는 쿼리(최신순으로, 취소/완료건 밑으로)
		String sql = "SELECT o.*, p.product_name FROM orders o LEFT OUTER JOIN product p ON p.product_no = o.product_no " + searchQuery + " ORDER BY order_status, o.createdate DESC limit ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// ?값 세팅
		stmt.setInt(1, startRow);
		stmt.setInt(2, rowPerPage);
		
		// 쿼리 실행 후 결과 값 저장
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> map = new HashMap<>();
			
			Order order = new Order();
			order.setOrderNo(rs.getInt("order_no"));
			order.setProductNo(rs.getInt("product_no"));
			order.setId(rs.getString("id"));
			order.setOrderStatus(rs.getString("order_status"));
			order.setOrderCnt(rs.getInt("order_cnt"));
			order.setOrderPrice(rs.getInt("order_price"));
			order.setCreatedate(rs.getString("createdate"));
			
			String productName = rs.getString("product_name");
			
			map.put("order", order);
			map.put("productName", productName);
			
			list.add(map);
		}
		
		return list;
	}
	
	// 주문 상태를 수정하는 메서드
	public int updateOrderStatus(Order order) throws Exception {
		// 매개변수값 유효성 검사
		if(order == null || order.getOrderStatus() == null) {
			System.out.println("입력값이 없거나 바르지 않습니다.");
			return 0;
		}
		//결과 값을 반환해줄 int타입 변수 선언
		int row = 0;
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 주문상태를 수정하는 쿼리
		String sql = "UPDATE orders SET order_status = ?, updatedate = NOW() WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// ?값 세팅
		stmt.setString(1, order.getOrderStatus());
		stmt.setInt(2, order.getOrderNo());
		
		// 쿼리 실행후 영향받은 행의 수 저장
		row = stmt.executeUpdate();
		
		if(!order.getOrderStatus().equals("취소")) {
			return row;
		}
		
		// 주문 취소건일 경우에는 상품의 판매량 개수 줄여주기
		String cancelSql = "UPDATE product SET product_sale_cnt = product_sale_cnt - ?, updatedate = NOW() WHERE product_no = ?";
		PreparedStatement cancelStmt = conn.prepareStatement(cancelSql);
		
		// ?값 세팅
		cancelStmt.setInt(1, order.getOrderCnt());
		cancelStmt.setInt(2, order.getProductNo());
		
		row += cancelStmt.executeUpdate();
		
		return row;
	}
	
	// 고객별 주문내역 리스트를 반환하는 메서드
	public ArrayList<HashMap<String, Object>> getCstmOrderList(String id) throws Exception{
		// 매개변수 값 유효성 검사
		if(id == null || id.equals("")) {
			System.out.println("아이디 값이 입력되지 않았습니다.");
			return null;
		}
		
		// 결과를 담아줄 HashMap ArrayList 선언
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 고객별 주문내역 리스트를 가져오는 쿼리
		String sql = "SELECT o.*, p.product_name, pimg.product_save_filename, pimg.product_filetype FROM orders o INNER JOIN product p ON o.product_no = p.product_no INNER JOIN product_img pimg ON p.product_no = pimg.product_no WHERE id = ? ORDER  BY createdate DESC";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// ?값 세팅
		stmt.setString(1, id);
		
		// 쿼리 실행 후 결과값 저장
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> map = new HashMap<>();
			
			Order order = new Order();
			order.setOrderNo(rs.getInt("order_no"));
			order.setProductNo(rs.getInt("product_no"));
			order.setId(rs.getString("id"));
			order.setOrderStatus(rs.getString("order_status"));
			order.setOrderCnt(rs.getInt("order_cnt"));
			order.setOrderPrice(rs.getInt("order_price"));
			order.setCreatedate(rs.getString("createdate"));
			
			String productName = rs.getString("product_name");
			
			ProductImg pimg = new ProductImg();
			pimg.setProductSaveFilename(rs.getString("product_save_filename"));
			pimg.setProductFiletype(rs.getString("product_filetype"));
			
			map.put("order", order);
			map.put("productName", productName);
			map.put("productImg", pimg);
			
			list.add(map);
		}
		
		return list;
	}
	
	// 주문 하나에 대한 상세정보를 반환하는 메서드
	// **jsp단에서 order정보 받아서 order의 product_no로 product정보랑 productImg정보가져옴
	public Order getOrderDetail(int orderNo) throws Exception {
		// 결과를 담아줄 Order타입 객체 선언
		Order order = new Order();
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 주문 하나에 대한 상세정보를 가져오는 쿼리
		String sql = "select * from orders where order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// ?값 세팅
		stmt.setInt(1, orderNo);
		
		// 쿼리 실행후 결과 저장
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			order.setOrderNo(rs.getInt("order_no"));
			order.setProductNo(rs.getInt("product_no"));
			order.setOrderCnt(rs.getInt("order_cnt"));
			order.setOrderPrice(rs.getInt("order_price"));
			order.setId(rs.getString("id"));
			order.setOrderStatus(rs.getString("order_status"));
			order.setCreatedate(rs.getString("createdate"));
		}
		
		return order;
	}
	
	// 주문 정보를 입력하는 메서드
	public int insertOrder(Order order) throws Exception {
		// 결과를 저장해줄 int타입 변수 선언
		int row = 0;
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 주문 정보 데이터를 추가하는 쿼리
		String sql = "INSERT INTO orders(product_no, id, order_status, order_cnt, order_price, createdate, updatedate) VALUES(?, ?, '결제완료', ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// ?값 세팅
		stmt.setInt(1, order.getProductNo());
		stmt.setString(2, order.getId());
		stmt.setInt(3, order.getOrderCnt());
		stmt.setInt(4, order.getOrderPrice());
		
		// 쿼리 실행 후 영향받은 행 저장
		row = stmt.executeUpdate();
		
		// 주문한 제품의 판매수량을 더해주는 쿼리
		String productSql = "update product set product_sale_cnt = product_sale_cnt + ?, updatedate = now() where product_no = ?";
		PreparedStatement productStmt = conn.prepareStatement(productSql);
		
		// ?값 세팅
		productStmt.setInt(1, order.getOrderCnt());
		productStmt.setInt(2, order.getProductNo());
		
		// 쿼리 실행 후 영향받은 행 저장
		row += productStmt.executeUpdate();
		
		return row;
	}
}
