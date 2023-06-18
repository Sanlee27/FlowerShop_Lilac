<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//세션에 있는 아이디값 저장
	String loginId = (String)session.getAttribute("loginId");
	
	// 로그인 안되어 있으면 로그인 페이지로 이동
	if(loginId == null){
		response.sendRedirect(request.getContextPath() + "/cstm/login.jsp");
		return;
	}
	
	// 요청값 유효성 검사
	if(request.getParameter("productNo") == null
	|| request.getParameter("productNo").equals("")
	|| request.getParameter("orderCnt") == null
	|| request.getParameter("orderCnt").equals("")){
		return;
	}

	// 요청값 저장
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	int orderCnt = Integer.parseInt(request.getParameter("orderCnt"));
	
	// 데이터 불러올 Dao들 객체선언
	CustomerDao customerDao = new CustomerDao();
	AddressDao addressDao = new AddressDao();
	ProductDao productDao = new ProductDao();
	
	// 필요한 데이터들 전부 가져오기
	Customer customer = customerDao.selectCustomerInfo(loginId);
	ArrayList<Address> address = addressDao.selectHistoryAddress(loginId);
	HashMap<String, Object> product = productDao.getProductDetail(productNo);

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
		<!-- 장바구니 모달 -->
		<jsp:include page="/cstm/cart.jsp"></jsp:include>
		
		<div class="container">
		
		</div>
	</div>
</body>
</html>