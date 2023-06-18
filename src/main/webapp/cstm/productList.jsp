<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	//클래스 객체 생성
	ProductDao dao = new ProductDao();

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
	int totalPdctRow = dao.getProductCnt();
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
	
	
	// ==================================================
	
	String searchCategory = "";
	String searchName = "";
	String order = "";
	
	// 전체 상품리스트
	ArrayList<HashMap<String, Object>> list = dao.getAllProductList(searchCategory, searchName, order, startRow, rowPerPage);
	
	
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
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<table>
			<tr>
				<th>상품 번호</th>
				<th>상품 이름</th>
				<th>상품 가격</th>
				<th>할인율</th>
				<th>할인가</th>
				<th>상태 <a href="<%=request.getContextPath()%>/cstm/logoutAction.jsp">로그아웃</a> </th>
			</tr>
			<%
				for(HashMap<String, Object> o : list){
					Product product = (Product)o.get("product");
					ProductImg pi = (ProductImg)o.get("productImg");
					double discountRate = (double)o.get("discountRate");
					int discountPrice = (int)o.get("discountPrice"); 
					String path = request.getContextPath() + "/product/" + pi.getProductSaveFilename();
			%>		
					<%
						if(product.getProductStatus().equals("품절")){
					%>
							<tr>
								<td><del><%=product.getProductNo()%></del></td>
								<td>
									<del>
										<img src="<%=path%>" width="100px">
										<%=product.getProductName()%>
									</del>
								</td>
								<td>
									<del><fmt:formatNumber value="<%=product.getProductPrice()%>" pattern="#,###"/></del>
								</td>
								<%
									if(Math.round(discountRate*100) == 0){
										
								%>
										<td>-</td>
										<td>-</td>
								<%
									} else {
								%>
										<td><del><%=Math.round(discountRate*100)%>%</del></td>
										<td style="font-weight: bold;"><del><%=discountPrice%></del></td>
								<%
									}
								%>			
								<td><del><%=product.getProductStatus()%></del></td>
							</tr>
					<%
						} else {
					%>		
					
							<tr>
								<td><%=product.getProductNo()%></td>
								<td>
									<img src="<%=path%>" width="100px">
									<%=product.getProductName()%>
								</td>
								<td>
									<fmt:formatNumber value="<%=product.getProductPrice()%>" pattern="#,###"/>
								</td>
								<%
									if(Math.round(discountRate*100) == 0){
										
								%>
										<td>-</td>
										<td>-</td>
								<%
									} else {
								%>
										<td><%=Math.round(discountRate*100)%>%</td>
										<td style="font-weight: bold;"><%=discountPrice%></td>
								<%
									}
								%>			
								<td><%=product.getProductStatus()%></td>
							</tr>
					<%
						}
				}
			%>
		</table>
		
		</div>
		<!-- ================ 페이지 ================ -->
		<div class="container text-center">
			<a href="<%=request.getContextPath()%>/cstm/productList.jsp?currentPage=1">처음으로</a>
			<%
				// 10p 단위 이전 버튼
				if(minPage>1){
			%>
					<a href="<%=request.getContextPath()%>/cstm/productList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>
			<%
				}
			
				for(int i=minPage; i<=maxPage; i=i+1){
					if(i == currentPage){
					%>
						<span><%=i%></span>
					<%	
					} else {
					%>
						<a href="<%=request.getContextPath()%>/cstm/productList.jsp?currentPage=<%=i%>"><%=i%></a>
					<%	
					}
				}
				// 10p단위 다음버튼
				if(maxPage != lastPage){
			%>	
					<a href="<%=request.getContextPath()%>/cstm/productList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>	
			<%
				}
			%>
			<a href="<%=request.getContextPath()%>/cstm/productList.jsp?currentPage=<%=lastPage%>">마지막으로</a>
		</div>
</body>
</html>