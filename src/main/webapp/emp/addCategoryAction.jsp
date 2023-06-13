<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CategoryDao"%>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder"%>

<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//유효성검사
	if(request.getParameter("categoryName") == null
		||request.getParameter("categoryName").equals("")){
		
		response.sendRedirect(request.getContextPath() + "/emp/category.jsp");
			System.out.println("categoryName 확인");
		return;
	}
	
	//변수
	String msg = "";
	String categoryName = request.getParameter("categoryName");
	
	//DAO 가져오기
	CategoryDao categorydao = new CategoryDao();

	//category vo 값 가져오기
	Category category = new Category();
	category.setCategoryName(categoryName);
	
	//카테고리명 중복확인 
	if(categoryName.equals(category.getCategoryName())){
		System.out.println("카테고리명 변경 필요");
		msg = URLEncoder.encode("해당 카테고리명은 이미 존재합니다.","utf-8");
		response.sendRedirect(request.getContextPath() + "/emp/addCategory.jsp?msg=" + msg);
		return;
	}
	
	//int row 안에 dao
	int row = categorydao.insertCategory(category);
	if(row == 1){
		response.sendRedirect(request.getContextPath() + "/emp/category.jsp");
		System.out.println("추가 성공");
	} else{
		response.sendRedirect(request.getContextPath() + "/emp/addCategoryAction.jsp");
		System.out.println("추가 실패");
	}
%>
