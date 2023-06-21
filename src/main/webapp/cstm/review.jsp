<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>


<%
//후기 상세 페이지


	//요청값 변수에 저장

	//세션 유효성 검사
	if(session.getAttribute("loginId")==null){
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;
	}

	//요청값 유효성 검사-> id
	if(request.getParameter("orderNo") == null
		|| request.getParameter("orderNo").equals("")){
		//home.jsp로
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//요청값 변수에 저장
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	System.out.println(orderNo + "<- orderNo");
	String loginId = (String)session.getAttribute("loginId");
	System.out.println(loginId+ "<--loginId");
	boolean isAdmin = loginId.equals("admin1") || loginId.equals("admin2") ? true : false;

	
	
	//sql이 담긴 클래스 객체 생성
	
	ReviewDao oneDao = new ReviewDao();
	HashMap<String, Object> map = oneDao.reviewOne(orderNo);
	
	//상세보기 이미지를 위한 객체 생성
	Review review = (Review) map.get("review");
	ReviewImg reviewImg = (ReviewImg)map.get("reviewImg");
	
	//디버깅
	System.out.println(map);
	
	//path 경로 설정
	String path = "";
	
	if (reviewImg != null) {
		path = request.getContextPath() + "/review/" + reviewImg.getReviewSaveFilename();
	}
	
	//String path = request.getContextPath()+  "/review/" + reviewImg.getReviewSaveFilename();
	
	//디버깅
	System.out.println(path);
	


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
	<script>
	$(document).ready(function() {
	    $('#modifyButton').click(function() {
	        var comment = $(this).attr('data-text');
	        $('#answer textarea').prop('disabled', function(_, value) {
	            return !value;
	        });
	        
	        $('#answerForm').attr('action', '<%=request.getContextPath()%>/cstm/modifyQuestionAction.jsp?orderNo=' + orderNo);
	        $('#modifyEnd').show();
	        $(this).hide();
	        $("#deletebtn").hide();
	    });
	    
		if("<%=request.getParameter("msg")%>" != "null"){
			swal("완료", "<%=request.getParameter("msg")%>", "success");
		};
	});
	
	
	</script>
<body>
	<div>
	<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<div class="container">
	
		<h1>후기 상세</h1>
			<form action="<%=request.getContextPath()%>/cstm/modifyReview.jsp" method="post">
			<input type="hidden" name="orderNo" value="<%=((Review)map.get("review")).getOrderNo()%>">
				<table>
			
					<tr>
						<td>주문 번호</td>
						<td><%=((Review)map.get("review")).getOrderNo()%></td> 
						<!-- 
						reviwone 메서드의 해시맵 키"review"로부터 orderNo 값을 출력
						 -->
					</tr>
					<tr>
						<td>제목</td>
						<td><%=((Review)map.get("review")).getReviewTitle()%></td>
					</tr>
					<tr>
						<td>내용</td>
						<td><%=((Review)map.get("review")).getReviewContent()%></td>
					</tr>
					<%
					if (reviewImg != null) {
					%>
					<tr>
						<td>상품사진</td>
						<td>
							<img src="<%=path%>" alt="ReviewSaveFilename" width="100">
						</td>
					</tr>
					
					<tr>
						<td>파일타입</td>
						<td>
						<%=((ReviewImg)map.get("reviewImg")).getReviewFiletype()%></td>
					</tr>
					 <%
					}
					%>
					<tr>
						<td>작성일</td>
						<td><%=((Review)map.get("review")).getCreatedate().substring(0, 10)%></td>
					</tr>
					<tr>
						<td>수정일</td>
						<td><%=((Review)map.get("review")).getUpdatedate().substring(0, 10)%></td>
					</tr>
					
				</table>
				<%//로그인 사용자 = 현재로그인 수정 삭제 가능
		         	if(loginId != null) {
		        		if(loginId.equals(map.get("id"))) {
		 		%>
					<button type= "submit">
					수정	
					</button>
					
				<%}} %>
			</form>
			
			
				<%//로그인 사용자 = 현재로그인 수정 삭제 가능
				if(loginId != null) {
	        		if(loginId.equals(map.get("id"))) {
	 			%>
			<form action="<%=request.getContextPath()%>/cstm/removeReviewAction.jsp" method="get">
			<input type="hidden" name="orderNo" value="<%=((Review)map.get("review")).getOrderNo()%>">
					<button type= "submit">
					삭제
					</button>
			</form>
			<%
		        	 	} 
		        	}
				%>
		</div>	
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
</body>
</html>