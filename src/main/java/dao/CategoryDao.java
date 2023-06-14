package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

import util.DBUtil;
import vo.*;

public class CategoryDao {
	//카테고리 리스트
	public ArrayList<Category> selectCategoryList() throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement categoryStmt = conn.prepareStatement(
				"SELECT category_name categoryName, substring(createdate,1,10) createdate, substring(updatedate,1,10) updatedate FROM category ORDER BY categoryName"
			);
		ResultSet categoryRs = categoryStmt.executeQuery();
		
		ArrayList<Category> categoryList = new ArrayList<Category>();
		while(categoryRs.next()) {
			Category c = new Category();
			c.setCategoryName(categoryRs.getString("categoryName"));
			c.setCreatedate(categoryRs.getString("createdate"));
			c.setUpdatedate(categoryRs.getString("updatedate"));
			categoryList.add(c);
		}
		
		return categoryList;
	}
	
	//카테고리 추가
	public int insertCategory(Category category) throws Exception {
		//유효성검사
		if(category == null || category.getCategoryName() == null) {
			System.out.println("category클래스, name값 확인");
			return 0;
		}
		
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement categoryInsStmt = conn.prepareStatement(
				"INSERT INTO category(category_name, createdate, updatedate) VALUES(?, now(), now())"
			);
		categoryInsStmt.setString(1, category.getCategoryName());
		
		row = categoryInsStmt.executeUpdate();
		
		return row;
	}
	
	//중복검사
	public int categoryCnt(String categoryName) throws Exception {
		//유효성검사
		if(categoryName == null) {
			System.out.println("categoryName값 확인");
			return 0;
		}
		
		int result = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement categoryChangeStmt = conn.prepareStatement(
			"SELECT COUNT(*) FROM category WHERE category_name = ?"
		);
		categoryChangeStmt.setString(1, categoryName);
		
		ResultSet categoryChangeRs = categoryChangeStmt.executeQuery();
				
		if(categoryChangeRs.next()) {
			result = categoryChangeRs.getInt("COUNT(*)");
		}
		
		return result;
	}
	
	//카테고리 수정
	public int updateCategory(Category oriCategory, Category newCategory) throws Exception {
		//유효성검사
		if(oriCategory == null || newCategory == null || 
				oriCategory.getCategoryName() == null || newCategory.getCategoryName() == null ) {
			System.out.println("category클래스, name값 확인");
			return 0;
		}
		
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement categoryUpStmt = conn.prepareStatement(
				"UPDATE category SET category_name = ?, updatedate = now() WHERE category_name = ?"
			);
		categoryUpStmt.setString(1, newCategory.getCategoryName());
		categoryUpStmt.setString(2, oriCategory.getCategoryName());
		
		row = categoryUpStmt.executeUpdate();
		
		return row;
	}
	
	//카테고리 삭제
	public int deleteCategory(String categoryName) throws Exception {
		//유효성검사
		if(categoryName == null) {
			System.out.println("categoryName값 확인");
			return 0;
		}
		
		int row = 0; // 업데이트 실행 후 영향을 받은 행의 수
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement categoryDelStmt = conn.prepareStatement(
				"DELETE FROM category WHERE category_name = ?"
			);
		categoryDelStmt.setString(1, categoryName);
		
		row = categoryDelStmt.executeUpdate();
		
		return row;
	}
}
