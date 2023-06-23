<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>

<%

/*
후기게시판 -> 전체 reviewList를 띄운다
리스트 열람만 가능, 리스트에 사진 안 띄움
*/
	//유효성 검사 x
	
	
	//현재페이지
		int currentPage = 1;
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
	//reviewDao 객체 선언
		ReviewDao reviewDao = new ReviewDao();
		ProductDao productDao = new ProductDao();
		OrderDao orderDao = new OrderDao();

		
	// 요청값 변수에 저장
	//int orderNo = 0;
	//String orderNoParam = request.getParameter("orderNo");
	//if (orderNoParam != null && !orderNoParam.equals("")) {
	//    orderNo = Integer.parseInt(orderNoParam);
	//}
	//System.out.println(orderNoParam);
	
	// 페이징을 위한 변수 선언
		//총 행의 수
		int totalRow = reviewDao.selectReviewCnt();
	
		//페이지 당 행의 개수
		int rowPerPage = 5;
		int beginRow = (currentPage - 1) * rowPerPage;
		
		//페이지에 들어가는 목록의 개수
		int pagePerPage = 5;
		
		//페이지 선택 버튼 1/11/21
		int minPage = (currentPage - 1) / pagePerPage * pagePerPage + 1;
		
		//마지막 페이지
		int lastPage = totalRow / rowPerPage;
		if(totalRow % rowPerPage != 0){
			lastPage++;
		}
		//페이지 선택 버튼 10/20/30
		int maxPage = minPage + (pagePerPage-1);
		if(maxPage > lastPage){
			maxPage = lastPage;
		}

	
	//현재 페이지에 표시 할 리스트 생성
		ArrayList<HashMap<String, Object>> list = reviewDao.reviewList( beginRow, rowPerPage);
		

		
		
	
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
	<!-- ajax -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script>

	$(document).ready(function(){
		if("<%=request.getParameter("msg")%>" != "null"){
			swal("성공", "<%=request.getParameter("msg")%>", "success");
		}
	});
		function listItemClick(orderNo) {
			window.location.href = "<%=request.getContextPath()%>/cstm/review.jsp?orderNo=" + orderNo;
		}
	</script>
	
</head>
<body>
<!-- 메인메뉴 -->
		<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
<!-- 리스트 폼 -->		
		<div class="container">
		
			<div class="list-wrapperql marginTop50">
				<h2>후기게시판</h2>
				<div class="list-item marginTop20">
					<div>상품명</div>
					<div>제목</div>
					<div>작성일</div>
					<div>수정일</div>
					<div>아이디</div>
				</div>
				
				<%
					for(HashMap<String, Object> map: list){
						Review review = (Review)map.get("review");
						String productName = (String)map.get("productName");
						Order order = orderDao.getOrderDetail(review.getOrderNo());
		
				%>
					<div class="list-item hovered" onclick="listItemClick(<%=review.getOrderNo()%>)">
						
						<div><%=productName %></div>
						<div><%=review.getReviewTitle() %></div>
						<div><%=review.getUpdatedate().substring(0,10) %></div>
						<div><%=review.getCreatedate().substring(0,10) %></div>
						<div><%=order.getId()%></div>
		
		
					</div>
			
			
				<%
					}
				%>
				
		
				<!-- 페이지네이션 -->
				<div class="pagination flex-wrapper">
					<div class="flex-wrapper">
						<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/reviewList.jsp?currentPage=1">◀◀</a>
						
						<%
							if(minPage != 1){
						%>
								<a href="<%=request.getContextPath() %>/cstm/reviewList.jsp?currentPage=<%=minPage - pagePerPage %>"  class="pageBtn">◁</a>
						<%
							}
						%>
					</div>
					<div class="page">
						<%
							for(int i = minPage; i <= maxPage; i++){
								String selected = i == currentPage ? "selected" : "";
						%>
								<a href="<%=request.getContextPath() %>/cstm/reviewList.jsp?currentPage=<%=i %>" class="<%=selected %>">
									<%=i %>
								</a>
						<%
							}
						%>
					</div>
					<div class="flex-wrapper">
						<%
							if(maxPage != lastPage){
						%>
								<a href="<%=request.getContextPath() %>/cstm/reviewList.jsp?currentPage=<%=maxPage + 1 %>"  class="pageBtn">▷</a>
						<%
							}
						%>
						<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/reviewList.jsp?currentPage=<%=lastPage%>">▶▶</a>
					</div>
					
				</div>
			</div>
		</div>
	
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	<!-- footer -->
	<jsp:include page="/inc/footer.jsp"></jsp:include>
</body>
</html>