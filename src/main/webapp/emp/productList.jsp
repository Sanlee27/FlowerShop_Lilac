<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDao"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%@ page import = "java.text.*" %>
<%
	//dao
	ProductDao productdao = new ProductDao();

	// 변수
	String searchCategory = null;
	String searchName = null;
	String order = null;
	String categoryName = request.getParameter("categoryName");
	
	// 페이징 변수
	int currentPage = 1;
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
			System.out.println(currentPage + "<-currentPage");
	int rowPerPage = 1; //페이지당 행
	int startRow = (currentPage - 1) * rowPerPage; // 시작행
		
	int totalRow = productdao.getProductCnt(); // 전체행
	
	int lastPage = totalRow / rowPerPage; //마지막페이지
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
		System.out.println(rowPerPage);

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
</div>

<div class="container">
	<!-- 상품 리스트 -->
	<div class="list-wrapper9">
		<h2>상품 리스트</h2>
		<a href="<%=request.getContextPath()%>/emp/addProduct.jsp">✚</a>	
		<div class="list-item">
			<div>상품번호</div>
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
			<div><%=product.getProductName()%></div>
			<div><%=dc.format(product.getProductPrice())%></div>
			<div><%=product.getProductStatus()%></div>
			<div><%=product.getProductSaleCnt()%></div>
			<div><%=discountRate%></div>
			<div><%=dc.format(discountPrice)%></div>
			<div>
				<a href="<%=request.getContextPath()%>/emp/modifyProduct.jsp?productNo=<%=product.getProductNo()%>">수정</a>
			</div>
			<div>
				<a href="<%=request.getContextPath()%>/emp/removeProductAction.jsp?productNo=<%=product.getProductNo()%>">삭제</a>
			</div>
		</div>
	<%
		}
	%>
	</div>
	
<!-- 페이징 -->
<%
	int pagePerNum = 1;
	
	int minPageNum = ((currentPage - 1)/pagePerNum) + 1; // 1, 11, 21, 31, 
	int maxPageNum = ((minPageNum+pagePerNum) - 1) * pagePerNum; // 10, 20, 30,
	if(maxPageNum > lastPage) { // maxPageNum가 lastPage보다 클 경우 lastPage값으로 변경
		maxPageNum = lastPage;
	}
%>
	<div class="pagination flex-wrapper">
	<!-- 이전 -> 최소페이지가 1보다 클 경우 이전 활성화 -->
		<div>
			<%
				if(minPageNum != 1){
			%>
					<a href="<%=request.getContextPath()%>/emp/productList.jsp?currentPage=<%=minPageNum - pagePerNum%>" class="pageBtn">
						◀
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
					<a href="<%=request.getContextPath() %>/emp/productList.jsp?currentPage=<%=i %>" class="<%=selected %>">
						<%=i %>
					</a>
			<%
				}
			%>
		</div>
		<div>
			<%
				if(maxPageNum != lastPage){
			%>
					<a href="<%=request.getContextPath()%>/emp/productList.jsp?currentPage=<%=minPageNum + 1%>" class="pageBtn">
						▶
					</a>
			<%
				}
			%>
		</div>
	</div>
</div>
</body>
</html>