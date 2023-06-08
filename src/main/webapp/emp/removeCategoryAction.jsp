<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//유효성검사
	if(request.getParameter("categoryName") == null
		||request.getParameter("categoryName").equals("")) {
		response.sendRedirect(request.getContextPath() + "/emp/category.jsp");
		System.out.println("categoryName 값 필요");
		return;
	}
	
	//DAO 가져오기
	CategoryDao categorydao = new CategoryDao();
	ProductDao productdao = new ProductDao();
	
	//변수
	String msg = "";
	String categoryName = request.getParameter("categoryName");
	int cnt =productdao.getCategoryProductCnt(categoryName);
		System.out.println(categoryName + "<--카테고리 삭제 categoryName");
		System.out.println(cnt + "<--카테고리 삭제 상품 수 확인");
	
	//카테고리에 속한 상품 갯수 확인 (0개일때만 삭제 가능)
	if(cnt != 0) {
		System.out.println("상품 삭제 혹은 카테고리 변경 필요");
		msg = URLEncoder.encode("해당 카테고리에 포함 된 상품 카테고리 변경 혹은 삭제해주세요.","utf-8");
		response.sendRedirect(request.getContextPath() + "/emp/category.jsp?msg=" + msg);
		return;
	}
	
	//int row에 dao 넣기
	int row = categorydao.deleteCategory(categoryName);
	if(row == 1) {
		System.out.println("삭제 성공");
		msg = URLEncoder.encode(categoryName + "카테고리가 삭제되었습니다","utf-8");
		response.sendRedirect(request.getContextPath() + "/emp/category.jsp?msg=" + msg);
	} else {
		System.out.println("삭제 실패");
		response.sendRedirect(request.getContextPath() + "/emp/category.jsp?msg=" + msg);
	}
%>