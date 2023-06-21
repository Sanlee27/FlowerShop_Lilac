<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>

<% 
//포토후기 입력 페이지

	/*
	//유효성 검사
	if(request.getParameter("orderNo") == null  
		|| request.getParameter("orderNo").equals("")) {
		// home.jsp으로
		response.sendRedirect(request.getContextPath() + "./home.jsp");
		return;
	}
	*/

	//요청값 변수에 저장
	//int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int orderNo = 3;

	//▼▼▼장바구니모달▼▼▼
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
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
	<!-- ajax -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
	<div>
	<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<h1>후기 작성</h1>
			<form action="<%=request.getContextPath()%>/cstm/addReviewAction.jsp" method="post" enctype="multipart/form-data">
				<input type="hidden" name="orderNo" value=<%=orderNo%>>
				<table>
				<!-- orderNo -->
					<tr>
						<td>orderNo</td>
						<td><%=orderNo%></td> 
						<!-- 
						reviweone 메서드의 해시맵 키"review"로부터 orderNo 값을 출력
						 -->
					</tr>
					
				<!-- 로그인 사용자 id -->
				<%
					/// String memeberId = (String)session.getAttribute("loginMemberId");
					String id = "user5";
				%>
				
				
				<tr>
					<td>id</td>
					<td>
						<input type="text" name="memberId" 
							value="<%= id %>" readonly="readonly">
					</td>
				</tr>
					
				<!-- reviewTitle -->
					<tr>
						<td>제목</td>
						<td>
							
							<input type="text" name="reviewTitle" onclick="if(this.value=='타이틀을 입력하세요'){this.value=''}" value="타이틀을 입력하세요"> <!-- text를 클릭하면 value 값 지워짐 -->
						</td>
					</tr>
				<!-- reviewContent -->
					<tr>
						<td>내용</td>
						<td>
							<textarea rows="3" cols="50" name="reviewContent" required="required" > </textarea>
						</td>
					</tr>
	
				<!-- fileUpload -->
					<tr>
						<td>파일 업로드</td>
						<td><input type="file" name="reviewImg"></td>
					</tr>
	
				
					
				</table>
					<button type= "submit">
						작성		
					</button>
		</form>
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
	
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	
</body>
</html>