<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 만약에 아이디가 세션에 없으면
		// 장바구니세션에서 가져오기
		
	// 아니면
	String id = "user3";
	// CartDao 객체선언
	CartDao cartDao = new CartDao();

	// 아이디에 해당하는 cart정보 가져오기
	Cart cart = cartDao.selectCart(id);
	
	// cart에 있는 productNo저장
	int productNo = cart.getProductNo();
	
	// ProdcutDao 객체선언
	ProductDao productDao = new ProductDao();
	
	// productNo에 해당하는 product정보 가져오기
	HashMap<String, Object> map = productDao.getProductDetail(productNo);
	Product product = (Product)map.get("product");
	ProductImg productImg = (ProductImg)map.get("productImg");
	int discountPrice = (Integer)map.get("discountPrice");
	double discountRate = (Double)map.get("discountRate");
	
	// 가격 표시해줄 포맷터
	DecimalFormat dc = new DecimalFormat("###,###,###,###");
%>
<div class="modal-container">
	<div class="modal">
		<h2>장바구니</h2>
		<button type="button" onclick='modalClose()' class="closeBtn">
			<img src="<%=request.getContextPath() %>/images/close.png">
		</button>
		<div class="flex-wrapper marginTop30">
			<div>
				<img src="<%=request.getContextPath() %>/product/<%=productImg.getProductSaveFilename() %>" class="product-img">
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
					<a class="pmBtn" onclick="changeCartCnt(<%=cart.getCartNo() %>, parseInt($(this).parent().find('#cartCnt').text(), 10) - 1)">
						<img src="<%=request.getContextPath() %>/images/minus.png">
					</a>
					<div id="cartCnt"><%=cart.getCartCnt() %></div>
					<a class="pmBtn" onclick="changeCartCnt(<%=cart.getCartNo() %>, parseInt($(this).parent().find('#cartCnt').text(), 10) + 1)">
						<img src="<%=request.getContextPath() %>/images/plus.png">
					</a>
				</div>
			</div>
		</div>
		<h3 class="marginTop20" id="cartTotal">
			주문금액 : <%=dc.format(discountPrice * cart.getCartCnt()) %>
		</h3>
		<div class="flex-wrapper marginTop20">
			<a href="<%=request.getContextPath() %>/cstm/order.jsp?cartNo=<%=cart.getCartNo() %>" class="cartBtn">구매</a>
			<a href="<%=request.getContextPath() %>/cstm/removeCartAction.jsp?cartNo=<%=cart.getCartNo() %>" class="cartBtn">삭제</a>
		</div>
	</div>
</div>
<script>
	function changeCartCnt(cartNo, cartCnt) {
		if(cartCnt == 0 || cartNo == 0){
			return;
		}
	    var xhr = new XMLHttpRequest();
	    var url = '<%=request.getContextPath()%>/cstm/modifyCartAction.jsp';
	    var params = 'cartNo=' + encodeURIComponent(cartNo) + '&cartCnt=' + encodeURIComponent(cartCnt);
	
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
	function modalClose(){
		$('.modal-container').hide();
	}
</script>