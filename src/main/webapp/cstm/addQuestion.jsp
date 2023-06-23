<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>

<%
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//유효성 검사
	if(request.getParameter("productNo") == null
		|| request.getParameter("productNo").equals("")){
		//home.jsp로
		response.sendRedirect(request.getContextPath()+"/cstm/questionList.jsp");
		return;
	}
	
	//세션 유효성 검사
	if(session.getAttribute("loginId")==null){
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;
	}
	//요청값 변수에 저장
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	String loginId = (String)session.getAttribute("loginId");
		System.out.println(loginId+"<--loginId");
		System.out.println(productNo+"<--productNo");

	
	//클래스 객체 생성
	QuestionDao questionDao = new QuestionDao();
	
	//상세페이지 객체 생성

	
		
	
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
	<style>
		.list-wrapper .list-item{
			grid-template-columns: 50% 50%;
		}
	</style>
<body>
	<div>
	<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<div class="container">

		<h1>문의 입력</h1>
			<form action="<%=request.getContextPath()%>/cstm/addQuestionAction.jsp" method="get">
				<div class="form-list">
				<input type="hidden" name="loginId" value="<%=loginId%>">
				<input type="hidden" name="productNo" value="<%=productNo%>">
					<div>
						<div>카테고리</div>
						<div>
						<select name= "qCategory">
								<option value="상품">상품</option>
								<option value="결제">결제</option>
								<option value="배송">배송</option>
								<option value="기타">기타</option>
						</select>
						</div>
					</div>
					<div>
						<div>제목</div>
						<div><input type="text" name="qTitle" onclick="if(this.value=='타이틀을 입력하세요'){this.value=''}" placeholder="타이틀을 입력하세요" required="required"> <!-- text를 클릭하면 value 값 지워짐 --></div>
					</div>
					<div>
						<div>내용</div>
						<div><textarea rows="3" cols="100" name="qContent" onclick="if(this.value=='내용을 입력하세요'){this.value=''}" placeholder="내용을 입력하세요" required="required"></textarea></div>
					</div>
				</div>
				<div class="flex-wrapper marginTop20">
					<button type= "submit" class="style-btn">
					입력
					</button>
				</div>
			</form>	
				
	</div>	

	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>



</body>
</html>