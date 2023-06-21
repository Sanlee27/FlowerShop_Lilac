<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%@ page import="java.net.URLEncoder"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//qNo 유효성검사
	if(request.getParameter("qNo") == null 
		||request.getParameter("qNo").equals("")){
		response.sendRedirect(request.getContextPath() + "/cstm/questionList.jsp");
		System.out.println("qNo 값 필요");
		return;
	}
	
	//qNo, msg변수
	String msg = "";
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	System.out.println(qNo + "<-- 답변수정 aNo 값");

	//유효성검사
	if(request.getParameter("comment") == null 
		||request.getParameter("comment").equals("")){
		msg = URLEncoder.encode("답변을 입력해주세요.","utf-8");
		System.out.println("commnet 값 필요");
		response.sendRedirect(request.getContextPath() + "/cstm/question.jsp?msg=" + msg + "&qNo=" + qNo);
		return;
	}
	
	//변수
	String comment = request.getParameter("comment");
	int answerNo = Integer.parseInt(request.getParameter("answerNo"));
		System.out.println(comment + "<-- 답변수정 comment 값");
	
	//DAO
	AnswerDao answerdao = new AnswerDao();
	
	//answer
	Answer answer = new Answer();
	answer.setAnswerContent(comment);
	answer.setqNo(qNo);
	answer.setAnswerNo(answerNo);
		System.out.println(answer.getAnswerContent() + "<-- 답변수정 getAnswerContent 값");
	
	int row = answerdao.updateAnswer(answer);
	if(row == 1) {
		System.out.println("변경성공");
		msg = URLEncoder.encode("답변이 수정되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath() + "/cstm/question.jsp?qNo=" + qNo + "&msg=" + msg);
		return;
	} else {
		System.out.println("변경실패");
		response.sendRedirect(request.getContextPath() + "/cstm/question.jsp?answerNo=" + qNo);
		return;
	}
%>