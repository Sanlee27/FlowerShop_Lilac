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
				"SELECT category_name categoryName, createdate, updatedate FROM category ORDER BY categoryName"
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
		int row = 0;
		if(category == null || category.getCategoryName() == null) {
			System.out.println("category클래스, name값 확인");
			return 0;
		}
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement categoryInsStmt = conn.prepareStatement(
				"INSERT INTO category(category_name, createdate, updatedate) VALUES(?, now(), now())"
			);
		categoryInsStmt.setString(1, category.getCategoryName());
		row = categoryInsStmt.executeUpdate();
		
		return row;
	}
	
	//카테고리 수정
	public int updateCategory(Category oriCategory, Category newCategory) throws Exception {
		int row = 0;
		
		if(oriCategory == null || newCategory == null || 
				oriCategory.getCategoryName() == null || newCategory.getCategoryName() == null ) {
			System.out.println("category클래스, name값 확인");
			return 0;
		}
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement categoryUpStmt = conn.prepareStatement(
				"UPDATE category SET category_name = ? WHERE category_name = ?"
			);
		categoryUpStmt.setString(1, newCategory.getCategoryName());
		categoryUpStmt.setString(2, oriCategory.getCategoryName());
		
		row = categoryUpStmt.executeUpdate();
		
		return row;
	}
}
