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
	HashMap<String, Object> productDetail = productDao.getProductDetail(productNo);
	Product product = (Product)productDetail.get("product");
	ProductImg productImg = (ProductImg)productDetail.get("productImg");
	double discountRate = (Double)productDetail.get("discountRate");
	int discountPrice = (Integer)productDetail.get("discountPrice");
	double cstmGradePoint = customer.getCstmRank().equals("씨앗") ? 0.01 : customer.getCstmRank().equals("새싹") ? 0.03 : 0.05;
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
	<script>
		function addressModalOpen(){
			$('#addressModal').show();
		}
	</script>
</head>
<body>
	<div>
		<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		<!-- 장바구니 모달 -->
		<jsp:include page="/cstm/cart.jsp"></jsp:include>
		<!-- 주소리스트 모달 -->
		<jsp:include page="/cstm/address.jsp"></jsp:include>
		
		<div class="container">
			<h2>구매자 정보</h2>
			<div>이름 : <%=customer.getCstmName() %></div>
			<div>이메일 : <%=customer.getCstmEmail() %></div>
			<div>전화번호 : <%=customer.getCstmPhone() %></div>
			<div>
				기본배송지 : <%=customer.getCstmAddress() %>
				<button type="button" onclick='addressModalOpen()'>배송지 선택</button>
			</div>
			<hr>
			
			<h2>구매정보</h2>
			<div><img src="<%=request.getContextPath() %>/product/<%=productImg.getProductSaveFilename()%>"></div>
			<div><%=product.getProductName() %></div>
			<div>수량 : <%=orderCnt %>개</div>
			<div>
				<%
					if(discountRate != 0.0){
				%>
						상품금액 : <del><%=product.getProductPrice() %></del>
						<span class="price"><%=discountPrice %></span>
				<%
					}else{
				%>
						상품금액 : <%=product.getProductPrice() %>
				<%
					}
				%>
				
			</div>
			<div>
				주문금액 : <%=discountPrice * orderCnt %>원
				<%
					if(discountRate != 0.0){
				%>
						(<%=(product.getProductPrice() - discountPrice) * orderCnt %>원 할인)
				<%
					}
				%>
			</div>
			<div>예상적립금 : <%=(int)(discountPrice * orderCnt * cstmGradePoint) %>원</div>
			<hr>
			
			<h2>결제정보</h2>
			<div>보유 포인트 : <%=customer.getCstmPoint() %></div>
			<div>사용할 포인트 : <input type="number"></div>
			<div>
				결제수단 : 
				<input type="radio" value="카드결제">카드결제
				<input type="radio" value="무통장입금">무통장입금
				<input type="radio" value="간편결제">간편결제
			<div>
			<button>결제하기</button>
		</div>
	</div>
</body>
</html>