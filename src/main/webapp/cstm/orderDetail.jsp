<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 _ 로그인전이면 로그인폼으로 돌아가게
	if(session.getAttribute("loginId") == null){ 
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;	
	}
	
	// System.out.println(request.getParameter("id"));
	// System.out.println(request.getParameter("orderNo"));
	
	String id = request.getParameter("id");
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	
	// 주문내역상세
	OrderDao dao = new OrderDao();
	Order order = dao.getOrderDetail(orderNo);
	
	// 주문내역상세의 productNo 변수저장
	int productNo = order.getProductNo();
	
	// 상품정보 상세
	ProductDao pDao = new ProductDao();
	HashMap<String, Object> pInfo = pDao.getProductDetail(productNo);
	
	Product product = (Product)pInfo.get("product");
	ProductImg productImg = (ProductImg)pInfo.get("productImg");
	double discountRate = (double)pInfo.get("discountRate");
	int discountPrice = (int)pInfo.get("discountPrice");
	
	// 이미지 주소
	String path = request.getContextPath() + "/product/" + productImg.getProductSaveFilename() + ".jpg";
	
	// 고객 등급확인
	CustomerDao cDao = new CustomerDao();
	Customer cstm = cDao.selectCustomerInfo(id);
	
	// System.out.println(request.getParameter("msg"));
%>
<!DOCTYPE html>
<html>
<head>
<title>Lilac</title>
	<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<script>
	$(document).ready(function() {
		
		let submitBtn = $('button[type="submit"]');
		
		// 취소상태 시 주문취소 버튼 비활성화
		if("<%=order.getOrderStatus()%>" === "취소"){
			submitBtn.prop('disabled', true);
		}
		
	});
	</script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<form action="<%=request.getContextPath()%>/cstm/removeOrderAction.jsp" method="post">
			<h1>주문내역 상세</h1>
			<div class="font-line"></div>
			<br>
			<div class="form-list">
				<div>
					<div>주문 번호</div>
					<div><%=order.getOrderNo()%></div>
				</div>
				<div>
					<div>주문 일자</div>
					<div><%=order.getCreatedate()%></div>
				</div>
				<div>
					<div>상품 정보</div>
					<div>
						<input type="hidden" name="id" value="<%=order.getId()%>">
						<input type="hidden" name="orderNo" value="<%=order.getOrderNo()%>">
						<div class="product-info">
							<img src="<%=path%>" width="200px">
							<div onClick="location.href='<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=order.getProductNo()%>'"><%=product.getProductName()%></div>
						</div>
					</div>
				</div>
				<div>
					<div>할인 금액</div>
					<div>
						<fmt:formatNumber value="<%=discountPrice%>" pattern="###,###,###"/>
					</div>
				</div>
				<div>
					<div>포인트 적립</div>
					<%
						if(cstm.getCstmRank().equals("씨앗")){
					%>
							<div>
								<fmt:formatNumber value="<%=Math.round(order.getOrderPrice()*0.01)%>" pattern="###,###,###"/>
							</div>
					<%
						} else if(cstm.getCstmRank().equals("새싹")){
							
					%>
							<div>
								<fmt:formatNumber value="<%=Math.round(order.getOrderPrice()*0.03)%>" pattern="###,###,###"/>
							</div>
					<%
						} else {
					%>
							<div>
								<fmt:formatNumber value="<%=Math.round(order.getOrderPrice()*0.05)%>" pattern="###,###,###"/>
							</div>
					<%
						}
					%>
				</div>
				<div>
					<div>주문 금액(수량)</div>
					<div>
						<input type="hidden" name="orderCnt" value="<%=order.getOrderCnt()%>">
						<fmt:formatNumber value="<%=order.getOrderPrice()%>" pattern="###,###,###"/>(<%=order.getOrderCnt()%>)
					</div>
				</div>
				<div>
					<div>주문 상태</div>
					<div><%=order.getOrderStatus()%>
						<%
							if(order.getOrderStatus().equals("배송완료")){
						%>
								<button type="button" class="style-btn" onclick="location.href='<%=request.getContextPath()%>/cstm/addReview.jsp?id=<%=id%>&orderNo=<%=order.getOrderNo()%>'">리뷰 작성</button>
						<%		
							}
						%>
					</div>
				</div>
			</div>
			<br>
			<h3>배송지</h3>
			<br>
			<button type="submit" class="style-btn">주문 취소</button>
			<button type="button" class="style-btn" onclick="history.back()">뒤로가기</button>
		</form>
	</div>
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
</body>
</html>