<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Lilac</title>
	<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
	<!-- jQuery, home부분 js파일 -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="<%=request.getContextPath() %>/script/homeScript.js" type="text/javascript" defer></script>
	<!-- data-aos 라이브러리(fade up구현해주는 - 스크롤이벤트) -->
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
	<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
</head>
<body>
	<div>
		<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		
		<!-- 이미지 슬라이드 부분 -->
		<div class="image-slide">
			<ul class="images">
				<li class="main1">
					<img src="images/main1.jpg">
					<div class="comment">
						분위기 전환이 필요할때
						<br>
						<span>화사한 꽃병으로 거실을 더 환하게!</span>
					</div>
				</li>
				<li class="main2">
					<img src="images/main2.jpg">
					<div class="comment">
						선물이 필요할때
						<br>
						<span>화려한 꽃바구니로 마음을 전하세요!</span>
					</div>
				</li>
				<li class="main3">
					<img src="images/main3.jpg">
					<div class="comment">
						아주 특별한 날에도
						<br>
						<span>주문제작 부케로 특별하게!</span>
					</div>
				</li>
			</ul>
		</div>
		
		<!-- deco -->
		<div class="down-arrow">
				<img src="images/down-arrow.png">
		</div>
		
		<!-- 신상품 보여주는 부분 -->
		<div class="product-list" data-aos="fade-up" data-aos-duration="3000">
			<h2>신상품</h2>
			<div class="products">
				<div>
					<img src="product/basket1.jpg">
					<div class="divide-line"></div>
					<div class="content">
						화려한 꽃 바구니
						<br>
						<del>29,900</del>
						<br>
						<span class="price">19,900</span>
					</div>
				</div>
				<div>
					<img src="product/bouquet1.jpg">
					<div class="divide-line"></div>
					<div class="content">
						꽃다발 선물용
						<br>
						39,900
					</div>
				</div>
				<div>
					<img src="product/pot1.jpg">
					<div class="divide-line"></div>
					<div class="content">
						달리아 화분
						<br>
						19,900
					</div>
				</div>
				<div>
					<img src="product/pot2.jpg">
					<div class="divide-line"></div>
					<div class="content">
						튤립 화분
						<br>
						19,900
					</div>
				</div>
				<div>
					<img src="product/pot3.jpg">
					<div class="divide-line"></div>
					<div class="content">
						화려한 화분 선물용
						<br>
						25,900
					</div>
				</div>
				<div>
					<img src="product/pot4.jpg">
					<div class="divide-line"></div>
					<div class="content">
						감성 화분 선물용
						<br>
						35,900
					</div>
				</div>
				<div>
					<img src="product/pot5.jpg">
					<div class="divide-line"></div>
					<div class="content">
						백합 화분
						<br>
						19,900
					</div>
				</div>
				<div>
					<img src="product/wedding1.jpg">
					<div class="divide-line"></div>
					<div class="content">
						웨딩용 부케
						<br>
						59,900
					</div>
				</div>
			</div>
			
		</div>
	</div>
</body>
</html>