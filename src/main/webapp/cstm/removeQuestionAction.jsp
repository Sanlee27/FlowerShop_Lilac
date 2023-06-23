<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>
<%@ page import="java.net.URLEncoder"%>


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
	//메시지 변수
	String msg = "";
	
	//디버깅
	System.out.println(qNo);

	//클래스 객체 생성
	QuestionDao questionDao = new QuestionDao();

	//삭제 메서드 실행
	int row = questionDao.deleteQuestion(qNo);
	
	if(row != 0){
		msg = URLEncoder.encode("문의 삭제 성공!","utf-8");
		System.out.println("문의 삭제 성공");
		response.sendRedirect(request.getContextPath()+"/cstm/questionList.jsp?msg="+ msg);
		return;
	}

	//액션 후 페이지 이동
	response.sendRedirect(request.getContextPath() + "/cstm/questionList.jsp?qNo=" + qNo);

%>

