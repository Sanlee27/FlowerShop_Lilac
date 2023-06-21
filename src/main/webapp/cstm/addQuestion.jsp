<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>

<%
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//유효성 검사

	//요청값 변수에 저장
	//제품에 대한 문의인데 q_no? productNo도 받아야?
	
	//int qNo = Integer.parseInt(request.getParameter("qNo"));
	//int productNo = Integer.parseInt(request.getParameter("productNo"));
	int qNo = 10;
	int productNo = 5;
	String id = "user5";
	
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
		<h1>문의 입력</h1>
			<form action="<%=request.getContextPath()%>/cstm/addQuestionAction.jsp" method="get">
				<table>
					<tr>
						<td>문의 번호</td>
						<td><%=one.getqNo() %></td>
					</tr>
					<tr>
						<td>제품 번호</td>
						<td><%=one.getProductNo() %></td>
					</tr>
					<tr>
						<td>id</td>
						<td><%=one.getId() %></td>
					</tr>
					<tr>
						<td>카테고리</td>
						<td><select name= "qCategory">
								<option value="상품">상품</option>
								<option value="결제">결제</option>
								<option value="배송">배송</option>
								<option value="기타">기타</option>
							</select>
						</td>
					</tr>
			
					<tr>
						<td>제목</td>
						<td>
							<input type="text" name="qTitle" onclick="if(this.value=='타이틀을 입력하세요'){this.value=''}" value="타이틀을 입력하세요"> <!-- text를 클릭하면 value 값 지워짐 -->
						</td>
					</tr>
					<tr>
						<td>내용</td>
						<td>
							<input type="text" name="qContent" onclick="if(this.value=='내용을 입력하세요'){this.value=''}" value="내용을 입력하세요" > 
						</td>
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
					입력
					</button>
				</form>	
		</div>	
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>



</body>
</html>