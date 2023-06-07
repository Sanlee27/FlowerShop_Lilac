<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Lilac</title>
	<link href="style.css" type="text/css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="script.js" type="text/javascript" defer></script>
	<!-- data-aos 라이브러리 -->
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
	<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
	<link rel="icon" href="images/favicon.png"/>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		<div class="image-slide">
			<ul class="images">
				<li>
					<img src="images/basket.jpg">
					<div class="comment">꽃바구니 19,900원 부터</div>
				</li>
				<li>
					<img src="images/pot.jpg">
					<div class="comment">화분종류 9,900원 부터</div>
				</li>
				<li>
					<img src="images/bouquet.jpg">
					<div class="comment">부케 주문제작 가능</div>
				</li>
			</ul>
		</div>
		
		<div class="down-arrow">
			<img src="images/down-arrow.png">
		</div>
		
		<div class="new-product" data-aos="fade-up" data-aos-duration="3000">
			<h1>신상품</h1>
			<div class="products">
				<div>
					<img src="product/basket1.jpg">
					<div class="divide-line"></div>
					<div class="content">
						화려한 꽃 바구니
						<br>
						29,900
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