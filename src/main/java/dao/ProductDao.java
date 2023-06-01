package dao;
import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class ProductDao {
	// 전체상품 리스트를 반환하는 메서드
	public ArrayList<Product> getAllProductList() throws Exception{
		// 결과를 담아줄 Product타입 ArrayList선언
		ArrayList<Product> list = new ArrayList<>();
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 전체상품 리스트를 불러오는 쿼리
		String sql = "select * from product";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리 실행 후 저장
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			Product p = new Product();
			p.setProductNo(rs.getInt("product_no"));
			p.setCategoryName(rs.getString("category_name"));
			p.setProductName(rs.getString("product_name"));
			p.setProductPrice(rs.getInt("product_price"));
			p.setProductStatus(rs.getString("product_status"));
			p.setProductInfo(rs.getString("product_info"));
			p.setProductStock(rs.getInt("product_stock"));
			p.setCreatedate(rs.getString("createdate"));
			p.setUpdatedate(rs.getString("updatedate"));
			list.add(p);
		}
		
		return list;
	}
	
	// 상품 하나에 대한 상세정보를 반환하는 메서드
	public Product getProductDetail(int productNo) throws Exception {
		// 결과를 담아줄 Product타입 변수 선언
		Product p = new Product();
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// productNo에 해당하는 상세정보 가져오는 쿼리
		String sql = "select * from product where product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// ?값 세팅
		stmt.setInt(1, productNo);
		
		// 실행 후 결과 저장
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			p.setProductNo(rs.getInt("product_no"));
			p.setCategoryName(rs.getString("category_name"));
			p.setProductName(rs.getString("product_name"));
			p.setProductPrice(rs.getInt("product_price"));
			p.setProductStatus(rs.getString("product_status"));
			p.setProductInfo(rs.getString("product_info"));
			p.setProductStock(rs.getInt("product_stock"));
			p.setCreatedate(rs.getString("createdate"));
			p.setUpdatedate(rs.getString("updatedate"));
		}
		
		return p;
	}
	
	// 상품을 등록하는 메서드
	public int insertProduct(Product product) throws Exception {
		// 매개변수값 유효성 검사
		if(product == null || product.getCategoryName() == null
		|| product.getProductName() == null || product.getProductStatus() == null
		|| product.getProductInfo() == null ) {
			System.out.println("입력값이 없거나 부족함.");
			return 0;
		}
		
		// 결과를 담아줄 int타입 변수 선언
		int row = 0;
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// product 테이블에 데이터를 추가하는 쿼리
		String sql = "insert into product(category_name, product_name, product_price, product_status, product_info, product_stock, createdate, updatedate) values(?, ?, ?, ?, ?, ?, now(), now())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// ?값 세팅
		stmt.setString(1, product.getCategoryName());
		stmt.setString(2, product.getProductName());
		stmt.setInt(3, product.getProductPrice());
		stmt.setString(4, product.getProductStatus());
		stmt.setString(5, product.getProductInfo());
		stmt.setInt(6, product.getProductStock());
		
		// 쿼리 실행 후 영향받은 행 저장
		row = stmt.executeUpdate();
		
		return row;	
	}
	
	// 상품정보를 수정하는 메서드
	public int updateProduct(Product product) throws Exception {
		// 매개변수값 유효성 검사
		if(product == null || product.getCategoryName() == null
		|| product.getProductName() == null || product.getProductStatus() == null
		|| product.getProductInfo() == null ) {
			System.out.println("입력값이 없거나 부족함.");
			return 0;
		}
		
		// 결과 값을 저장해줄 int타입 변수 선언
		int row = 0;
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// product_no에 해당하는 product데이터를 수정하는 쿼리
		String sql = "update product set category_name = ?, product_name = ?, product_price = ?, product_status = ?, product_info = ?, product_stock = ?, updatedate = now() where product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// ?값 세팅
		stmt.setString(1, product.getCategoryName());
		stmt.setString(2, product.getProductName());
		stmt.setInt(3, product.getProductPrice());
		stmt.setString(4, product.getProductStatus());
		stmt.setString(5, product.getProductInfo());
		stmt.setInt(6, product.getProductStock());
		stmt.setInt(7, product.getProductNo());
		
		// 쿼리 실행 후 영향받은 행 저장
		row = stmt.executeUpdate();
		
		return row;
	}
}
