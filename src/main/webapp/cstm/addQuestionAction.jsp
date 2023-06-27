<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>
<%@ page import="java.net.URLEncoder"%>

<%

//문의 입력 액션 페이지

	//유효성 검사
	if(request.getParameter("productNo") == null
		|| request.getParameter("loginId") == null
		|| request.getParameter("productNo").equals("")
		|| request.getParameter("loginId").equals("")){
		//home.jsp로
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//요청값 변수에 저장

	int productNo = Integer.parseInt(request.getParameter("productNo"));
	String id = request.getParameter("loginId");
	String qCategory = request.getParameter("qCategory");
	String qTitle = request.getParameter("qTitle");
	String qContent = request.getParameter("qContent");
	
	/* 
	디버깅
	System.out.println(productNo);
	System.out.println(id);
	System.out.println(qCategory);
	System.out.println(qTitle);
	System.out.println(qContent);
	*/

	//클래스 객체 생성
	QuestionDao questionDao = new QuestionDao();
	
	//객체 생성해 요청값 저장
	Question question = new Question();
	
	question.setId(id);
	question.setProductNo(productNo);
	question.setqCategory(qCategory);
	question.setqTitle(qTitle);
	question.setqContent(qContent);
	
	//메시지 변수
	String msg = "";

	//문의 입력 메서드 실행
	int row = questionDao.addQuestion(question);
	
	if(row != 0){ //수정 성공
		msg = URLEncoder.encode("문의 입력 성공!","utf-8");
		System.out.println("문의글 입력 성공");
		response.sendRedirect(request.getContextPath()+"/cstm/questionList.jsp?msg="+ msg);
		return;
	}
	
	//액션 끝나고 돌아가기
	response.sendRedirect(request.getContextPath()+"/cstm/questionList.jsp");

%>
