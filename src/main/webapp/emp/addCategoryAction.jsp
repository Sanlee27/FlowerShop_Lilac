<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CategoryDao"%>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//메시지 변수
	String msg = "";
	
	//유효성검사
	if(request.getParameter("categoryName") == null
		||request.getParameter("categoryName").equals("")){
		
		msg = URLEncoder.encode("카테고리명을 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath() + "/emp/addCategory.jsp?msg=" + msg);
		return;
	}
	
	//DAO 가져오기
	CategoryDao categorydao = new CategoryDao();

	//변수
	String categoryName = request.getParameter("categoryName");
	int categoyrCnt = categorydao.categoryCnt(categoryName);
		System.out.println(categoryName + "<-- categoryName");
		System.out.println(categoyrCnt + "<-- 카테고리 중복확인용 categoyrCnt");
			
	//category 가져오기
	Category category = new Category();
	category.setCategoryName(categoryName);
	System.out.println(category + "<-- category");

	//카테고리명이 0일때만 추가가능
	if(categoyrCnt != 0){
		System.out.println("카테고리명 변경 필요");
		msg = URLEncoder.encode("해당 카테고리명은 이미 존재합니다.","utf-8");
		response.sendRedirect(request.getContextPath() + "/emp/addCategory.jsp?msg=" + msg);
		return;
	}
	
	//int row 안에 dao
	int row = categorydao.insertCategory(category);
		System.out.println(row + "<--row");

	if(row == 1){
		msg = URLEncoder.encode("카테고리 등록 성공!","utf-8");
		response.sendRedirect(request.getContextPath() + "/emp/category.jsp?msg=" + msg);
		System.out.println("추가 성공");

	} else{
		response.sendRedirect(request.getContextPath() + "/emp/addCategory.jsp");
		System.out.println("추가 실패");
	}
%>
