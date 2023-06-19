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
	
	// 전체 row수
	int totalRow = 0; 
	int totalPdctRow = dao.getProductCnt();
	totalRow = totalPdctRow;
	
	// 상품정보 메소드
	ArrayList<HashMap<String, Object>> list = dDao.getAllProduct();
	
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
			
			let dcRate = $('input[name="dcRate"]');
			let pattern = /^[0-9]+$/; 
			dcRate.blur(function(){
				if(!pattern.test(dcRate.val()) || dcRate.val().length<3){
					swal("경고", "할인율은 1 ~ 99까지 설정가능합니다..", "warning");
					dcRate.val('');
				}
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
		<h1>할인 관리</h1> <h3>오늘 날짜 : <%=today%></h3>
		<div>
			<button type="button" id="delCk" onclick="removeChecked()">개별삭제</button>
			<button type="button" onclick="location.href='<%=request.getContextPath()%>/emp/removePassedDiscountAction.jsp'">할인 종료 제품 일괄삭제</button>
		</div>
		<table>
			<tr>
				<th>상품 번호</th>
				<th>상품 이름</th>
				<th>상품 원가</th>
				<th>상태</th>
				<th>판매량</th>
				<th>할인 시작 ~ </th>
				<th>할인 종료</th>
				<th>할인율</th>
				<th>선택<input type="checkbox" name="ckAll"></th>
			</tr>
			<%
				for(HashMap<String, Object> dc : list){
					Product product = (Product)dc.get("product");
					Discount discount = (Discount)dc.get("discount");
			%>		
					<tr>
						<td>
							<input type="hidden" name="productNo" value="<%=product.getProductNo()%>">
							<%=product.getProductNo()%>
						</td>
						<td>
							<%=product.getProductName()%>
						</td>
						<td>
							<fmt:formatNumber value="<%=product.getProductPrice()%>" pattern="#,###"/>
						</td>
						<td><%=product.getProductStatus()%></td>
						<td><%=product.getProductSaleCnt()%></td>
						<td><%=discount.getDiscountStart()%> ~ </td>
						<td><%=discount.getDiscountEnd()%></td>
						<%
							if(discount.getDiscountRate() == 0){
						%>
								<td>
									<input type="text" name="dcRate" value="-">
								</td>
						<%
							} else {
						%>
								<td>
									<input type="text" name="dcRate" value="<%=Math.round(discount.getDiscountRate()*100)%>">%
								</td>
						<%
							}
						%>
						<td>
							<input type="checkbox" name="ck">
						</td>
					</tr>
			<%
				}
			%>
		</table>
	</div>
</body>
</html>