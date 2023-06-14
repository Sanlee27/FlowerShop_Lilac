<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>

<%
	/*
	//요청값 유효성 검사-> id
	if(request.getParameter("qNo") == null
		|| request.getParameter("qNo").equals("")){
		//home.jsp로
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	*/

	//요청값 변수에 저장
	
	//int qNo = Integer.parseInt(request.getParameter("qNo"));
	int qNo = 2;


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
<title>question</title>
	<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
</head>
<body>
	<div>
	<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>

	<div class="container">
	
		<h1>문의 상세</h1>
			<form action="<%=request.getContextPath()%>/cstm/modifyQuestion.jsp" method="get">
				<table>
					<tr>
						<td>문의번호</td>
						<td><%=one.getqNo() %></td>
					</tr>
					<tr>
						<td>상품번호</td>
						<td><%=one.getProductNo() %></td>
					</tr>
					<tr>
						<td>id</td>
						<td><%=one.getId() %></td>
					</tr>
					<tr>
						<td>카테고리</td>
						<td><%=one.getqCategory() %></td>
					</tr>
					<tr>
						<td>답변여부</td>
						<td><%=one.getqAnswer() %></td>
					</tr>
					<tr>
						<td>제목</td>
						<td><%=one.getqTitle() %></td>
					</tr>
					<tr>
						<td>내용</td>
						<td><%=one.getqContent() %></td>
					</tr>
					<tr>
						<td>수정일</td>
						<td><%=one.getUpdatedate() %></td>
					</tr>
					<tr>
						<td>작성일</td>
						<td><%=one.getCreatedate() %></td>
					</tr>
				
				</table>
					<button type= "submit">
					수정	
					</button>
				</form>	
				
				<form action="<%=request.getContextPath()%>/cstm/removeQuestionAction.jsp" method="get">
					<button type= "submit">
					삭제
					</button>
				</form>
	</div>
</body>
</html>