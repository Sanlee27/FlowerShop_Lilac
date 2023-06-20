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


		
	// 요청값 변수에 저장
	//int orderNo = 0;
	//String orderNoParam = request.getParameter("orderNo");
	//if (orderNoParam != null && !orderNoParam.equals("")) {
	//    orderNo = Integer.parseInt(orderNoParam);
	//}
	//System.out.println(orderNoParam);
	
	// 페이징을 위한 변수 선언
		int totalRow = reviewDao.selectReviewCnt();
		int rowPerPage = 3;
		int beginRow = (currentPage - 1) * rowPerPage;
		int pagePerPage = 3;
		int startPage = (currentPage - 1) / pagePerPage * pagePerPage + 1;
		int endPage = totalRow / rowPerPage;
		if(totalRow % rowPerPage != 0){
			endPage++;
		}
		int lastPage = startPage + pagePerPage;
		if(lastPage > endPage){
			lastPage = endPage;
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
	
	<script>
		$(document).ready(function() {
			$('.list-item').click(function() {
				let orderNo = $(this).find('.orderNo').text();
				window.location.href ="<%=request.getContextPath()%>/cstm/review.jsp?orderNo=" + orderNo;
			});
		});
	</script>
</head>
<body>
<div>
<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div class="container">

	<div class="list-wrapperql marginTop50">
		<h2>후기 리스트</h2>
		<div class="list-item marginTop20">
			<div>주문번호</div>
			<div>상품명</div>
			<div>제목</div>
			<div>작성일</div>
			<div>수정일</div>
		</div>
		
		<%
			for(HashMap<String, Object> map: list){
				Review review = (Review)map.get("review");
				String productName = (String)map.get("productName");

		%>
			<div class="list-item hovered">
				<input type="hidden" name="orderNo" value="<%=review.getOrderNo()%>">
				
				<div class="orderNo"><%=review.getOrderNo() %></div>
				<div><%=productName %></div>
				<div><%=review.getReviewTitle() %></div>
				<div><%=review.getUpdatedate().substring(0,10) %></div>
				<div><%=review.getCreatedate().substring(0,10) %></div>

			</div>
	
	
		<%
			}
		%>
		

		<!-- 페이지네이션 -->
		<div class="pagination flex-wrapper">
				<div>
					<%
						if(startPage != 1){
					%>
							<a href="<%=request.getContextPath() %>/cstm/reviewList.jsp?currentPage=<%=startPage - pagePerPage %>"  class="pageBtn">
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
							<a href="<%=request.getContextPath() %>/cstm/reviewList.jsp?currentPage=<%=i %>" class="<%=selected %>">
								<%=i %>
							</a>
					<%
						}
					%>
				</div>
				<div>
					<%
						if(endPage != lastPage){
					%>
							<a href="<%=request.getContextPath() %>/cstm/reviewList.jsp?currentPage=<%=endPage + 1 %>"  class="pageBtn">
								▶
							</a>
					<%
						}
					%>
				</div>
			</div>	
		</div>
	</div>
</body>
</html>