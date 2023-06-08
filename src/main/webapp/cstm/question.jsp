<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>

<%
	/*
	//요청값 유효성 검사
	if(request.getParameter("qNo") == null
		|| request.getParameter("qNo").equals("")){
		//home.jsp로
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	*/

	//요청값 변수에 저장
	
	//int qNo = Integer.parseInt(request.getParameter("qNo"));
	int qNo = 3;


	//클래스 객체 생성
	QuestionDao questionDao = new QuestionDao();
	
	//상세페이지 객체 생성
	Question one = questionDao.questionOne(qNo);

	System.out.println(one);
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<h1>문의 상세</h1>
	<form action="<%=request.getContextPath()%>/cstm/modifyQuestion.jsp" method="get">
		<table>
			<tr>
				<td>qNo</td>
				<td><%=one.getqNo() %></td>
			</tr>
			<tr>
				<td>productNo</td>
				<td><%=one.getProductNo() %></td>
			</tr>
			<tr>
				<td>id</td>
				<td><%=one.getId() %></td>
			</tr>
			<tr>
				<td>qCategory</td>
				<td><%=one.getqCategory() %></td>
			</tr>
			<tr>
				<td>qAnswer</td>
				<td><%=one.getqAnswer() %></td>
			</tr>
			<tr>
				<td>qTitle</td>
				<td><%=one.getqTitle() %></td>
			</tr>
			<tr>
				<td>updatedate</td>
				<td><%=one.getUpdatedate() %></td>
			</tr>
			<tr>
				<td>createdate</td>
				<td><%=one.getCreatedate() %></td>
			</tr>
		
		</table>
			<button type= "submit">
			수정	
			</button>
		</form>	
		
		<form action="<%=request.getContextPath()%>/cstm/modifyQuestionAction.jsp" method="get">
			<button type= "submit">
			삭제
			</button>
		</form>

</body>
</html>