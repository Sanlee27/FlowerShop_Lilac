package dao;

import java.sql.*;
import java.util.*;

import util.DBUtil;
import vo.*;

public class CartDao {
	//장바구니 내 상품 보기
	public Cart selectCart(String id) throws Exception {
		//유효성검사
		if(id == null) {
			System.out.println("id값 확인");
			return null;
		}
		
		Cart cart = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement cartSelStmt = conn.prepareStatement(
				"SELECT cart_no cartNo, product_no productNo, id, cart_cnt cartCnt FROM cart WHERE id = ? ORDER BY cart_no"
			);
		
		cartSelStmt.setString(1, id);
		
		ResultSet cartSelRs = cartSelStmt.executeQuery();
		
		if(cartSelRs.next()) {
			cart = new Cart();
			cart.setCartNo(cartSelRs.getInt("cartNo"));
			cart.setProductNo(cartSelRs.getInt("productNo"));
			cart.setId(cartSelRs.getString("id"));
			cart.setCartCnt(cartSelRs.getInt("cartCnt"));
		}
	
		return cart;
	
	}
	//장바구니 상품 추가 
	public int insertCart(Cart cart) throws Exception {
		//유효성검사
		if(cart == null || cart.getId() == null) {
			System.out.println("cart클래스, Id값 확인");
			return 0;
		}
		
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement cartInsStmt = conn.prepareStatement(
				"INSERT INTO cart(product_no, id, cart_cnt, createdate, updatedate) VALUES(?, ?, ?, now(), now())"
			);
		cartInsStmt.setInt(1, cart.getProductNo());
		cartInsStmt.setString(2, cart.getId());
		cartInsStmt.setInt(3, cart.getCartCnt());
		
		row = cartInsStmt.executeUpdate();
		
		return row;
	}
	
	//장바구니 상품 수정
	public int updateCart(Cart cart) throws Exception {
		//유효성검사
		if(cart == null || cart.getCartNo() == 0) {
			System.out.println("cart클래스, cartNo 확인");
			return 0;
		}
		
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement CartUpStmt = conn.prepareStatement(
				"UPDATE cart SET cart_cnt = ?, updatedate = now() WHERE cart_no = ?"
			);
		CartUpStmt.setInt(1, cart.getCartCnt());
		CartUpStmt.setInt(2, cart.getCartNo());
		
		row = CartUpStmt.executeUpdate();
		
		return row;
	}
	
	//장바구니 상품 삭제
	public int deleteCart(int cartNo) throws Exception {
		//유효성검사
		if(cartNo == 0) {
			System.out.println("cartNo값 확인");
			return 0;
		}
		
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement CartDelStmt = conn.prepareStatement(
				"DELETE FROM cart WHERE cart_no = ?"
			);
		CartDelStmt.setInt(1, cartNo);
		
		row = CartDelStmt.executeUpdate();
		
		return row;
	}
}
