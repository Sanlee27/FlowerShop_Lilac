<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("UTF-8");

	//클래스 객체 생성
	ProductDao dao = new ProductDao();
	CategoryDao cDao = new CategoryDao();

	// ==================================================
	
	String searchCategory = "";
	if(request.getParameter("searchCategory") != null) {
		searchCategory = request.getParameter("searchCategory");
	}
	String searchName = "";
	if(request.getParameter("searchName") != null) {
		searchName = request.getParameter("searchName");
	}
	String order = "";
	if(request.getParameter("order") != null) {
		order = request.getParameter("order");
	}
	
	//================== 페이지 ===================
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 페이지 당 행 개수
	int rowPerPage  = 12;
	if(request.getParameter("rowPerPage") != null) {
	      rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	
	// 총 행의 수
	int totalRow = 0; 
	int totalPdctRow = dao.getProductCnt(searchCategory, searchName);
	totalRow = totalPdctRow;
	// System.out.println(totalRow);
	
	// 시작행 = ((현재 페이지 - 1) x 페이지당 개수 20개)
	int startRow = (currentPage-1) * rowPerPage;
	
	// 마지막행 = 시작행 + (페이지당 개수 20개 - 1 = 19);
	int endRow = startRow + (rowPerPage - 1);
	if(endRow > totalRow){
		endRow = totalRow;
	}
	
	// 각 페이지 선택 버튼 몇개 표시?
	int pagePerPage = 10;
	
	// 마지막 페이지
	int lastPage = totalRow / rowPerPage; 
	if(totalRow % rowPerPage != 0){ // 페이지가 떨어지지않아 잔여 행이 있다면 
		lastPage = lastPage + 1; // 1 추가, 잔여 행을 lastPage에 배치
	}
	
	// 페이지 선택 버튼 최소값 >> 1~10 / 11~20 에서 1 / 11 / 21 ,,,
	int minPage = (((currentPage-1) / pagePerPage) * pagePerPage) + 1;
		
	// 페이지 선택 버튼 최대값 >> 1~10 / 11~20 에서 10 / 20 / 30 ,,,
	int maxPage = minPage + (pagePerPage - 1);
	if(maxPage > lastPage){ // ex) lastPage는 27, maxPage가 30(21~30) 일 경우
		maxPage = lastPage;  // maxPage를 lastPage == 27로 한다. 
	}
	
	// 전체 상품리스트
	ArrayList<HashMap<String, Object>> list = dao.getAllProductList(searchCategory, searchName, order, startRow, rowPerPage);
	
	// 카테고리 리스트
	ArrayList<Category> cateList = cDao.selectCategoryList();
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
				
				//========= 정렬버튼 고정 ===========
		 		let selectedCategory = '<%=searchCategory%>';
			    if (selectedCategory) {
			      $('select[name="searchCategory"]').val(selectedCategory);
			    }
			    
			    let selectedOrder = '<%=order%>';
			    if (selectedOrder) {
			      $('select[name="order"]').val(selectedOrder);
			    }
				
			    // 입력한 검색어 고정
			    let enteredSearchName = '<%=searchName%>';
			    if (enteredSearchName) {
			      $('input[name="searchName"]').val('<%=searchName%>');
			    }
			    
			    // ========= 정렬 초기화 버튼 =============
			    $('#reset').click(function () {
			        $('select[name="searchCategory"] option:eq(0)').prop('selected', true);
			        $('select[name="order"] option:eq(0)').prop('selected', true);
			        $('form').submit();
			    });
			     
			    // 선택값 바로 실행
			    $('select[name="searchCategory"], select[name="order"]').change(function() {
			        $('form').submit();
			      });
			    
				// ========= 검색 초기화 버튼 =============
				$('#resetSearch').click(function(){
					 $('input[name="searchName"]').val('');
					 $('form').submit();
				});
				
			});
		function productClick(productNo){
			location.href = "<%=request.getContextPath()%>" + "/cstm/product.jsp?productNo=" + productNo;
		}
	</script>
	<!-- data-aos 라이브러리(fade up구현해주는 - 스크롤이벤트) -->
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
	<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
		
</head>
	<body>
		<script>
			AOS.init();
		</script>
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<!-- =========== 리스트 ============ -->
		<div class="container">
			<div class="product-list">
				<h1><a href="<%=request.getContextPath()%>/cstm/productList.jsp">상품 리스트</a></h1>
				<!-- ==============검색버튼============== -->
				<form>
					<div class="marginTop30">
						<select name="searchCategory">
							<option value="">카테고리</option>
							<%
								for(Category c : cateList){
							%>
									<option value="<%=c.getCategoryName()%>"><%=c.getCategoryName()%></option>
							<%
								}
							%>
						</select>
						
						<select id="order" name="order">
							<option value="">정렬</option>
							<option value="판매량많은순">판매량많은순</option>
							<option value="가격높은순">가격높은순</option>
							<option value="가격낮은순">가격낮은순</option>
							<option value="할인율높은순">할인율높은순</option>
						</select>
						
						<input type="text" name="searchName" placeholder="상품을 입력하세요">
						
						<button type="button" id="resetSearch" class="style-btn">검색초기화</button>
						<button type="button" id="reset" class="style-btn">정렬초기화</button>
					</div>
					<div class="products">
					<%
						for(HashMap<String, Object> o : list){
							Product product = (Product)o.get("product");
							ProductImg pi = (ProductImg)o.get("productImg");
							double discountRate = (double)o.get("discountRate");
							int discountPrice = (int)o.get("discountPrice"); 
							String path = request.getContextPath() + "/product/" + pi.getProductSaveFilename() + "." + pi.getProductFiletype();
					%>		
								<div onclick="productClick(<%=product.getProductNo()%>)" data-aos="fade-up" data-aos-duration="2000">
									<div class="img-wrapper">
										<img src="<%=path%>">
									</div>
									<div class="divide-line"></div>
									<div class="content">
										<a href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=product.getProductNo()%>">
											<%=product.getProductName()%>
										</a>
									<br>
									<%	
										if(product.getProductStatus().equals("품절")){
									%>
											<span class="price">품절</span>
									<%
										} else {
											if(discountRate == 0){
									%>
												<a href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=product.getProductNo()%>">
													<fmt:formatNumber value="<%=product.getProductPrice()%>" pattern="###,###,###"/>
												</a>
									<%
											} else {
									%>
												<del><fmt:formatNumber value="<%=product.getProductPrice()%>" pattern="###,###,###"/></del>
												<br>
													<a href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=product.getProductNo()%>">
														<span class="price">
															<fmt:formatNumber value="<%=discountPrice%>" pattern="###,###,###"/>
														</span>
													</a>
												
									<%
											}
										}
									%>
									</div>
								</div>
					<%
						}
					%>
					</div>
					<br>
					<!-- ================ 페이지 ================ -->
					<div class="pagination flex-wrapper">
						<div class="flex-wrapper">
							<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/productList.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=1">◀◀</a>
							<%
								// 10p 단위 이전 버튼
								if(minPage>1){
							%>
									<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/productList.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=<%=minPage-pagePerPage%>">◁</a>
							<%
								}
							%>
						</div>
						<div class="page">
							<%
								for(int i=minPage; i<=maxPage; i=i+1){
									if(i == currentPage){
									%>
										<a class="selected"><%=i%></a>
									<%	
									} else {
									%>
										<a href="<%=request.getContextPath()%>/cstm/productList.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=<%=i%>"><%=i%></a>
									<%	
									}
								}
							%>
						</div>
						<div class="flex-wrapper">
							<%
								// 10p단위 다음버튼
								if(maxPage != lastPage){
							%>	
									<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/productList.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=<%=minPage+pagePerPage%>">▷</a>	
							<%
								}
							%>
							<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/productList.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=<%=lastPage%>">▶▶</a>
						</div>
					</div>
				</form>
			</div>
		</div>
		<jsp:include page="/cstm/cart.jsp"></jsp:include>
		<!-- footer -->
		<jsp:include page="/inc/footer.jsp"></jsp:include>
	</body>
</html>