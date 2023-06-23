<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.tomcat.util.http.fileupload.FileUtils"%>
<%	
	//유효성검사
	if(request.getParameter("productNo") == null
		||request.getParameter("productNo").equals("")) {
		
		response.sendRedirect(request.getContextPath() + "/emp/productList.jsp");
		System.out.println("productNo 값 필요");
		return;
	}
	
	//DAO 불러오기
	CategoryDao categorydao = new CategoryDao();
	ProductDao productdao = new ProductDao();
	
	//변수
	int productNo = Integer.parseInt(request.getParameter("productNo"));
		System.out.println(productNo + "<-productNo");
	
	
	//category 값 불러오기
	ArrayList<Category> categoryList = categorydao.selectCategoryList();
	
	//product 값 불러오기 
	HashMap<String, Object> map = productdao.getProductDetail(productNo);
	Product product = (Product)map.get("product");
	ProductImg productImg = (ProductImg)map.get("productImg");
	
	//path 변수
	String path = request.getContextPath() + "/product/" + productImg.getProductSaveFilename() + "." + productImg.getProductFiletype();
		System.out.println(path + "<-path");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Lilac</title>
	<!-- css파일 -->
	<link href="<%=request.getContextPath()%>/style.css" type="text/css" rel="stylesheet">
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath()%>/images/favicon.png"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script>
	// 이미지 미리보기 함수
    function previewImage(event) {
		// FileReader 객체 생성
    	var reader = new FileReader();

		// 파일 읽기가 완료되었을 때의 동작 정의
		reader.onload = function () {
			
		// 미리보기 영역의 img 태그를 찾아서 src 속성 설정
        var output = document.getElementById('preview');
		
        output.src = reader.result;
      };

		// 선택한 파일을 읽기
      reader.readAsDataURL(event.target.files[0]);
	};
	//경고창
	$(document).ready(function(){
		
		if("<%=request.getParameter("msg")%>" != "null") {
			swal("경고", "<%=request.getParameter("msg")%>", "warning");
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
	<!-- 상품 수정폼 -->
	<h1>상품 수정</h1>
	<div class="font-line"></div>
		<form action = "<%=request.getContextPath()%>/emp/modifyProductAction.jsp" method="post" encType="multipart/form-data">
			<div class="form-list">
				<div>
					<div> 상품 번호 </div>
					<div><input type="number" name = "productNo" value = "<%=productNo%>"></div>
				</div>
				<div>
					<div> 상품 카테고리 </div>
					<div>
						<select name="categoryName">
						<%
							for(Category c : categoryList) {
								String categoryName = c.getCategoryName();
								String selected = categoryName.equals(product.getCategoryName())  ? "selected" : "";
						%>
							<option <%=selected%>><%=categoryName%></option>
						<%
							}
						%>
						</select>
					</div>
				</div>
				<div>
					<div>상품명</div>
					<div>
						<input type="text" name = "productName" value = "<%=product.getProductName()%>">
					</div>
				</div>
				<div>
					<div>상품 설명</div>
					<div>
						<textarea rows="3" cols="100" name = "productInfo"><%=product.getProductInfo()%></textarea>
					</div>
				</div>
				<div>
					<div>상품 가격</div>
					<div>
						<input type="number" name = "productPrice" value="<%=product.getProductPrice()%>">
					</div>
				</div>
				<div>
					<div>상품 상태</div>
					<div>
						<select name="productStatus">
						<%
								String productStatus = product.getProductStatus();
						%>
							<option <%if(productStatus.equals("판매중")){ %> selected <% } %>>판매중</option>
							<option <%if(productStatus.equals("품절")){ %> selected <% } %>>품절</option>
						</select>
					</div>
				</div>
				<div>
					<div>재고량</div>
					<div>
						<input type="number" name = "productStock" value="<%=product.getProductStock()%>">
					</div>
				</div> 
				
				<div>
					<div>상품 이미지</div>
					<div>
						<img src="<%=path%>" id="preview" width="300px">
						<input type="hidden" name = "preProductImg" value="<%=productImg.getProductSaveFilename()%>">
						<input type="file" name = "productImg" onchange="previewImage(event)">
					</div>
				</div> 
				<br>
					<button type="submit" class="style-btn">수정</button>
					<button type="submit" class="style-btn" formaction="<%=request.getContextPath()%>/emp/productList.jsp">이전</button>
			</div>
		</form>
</div>
<!-- footer -->
<jsp:include page="/inc/footer.jsp"></jsp:include>
</body>
</html>