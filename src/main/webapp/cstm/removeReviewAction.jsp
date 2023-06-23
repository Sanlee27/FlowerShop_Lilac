<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>




<%
	//후기 삭제 액션
	
	//인코딩 설정
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 + 세션

	//요청값 변수에 저장
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));

	//클래스 객체 생성
	ReviewDao reviewDao = new ReviewDao();

	//삭제 메서드 실행
	int row = reviewDao.deleteReview(orderNo);
	
	if(row != 0){
		System.out.println("후기 삭제 성공");
	}

	//액션 후 페이지 이동
	response.sendRedirect(request.getContextPath()+"/cstm/reviewList.jsp");
	

%>
