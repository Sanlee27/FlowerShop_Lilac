package dao;
import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class ProductDao {
	// 전체상품 리스트를 반환하는 메서드
	public ArrayList<HashMap<String, Object>> getAllProductList(String searchCategory, String searchName, String order, int startRow, int rowPerPage) throws Exception{
		// 결과를 담아줄 HashMap타입 ArrayList선언
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
	
		// 검색부분 매개변수값 있으면 추가
		String searchQuery = "";
		
		if(searchCategory != null && !searchCategory.equals("")) {
			searchQuery += "where p.category_name = '" + searchCategory + "' ";
		}
		
		if(searchName != null && !searchName.equals("")) {
			if(searchQuery.equals("")) {
				searchQuery += "where";
			}else {
				searchQuery += "and";
			}
			searchQuery += " p.product_name like '%" + searchName + "%'";
		}
		
		// 정렬부분 매개변수값 있으면 추가
		String orderQuery = "";
		if(order != null && !order.equals("")) {
			if(order.equals("판매량많은순")) {
				orderQuery += "order by product_sale_cnt desc";
			}
			if(order.equals("가격높은순")) {
				orderQuery += "order by discount_price desc";
			}
			if(order.equals("가격낮은순")) {
				orderQuery += "order by discount_price";
			}
			if(order.equals("할인율높은순")) {
				orderQuery += "order by discount_rate desc";
			}
		}
		
		// 전체상품 리스트를 불러오는 쿼리(할인된 가격 포함, 검색어/정렬기준에 해당하는 결과)
		String sql = "SELECT p.product_no, p.product_name, p.product_price, p.product_status, p.product_sale_cnt, pimg.product_ori_filename, pimg.product_save_filename, pimg.product_filetype, d.discount_rate, ifnull(ROUND((1 - d.discount_rate) * p.product_price), p.product_price) discount_price FROM product p LEFT OUTER join product_img pimg ON p.product_no = pimg.product_no LEFT OUTER JOIN  discount d ON p.product_no = d.product_no " + searchQuery + " " + orderQuery + " limit ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// ?값 세팅
		stmt.setInt(1, startRow);
		stmt.setInt(2, rowPerPage);
		
		// 쿼리 실행 후 저장
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> map = new HashMap<>();
			
			Product p = new Product();
			p.setProductNo(rs.getInt("product_no"));
			p.setProductName(rs.getString("product_name"));
			p.setProductPrice(rs.getInt("product_price"));
			p.setProductStatus(rs.getString("product_status"));
			p.setProductSaleCnt(rs.getInt("product_sale_cnt"));
			
			ProductImg pi = new ProductImg();
			pi.setProductOriFilename(rs.getString("product_ori_filename"));
			pi.setProductSaveFilename(rs.getString("product_save_filename"));
			pi.setProductFiletype(rs.getString("product_filetype"));
			
			double discountRate = rs.getDouble("discount_rate");
			int discountPrice = rs.getInt("discount_price");
			
			map.put("product", p);
			map.put("productImg", pi);
			map.put("discountRate", discountRate);
			map.put("discountPrice", discountPrice);
			
			list.add(map);
		}
		
		return list;
	}
	
	// 상품 하나에 대한 상세정보를 반환하는 메서드
	public HashMap<String, Object> getProductDetail(int productNo) throws Exception {
		// 결과를 담아줄 HashMap선언
		HashMap<String, Object> map = new HashMap<>();
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// productNo에 해당하는 상세정보 가져오는 쿼리
		String sql = "SELECT p.*, pimg.product_ori_filename, pimg.product_save_filename, pimg.product_filetype, d.discount_rate, ifnull(ROUND((1 - d.discount_rate) * p.product_price), p.product_price) discount_price FROM product p LEFT OUTER join product_img pimg ON p.product_no = pimg.product_no LEFT OUTER JOIN  discount d ON p.product_no = d.product_no where p.product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// ?값 세팅
		stmt.setInt(1, productNo);
		
		// 실행 후 결과 저장
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			Product p = new Product();
			p.setProductNo(rs.getInt("product_no"));
			p.setProductName(rs.getString("product_name"));
			p.setProductPrice(rs.getInt("product_price"));
			p.setProductStatus(rs.getString("product_status"));
			p.setProductInfo(rs.getString("product_info"));
			p.setProductStock(rs.getInt("product_stock"));
			
			ProductImg pi = new ProductImg();
			pi.setProductOriFilename(rs.getString("product_ori_filename"));
			pi.setProductSaveFilename(rs.getString("product_save_filename"));
			pi.setProductFiletype(rs.getString("product_filetype"));
			
			double discountRate = rs.getDouble("discount_rate");
			int discountPrice = rs.getInt("discount_price");
			
			map.put("product", p);
			map.put("productImg", pi);
			map.put("discountRate", discountRate);
			map.put("discountPrice", discountPrice);
		}
		
		return map;
	}
	
	// 상품을 등록하는 메서드
	public int insertProduct(HashMap<String, Object> map) throws Exception {
		// 매개변수값 유효성 검사
		if(map == null || map.get("product") == null || map.get("productImg") == null) {
			System.out.println("입력값이 없거나 부족함.");
			return 0;
		}
		
		//매개변수값 저장
		Product product = (Product)map.get("product");
		ProductImg productImg = (ProductImg)map.get("productImg");
		
		// 결과를 담아줄 int타입 변수 선언
		int row = 0;
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// product 테이블에 데이터를 추가하는 쿼리
		String productSql = "insert into product(category_name, product_name, product_price, product_status, product_info, product_stock, createdate, updatedate) values(?, ?, ?, ?, ?, ?, now(), now())";
		PreparedStatement productStmt = conn.prepareStatement(productSql, PreparedStatement.RETURN_GENERATED_KEYS);
		
		// ?값 세팅
		productStmt.setString(1, product.getCategoryName());
		productStmt.setString(2, product.getProductName());
		productStmt.setInt(3, product.getProductPrice());
		productStmt.setString(4, product.getProductStatus());
		productStmt.setString(5, product.getProductInfo());
		productStmt.setInt(6, product.getProductStock());
		productStmt.executeUpdate();
		
		// 쿼리 실행 후 productNo값 가져오기
		ResultSet keyRs = productStmt.getGeneratedKeys();
		
		int productNo = 0;
		
		if(keyRs.next()) {
			productNo = keyRs.getInt(1);
		}

		// product_img에 데이터를 추가하는 쿼리
		String productImgSql = "insert into product_img values(?, ?, ?, ?, now(), now())";
		PreparedStatement productImgStmt = conn.prepareStatement(productImgSql);
		
		// ?값 세팅
		productImgStmt.setInt(1, productNo);
		productImgStmt.setString(2, productImg.getProductOriFilename());
		productImgStmt.setString(3, productImg.getProductSaveFilename());
		productImgStmt.setString(4, productImg.getProductFiletype());
		
		row = productImgStmt.executeUpdate();
		return row;	
	}
	
	// 상품정보를 수정하는 메서드
	public int updateProduct(HashMap<String, Object> map) throws Exception {
		// 매개변수값 유효성 검사
		if(map == null || map.get("product") == null || map.get("productImg") == null) {
			System.out.println("입력값이 없거나 부족함.");
			return 0;
		}
		
		//매개변수값 저장
		Product product = (Product)map.get("product");
		ProductImg productImg = (ProductImg)map.get("productImg");
				
		// 결과 값을 저장해줄 int타입 변수 선언
		int row = 0;
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// product_no에 해당하는 product데이터를 수정하는 쿼리
		String productSql = "update product set category_name = ?, product_name = ?, product_price = ?, product_status = ?, product_info = ?, product_stock = ?, updatedate = now() where product_no = ?";
		PreparedStatement productStmt = conn.prepareStatement(productSql);
		
		// ?값 세팅
		productStmt.setString(1, product.getCategoryName());
		productStmt.setString(2, product.getProductName());
		productStmt.setInt(3, product.getProductPrice());
		productStmt.setString(4, product.getProductStatus());
		productStmt.setString(5, product.getProductInfo());
		productStmt.setInt(6, product.getProductStock());
		productStmt.setInt(7, product.getProductNo());
		
		// 쿼리 실행 후 영향받은 행 저장
		row = productStmt.executeUpdate();
		
		// product_img를 수정하는 쿼리
		String productImgSql = "update product_img set product_ori_filename = ?, product_save_filename = ?, product_filetype = ?, updatedate = now() where product_no = ?";
		PreparedStatement productImgStmt = conn.prepareStatement(productImgSql);
		
		// ?값 세팅
		productImgStmt.setString(1, productImg.getProductOriFilename());
		productImgStmt.setString(2, productImg.getProductSaveFilename());
		productImgStmt.setString(3, productImg.getProductFiletype());
		productImgStmt.setInt(4, productImg.getProductNo());
		
		row += productImgStmt.executeUpdate();
		
		return row;
	}
	
	// 상품을 삭제하는 메서드
	public int deleteProduct(int productNo) throws Exception {
		// 결과 값을 저장해줄 int타입 변수 선언
		int row = 0;
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// productNo에 해당하는 product데이터를 삭제하는 쿼리
		String sql = "delete from product where product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// ?값 세팅
		stmt.setInt(1, productNo);
		
		// 쿼리 실행 후 영향받은 행 저장
		row = stmt.executeUpdate();
		
		return row;
	}
	
	// 신상품(최신상품 8개)를 반환하는 메서드
	public ArrayList<HashMap<String, Object>> getNewProducts() throws Exception{
		// 결과를 저장해줄 Product타입 ArrayList 선언
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 일주일 내에 등록된 상품 리스트를 불러오는 쿼리
		String sql = "SELECT p.createdate, p.product_no, p.product_name, p.product_price, p.product_status, p.product_sale_cnt, pimg.product_ori_filename, pimg.product_save_filename, pimg.product_filetype, d.discount_rate, ifnull(ROUND((1 - d.discount_rate) * p.product_price), p.product_price) discount_price FROM product p LEFT OUTER JOIN product_img pimg ON p.product_no = pimg.product_no LEFT OUTER JOIN discount d ON p.product_no = d.product_no ORDER BY p.createdate DESC LIMIT 0, 8";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리 실행 후 결과값 저장
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> map = new HashMap<>();
			
			Product p = new Product();
			p.setProductNo(rs.getInt("product_no"));
			p.setProductName(rs.getString("product_name"));
			p.setProductPrice(rs.getInt("product_price"));
			p.setProductStatus(rs.getString("product_status"));
			
			ProductImg pi = new ProductImg();
			pi.setProductOriFilename(rs.getString("product_ori_filename"));
			pi.setProductSaveFilename(rs.getString("product_save_filename"));
			pi.setProductFiletype(rs.getString("product_filetype"));
			
			double discountRate = rs.getDouble("discount_rate");
			int discountPrice = rs.getInt("discount_price");
			
			map.put("product", p);
			map.put("productImg", pi);
			map.put("discountRate", discountRate);
			map.put("discountPrice", discountPrice);
			
			list.add(map);
		}
		
		return list;
	}
	
	// 할인상품 목록을 반환하는 메서드
	public ArrayList<HashMap<String, Object>> getDiscountProducts() throws Exception{
		// 결과를 저장해줄 Product타입 ArrayList 선언
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 할인중인 상품 리스트를 가져오는 쿼리 
		String sql = "SELECT p.createdate, p.product_no, p.product_name, p.product_price, p.product_status, p.product_sale_cnt, pimg.product_ori_filename, pimg.product_save_filename, pimg.product_filetype, d.discount_rate, ifnull(ROUND((1 - d.discount_rate) * p.product_price), p.product_price) discount_price FROM product p LEFT OUTER JOIN product_img pimg ON p.product_no = pimg.product_no INNER JOIN  discount d ON p.product_no = d.product_no limit 0, 8";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리 실행 후 결과값 저장
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> map = new HashMap<>();
			
			Product p = new Product();
			p.setProductNo(rs.getInt("product_no"));
			p.setProductName(rs.getString("product_name"));
			p.setProductPrice(rs.getInt("product_price"));
			p.setProductStatus(rs.getString("product_status"));
			
			ProductImg pi = new ProductImg();
			pi.setProductOriFilename(rs.getString("product_ori_filename"));
			pi.setProductSaveFilename(rs.getString("product_save_filename"));
			pi.setProductFiletype(rs.getString("product_filetype"));
			
			double discountRate = rs.getDouble("discount_rate");
			int discountPrice = rs.getInt("discount_price");
			
			map.put("product", p);
			map.put("productImg", pi);
			map.put("discountRate", discountRate);
			map.put("discountPrice", discountPrice);
			
			list.add(map);
		}
		
		return list;
	}
}
