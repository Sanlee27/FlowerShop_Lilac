<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>


<%	

//문의 삭제 액션페이지
	
	//인코딩 설정
	request.setCharacterEncoding("utf-8");
	
	//요청값 유효성 검사
	if(request.getParameter("qNo") == null
		|| request.getParameter("qNo").equals("")){
		//home.jsp로
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	
	//요청값 변수에 저장
	int qNo = Integer.parseInt(request.getParameter("qNo"));

	//디버깅
	System.out.println(qNo);

	//클래스 객체 생성
	QuestionDao questionDao = new QuestionDao();

	//삭제 메서드 실행
	int row = questionDao.deleteQuestion(qNo);
	
	if(row != 0){
		System.out.println("문의 삭제 성공");
	}

	//액션 후 페이지 이동
	response.sendRedirect(request.getContextPath() + "/cstm/questionList.jsp?qNo=" + qNo);

%>

