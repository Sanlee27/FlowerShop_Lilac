<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%@ page import="java.net.URLEncoder"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//유효성검사 
	if(request.getParameter("comment") == null 
		||request.getParameter("qNo") == null 
		||request.getParameter("id") == null 
		||request.getParameter("comment").equals("")
		||request.getParameter("qNo").equals("")
		||request.getParameter("id").equals("")){
		
		System.out.println("comment, qNo, id값 필요");
		response.sendRedirect(request.getContextPath()+"/cstm/question.jsp");
		return;
	}
	
	//변수
	String msg = "";
	String comment = request.getParameter("comment");
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	String id = (String)session.getAttribute("loginId");
		System.out.println(comment + "<--comment");
		System.out.println(qNo + "<--qNo");
		System.out.println(id + "<--id");

	//DAO
	QuestionDao questiondao = new QuestionDao();
	AnswerDao answerdao = new AnswerDao();
	
	//answer
	Answer answer = new Answer();
		System.out.println(answer);
	answer.setAnswerContent(comment);
	answer.setqNo(qNo);
	answer.setId(id);
		System.out.println(answer.getAnswerContent());
		System.out.println(answer.getId());

	//결과
	int row = answerdao.insertAnswer(answer);
		System.out.println(row);
	if(row == 1) {
		System.out.println("입력 성공");
		msg = URLEncoder.encode("답변이 등록되었습니다.","utf-8");
		row = questiondao.updatdQuestionByPage(qNo);
			System.out.println(row + "<--2");
		response.sendRedirect(request.getContextPath()+"/cstm/question.jsp?qNo=" + qNo + "&msg=" + msg);
		return;
	} else {
		System.out.println("입력 실패");
		response.sendRedirect(request.getContextPath()+"/cstm/question.jsp?qNo=" + qNo);
		return;
	}
	
%>