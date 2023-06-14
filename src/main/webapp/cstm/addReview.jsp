<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>

<% 
//후기 입력 페이지

	/*
	//유효성 검사
	if(request.getParameter("orderNo") == null  
		|| request.getParameter("orderNo").equals("")) {
		// home.jsp으로
		response.sendRedirect(request.getContextPath() + "home.jsp");
		return;
	}
	*/

	//요청값 변수에 저장
	//int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int orderNo = 1;



%>






<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>후기 작성</h1>
		<form action="<%=request.getContextPath()%>/cstm/addReviewAction.jsp" method="post" enctype="multipart/form-data">
			<input type="hidden" name="orderNo" value=<%=orderNo%>>
			<table>
			<!-- orderNo -->
				<tr>
					<td>orderNo</td>
					<td><%=orderNo%></td> 
					<!-- 
					reviweone 메서드의 해시맵 키"review"로부터 orderNo 값을 출력
					 -->
				</tr>
				
			<!-- 로그인 사용자 id -->
			<%
			
				/// String memeberId = (String)session.getAttribute("loginMemberId");
				String id = "user3";
			%>
			
			
			<tr>
				<td>id</td>
				<td>
					<input type="text" name="memberId" 
						value="<%= id %>" readonly="readonly">
				</td>
			</tr>
				
			<!-- reviewTitle -->
				<tr>
					<td>reviewTitle</td>
					<td>
						
						<input type="text" name="reviewTitle" onclick="if(this.value=='타이틀을 입력하세요'){this.value=''}" value="타이틀을 입력하세요"> <!-- text를 클릭하면 value 값 지워짐 -->
					</td>
				</tr>
			<!-- reviewContent -->
				<tr>
					<td>reviewContent</td>
					<td>
						<textarea rows="3" cols="50" name="reviewContent" required="required" > </textarea>
					</td>
				</tr>
			<!-- fileUpload -->
				<tr>
					<td>fileUpload</td>
					<td><input type="file" name="reviewImg" required="required"></td>
				</tr>
			
				
			
				
			</table>
				<button type= "submit">
					작성		
				</button>
		</form>
</body>
</html>