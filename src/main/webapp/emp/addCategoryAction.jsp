<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.CategoryDao"%>
<%@ page import="vo.*"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//유효성검사
	//DAO 가져오기
	CategoryDao categorydao = new CategoryDao();

	//category vo 값 가져오기
	Category category = new Category();
	category.getCategoryName();
	category.getCreatedate();
	category.getUpdatedate();
	
	//int row 안에 dao

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addCategoryAction</title>
</head>
<body>

</body>
</html>