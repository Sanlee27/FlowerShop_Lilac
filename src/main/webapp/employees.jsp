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
	System.out.println(date.get(0));
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Lilac</title>
	<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
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
	<script type="text/javascript">
		const orderCntList = <%=orderCnt%>;
		
		const day = new Date();
		const sunday = day.getTime() - 86400000 * (day.getDay()+1);
		day.setTime(sunday);
		const lastWeekDate = [day.toISOString().slice(0, 10)];
		for(let i = 1; i < 7; i++){
			day.setTime(day.getTime() + 86400000);
			lastWeekDate.push(day.toISOString().slice(0, 10));
		}
		let lastWeekOrderCnt = [0, 0, 0, 0, 0, 0, 0];
		let nowIdx = 0;
		
		<%
			for(int i = 0; i < date.size(); i++){
				String nowDate = date.get(i);
				
		%>
			nowIdx = lastWeekDate.indexOf("<%=nowDate%>");
			console.log(nowIdx);
			if(nowIdx != -1){
				lastWeekOrderCnt[nowIdx] = orderCntList[<%=i%>];
			}
		<%
			}
		%>
		console.log(lastWeekOrderCnt);
	
		const ctx1 = document.getElementById('orderChart').getContext('2d');
		 new Chart(ctx1, {
		    type: 'bar',
		    data: {
		      labels: lastWeekDate,
		      datasets: [{
		        label: 'Daily Sales Count',
		        data: lastWeekOrderCnt,
		        borderWidth: 2,
		        backgroundColor: ['#817EE4'],
		        borderColor: ['rgb(200, 200, 200)']
		      }],
		    },
		   	options: {
			responsive: false,
		      scales: {
		        y: {
		          beginAtZero: true
		        }
		      }
		    }
		 });
	
		const ctx2 = document.getElementById('cstmGenderChart').getContext('2d');
		new Chart(ctx2, {
		    type: 'doughnut',
		    data: {
			  labels: [
				'Male',
			    'Female'
			  ],
			  datasets: [{
			    label: 'Gender Count',
			    data: [5,7],
			    backgroundColor: [
			      '#B2CCFF',
			      '#FFB2D9'
			    ],
			    hoverOffset: 4
			  }]
			},
		   	options: {
				responsive: false,
		    }
		 });
		 
		const ctx3 = document.getElementById('cstmAgesChart').getContext('2d');
		new Chart(ctx3, {
		    type: 'doughnut',
		    data: {
			  labels: [
			    '10\'s',
			    '20\'s',
			    '30\'s',
			    '40\'s',
			    '50\'s',
			    '60\'s',
			  ],
			  datasets: [{
			    label: 'Age\'s Count',
			    data: [10, 50, 40, 60, 20, 10],
			    backgroundColor: [
			      '#FFA7A7',
			      '#FFC19E',
			      '#FFE08C',
			      '#B7F0B1',
			      '#B2CCFF',
			      '#D1B2FF'    
			    ],
			    hoverOffset: 4
			  }]
			},
		   	options: {
				responsive: false,
		    }
		 });
	</script>
</body>
</html>