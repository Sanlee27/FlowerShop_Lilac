<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>

<%

//문의 입력 액션 페이지

	//유효성 검사


	//요청값 변수에 저장

	//int productNo = Integer.parseInt(request.getParameter("productNo"));
	int productNo = 5;
	
	//String id = request.getParameter("id");
	String id = "user3";
	
	String qCategory = request.getParameter("qCategory");
	String qTitle = request.getParameter("qTitle");
	String qContent = request.getParameter("qContent");
	
	//디버깅

	System.out.println(productNo);
	System.out.println(id);
	System.out.println(qCategory);
	System.out.println(qTitle);
	System.out.println(qContent);
	

	//클래스 객체 생성
	QuestionDao questionDao = new QuestionDao();
	
	//객체 생성해 요청값 저장
	
	Question question = new Question();
	
	question.setId(id);
	question.setProductNo(productNo);
	question.setqCategory(qCategory);
	question.setqTitle(qTitle);
	question.setqContent(qContent);
	
	//문의 입력 메서드 실행
	int row = questionDao.addQuestion(question);
	
	if(row != 0){ //수정 성공
		System.out.println("문의글 입력 성공");
	}
	
	//액션 끝나고 돌아가기
	//response.sendRedirect(request.getContextPath() + " qNo" + qNo);

%>
