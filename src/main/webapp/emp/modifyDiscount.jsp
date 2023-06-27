<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 _ 로그인전이면 로그인폼으로 돌아가게
	if(!session.getAttribute("loginId").equals("admin1") && !session.getAttribute("loginId").equals("admin2")){ 
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;		
	}	
	
	// 클래스 객체
	DiscountDao dDao = new DiscountDao();
	ProductDao pDao = new ProductDao();
	CategoryDao cDao = new CategoryDao();
	
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
	int rowPerPage  = 10;
	if(request.getParameter("rowPerPage") != null) {
	      rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	
	// 총 행의 수
	int totalRow = 0; 
	int totalPdctRow = pDao.getProductCnt(searchCategory, searchName);
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
	ArrayList<HashMap<String, Object>> list = dDao.getAllProduct(searchCategory, searchName, order, startRow, rowPerPage);
	
	// 카테고리 리스트
	ArrayList<Category> cateList = cDao.selectCategoryList();
	
	//오늘 날짜
	Calendar cal = Calendar.getInstance();
	int y = cal.get(Calendar.YEAR);
	int m = cal.get(Calendar.MONTH)+1;
	int d = cal.get(Calendar.DAY_OF_MONTH);
	String today = y + "-" + m + "-" + d;
	// System.out.println(today);
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
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<script>
		$(document).ready(function() {
			// ============== 할인율 조정
			let rateBtns = $('input[name="discountRate"]');
			
			rateBtns.each(function() {
				let rateBtn = $(this);
				let preValue = rateBtn.val();
				
				// 값 변경시 기존값 공백
				rateBtn.focus(function() {
				    $(this).val('');
				});
			
				// 다입력했을때 공백일경우 기존값 복원, 0~99 or 숫자가 아닐시 경고
				rateBtn.blur(function() {
			    	let value = $(this).val();
			    	if (value === '') {
						$(this).val(preValue);
					} else if (value < 0 || value > 99 || !Number.isInteger(parseFloat(value))) {
						$(this).val(preValue);
						swal("경고", "0~99까지의 정수만 입력가능합니다.", "warning");
			    	}
				});
			});
			
			// =============== 날짜 조정
			let dcStarts = $('input[name="discountStart"]');
			let dcEnds = $('input[name="discountEnd"]');
			
			// start날짜가 end 이후일때
			dcStarts.each(function(index) {
			    let dcStart = $(this);
			    let dcEnd = $('#dcEnd' + (index + 1)); // count 값을 이용하여 고유한 ID 선택
			
			    let startValue = dcStart.val();
			    let endValue = dcEnd.val();
			
			    dcStart.on('input', function() {
			        startValue = dcStart.val(); // 입력된 값을 업데이트
			    });
			
			    dcStart.blur(function() {
			        let newValue = dcStart.val();
			
			        if (newValue === '') {
			            dcEnd.val(endValue); // dcStart가 비어있다면 dcEnd 값을 현재 값으로 갱신
			        } else if (endValue !== '' && newValue > endValue) {
			            dcStart.val(endValue); // dcStart 값이 dcEnd 값보다 크다면 이전 값으로 복원
			            swal("경고", "할인 시작일은 할인 종료일 이전으로 설정해야 합니다.", "warning");
			        }
			    });
			});
			
			// end날짜가 start보다 이전일때
			dcEnds.each(function(index) {
				let dcEnd = $(this);
		        let dcStart = $('#dcStart' + (index + 1)); // count 값을 이용하여 고유한 ID 선택
		      
		      
		        dcEnd.blur(function() {
			        let startValue = dcStart.val();
			        let endValue = dcEnd.val();
					let newValue = endValue
					
		            if (newValue === '') {
		                dcStart.val(startValue); // dcEnd가 비어있다면 dcStart 값을 이전 값으로 복원
		            } else if (newValue < startValue) {
		                dcEnd.val(startValue); // dcEnd 값이 dcStart 값보다 작다면 이전 값으로 복원
		                swal("경고", "할인 종료일은 할인 시작일 이후로 설정해야 합니다.", "warning");
		            }
				});
			});
			
			// ============== 정렬버튼
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
		    function submitForm() {
		        // 정렬된 데이터를 가지고 action 페이지로 이동하기
		        let form = document.getElementById("form");
		        form.action = "<%=request.getContextPath()%>/emp/modifyDiscountAction.jsp";
		        form.submit();
		      }
		    
		    $('#modify').click(function(){
		    	submitForm();
		    })
		});
			// form안에 input이 1개인 경우 엔터 누르면 바로 submit
			// 2개 이상인 경우는 submit X > 따로 이벤트함수 만들어야됨
			function handleSearch(event) {
			    if (event.keyCode === 13) { // 엔터 키를 눌렀을 때
			    	$('form').submit(); // 폼 제출 처리
			    }
			}
	</script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<div class="list-wrapper9">
			<h1>할인 변경</h1>
			<h3>오늘 날짜 : <%=today%></h3>
			<br>
			<!-- ==============리스트============= -->
			<form id="form" method="get">
				<div>
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
					
					<select name="order">
						<option value="">정렬</option>
						<option value="이름순">이름순</option>
						<option value="원가높은순">원가높은순</option>
						<option value="판매량낮은순">판매량낮은순</option>
						<option value="재고많은순">재고많은순</option>
					</select>
					
					<input type="text" name="searchName" placeholder="상품을 입력하세요" onkeydown="handleSearch(event)">
					
					<button type="button" id="resetSearch" class="style-btn">검색초기화</button>
					<button type="button" id="reset" class="style-btn">정렬초기화</button>
				</div>
				<div class="list-item">
					<div>상품 번호</div>
					<div>상품 이름</div>
					<div>상품 원가</div>
					<div>상태</div>
					<div>판매량</div>
					<div>재고량</div>
					<div>할인 시작</div>
					<div>할인 종료</div>
					<div>할인율</div>
				</div>
				<%
					int count = 0;
					for(HashMap<String, Object> l : list){
						Product product = (Product) l.get("product");
						Discount discount = (Discount) l.get("discount");
						count++;
				%>
						<div class="list-item">
							<div>
								<input type="hidden" name="productNo" value="<%=product.getProductNo()%>">
								<%=product.getProductNo()%>
							</div>
							<div><%=product.getProductName()%></div>
							<div><%=product.getProductPrice()%></div>
							<div><%=product.getProductStatus()%></div>
							<div><%=product.getProductSaleCnt()%></div>
							<div><%=product.getProductStock()%></div>
							<div>
								<input type="date" id="dcStart<%=count%>" name="discountStart" value="<%=discount.getDiscountStart()%>">
							</div>
							<div>
								<input type="date" id="dcEnd<%=count%>" name="discountEnd" value="<%=discount.getDiscountEnd()%>">
							</div>
							<div>
								<input type="number" min="0" max="99" name="discountRate" value="<%=Math.round(discount.getDiscountRate()*100)%>">
							</div>
						</div>
				<%
					}
				%>
				<br>
				<button type="button" id="modify" class="style-btn">수정하기</button>
			</form>
		</div>
		<!-- ===============페이지================ -->
		<div class="pagination flex-wrapper">
			<div class="flex-wrapper">
				<a class="pageBtn" href="<%=request.getContextPath()%>/emp/modifyDiscount.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=1">
					◀◀
				</a>
				<%
					// 10p 단위 이전 버튼
					if(minPage>1){
				%>
						<a class="pageBtn" href="<%=request.getContextPath()%>/emp/modifyDiscount.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=<%=minPage-pagePerPage%>">◁</a>
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
						<a href="<%=request.getContextPath()%>/emp/modifyDiscount.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=<%=i%>"><%=i%></a>
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
						<a class="pageBtn" href="<%=request.getContextPath()%>/emp/modifyDiscount.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=<%=minPage+pagePerPage%>">▷</a>	
				<%
					}
				%>
				<a class="pageBtn" href="<%=request.getContextPath()%>/emp/modifyDiscount.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&order=<%=order%>&currentPage=<%=lastPage%>">
					▶▶
				</a>
			</div>
		</div>
	</div>
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	<!-- footer -->
	<jsp:include page="/inc/footer.jsp"></jsp:include>
</body>
</html>