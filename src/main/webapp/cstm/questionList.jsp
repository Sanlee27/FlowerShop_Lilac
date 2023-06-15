<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>

<%

/*
문의게시판-> 전체 QuestionList를 띄운다
리스트 열람만 가능
*/
	
	//유효성검사 X
	
	//QuestionDao 객체 선언
	QuestionDao questionDao = new QuestionDao();
	

	//현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	// 페이징을 위한 변수 선언
	int totalRow = questionDao.selectQuestionCnt();
	int rowPerPage = 3;
	int beginRow = (currentPage - 1) * rowPerPage;
	int pagePerPage = 3;
	int startPage = (currentPage - 1) / pagePerPage * pagePerPage + 1;
	int endPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		endPage++;
	}
	int lastPage = startPage + pagePerPage;
	if(lastPage > endPage){
		lastPage = endPage;
	}

	
	
	//현재 페이지에 표시 할 리스트 생성
	ArrayList<Question> list = questionDao.questionList(beginRow, rowPerPage);

		
		
%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
	<!-- jQuery -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

	<script>
		$(document).ready(function() {
			$('.list-item').click(function() {
				let qNo = $(this).find('.qNo').text();
				window.location.href ="<%=request.getContextPath()%>/cstm/question.jsp?qNo=" + qNo;
			});
		});
	</script>

</head>
<body>

	<div>
	<!-- 메인메뉴 -->
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<div class="container">
		
		
		<div class="list-wrapperql marginTop50">
			<h2>문의리스트</h2>
			<div class="list-item marginTop20" id="test">
				<div>주문번호</div>
				<div>카테고리</div>
				<div>제목</div>
				<div>업로드일자</div>
				<div>답변여부</div>
			</div>
			<%
				for(Question m : list){
			%>
					<input type="hidden" name="qNo" value="<%=m.getqNo()%>">
					<div class="list-item hovered ">
						<div class="qNo"><%=m.getqNo() %></div>
						<div><%=m.getqCategory() %></div>
						<div><%=m.getqTitle() %></div>
						<div><%=m.getCreatedate().substring(0, 10) %></div>
						<!-- 리스트 출력 시 답변여부 상태를 Y: 답변완료, N:답변 대기로 표현 -->
						<div><%=m.getqAnswer().equals("Y") ? "답변 완료" : "답변 대기" %></div>
					</div>
			<%
				}
			%>
		</div>
	</div>

		<!-- 페이지네이션 -->
		<div class="pagination flex-wrapper">
				<div>
					<%
						if(startPage != 1){
					%>
							<a href="<%=request.getContextPath() %>/cstm/questionList.jsp?currentPage=<%=startPage - pagePerPage %>"  class="pageBtn">
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
							<a href="<%=request.getContextPath() %>/cstm/questionList.jsp?currentPage=<%=i %>" class="<%=selected %>">
								<%=i %>
							</a>
					<%
						}
					%>
				</div>
				<div>
					<%
						if(endPage != lastPage){
					%>
							<a href="<%=request.getContextPath() %>/cstm/questionList?currentPage=<%=endPage + 1 %>"  class="pageBtn">
								▶
							</a>
					<%
						}
					%>
				</div>
			</div>	
	

</body>
</html>