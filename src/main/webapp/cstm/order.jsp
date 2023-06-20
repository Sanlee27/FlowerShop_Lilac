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
	
	// 전체 주문금액을 저장할 변수
	int totalPrice = discountPrice * orderCnt;
	
	// 예상 적립금을 저장할 변수
	int toAddPoint = (int)(discountPrice * orderCnt * cstmGradePoint);
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
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script>
		function addressModalOpen(){
			$('#addressModal').show();
		}
		function pointInputChange(input){
			if(parseInt($(input).val()) > <%=customer.getCstmPoint() %>){
				swal("경고", "사용 가능 포인트는 <%=customer.getCstmPoint()%>입니다.", "warning");
				$(input).val(<%=customer.getCstmPoint()%>)
			}
		}
		function payBtnClick(){
			// 입력값들 유효성 검사
			if($("#address").text() == ""){
				swal("경고", "배송지를 선택해 주세요", "warning");
				return;
			}
			if($("input[name='pay']:checked").val() == undefined){
				swal("경고", "결제수단을 선택해 주세요", "warning");
				return;
			}
			
			let toSpendPoint = $("#toSpendPoint").val() == "" ? 0 : parseInt($("#toSpendPoint").val()); 
			let xhr = new XMLHttpRequest();
			let url = '<%=request.getContextPath()%>/cstm/orderAction.jsp';
			let params = {
				productNo : <%=productNo%>,
				id : "<%=loginId%>",
				orderCnt : <%=orderCnt%>,
				totalPrice : <%=totalPrice%>,
				address : $("#address").text(),
				toAddPoint : <%=toAddPoint%>,
				toSpendPoint : toSpendPoint
			};
			xhr.open('POST', url, true);
			xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
			xhr.onreadystatechange = function() {
			    if (xhr.readyState === 4) {
				if (xhr.status === 200) {
					swal("성공", "결제완료", "success");
					setTimeout(function() {
						window.location.href = '<%=request.getContextPath()%>' + '/cstm/orderList.jsp?id=' + '<%=loginId%>';
					}, 5000);
				} else {
			        // 요청이 실패한 경우
			    	swal("결제실패", "주문정보나 결제수단을 확인하세요", "error");
			      }
			    }
			  };

			  xhr.send($.param(params));
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
				배송지 : <span id="address"><%=customer.getCstmAddress() %></span>
				<button type="button" onclick='addressModalOpen()'>배송지변경</button>
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
				주문금액 : <%=totalPrice %>원
				<%
					if(discountRate != 0.0){
				%>
						(<%=(product.getProductPrice() - discountPrice) * orderCnt %>원 할인)
				<%
					}
				%>
			</div>
			<div>예상적립금 : <%= toAddPoint%>원</div>
			<hr>
			
			<h2>결제정보</h2>
			<div>보유 포인트 : <%=customer.getCstmPoint() %></div>
			<div>사용할 포인트 : <input type="number" inputmode="numeric" onchange="pointInputChange(this)" id="toSpendPoint" value=0></div>
			<div>
				결제수단 : 
				<input type="radio" value="카드결제" name="pay">카드결제
				<input type="radio" value="무통장입금" name="pay">무통장입금
				<input type="radio" value="간편결제" name="pay">간편결제
			<div>
			<button type="button" onclick="payBtnClick()">결제하기</button>
		</div>
	</div>
</body>
</html>