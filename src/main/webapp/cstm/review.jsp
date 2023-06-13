<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>


<%
//후기 상세 페이지
	
	

	/*
	//현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	*/
	
	//요청값 변수에 저장

	//int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	
	int orderNo = 1;
	
	//sql이 담긴 클래스 객체 생성
	
	ReviewDao oneDao = new ReviewDao();
	
	HashMap<String, Object> map = oneDao.reviewOne(orderNo);

	System.out.println(map);
	



%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>후기 상세</h1>
	<form action="<%=request.getContextPath()%>/cstm/modifyReview.jsp" method="post">
		<table>
	
			<tr>
				<td>orderNo</td>
				<td><%=((Review)map.get("review")).getOrderNo()%></td> 
				<!-- 
				reviwone 메서드의 해시맵 키"review"로부터 orderNo 값을 출력
				 -->
			</tr>
			<tr>
				<td>reviewTitle</td>
				<td><%=((Review)map.get("review")).getReviewTitle()%></td>
			</tr>
			<tr>
				<td>reviewContent</td>
				<td><%=((Review)map.get("review")).getReviewContent()%></td>
			</tr>
			<tr>
				<td>ReviewSaveFilename</td>
				<td><%=((ReviewImg)map.get("reviewImg")).getReviewSaveFilename()%></td>
			</tr>
			<tr>
				<td>reviewFiletype</td>
				<td><%=((ReviewImg)map.get("reviewImg")).getReviewFiletype()%></td>
			</tr>
			<tr>
				<td>createdate</td>
				<td><%=((Review)map.get("review")).getCreatedate()%></td>
			</tr>
			<tr>
				<td>updatedate</td>
				<td><%=((Review)map.get("review")).getUpdatedate()%></td>
			</tr>
			
		
			
		</table>
			<button type= "submit">
				수정		
			</button>
	</form>
	
	<form action="<%=request.getContextPath()%>/cstm/removeReviewAction.jsp" method="get">
			<button type= "submit">
			삭제
			</button>
		</form>
		
</body>
</html>