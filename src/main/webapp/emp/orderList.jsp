<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 요청값 있으면 저장
	String searchUser = null;
	if(request.getParameter("searchUser") != null
	&& !request.getParameter("searchUser").equals("")){
		searchUser = request.getParameter("searchUser");
	}
	
	String searchProduct = null;
	if(request.getParameter("searchProduct") != null
	&& !request.getParameter("searchProduct").equals("")){
		searchProduct = request.getParameter("searchProduct");
	}
	int currentPage = 1;
	if(request.getParameter("currentPage") != null
	&& !request.getParameter("currentPage").equals("")){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 페이징을 위한 변수선언
	int rowPerPage = 10;
	int startRow = (currentPage - 1) * rowPerPage;
	
	// OrderDao 객체 선언
	OrderDao orderDao = new OrderDao();
	
	// 주문내역 가져오기
	ArrayList<HashMap<String, Object>> orderList = orderDao.getAllOrderList(searchUser, searchProduct, startRow, rowPerPage);
	
	// 주문내역안에 들어있는 totalRow값 따로 저장
	int totalRow = (Integer)orderList.get(0).get("totalCnt");
	
	// 페이징을 위한 변수
	int pagePerPage = 10;
	int startPage = (currentPage - 1) / pagePerPage * pagePerPage + 1;
	int endPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		endPage++;
	}
	int lastPage = startPage + pagePerPage - 1;
	if(lastPage > endPage){
		lastPage = endPage;
	}
	
	// 가격 표시해줄 포맷터
	DecimalFormat dc = new DecimalFormat("###,###,###,###");
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
	<!-- jQuery -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<!-- 페이지단 script -->
	<script>
		$(document).ready(function(){
			const msg = "<%=request.getParameter("msg")%>";
			
			if(msg == "null" || msg == ""){
				return;
			}
			if(msg === "success"){
				swal("성공", "수정에 성공하였습니다.", "success");
			}else{
				swal("실패", "수정에 실패하였습니다.", "error");
			}
		})
	 	function modifyOrder(orderNo) {
		    let url = '<%= request.getContextPath() %>/emp/modifyOrderAction.jsp?orderNo=' + orderNo + '&orderStatus=' + encodeURIComponent($('div.list-item select[name=orderStatus]').val());
		    window.location.href = url;
		  }
	</script>
</head>
<body>
	<!-- 메인메뉴 -->
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	
	<div class="container">
		<div class="list-wrapperod marginTop50">
			<h2>주문리스트</h2>
			<br>
			<div class="list-item">
				<div>주문번호</div>
				<div>상품번호</div>
				<div>상품이름</div>
				<div>아이디</div>
				<div>주문상태</div>
				<div>주문수량</div>
				<div>주문금액</div>
				<div>주문일자</div>
				<div>&nbsp;</div>
			</div>
			<%
				for(HashMap<String, Object> m : orderList){
					if(m.get("order") == null){
						continue;
					}
					Order order = (Order)m.get("order");
					String productName = (String)m.get("productName");
					String orderStatus = order.getOrderStatus();
			%>
					<div class="list-item">
						<div><%=order.getOrderNo() %></div>
						<div><%=order.getProductNo() %></div>
						<div><%=productName %></div>
						<div><%=order.getId() %></div>
						<div>
							<select name="orderStatus" <%if(orderStatus.equals("배송완료") || orderStatus.equals("취소")){ %> disabled <%} %>>
								<option <%if(orderStatus.equals("결제완료")){ %> selected <%} %>>결제완료</option>
								<option <%if(orderStatus.equals("배송중")){ %> selected <%} %>>배송중</option>
								<option <%if(orderStatus.equals("배송완료")){ %> selected <%} %>>배송완료</option>
								<option <%if(orderStatus.equals("취소")){ %> selected <%} %>>취소</option>
							</select>
						</div>
						<div><%=order.getOrderCnt() %></div>
						<div><%=dc.format(order.getOrderPrice()) %></div>
						<div><%=order.getCreatedate() %></div>
						<div>
							<a href="#" onclick="modifyOrder(<%= order.getOrderNo() %>, this.previousElementSibling)" class="style-btn">수정</a>
						</div>
					</div>
			<%
				}
			%>
		</div>
		
		<div class="pagination flex-wrapper">
			<div class="flex-wrapper">
				<a href="<%=request.getContextPath() %>/emp/orderList.jsp?currentPage=1"  class="pageBtn">
					◀◀
				</a>
				<%
					if(startPage != 1){
				%>
						<a href="<%=request.getContextPath() %>/emp/orderList.jsp?currentPage=<%=startPage - pagePerPage %>"  class="pageBtn">
							◀
						</a>
				<%
					}
				%>
			</div>
			<div class="page">
				<%
					for(int i = startPage; i <= endPage; i++){
						String selected = i == currentPage ? "selected" : "";
				%>
						<a href="<%=request.getContextPath() %>/emp/orderList.jsp?currentPage=<%=i %>" class="<%=selected %>">
							<%=i %>
						</a>
				<%
					}
				%>
			</div>
			<div class="flex-wrapper">
				<%
					if(endPage != lastPage){
				%>
						<a href="<%=request.getContextPath() %>/emp/orderList.jsp?currentPage=<%=endPage + 1 %>"  class="pageBtn">
							▶
						</a>
				<%
					}
				%>
				<a href="<%=request.getContextPath() %>/emp/orderList.jsp?currentPage=<%=lastPage%>"  class="pageBtn">
					▶▶
				</a>
			</div>
		</div>
	</div>
	<!-- footer -->
	<jsp:include page="/inc/footer.jsp"></jsp:include>
</body>
</html>