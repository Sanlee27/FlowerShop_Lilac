<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.DecimalFormat"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	
	//유효성검사
	if(request.getParameter("productNo") == null
		||request.getParameter("productNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/cstm/productList.jsp");
		return;
	}
	
	//DAO
	ProductDao productdao = new ProductDao();
	ReviewDao reviewdao = new ReviewDao();
	OrderDao orderdao = new OrderDao();
	QuestionDao questiondao = new QuestionDao();
	
	//변수
	//int productNo = 2;
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	
	//productdao
	HashMap<String, Object> map = productdao.getProductDetail(productNo);
	Product product = (Product)map.get("product");
	ProductImg productimg = (ProductImg)map.get("productImg");
	double discountrate = (double)map.get("discountRate");
	int discountprice = (int)map.get("discountPrice");
	
	//리뷰 페이징
	int reCurrentPage = 1; // 현재페이지
		if(request.getParameter("reCurrentPage") != null) {
			reCurrentPage = Integer.parseInt(request.getParameter("reCurrentPage"));
		}
			System.out.println(reCurrentPage + "<-reCurrentPage");
			
	int reRowPerPage = 2; // 페이지당 행

	int reBeginRow = (reCurrentPage - 1) * reRowPerPage; // 첫 행
	int reTotalRow = reviewdao.selectReviewProductNoCnt(productNo); // 전체 행 
	int reLastPage = reTotalRow / reRowPerPage; // 마지막 페이지
	if(reTotalRow % reRowPerPage != 0) { // 전체행 / 페이지당 행 != 0 -> 페이지 추가
		reLastPage++;
	}

	int rePagePerNum = 2; // 페이지당 페이지 수
	
	int reMinPageNum = (reCurrentPage - 1)/rePagePerNum * rePagePerNum + 1; // 페이지당 최소 페이지 번호 
	int reMaxPageNum = reMinPageNum * rePagePerNum; // 페이지당 최대 페이지 번호 
	if(reMaxPageNum > reLastPage) {
		reMaxPageNum = reLastPage;
	}
	
	//review
	ArrayList<HashMap<String, Object>> reList = reviewdao.reviewProductList(productNo, reBeginRow, reRowPerPage);
		System.out.println(reList.size() + "<-reList");
		
	//문의 페이징 
	int currentPage = 1; // 현재페이지
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
			System.out.println(currentPage + "<-currentPage");
	int rowPerPage = 2; // 페이지당 행

	int beginRow = (currentPage - 1) * rowPerPage; // 첫 행
	int totalRow = questiondao.selectProductNoCnt(productNo);// 전체 행
		System.out.println(totalRow);
	int lastPage = totalRow / rowPerPage; // 마지막 페이지
	if(totalRow % rowPerPage != 0) { // 전체행 / 페이지당 행 != 0 -> 페이지 추가
		lastPage++;
	}

	int pagePerNum = 2; // 페이지당 페이지 수
	
	int minPageNum = (currentPage - 1)/pagePerNum * pagePerNum + 1; // 페이지당 최소 페이지 번호 
	int maxPageNum = (minPageNum + pagePerNum - 1); // 페이지 숫자 최대 // 페이지당 최대 페이지 번호 
	if(maxPageNum > lastPage) {
		maxPageNum = lastPage;
	}
	
	//question
	ArrayList<Question> qList = questiondao.QuestionProduct(productNo, beginRow, rowPerPage);
		System.out.println(qList + "<-qList");

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
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
  	<script>
  		
  	</script>
	<script>
		$(document).ready(function(){
			//상품 정보 페이드인
		  	    $('.container').fadeIn(1000);
		  
		
			//nav 이동
			$("#toDetail").click(function(){
				window.scrollTo({top:700, behavior: "smooth"});
			});
			$("#toReview").click(function(){
				window.scrollTo({top:2030, behavior: "smooth"});
			});
			$("#toQna").click(function(){
				window.scrollTo({top:2720, behavior: "smooth"});
			});
			
			//스크롤 위치에 따른 네비바 색 변환
			$(window).scroll(function() {
				 var scrollPosition = $(this).scrollTop();
				 var threshold = 700;
				 var navbar = $('.navbar-wrapper');
				 var toDetail = $('#toDetail');
				 var toReview = $('#toReview');
				 var toQna = $('#toQna');
				  
				  if (scrollPosition < threshold) {//0~700
				    navbar.removeClass('fixed');
				    toDetail.removeClass('active');
				    toReview.removeClass('active');
				    toQna.removeClass('active');
				  } else if (scrollPosition >= threshold && scrollPosition < 2030) { //700~2150-상세
				    navbar.addClass('fixed');
				    toDetail.addClass('active');
				    toReview.removeClass('active');
				    toQna.removeClass('active');
				  } else if (scrollPosition >= 2030 && scrollPosition < 2720) { //2150~2650-리뷰
				    navbar.addClass('fixed');
				    toDetail.removeClass('active');
				    toReview.addClass('active');
				    toQna.removeClass('active');
				  } else { // 그이상 - 문의
				    navbar.addClass('fixed');
				    toDetail.removeClass('active');
				    toReview.removeClass('active');
				    toQna.addClass('active');
				  }
			});
			
			// 총 주문 가격 계산 함수
			function calculateTotalPrice() {
			  var productDp = <%=discountprice%>; // 할인된 가격
			  var productCnt = parseInt($("#productCnt_input").val()); // 수량
			
			  var totalPrice = productDp * productCnt;
			
			  $("#totalPrice").text(totalPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + "원"); // 총 주문 가격을 표시할 요소에 값 할당
			}
			// 수량이 변경될 때마다 총 주문 가격 계산
			$("#productCnt_input").on("input", calculateTotalPrice);

			//상품 수량 변경 
			let productCnt = $("#productCnt_input").val();
			$("#plus").click(function(){
				$("#productCnt_input").val(++productCnt);
				calculateTotalPrice();
			});
			
			$("#minus").click(function(){
				if(productCnt > 1) {
					$("#productCnt_input").val(--productCnt);
					calculateTotalPrice();
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
		//주문버튼
		function orderClick(){
			const pNo = '<%=productNo%>';
			const cCnt = $('#productCnt_input').val();
			
			location.href="<%=request.getContextPath()%>" + '/cstm/order.jsp?productNo=' + pNo + '&orderCnt=' + cCnt;		
			}
		//카트버튼
		function cartClick(){
			let xhr = new XMLHttpRequest();
			let url = '<%=request.getContextPath()%>/cstm/addCartAction.jsp';
			let cartCnt = $('#productCnt_input').val()
			let params = {
					productNo : '<%=productNo%>',
					cartCnt : cartCnt
			};
			xhr.open('POST', url, true);
			xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
			xhr.onreadystatechange = function() {
			    if (xhr.readyState === 4) {
				if (xhr.status === 200) {
					swal("성공", "장바구니 추가 성공", "success")
			          .then(function() {
			            location.reload();
			          });
				} else {
			        // 요청이 실패한 경우
			    	swal("실패", "장바구니 추가 실패", "error");
			      }
			    }
			  };
			  xhr.send($.param(params));	
		}
	</script>
</head>
<body>
	<!-- 메인메뉴 -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	
<div class="container" id="product-container">
     	<!-- 상품 주문 -->
	<div class="productOrder" >
		<div class="productLeft">
			<img src="<%=path%>">
		</div>
		
		<div class="productRight">
			<div class="productName"><%=product.getProductName()%></div>
			<div class="productDc">
				<%
					if(discountrate == 0.0){
				%>
						<%=dc.format(product.getProductPrice())%>원
				<%
					}else{
				%>
						<span class="priceDc">&#x2B07;<%=Math.round(discountrate * 100)%>% 할인</span>	
						<del><%=dc.format(product.getProductPrice())%>원</del>
						<span class="price"><%=dc.format(discountprice) %>원</span>		
				<%
					}
				%>
			
			</div>
			<div id="productCnt">
				<div class="flex-wrapper">
						<div>구매수량</div>
					<div class="btn-wrapper">
						<button id="plus" class="pmBtn"><img src="<%=request.getContextPath() %>/images/plus.png"></button>
						<div><input type="number" id="productCnt_input" value="1" min="1"></div>
						<button id="minus" class="pmBtn"><img src="<%=request.getContextPath() %>/images/minus.png"></button>
					</div>
				</div>
			</div>
			
			<div class="totalPrice-wrapper">
				<div>상품금액 합계</div>
				<div id="totalPrice"><%=dc.format(discountprice)%>원</div>
			</div>
			<div class="deco-line"></div>
			
			<div class="flex-wrapper">
				<div class="orderCartBtn" onclick="orderClick()"><a>주문하기</a></div>
				<div class="orderCartBtn" onclick="orderClick()" id="cart"><a>장바구니</a></div>
			</div>
		</div>
	</div>
	
	<div class="navbar-wrapper">
		<div id="navbar" class="marginTop20 productNavbar">
			<div><button id="toDetail" >상세설명</button></div>
			<div><button id="toReview" >리뷰</button></div>
			<div><button id="toQna" >문의</button></div>
		</div>	
	</div>
	
	<div class="productInfo marginTop100">
		<!-- <h1>상세설명</h1> -->
		<div class="productImg"><img src="<%=path%>"></div>
		<div class="detailName"><h1><%=product.getProductName()%></h1></div>
		<div >
			<%
				if(product.getProductInfo().length() < 50) {		
			%>
				<div><%=product.getProductInfo().substring(0,product.getProductInfo().length())%></div>
			<%
				}else {
			%>
					<div class="detailFrist"><%=product.getProductInfo().substring(0,30)%></div>
					<div><%=product.getProductInfo().substring(30)%></div>
			<%
				}
			%>
		</div>
	</div>
	
	<div class="list-wrapper3 marginTop180 productReview">
		<h2 class="detailCate">리뷰</h2>
		<span class="font-line"></span>
		<div class="list-item">
			<div>제목</div>
			<div>작성자</div>
			<div>작성일</div>
		</div>
		
		<%
			for(HashMap<String, Object> r : reList) {
				Review review = (Review)r.get("review");
				
		%>
		<div class="list-item">
			<div><%=review.getReviewTitle()%></div>
			<div><%=r.get("id")%></div>
			<div><%=review.getCreatedate()%></div>
		</div>
		<%
			}
		%>
		
		<!-- 페이징 -->
		<div class="pagination flex-wrapper">
			<!-- 이전 -> 최소페이지가 1보다 클 경우 이전 활성화 -->
			<div class="flex-wrapper">
				<%
					if(reMinPageNum != 1){
				%>
						<!-- 제일 처음으로  -->
						<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=productNo%>&currentPage=<%=currentPage%>&reCurrentPage=1">
							◀◀
						</a>
						<!-- 10개 이전으로  -->
						<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=productNo%>&currentPage=<%=currentPage%>&reCurrentPage=<%=reMinPageNum - rePagePerNum%>">
							◁
						</a>
				<%
					}
				%>
			</div>
			
			<!-- 페이지 번호 -->
			<div class="page">
				<%
					for(int i = reMinPageNum; i <= reMaxPageNum; i++){
						String selected = i == reCurrentPage ? "selected" : "";
				%>
						<a href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=productNo%>&currentPage=<%=currentPage%>&reCurrentPage=<%=i%>" class="<%=selected%>">
							<%=i%>
						</a>
				<%
					}
				%>
			</div>
			
			<!-- 다음 -->
			<div class="flex-wrapper">
				<%
					if(reMaxPageNum != reLastPage){
				%>
						<!-- 10개 다음으로 -->
						<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=productNo%>&currentPage=<%=currentPage%>&reCurrentPage=<%=reMaxPageNum + 1%>">
							▷
						</a>
						<!-- 제일 마지막으로  -->
						<a class="pageBtn" href="<%=request.getContextPath()%>/emp/productList.jsp?productNo=<%=productNo%>&currentPage=<%=currentPage%>&reCurrentPage=<%=reLastPage%>">
							▶▶
						</a>
				<%
					}
				%>
			</div>
		</div>
	</div>
	
	<div class="list-wrapper6-2 marginTop180 productQna">
		<h2 class="detailCate">문의</h2>
		<span class="font-line"></span>
			<div class="marginTop30"><a class="style-btn" href="<%=request.getContextPath()%>/cstm/addQuestion.jsp?productNo=<%=productNo%>">문의하기</a></div>
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
			<!-- 문의 페이징 -->
			<div class="pagination flex-wrapper" id="qna">
				<!-- 이전 -> 최소페이지가 1보다 클 경우 이전 활성화 -->
				<div class="flex-wrapper">
					<%
						if(minPageNum != 1){
					%>
							<!-- 제일 처음으로  -->
							<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=productNo%>&reCurrentPage=<%=reCurrentPage%>&currentPage=1">
								◀◀
							</a>
							<!-- 10개 이전으로  -->
							<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=productNo%>&reCurrentPage=<%=reCurrentPage%>&currentPage=<%=minPageNum - pagePerNum%>#qnaPageBtn" class="pagelink">
								◁
							</a>
					<%
						}
					%>
				</div>
				
				<!-- 페이지 번호 -->
				<div class="page">
					<%
						for(int i = minPageNum; i <= maxPageNum; i++){
							String selected = i == currentPage ? "selected" : "";
					%>
							<a href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=productNo%>&reCurrentPage=<%=reCurrentPage%>&currentPage=<%=i%>#qnaPageBtn" class="<%=selected%>" class="pagelink">
								<%=i%>
							</a>
					<%
						}
					%>
				</div>
				
				<!-- 다음 -->
				<div class="flex-wrapper">
					<%
						if(maxPageNum != lastPage){
					%>
							<!-- 10개 다음으로 -->
							<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=productNo%>&reCurrentPage=<%=reCurrentPage%>&currentPage=<%=maxPageNum + 1%>#qnaPageBtn" class="pagelink">
								▷
							</a>
							<!-- 제일 마지막으로  -->
							<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=productNo%>&reCurrentPage=<%=reCurrentPage%>&currentPage=<%=lastPage%>">
								▶▶
							</a>
					<%
						}
					%>
				</div>
		
	</div>
</div>
</body>
</html>