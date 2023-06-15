<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="java.net.URLEncoder"%>
<%
	//유효성 검사
	if(request.getParameter("answerNo") == null	
		||request.getParameter("answerNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/cstm/question.jsp");
		System.out.println("answerNo 값 필요");
		return;
	}
	//변수
	String msg = "";
	int answerNo = Integer.parseInt(request.getParameter("answerNo"));
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	
	//DAO
	QuestionDao questiondao = new QuestionDao();
	AnswerDao answerdao = new AnswerDao();
	
	//결과
	int row = answerdao.deleteAnswer(answerNo);
	if(row == 1) {
		System.out.println("변경성공");
		msg = URLEncoder.encode("답변이 삭제되었습니다.","utf-8");
		row = questiondao.updateToNQuestion(qNo);
		response.sendRedirect(request.getContextPath() + "/cstm/question.jsp?qNo=" + qNo + "&msg=" + msg);
		return;
	} else {
		System.out.println("변경실패");
		response.sendRedirect(request.getContextPath() + "/cstm/question.jsp?answerNo" + answerNo);
		return;
	}
%>