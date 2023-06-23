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
	int rowPerPage = 10;
	int beginRow = (currentPage - 1) * rowPerPage;
	int pagePerPage = 10;
	int startPage = (currentPage - 1) / pagePerPage * pagePerPage + 1;
	int endPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		endPage++;
	}
	int lastPage = startPage + pagePerPage - 1;
	if(lastPage > endPage){
		lastPage = endPage;
	}
	
	// 미답변한 Q&A리스트 가져오기
	ArrayList<Question> qnaList = questionDao.selectQuestionByPage(beginRow, rowPerPage);
	
	// OrderDao객체선언
	OrderDao orderDao = new OrderDao();

	// 일주일치 판매량 가져오기
	ArrayList<HashMap<String, Object>> weekOrders = orderDao.getWeekSaleCnt();

	// js파일에 보내줄 date리스트, cnt리스트를 저장해줄 ArrayList생성
	ArrayList<String> date = new ArrayList<>();
	ArrayList<Integer> orderCnt = new ArrayList<>();
	
	// 각각 리스트에 불러온 값 저장
	for(HashMap<String, Object> map : weekOrders){
		date.add((String)map.get("orderdate"));
		orderCnt.add((Integer)map.get("cnt"));
	}
	
	// CustomerDao객체선언
	CustomerDao customerDao = new CustomerDao();
	
	// 성별별 통계 데이터 가져오기
	HashMap<String, Object> gender = customerDao.genStats();
	
	// 연령별 통계 데이터 가져오기
	HashMap<String, Object> ages = customerDao.ageStats();
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
	<!-- 날짜 데이터 가져오는 라이브러리 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.10.7/dayjs.min.js"></script>
	<!-- ajax -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
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
							<a href="<%=request.getContextPath() %>/cstm/question.jsp?qNo=<%=q.getqNo()%>" class="style-btn">
								답변등록
							</a>
						</div>
					</div>
				<%
					}
				%>
			</div>
			
			<div class="pagination flex-wrapper">
				<div class="flex-wrapper">
					<a href="<%=request.getContextPath() %>/employees.jsp?currentPage=1"  class="pageBtn">
						◀◀
					</a>
					<%
						if(startPage != 1){
					%>
							<a href="<%=request.getContextPath() %>/employees.jsp?currentPage=<%=startPage - pagePerPage %>"  class="pageBtn">
								◀
							</a>
					<%
						}
					%>
				</div>
				<div class="page">
					<%
						for(int i = startPage; i <= endPage; i++){
							String selected = i == currentPage ? "selected" : "";
					%>
							<a href="<%=request.getContextPath() %>/employees.jsp?currentPage=<%=i %>" class="<%=selected %>">
								<%=i %>
							</a>
					<%
						}
					%>
				</div>
				<div class="flex-wrapper">
					<%
						if(endPage != lastPage){
					%>
							<a href="<%=request.getContextPath() %>/employees.jsp?currentPage=<%=endPage + 1 %>"  class="pageBtn">
								▶
							</a>
					<%
						}
					%>
					<a href="<%=request.getContextPath() %>/employees.jsp?currentPage=<%=lastPage %>"  class="pageBtn">
						▶▶
					</a>
				</div>
			</div>
		</div>
	</div>
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	<script type="text/javascript">
		const orderCntList = <%=orderCnt%>;
		
		const day = dayjs();
		let startDate = day.subtract(6, "day");
		const lastWeekDate = [startDate.format("YYYY-MM-DD")];
		for(let i = 1; i < 7; i++){
			lastWeekDate.push(startDate.add(i, "day").format("YYYY-MM-DD"));
		}
		let lastWeekOrderCnt = [0, 0, 0, 0, 0, 0, 0];
		let nowIdx = 0;
		
		<%
			for(int i = 0; i < date.size(); i++){
				String nowDate = date.get(i);
				
		%>
			nowIdx = lastWeekDate.indexOf("<%=nowDate%>");
			if(nowIdx != -1){
				lastWeekOrderCnt[nowIdx] = orderCntList[<%=i%>];
			}
		<%
			}
		%>
	
		 new Chart($("#orderChart"), {
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
	
		new Chart($('#cstmGenderChart'), {
		    type: 'doughnut',
		    data: {
			  labels: [
				'Male',
			    'Female'
			  ],
			  datasets: [{
			    label: 'Gender Count',
			    data: [<%=(Integer)gender.get("남")%>,<%=(Integer)gender.get("여")%>],
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
		 
		new Chart($('#cstmAgesChart'), {
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
			    data: [
			    	<%=ages.get("10대")%>,
			    	<%=ages.get("20대")%>,
			    	<%=ages.get("30대")%>,
			    	<%=ages.get("40대")%>,
			    	<%=ages.get("50대")%>,
			    	<%=ages.get("60대")%>
			    ],
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
	<!-- footer -->
	<jsp:include page="/inc/footer.jsp"></jsp:include>
</body>
</html>