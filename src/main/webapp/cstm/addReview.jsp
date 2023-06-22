<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>

<% 
//포토후기 입력 페이지

	/*
	//유효성 검사
	if(request.getParameter("orderNo") == null  
		|| request.getParameter("orderNo").equals("")) {
		// home.jsp으로
		response.sendRedirect(request.getContextPath() + "./home.jsp");
		return;
	}
	*/

	//요청값 변수에 저장
	//int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int orderNo = 11;


%>






<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Lilac</title>
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
	
			<h1>후기 작성</h1>

				<form action="<%=request.getContextPath()%>/cstm/addReviewAction.jsp" method="post" enctype="multipart/form-data">
					<input type="hidden" name="orderNo" value=<%=orderNo%>>
					<div class="form-list">
						<!-- orderNo -->
						<div>
							<div>orderNo</div>
							<div><%=orderNo%></div> 
							<!-- 
							reviweone 메서드의 해시맵 키"review"로부터 orderNo 값을 출력
							 -->
						</div>	
						<!-- 로그인 사용자 id -->
						<%
							//String memeberId = (String)session.getAttribute("loginMemberId");
							String id = "user5";
						%>
						<div>
							<div>id</div> 
							<div><input type="text" name="memberId" value="<%= id %>" readonly="readonly"></div>
						</div>
						<!-- reviewTitle -->
						<div>
							<div>제목</div> 
							<div><input type="text" name="reviewTitle" onclick="if(this.value=='타이틀을 입력하세요'){this.value=''}" value="타이틀을 입력하세요"> <!-- text를 클릭하면 value 값 지워짐 --></div>
						</div>
						<!-- reviewContent -->
						<div>
							<div>내용</div>
							<div><textarea rows="3" cols="50" name="reviewContent" required="required" > </textarea></div>
						</div>
						<!-- fileUpload -->
						<div>
							<div>파일 업로드</div>
							<div><input type="file" name="reviewImg"></div>
						</div>
					</div>	
						<div class="flex-wrapper marginTop20">	
							<button type= "submit" class="style-btn">
								작성		
							</button>
						</div>
					
				</form>
			</div>

	
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	
</body>
</html>