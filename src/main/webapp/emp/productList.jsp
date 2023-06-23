<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%@ page import = "java.text.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//dao
	ProductDao productdao = new ProductDao();
	CategoryDao	categorydao = new CategoryDao();
	
	//Category
	ArrayList<Category> categoryList = categorydao.selectCategoryList();

	// 변수
	String searchCategory = ""; // 카테고리로 검색
		if(request.getParameter("searchCategory") != null) {
			searchCategory = request.getParameter("searchCategory");
		}
		System.out.println(searchCategory + "<-상품 카테고리 검색");
		
	String searchName = ""; // 상품이름으로 검색
		if(request.getParameter("searchName") != null) {
			searchName = request.getParameter("searchName");
		}
		System.out.println(searchName + "<-상품 검색어");
		
	String order = "";
		if(request.getParameter("order") != null) {
			order = request.getParameter("order");
		}
		System.out.println(searchName + "<-상품 검색어");
	String categoryName = request.getParameter("categoryName");
	
	// 페이징 변수
	int currentPage = 1;
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
			System.out.println(currentPage + "<-currentPage");
			
	int rowPerPage = 10; //페이지당 행
	int startRow = (currentPage - 1) * rowPerPage; // 시작행
	
	int totalRow = productdao.getProductCnt(searchCategory, searchName); // 전체행
	
	int pagePerNum = 10; // 페이지당 숫자
	
	int lastPage = totalRow / rowPerPage; //마지막페이지
	if(totalRow % rowPerPage != 0) { //전체 행 / 페이지 당 행이 0 이 아니면 페이지 추가 
		lastPage++;
	}
	
	int minPageNum = (currentPage - 1)/pagePerNum * pagePerNum + 1; // 페이지 숫자 최소
	int maxPageNum = (minPageNum + pagePerNum - 1); // 페이지 숫자 최대
	if(maxPageNum > lastPage) { // 마지막페이지가 페이지당 수보다 클 경우 페이지당 수로 변경
		maxPageNum = lastPage;
	}

	// ProductDao 값 불러오기
	ArrayList<HashMap<String, Object>> list = productdao.getAllProductList(searchCategory, searchName, order, startRow, rowPerPage);
	
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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script>
		$(document).ready(function(){
			//정렬 및 카테고리 선택 시 바로 실행
			$('#order, #searchCategory').change(function() { 
					
				// 제품명 값 가져오기
				  var searchName = $('#searchName').val(); 
				
				// 정렬 값 가져오기
				  var selectedOrder = $('#order').val(); 
				
				// 카테고리 값 가져오기
				  var selectedCategory = $('#searchCategory').val(); 
				
				  var params = {}; // 아래 값 넣기
				  
				  if (searchName) {
				      params.searchName = searchName;
				    }
				  
				  if (selectedOrder) {
					    params.order = selectedOrder;
					  }
			
				  if (selectedCategory) {
					    params.searchCategory = selectedCategory;
					  }
					  
				  var currentUrl = new URL(window.location.href); // 현재페이지
				  currentUrl.search = new URLSearchParams(params).toString(); // 문자열로 설정
				  window.location.href = currentUrl.toString(); // 새로운 페이지에 할당
			});

		    $('#reset').click(function () {//정렬초기화
		        $('select[name="searchCategory"] option:eq(0)').prop('selected', true);
		        $('select[name="order"] option:eq(0)').prop('selected', true);
		    });
	
				if("<%=request.getParameter("msg")%>" == "상품을 모두 삭제 후 카테고리를 삭제해주세요.") {
					swal("경고", "<%=request.getParameter("msg")%>", "warning");
				}else if("<%=request.getParameter("msg")%>" != "null") {
					swal("완료", "<%=request.getParameter("msg")%>", "success");
				}
		});
	</script>
	
</head>
<body>
<!-- 메인메뉴 -->
<div>
<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
<!-- 장바구니 모달 -->
<jsp:include page="/cstm/cart.jsp"></jsp:include>
</div>

<div class="container">
	<!-- 상품 리스트 -->
	<div class="list-wrapper10">
		<h1>상품 리스트</h1>
			<!-- 검색 -->
			<form class="marginTop30">
				<select id="searchCategory" name="searchCategory">
					<option value="">카테고리</option>
					<%
					for(Category c : categoryList) {
					%>
						<option <%if(c.getCategoryName().equals(searchCategory)){%>selected<%} %>><%=c.getCategoryName()%></option>
					<%
						}
					%>
				</select>				
				<select id="order" name="order">
					<option value="">정렬</option>
					<option value="판매량많은순" <%if(order.equals("판매량많은순")){%>selected<%}%>>판매량많은순</option>
					<option value="가격높은순" <%if(order.equals("가격높은순")){%>selected<%}%>>가격높은순</option>
					<option value="가격낮은순" <%if(order.equals("가격낮은순")){%>selected<%}%>>가격낮은순</option>
					<option value="할인율높은순" <%if(order.equals("할인율높은순")){%>selected<%}%>>할인율높은순</option>
				</select>
				<input type="text" id ="searchName" name="searchName" value="<%=searchName%>" placeholder="상품명을 입력해주세요.">
				<button type="submit" id="reset" class="style-btn">정렬초기화</button>
			</form>
			

<%-- 		<a href="<%=request.getContextPath()%>/emp/addProduct.jsp"><img src="<%=request.getContextPath() %>/images/plus.png"></a>	
 --%>		<div class="list-item marginTop30">
			<div>상품번호</div>
			<div>카테고리명</div>
			<div>상품명</div>
			<div>가격</div>
			<div>상품상태</div>
			<div>판매량</div>
			<div>할인율</div>
			<div>할인가격</div>
			<div>&nbsp;</div>
			<div>&nbsp;</div>
		</div>
	<%
		for(HashMap<String, Object> map : list) {
			Product product = (Product)map.get("product");
			double discountRate = (double)map.get("discountRate");
			int discountPrice = (int)map.get("discountPrice");	
	%>
		<div class="list-item">
			<div><%=product.getProductNo()%></div>
			<div><%=product.getCategoryName()%></div>
			<div><%=product.getProductName()%></div>
			<div><%=dc.format(product.getProductPrice())%></div>
			<div><%=product.getProductStatus()%></div>
			<div><%=product.getProductSaleCnt()%></div>
			<div>
			<%
				if(discountRate == 0){
			%>
				<div> - </div>
			<% 
				}else{
			%>
				<div><%=Math.round(discountRate * 100)%>%</div>
			<% 
				}
			%>
			</div>
			<div><%=dc.format(discountPrice)%></div>
			<div>
				<a class="style-btn" href="<%=request.getContextPath()%>/emp/modifyProduct.jsp?productNo=<%=product.getProductNo()%>">수정</a>
			</div>
			<div>
				<a class="style-btn" href="<%=request.getContextPath()%>/emp/removeProductAction.jsp?productNo=<%=product.getProductNo()%>">삭제</a>
			</div>
		</div>
	<%
		}
	%>
	</div>
	
<!-- 페이징 -->
	<div class="pagination flex-wrapper">
		<!-- 이전 -> 최소페이지가 1보다 클 경우 이전 활성화 -->
		<div class="flex-wrapper">
					<!-- 제일 처음으로  -->
					<a class="pageBtn" href="<%=request.getContextPath()%>/emp/productList.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=1">
						◀◀
					</a>
			<%
				if(minPageNum != 1){
			%>
					<!-- 10개 이전으로  -->
					<a class="pageBtn" href="<%=request.getContextPath()%>/emp/productList.jsp?currentPage=<%=minPageNum - pagePerNum%>&searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order<%=order%>" class="pageBtn">
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
					<a href="<%=request.getContextPath() %>/emp/productList.jsp?currentPage=<%=i%>&searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order<%=order%>" class="<%=selected %>">
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
					<a class="pageBtn" href="<%=request.getContextPath()%>/emp/productList.jsp?currentPage=<%=maxPageNum + 1%>&searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order<%=order%>">
					▷
					</a>
			<%
				}
			%>
					<!-- 제일 마지막으로  -->
					<a class="pageBtn" href="<%=request.getContextPath()%>/emp/productList.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=<%=lastPage%>">
					▶▶
					</a>
		</div>
	</div>
</div>
</body>
</html>