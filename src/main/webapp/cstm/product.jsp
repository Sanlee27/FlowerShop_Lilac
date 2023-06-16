<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.DecimalFormat"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	/*
	//유효성검사
	if(request.getParameter("productNo") == null) {
		
	}
	*/
	
	//DAO
	ProductDao productdao = new ProductDao();
	ReviewDao reviewdao = new ReviewDao();
	OrderDao orderdao = new OrderDao();
	QuestionDao questiondao = new QuestionDao();
	
	//변수
	int productNo = 2;
	//int productNo = Integer.parseInt(request.getParameter("productNo"));
	int orderNo = 4;
	//int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	
	//productdao
	HashMap<String, Object> map = productdao.getProductDetail(productNo);
	Product product = (Product)map.get("product");
	ProductImg productimg = (ProductImg)map.get("productImg");
	double discountrate = (double)map.get("discountRate");
	int discountprice = (int)map.get("discountPrice");
	
	//order
	Order order = orderdao.getOrderDetail(orderNo);
	
	//리뷰 페이징
	int reBeginRow = 0;
	int reRowPerPage = 10;
	
	//review
	ArrayList<Review> reList = reviewdao.reviewProduct(productNo, reBeginRow, reRowPerPage);
		System.out.println(reList);
		
	//문의 페이징
	int beginRow = 0;
	int rowPerPage = 10;
	
	//question
	ArrayList<Question> qList = questiondao.QuestionProduct(productNo, beginRow, rowPerPage);
		System.out.println(qList);

	// 가격 표시해줄 포맷터
	DecimalFormat dc = new DecimalFormat("###,###,###,###");
	
	//path 변수
	String path = request.getContextPath() + "/product/" + productimg.getProductSaveFilename();
		System.out.println(path + "<-path");

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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script>
		$(document).ready(function(){
			//nav 이동
			$("#toDetail").click(function(){
				window.scrollTo({top:900, behavior: "smooth"});
	
			});
			$("#toReview").click(function(){
				window.scrollTo({top:2490, behavior: "smooth"});
	
			});
			$("#toQna").click(function(){
				window.scrollTo({top:3360, behavior: "smooth"});
	
			});
			
			//상품 수량 변경 버튼
			let productCnt = $("#productCnt_input").val();
			$("#plus").click(function(){
				$("#productCnt_input").val(++productCnt);
			});
			
			$("#minus").click(function(){
				if(productCnt > 1) {
					$("#productCnt_input").val(--productCnt);
				} else {
					swal("경고", "상품을 한 개이상 구매해주세요", "warning");
				}
			});
			
			if("<%=request.getParameter("msg")%>" == "상품을 모두 삭제 후 카테고리를 삭제해주세요.") {
				swal("경고", "<%=request.getParameter("msg")%>", "warning");
			}else if("<%=request.getParameter("msg")%>" != "null") {
				swal("완료", "<%=request.getParameter("msg")%>", "success");
			}
		});
		function orderClick(){
			const pNo = '<%=productNo%>';
			const cCnt = $('#productCnt_input').val();
			
			location.href="<%=request.getContextPath()%>" + '/cstm/order.jsp?productNo=' + pNo + '&cartCnt=' + cCnt;		
			}
		function cartClick(){
			const pNo = '<%=productNo%>';
			const cCnt = $('#productCnt_input').val();
			
			location.href="<%=request.getContextPath()%>" + '/cstm/cart.jsp?productNo=' + pNo + '&cartCnt=' + cCnt;		
			}
	</script>
</head>
<body>
<!-- 메인메뉴 -->
<div>
<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>

<div class="container">
	<!-- 상품 주문 -->
	<div style="margin-bottom: 600px">
	<div><img src="<%=path%>" width="100px"></div>
	<div>상품명 : <%=product.getProductName()%></div>
	<div>가격 : <%=dc.format(product.getProductPrice())%>원</div>
	<div>할인율 : <%=Math.round(discountrate * 100)%>%</div>
	<div>할인된 가격 : <%=dc.format(discountprice)%>원</div>
	
	<div id="productCnt">
	<div>수량 : <input type="number" id="productCnt_input" value="1"></div>
	<span>
			<button id="plus">+</button>
			<button id="minus">-</button>
	</span>
	</div>
	
	<div><a onclick="orderClick()">주문하기</a></div>
	<div id="cart"><a onclick="cartClick()">장바구니</a></div>
	</div>
	<div>---------</div>
	
	<div id="navbar">
	<div><button id="toDetail" >상세설명</button></div>
	<div><button id="toReview" >리뷰</button></div>
	<div><button id="toQna" >문의</button></div>
	</div>
	
	<div>---------</div>
	<div style="margin-bottom: 400px">
		<h1>상세설명</h1>
		<div><img src="<%=path%>" width="500px"></div>
		<div><%=product.getProductInfo()%></div>
	</div>
	
	<div>---------</div>
	<div class="list-wrapper5" style="margin-bottom: 700px">
		<h1>리뷰</h1>
		<div class="list-item">
			<div>제목</div>
			<div>내용</div>
			<div>작성자</div>
			<div>작성일</div>
		</div>
		
		<%
			for(Review r : reList) {
		%>
		<div class="list-item">
			<div><%=r.getReviewTitle()%></div>
			<div><%=r.getReviewContent()%></div>
			<div><%=order.getId()%></div>
			<div><%=r.getCreatedate()%></div>
		</div>
		<%
			}
		%>
	</div>
	
	<div>---------</div>
	<div class="list-wrapper6" id="qna" style="margin-bottom: 800px">
	<h1>문의</h1>
		<div class="list-item">
			<div>카테고리</div>
			<div>제목</div>
			<div>내용</div>
			<div>작성자</div>
			<div>작성일</div>
			<div>답변여부</div>
		</div>
		<%
			for(Question q : qList) {
		%>
		<div class="list-item" id="review">
			<div><%=q.getqCategory()%></div>
			<div><%=q.getqTitle()%></div>
			<div><%=q.getqContent()%></div>
			<div><%=q.getId()%></div>
			<div><%=q.getCreatedate()%></div>
			<div><%=q.getqAnswer()%></div>
		</div>
		<%
			}
		%>
	</div>
</div>
</body>
</html>