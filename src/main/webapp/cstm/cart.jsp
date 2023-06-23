<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 변수 초기화
	int productNo = 0;
	int cartCnt = 0;
	String id = (String)session.getAttribute("loginId");
	int cartNo = 0;
	
	// 만약에 아이디가 세션에 없으면
	if(id == null){
		// 장바구니 세션에 데이터가 있으면
		if(session.getAttribute("cart") != null){
			// 장바구니세션에서 가져오기
			HashMap<String, Object> cart = (HashMap<String, Object>)session.getAttribute("cart");
			productNo = (Integer)cart.get("productNo");
			cartCnt = (Integer)cart.get("cartCnt");
		}
	}else{
		// CartDao 객체선언
		CartDao cartDao = new CartDao();
		
		// 아이디에 해당하는 cart정보 가져오기
		Cart cart = cartDao.selectCart(id);
		
		if(cart != null){
			// cart에 있는 productNo저장
			productNo = cart.getProductNo();
			
			// cart에 있는 나머지 값 저장
			cartCnt = cart.getCartCnt();
			cartNo = cart.getCartNo();
		}
	}
	
	ProductImg productImg = new ProductImg();
	int discountPrice = 0;
	double discountRate = 0.0;
	Product product = new Product();
	
	if(cartNo != 0 || session.getAttribute("cart") != null){
		// ProdcutDao 객체선언
		ProductDao productDao = new ProductDao();
		
		// productNo에 해당하는 product정보 가져오기
		HashMap<String, Object> map = productDao.getProductDetail(productNo);
		product = (Product)map.get("product");
		productImg = (ProductImg)map.get("productImg");
		discountPrice = (Integer)map.get("discountPrice");
		discountRate = (Double)map.get("discountRate");
	}
	
	// 가격 표시해줄 포맷터
	DecimalFormat dc = new DecimalFormat("###,###,###,###");
	
%>
<div class="modal-container" id="cartModal">
	<div class="modal">
		<h2>장바구니</h2>
		<button type="button" onclick='cartModalClose()' class="closeBtn">
				<img src="<%=request.getContextPath() %>/images/close.png">
		</button>
		<%
			if(productNo == 0 && cartCnt ==0){
		%>
			<div class="empty">
				장바구니가 비었습니다.
			</div>
		<% 
			}else{
		%>
			<div class="modal-body marginTop30">
				<div>
					<img src="<%=request.getContextPath() %>/product/<%=productImg.getProductSaveFilename() %>.<%=productImg.getProductFiletype() %>" class="product-img">
				</div>
				<div class="modal-content">
					<h3><%=product.getProductName() %></h3>
					<div>
						가격 : 
						<%
							if(discountRate == 0.0){
						%>
								<%=dc.format(product.getProductPrice()) %>
						<%
							}else{
						%>
								<del><%=dc.format(product.getProductPrice()) %></del>
								<span class="price"><%=dc.format(discountPrice) %></span>
						<%
							}
						%>
					
					</div>
					<div class="cnt-wrapper">
						<a class="pmBtn" onclick="changeCartCnt(<%=cartNo %>, parseInt($(this).parent().find('#cartCnt').text(), 10) - 1)">
							<img src="<%=request.getContextPath() %>/images/minus.png">
						</a>
						<div id="cartCnt"><%=cartCnt %></div>
						<a class="pmBtn" onclick="changeCartCnt(<%=cartNo %>, parseInt($(this).parent().find('#cartCnt').text(), 10) + 1)">
							<img src="<%=request.getContextPath() %>/images/plus.png">
						</a>
					</div>
				</div>
			</div>
			<h3 class="marginTop20" id="cartTotal">
				주문금액 : <%=dc.format(discountPrice * cartCnt) %>
			</h3>
			<div class="flex-wrapper marginTop20">
				<a onclick="orderBtnClick()" class="cartBtn">구매</a>
				<a onclick="removeCart(<%=cartNo %>)" class="cartBtn">삭제</a>
			</div>
		<%
			}
		%>
	</div>
</div>
<script>
	function orderBtnClick(){
		const cartCnt = $("#cartCnt").text();
		location.href="<%=request.getContextPath()%>" + "/cstm/order.jsp?productNo=" + <%=productNo%> + "&orderCnt=" + cartCnt;
	}
	function removeCart(cartNo){
		let xhr = new XMLHttpRequest();
		let url = '<%=request.getContextPath()%>/cstm/removeCartAction.jsp';
		let params = 'cartNo=' + encodeURIComponent(cartNo);

		
		xhr.open('POST', url, true);
	    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	
	    xhr.onreadystatechange = function() {
	        if (xhr.readyState === 4) {
	            if (xhr.status === 200) {
	                // 성공시 장바구니 비우기
	                $('.modal').html("<h2>장바구니</h2>"
	                	+ "<button type='button' onclick='cartModalClose()' class='closeBtn'><img src='<%=request.getContextPath() %>/images/close.png'></button>"
	            		+ "<div class='empty'>장바구니가 비었습니다.</div>");
	            } else {
	                // 요청이 실패한 경우
	                console.error('장바구니 삭제 실패');
	            }
	        }
	    };
	
	    xhr.send(params);
	}
	function changeCartCnt(cartNo, cartCnt) {
		if(cartCnt < 1){
			return;
		}
	    let xhr = new XMLHttpRequest();
	    let url = '<%=request.getContextPath()%>/cstm/modifyCartAction.jsp';
	    let params = 'cartNo=' + encodeURIComponent(cartNo) + '&cartCnt=' + encodeURIComponent(cartCnt);
	
	    xhr.open('POST', url, true);
	    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	
	    xhr.onreadystatechange = function() {
	        if (xhr.readyState === 4) {
	            if (xhr.status === 200) {
	                // 변경된 정보를 사용하여 DOM 업데이트 함수 호출
	                $('#cartCnt').text(cartCnt);
	                const total = cartCnt * <%=discountPrice%>;
	                $('#cartTotal').text('주문금액 : ' + total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","))
	            } else {
	                // 요청이 실패한 경우
	                console.error('장바구니 수량 변경 요청 실패');
	            }
	        }
	    };
	
	    xhr.send(params);
	}
	function cartModalClose(){
		$('#cartModal').hide();
	}
</script>