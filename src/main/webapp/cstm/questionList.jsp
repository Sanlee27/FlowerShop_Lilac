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

	//현재페이지
		int currentPage = 1;
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
	//페이지 메서드 가져오기
		QuestionDao totalRowDao = new QuestionDao();
		int totalRow = totalRowDao.selectQuestionCnt();
	
	//한 페이지에 담길 행의 개수 
			int rowPerPage = 3;
			int pagePerPage = 3;
			
	//시작행
		int beginRow = (currentPage-1)*rowPerPage +1;
	
	//마지막 행
		int endRow = beginRow + (rowPerPage-1); 
		
		if(endRow > totalRow){
			
			endRow = totalRow;
		}
	
	

	//마지막 페이지
		int lastPage = totalRow / rowPerPage;
		if(totalRow % rowPerPage != 0){
			lastPage = lastPage +1; //10으로 나누어 떨어지지 않는 나머지 게시글을 위한 1 페이지 생성
		}

	//페이지 목록 최초 게시물의 페이징
		int minPage = ((currentPage-1)/pagePerPage) * pagePerPage + 1;
	
	//페이지 목록 마지막 게시글의 페이징
		int maxPage = minPage +(pagePerPage -1);
		if(maxPage > lastPage){
			maxPage = lastPage;
		}
		
	//sql이 담긴 객체 생성
		QuestionDao questionDao = new QuestionDao();
	
	//현재 페이지에 표시 할 리스트 생성
		ArrayList<Question> list = questionDao.questionList(beginRow, rowPerPage);

		
		
%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
</head>
<body>
<div>
<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div class="container">
	
	<div class="list-wrapperql marginTop50">
		<h2>문의리스트</h2>
		<div class="list-item marginTop20">
			<div>문의번호</div>
			<!-- <div>id</div> -->
			<div>카테고리</div>
			<div>제목</div>
			<div>업로드일자</div>
			<div>답변여부</div>
		</div>
		<%
			for(Question m : list){
		%>
				<div class="list-item">
					<div><%=m.getqNo() %></div>
					<div><%=m.getqCategory() %></div>
					<div><%=m.getqTitle() %></div>
					<div><%=m.getCreatedate() %></div>
					<div><%=m.getqAnswer() %></div>
				</div>
		<%
			}
		%>
	</div>
</div>
<%-- <h1>questionList</h1>
	<table>
		<tr>
			<div>qNo</div>
			<!-- <div>id</div> -->
			<div>qCategory</div>
			<div>qAnswer</div>
			<div>qTitle</div>
			<div>createdate</div>

		</tr>
		<tr>
		<%
			for(Question m : list){
		%>
			<td>
				<a href="<%=request.getContextPath()%>/cstm/question.jsp?qNo=<%=m.getqNo() %>">
					
					<%=m.getqNo() %>
				</a>
			</td>
			<td>
				<a href="<%=request.getContextPath()%>/cstm/question.jsp?qNo=<%=m.getqCategory()%>">
					
					<%=m.getqCategory() %>
				</a>
			</td>
			<td>
				<a href="<%=request.getContextPath()%>/cstm/question.jsp?qNo=<%=m.getqAnswer()%>">
					
					<%=m.getqAnswer() %>
				</a>
			</td>
			<td>
				<a href="<%=request.getContextPath()%>/cstm/question.jsp?qNo=<%=m.getqTitle() %>">
					
					<%=m.getqTitle() %>
				</a>
			</td>
			<td>
				<a href="<%=request.getContextPath()%>/cstm/question.jsp?qNo=<%=m.getCreatedate() %>">
					
					<%=m.getCreatedate() %>
				</a>
			</td>
		</tr>
		<%
			}
		%>
		
	</table> --%>



	
		<div class="container text-center">
		<% 
		      if(minPage > 1) {
		%>
						   <a href="<%=request.getContextPath()%>/cstm/questionList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>   
		<%
						}
						
						for(int i = minPage; i<=maxPage; i=i+1) {
						   if(i == currentPage) {
		%>
						      <span><%=i%></span>&nbsp;
		<%         
						   } else {      
		%>
						      <a href="<%=request.getContextPath()%>/cstm/questionList.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;   
		<%   
						   }
						}
						
						if(maxPage != lastPage) {
		%>
						   <!--  maxPage + 1 -->
						   <a href="<%=request.getContextPath()%>/cstm/questionList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
		<%
					 	      }
	
		%>
		</div>				
	

</body>
</html>