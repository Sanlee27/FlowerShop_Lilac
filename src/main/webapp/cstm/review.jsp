<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>


<%
//후기 상세 페이지


	//요청값 변수에 저장

	//int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	
	int orderNo = 3;
	
	//sql이 담긴 클래스 객체 생성
	
	ReviewDao oneDao = new ReviewDao();
	
	HashMap<String, Object> map = oneDao.reviewOne(orderNo);
	
	//상세보기 이미지를 위한 객체 생성
	ReviewImg reviewImg = (ReviewImg)map.get("reviewImg");
	//디버깅
	System.out.println(map);
	//path 경로 설정
	String path = request.getContextPath()+  "/review/" + reviewImg.getReviewSaveFilename();
	System.out.println(path);
	


%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>review list</title>
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
				<td>
					<img src="<%=path%>" alt="ReviewSaveFilename" width="100">
				</td>
			</tr>
			
			<tr>
				<td>reviewFiletype</td>
				<td>
				<%=((ReviewImg)map.get("reviewImg")).getReviewFiletype()%></td>
			</tr>
			 
			<tr>
				<td>createdate</td>
				<td><%=((Review)map.get("review")).getCreatedate().substring(0, 10)%></td>
			</tr>
			<tr>
				<td>updatedate</td>
				<td><%=((Review)map.get("review")).getUpdatedate().substring(0, 10)%></td>
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