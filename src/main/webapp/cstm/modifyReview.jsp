<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>


<%
//후기 수정페이지

	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//유효성 검사 & 세션

	//요청값 변수에 저장
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	//int orderNo = 1;
	
	//디버깅
	System.out.println(orderNo+"<-modifyReview orderNo");
	
	//클래스 객체 생성
	ReviewDao oneDao = new ReviewDao();
	
	//수정페이지 객체 생성
	HashMap<String, Object> map = oneDao.reviewOne(orderNo);

	System.out.println(map+"<- modifyReview map");

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
	<!-- ajax -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
	<div>
	<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<div class="container">
		<h1>후기 수정</h1>
			<form action="<%=request.getContextPath()%>/cstm/modifyReviewAction.jsp" method="post" enctype="multipart/form-data">
				<input type="hidden" name="orderNo" value=<%=orderNo%>>
			<table>
			
				<!-- orderNo -->
				
					<tr>
						<td>주문번호</td>
						<td><%=orderNo%></td>
					</tr>
		
				<!-- reviewTitle -->
					<tr>
						<td>후기 제목</td>
						<td>
							<input type= "hidden" name ="reviewTitle" value=<%=((Review)map.get("review")).getReviewTitle()%>>
							<input type= "text" name="mTitle"  onclick="if(this.value=='타이틀을 입력하세요'){this.value=''}" value="타이틀을 입력하세요"> <!-- text를 클릭하면 value 값 지워짐 -->
						</td>
					</tr>
				<!-- reviewContent -->	
					<tr>
						<td>내용</td>
						<td>
							<input type= "hidden" name ="reviewContent" value=<%=((Review)map.get("review")).getReviewContent()%>>
							<input type= "text" name="mContent" onclick="if(this.value=='내용을 입력하세요'){this.value=''}" value="내용을 입력하세요" > 
						</td>
				<!-- boardFile -->		
					<tr>
						<td>변경할 파일 (현재파일 : <%=((ReviewImg)map.get("reviewImg")).getReviewSaveFilename()%>)</td>
						<td>
						
							<input type="file" name="modReviewImg" >
						
						</td>
					</tr>	
		
				
				</table>
					<button type="submit">수정</button>
	
			</form>
		</div>
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
</body>
</html>