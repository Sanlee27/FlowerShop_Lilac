<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>


<%
//후기 수정페이지

	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//유효성 검사 & 세션

	//요청값 변수에 저장
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));

	
	//디버깅
	System.out.println(orderNo+"<-modifyReview orderNo");
	
	//클래스 객체 생성
	ReviewDao oneDao = new ReviewDao();
	
	//수정페이지 객체 생성
	HashMap<String, Object> map = oneDao.reviewOne(orderNo);

	System.out.println(map+"<- modifyReview map");

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
	<!-- ajax -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script>
	    $(document).ready(function(){
	        const msg = "<%=request.getParameter("msg")%>";
	
	        if(msg == "null" || msg == ""){
	            return;
	        }
	        if(msg === "success"){
	            swal("성공", "수정에 성공하였습니다.", "success").then(() => {
	                window.location.href = "<%=request.getContextPath()%>/cstm/reviewList.jsp";
	            });
	        }else{
	            swal("실패", "수정에 실패하였습니다.", "error");
	        }
	    })
	</script>
</head>
<body>
	<div>
	<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<div class="container">
		<h1>후기 수정</h1>
		<div class="font-line"></div>
		<div class="flex-wrapper marginTop30"></div>
			<form action="<%=request.getContextPath()%>/cstm/modifyReviewAction.jsp" method="post" enctype="multipart/form-data">
			<input type="hidden" name="orderNo" value=<%=orderNo%>>
				<div class="form-list">
						<!-- orderNo -->
						<div>
							<div>주문번호</div> 
							<div><%=orderNo%></div>
						</div>
						<!-- reviewTitle -->
						<div>
							<div>후기제목</div>
							<div><input type= "hidden" name ="reviewTitle" value=<%=((Review)map.get("review")).getReviewTitle()%>>
								 <input type= "text" name="mTitle"  onclick="if(this.value=='타이틀을 입력하세요'){this.value=''}" value="타이틀을 입력하세요"> <!-- text를 클릭하면 value 값 지워짐 -->
							</div>
						</div>	
						<!-- reviewContent -->
						<div>
							<div>내용</div>
							<div><input type= "hidden" name ="reviewContent" value=<%=((Review)map.get("review")).getReviewContent()%>>
								<input type= "text" name="mContent" onclick="if(this.value=='내용을 입력하세요'){this.value=''}" value="내용을 입력하세요" > 
							</div>
						</div>
						<!-- boardFile -->
						<div>
							<div>변경할 파일 (현재파일 : <%=((ReviewImg)map.get("reviewImg")).getReviewSaveFilename()%>)</div>
							<div><input type="file" name="modReviewImg" required="required">
							</div>
						</div>	
				</div>
				<div class="flex-wrapper marginTop20">
					<button type="submit" class="style-btn">수정</button>
				</div>	
			</form>
				
						
		</div>
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
</body>
</html>