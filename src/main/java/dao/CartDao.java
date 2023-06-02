package dao;

import java.sql.*;
import java.util.*;

import util.DBUtil;
import vo.*;

public class CartDao {
	//장바구니 내 상품 보기
	public HashMap<String, Object> selectCart(String id) throws Exception {
		Cart cart = null;
		ProductImg productImg = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement cartSelStmt = conn.prepareStatement(
				"SELECT product_no productNo, id, cart_cnt cartCnt FROM cart WHERE id = ? ORDER BY cart_no"
			);
		
		cartSelStmt.setString(1, id);
		
		ResultSet cartSelRs = cartSelStmt.executeQuery();
		
		if(cartSelRs.next()) {
			cart = new Cart();
			cart.setProductNo(cartSelRs.getInt("productNo"));
			cart.setId(cartSelRs.getString("id"));
			cart.setCartCnt(cartSelRs.getInt("cartCnt"));
		}
		
		//이미지 쿼리 필요 - no 같은 번호의 이미지 내놔
		
		PreparedStatement cartImgStmt = conn.prepareStatement(
				"SELECT product_no productNo, product_ori_filename productOriFilename, product_save_filename productSaveFilename, product_filetype productFiletype FROM product_img WHERE product_no = ?"
			);
		cartImgStmt.setInt(1, cart.getProductNo());
		
		ResultSet cartImgRs = cartImgStmt.executeQuery();
		
		if(cartImgRs.next()) {
			productImg = new ProductImg();
			productImg.setProductNo(cartImgRs.getInt("productNo"));
			productImg.setProductOriFilename(cartImgRs.getString("productOriFilename"));
			productImg.setProductSaveFilename(cartImgRs.getString("productSaveFilename"));
			productImg.setProductFiletype(cartImgRs.getString("productFiletype"));
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("cart", cart);
		map.put("productImg", productImg);
	
		return map;
	
	}
	//장바구니 상품 추가 
	public int insertCart(Cart cart) throws Exception {
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
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement CartUpStmt = conn.prepareStatement(
				"UPDATE cart SET cart_cnt = ?, updatedate = now() WHERE id = ?"
			);
		CartUpStmt.setInt(1, cart.getCartCnt());
		CartUpStmt.setString(2, cart.getId());
		
		row = CartUpStmt.executeUpdate();
		
		return row;
	}
	
	//장바구니 상품 삭제
	public int deleteCart(int cartNo) throws Exception {
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
