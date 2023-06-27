<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>

<%

// 문의게시판
	
	//QuestionDao 객체 선언
	QuestionDao questionDao = new QuestionDao();
	

	//현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	// 페이징을 위한 변수 선언
	//총 행의 수
	int totalRow = questionDao.selectQuestionCnt();
	
	//페이지 당 행의 개수
	int rowPerPage = 5;
	int beginRow = (currentPage - 1) * rowPerPage;
	
	//페이지에 올라가는 목록의 개수
	int pagePerPage = 5;
	
	//페이지 선택버튼
	int  minPage = (currentPage - 1) / pagePerPage * pagePerPage + 1;
	
	//마지막 페이지
	int maxPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		maxPage++;
	}
	
	//페이지 선택 버튼
	int lastPage = minPage + (pagePerPage-1);
	if(lastPage > maxPage){
		lastPage = maxPage;
	}

	
	
	//현재 페이지에 표시 할 리스트 생성
	ArrayList<HashMap<String, Object>> list = questionDao.questionList(beginRow, rowPerPage);


		
%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Lilac</title>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
	<!-- jQuery -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<!-- ajax -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script>
	$(document).ready(function(){
		if("<%=request.getParameter("msg")%>" != "null"){
			swal("성공", "<%=request.getParameter("msg")%>", "success");
		}
	});
	
	
		function listItemClick(qNo) {
	
			window.location.href ="<%=request.getContextPath()%>/cstm/question.jsp?qNo=" + qNo;
		};

	</script>

</head>
<body>

	<div>
	<!-- 메인메뉴 -->
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<div class="container">

		<div class="list-wrapperql marginTop50">
			<h2>문의게시판</h2>
			<div class="list-item marginTop20" id="test">
				<div>상품명</div>
				<div>카테고리</div>
				<div>제목</div>
				<div>업로드일자</div>
				<div>답변여부</div>
			</div>
			<%
				for(HashMap<String, Object> map: list){
					Question question = (Question)map.get("question");
					String productName = (String)map.get("productName");
			%>
					<div class="list-item hovered " onclick="listItemClick(<%=question.getqNo() %>)">
						
						<div><%=productName %></div>
						<div><%=question.getqCategory() %></div>
						<div><%=question.getqTitle() %></div>
						<div><%=question.getCreatedate().substring(0, 10) %></div>
						<!-- 리스트 출력 시 답변여부 상태를 Y: 답변완료, N:답변 대기로 표현 -->
						<div><%=question.getqAnswer().equals("Y") ? "답변 완료" : "답변 대기" %></div>
					</div>
			<%
				}
			%>
		</div>

		<!-- 페이지네이션 -->
		<div class="pagination flex-wrapper">
			<div class="flex-wrapper">
				<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/questionList.jsp?currentPage=1">◀◀</a>
				<%
					if(minPage != 1){
				%>
						<a href="<%=request.getContextPath() %>/cstm/questionList.jsp?currentPage=<%=minPage - pagePerPage %>"  class="pageBtn">◁</a>
				<%
					}
				%>
			</div>
			<div class="page">
				<%
					for(int i = minPage; i <= maxPage; i++){
						String selected = i == currentPage ? "selected" : "";
				%>
						<a href="<%=request.getContextPath() %>/cstm/questionList.jsp?currentPage=<%=i %>" class="<%=selected %>">
							<%=i %>
						</a>
				<%
					}
				%>
			</div>
			<div class="flex-wrapper">
				<%
					if(maxPage != lastPage){
				%>
						<a href="<%=request.getContextPath() %>/cstm/questionList?currentPage=<%=maxPage + 1 %>"  class="pageBtn">▷</a>
				<%
					}
				%>
				<a class="pageBtn" href="<%=request.getContextPath()%>/cstm/reviewList.jsp?currentPage=<%=lastPage%>">▶▶</a>
			</div>
		</div>
	
	
	</div>
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	<!-- footer -->
	<jsp:include page="/inc/footer.jsp"></jsp:include>
</body>
</html>