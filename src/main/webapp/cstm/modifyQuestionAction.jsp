<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>
<%@ page import="java.net.URLEncoder"%>

<%

//문의 수정 액션페이지
	
	//인코딩 설정
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사
	
	//요청값 변수에 저장
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	
	
	String id = request.getParameter("id");
	String qCategory = request.getParameter("qCategory");
	String qAnswer = request.getParameter("qAnswer");
	String qTitle = request.getParameter("qTitle");
	String qContent = request.getParameter("qContent");
	//메시지 변수
	String msg = "";
	
	//디버깅
	System.out.println(qNo);
	System.out.println(id);
	System.out.println(qCategory);
	System.out.println(qAnswer);
	System.out.println(qTitle);
	System.out.println(qContent);
	

	//클래스 객체 생성
	QuestionDao questionDao = new QuestionDao();
	
	//객체 생성해 요청값 저장
	
	Question question = new Question();
	question.setqNo(qNo);
	question.setId(id);
	question.setqCategory(qCategory);
	question.setqAnswer(qAnswer);
	question.setqTitle(qTitle);
	question.setqContent(qContent);
	
	//문의 수정 메서드 실행
	int row = questionDao.modifyQuestion(question);
	
	if(row == 1){ //수정 성공
		msg = URLEncoder.encode("문의 수정 성공!","utf-8");
		System.out.println("문의글 수정 성공");
		response.sendRedirect(request.getContextPath()+"/cstm/questionList.jsp?msg="+ msg);
		return;
	}
	
	//액션 끝나고 돌아가기
	response.sendRedirect(request.getContextPath()+"/cstm/questionList.jsp");
	
%>


