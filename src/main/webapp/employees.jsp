<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 요청값 저장
	int currentPage = 1;
	if(request.getParameter("currentPage") != null
	&& !request.getParameter("currentPage").equals("")){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// QuestionDao객체선언
	QuestionDao questionDao = new QuestionDao();
	
	// 페이징을 위한 변수 선언
	int totalRow = questionDao.selectNoAnswerCnt();
	int rowPerPage = 5;
	int beginRow = (currentPage - 1) * rowPerPage;
	
	// 미답변한 Q&A리스트 가져오기
	ArrayList<Question> qnaList = questionDao.selectQuestionByPage(beginRow, rowPerPage);
	
	// OrderDao객체선언
	OrderDao orderDao = new OrderDao();

	// 일주일치 판매량 가져오기
	ArrayList<HashMap<String, Object>> weekOrders = orderDao.getWeekSaleCnt();

	// js파일에 보내줄 date리스트, cnt리스트를 저장해줄 ArrayList생성
	ArrayList<String> date = new ArrayList<>();
	ArrayList<Integer> orderCnt = new ArrayList<>();
	
	for(HashMap<String, Object> map : weekOrders){
		date.add((String)map.get("orderdate"));
		orderCnt.add((Integer)map.get("cnt"));
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Lilac</title>
	<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
	<!-- employees부분 js파일 -->
	<script src="<%=request.getContextPath() %>/script/empScript.js" type="text/javascript" defer></script>
	<!-- chart.js 라이브러리(통계 그래프 보여주는) -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
</head>
<body>
	
	<div>
		<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		<div class="container flex-wrapper">
			<canvas id="orderChart" width="600"></canvas>
			<canvas id="cstmGenderChart" width="300"></canvas>
			<canvas id="cstmAgesChart" width="300"></canvas>
			
			
			<div class="list-wrapper6 marginTop50">
				<h2>미답변 문의리스트</h2>
				<br>
				<div class="list-item">
					<div>문의번호</div>
					<div>상품번호</div>
					<div>고객아이디</div>
					<div>문의제목</div>
					<div>업로드일자</div>
					<div>&nbsp;</div>
				</div>
				<% 
					for(Question q : qnaList){
				%>
					<div class="list-item">
						<div><%=q.getqNo() %></div>
						<div><%=q.getProductNo() %></div>
						<div><%=q.getId() %></div>
						<div><%=q.getqTitle() %></div>
						<div><%=q.getCreatedate().substring(0, 10) %></div>
						<div>
							<a href="<%=request.getContextPath() %>/cstm/question.jsp?qNo=<%=q.getqNo()%>">
								답변등록
							</a>
						</div>
					</div>
				<%
					}
				%>
			</div>
		</div>
	</div>
</body>
</html>