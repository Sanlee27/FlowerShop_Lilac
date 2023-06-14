<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CategoryDao"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//유효성검사
	if(request.getParameter("oriCategory") == null
		||request.getParameter("newCategory") == null 
		||request.getParameter("oriCategory").equals("") 
		||request.getParameter("newCategory").equals("")) {
		response.sendRedirect(request.getContextPath() + "/emp/category.jsp");
		System.out.println("oriCategory,newCategory 값 필요");
		return;
	}
	
	//변수
	String msg = "";
	String oriCategory = request.getParameter("oriCategory");
	String newCategory = request.getParameter("newCategory"); 
		System.out.println(oriCategory + "<-- 카테고리 oriCategory 값");
		System.out.println(newCategory + "<-- 카테고리 newCategory 값");
	
	//DAO 가져오기
	CategoryDao categorydao = new CategoryDao();
	
	//category 객체 생성
	Category category = new Category();
	category.setCategoryName(oriCategory);
	
	Category category2 = new Category();
	category2.setCategoryName(newCategory);
	
	//int row 안에 dao
	int row = categorydao.updateCategory(category, category2);
	
	if(row == 1) {
		System.out.println("카테고리명 수정 성공");
		msg = URLEncoder.encode("카테고리 " + oriCategory +"에서  " + newCategory + "으로 수정되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath() + "/emp/category.jsp?msg=" + msg);
	} else{
		System.out.println("카테고리명 수정 실패");
		response.sendRedirect(request.getContextPath() + "/emp/category.jsp");
	}
%>