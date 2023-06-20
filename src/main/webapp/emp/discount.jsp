<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	// System.out.println(session.getAttribute("loginId"));
	
	// 클래스 객체
	ProductDao dao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	
	String searchCategory = "";
	if(request.getParameter("searchCategory") != null) {
		searchCategory = request.getParameter("searchCategory");
	}
	String searchName = "";
	if(request.getParameter("searchName") != null) {
		searchName = request.getParameter("searchName");
	}
	
	//================== 페이지 ===================
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 페이지 당 행 개수
	int rowPerPage  = 20;
	if(request.getParameter("rowPerPage") != null) {
	      rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	
	// 총 행의 수
	int totalRow = 0; 
	int totalPdctRow = dDao.getDcProductCnt();
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
		
	// 상품정보 메소드
	ArrayList<HashMap<String, Object>> list = dDao.getAllDcProduct(startRow, rowPerPage);
	ArrayList<HashMap<String, Object>> dcList = dDao.getAllDcProduct(startRow, rowPerPage);
	
	// 오늘 날짜
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
			// 전체 선택 체크박스
			$("input[name=ckAll]").click(function() {
				if($("input[name=ckAll]").is(":checked")){
					$("input[name=ck]").prop("checked", true);
				} else {
					$("input[name=ck]").prop("checked", false);
				}
			});
			// 개별 선택 체크박스 전부 선택시 전체 선택 체크
			$("input[name=ck]").click(function() {
				var total = $("input[name=ck]").length;
				var checked = $("input[name=ck]:checked").length;
				
				if(total != checked){
					$("input[name=ckAll]").prop("checked", false);
				} else {
					$("input[name=ckAll]").prop("checked", true); 
				}
			});
			
			// 상품 삭제 함수
			function removeDiscount() {
		        var checkedDiscounts = [];

		        $("input[name=ck]:checked").each(function() {
		        	checkedDiscounts.push($(this).closest(".list-item").find("input[name=productNo]").val());
		        });

		        if (checkedDiscounts.length > 0) {
		            var confirmation = confirm("선택한 상품을 삭제하시겠습니까?");
		            if (confirmation) {
		            	// 선택된것들 action으로 넘김
		            	location.href = "<%=request.getContextPath()%>/emp/removeDiscountAction.jsp?productNos=" + checkedDiscounts.join(",");
		            }
		        } else {
		            swal("경고", "삭제할 상품을 선택해주세요.", "warning");
		        }
		    }
			
			// 삭제 함수 실행
			$('#removeCk').click(function(){
				removeDiscount();
			});
			
			if("<%=request.getParameter("msg")%>" != "null"){
		 		swal("완료", "<%=request.getParameter("msg")%>", "success");
		 	}
		});
	</script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<div class="list-wrapper10">
			<h1>할인 관리</h1>
			<h3>오늘 날짜 : <%=today%></h3>
			<div>
				<button type="button" id="removeCk">개별삭제</button>
				<button type="button" onclick="location.href='<%=request.getContextPath()%>/emp/removePassedDiscountAction.jsp'">할인 종료 상품 일괄삭제</button>
				<button type="button" onclick="location.href='<%=request.getContextPath()%>/emp/modifyDiscount.jsp'">할인 수정</button>
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
					<div>
						삭제<input type="checkbox" name="ckAll">
					</div>
				</div>
				<%
					for(HashMap<String, Object> dc : dcList){
						Product product = (Product)dc.get("product");
						Discount discount = (Discount)dc.get("discount");
				%>		
						<div class="list-item">
							<div>
								<input type="hidden" name="productNo" value="<%=product.getProductNo()%>">
								<%=product.getProductNo()%>
							</div>
							<div>
								<%=product.getProductName()%>
							</div>
							<div>
								<fmt:formatNumber value="<%=product.getProductPrice()%>" pattern="###,###,###"/>
							</div>
							<div><%=product.getProductStatus()%></div>
							<div><%=product.getProductSaleCnt()%></div>
							<div><%=product.getProductStock()%></div>
							<div><%=discount.getDiscountStart()%></div>
							<div><%=discount.getDiscountEnd()%></div>
							<div><%=Math.round(discount.getDiscountRate()*100)%>%</div>
							<div>
								<input type="checkbox" name="ck">
							</div>
						</div>
				<%
					}
				%>
			<!-- ================ 페이지 ================ -->
			<div>
				<a href="<%=request.getContextPath()%>/emp/discount.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&currentPage=1">처음으로</a>
				<%
					// 10p 단위 이전 버튼
					if(minPage>1){
				%>
						<a href="<%=request.getContextPath()%>/emp/discount.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&currentPage=<%=minPage-pagePerPage%>">이전</a>
				<%
					}
				
					for(int i=minPage; i<=maxPage; i=i+1){
						if(i == currentPage){
						%>
							<span><%=i%></span>
						<%	
						} else {
						%>
							<a href="<%=request.getContextPath()%>/emp/discount.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&currentPage=<%=i%>"><%=i%></a>
						<%	
						}
					}
					// 10p단위 다음버튼
					if(maxPage != lastPage){
				%>	
						<a href="<%=request.getContextPath()%>/emp/discount.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&currentPage=<%=minPage+pagePerPage%>">다음</a>	
				<%
					}
				%>
				<a href="<%=request.getContextPath()%>/emp/discount.jsp?searchCategory=<%=searchCategory%>&searchName=<%=searchName%>&currentPage=<%=lastPage%>">마지막으로</a>
			</div>
		</div>
	</div>
</body>
</html>