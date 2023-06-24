<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>

<%
	//인코딩 설정
	request.setCharacterEncoding("UTF-8");

	//세션 유효성 검사
	if(session.getAttribute("loginId")==null){
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;
	}
	
	//요청값 유효성 검사-> id
	if(request.getParameter("qNo") == null
		|| request.getParameter("qNo").equals("")){
		//home.jsp로
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//요청값 변수에 저장
	int qNo = Integer.parseInt(request.getParameter("qNo"));
		System.out.println(qNo + "<--qNo");
	String loginId = (String)session.getAttribute("loginId");
		System.out.println(loginId+ "<--loginId");
	boolean isAdmin = loginId.equals("admin1") || loginId.equals("admin2") ? true : false;
	int beginRow = 0;
	int rowPerPage = 10;
	int productNo = Integer.parseInt(request.getParameter("qNo"));

	//클래스 객체 생성
	QuestionDao questionDao = new QuestionDao();
	AnswerDao answerdao = new AnswerDao();
	ProductDao productDao = new ProductDao();
	
	//상세페이지 객체 생성
	Question one = questionDao.questionOne(qNo);
	Answer answer = answerdao.selectAnswer(qNo);
	HashMap<String, Object> map = productDao.getProductDetail(one.getProductNo());
	
		Product product = (Product) map.get("product");
	

	System.out.println(one + "<-one");
	
	
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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<!-- ajax -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script>
    $(document).ready(function() {
        $('#modifyButton').click(function() {
            var comment = $(this).attr('data-text');
            $('#answer textarea').prop('disabled', function(_, value) {
                return !value;
            });
   
            
            $('#answerForm').attr('action', '<%=request.getContextPath()%>/emp/modifyAnswerAction.jsp?comment=' + comment);
            $('#modifyEnd').show();
            $(this).hide();
            $("#deletebtn").hide();
        });
        
        if("<%=request.getParameter("msg")%>" == "답변을 입력해주세요.") {
			swal("경고", "<%=request.getParameter("msg")%>", "warning");
		}else if("<%=request.getParameter("msg")%>" != "null"){
			swal("완료", "<%=request.getParameter("msg")%>", "success");
		};
	});
    function backBtnClick(){
    	if(<%=isAdmin %>){
    		location.href="<%=request.getContextPath() %>" + "/employees.jsp"
    		} else {history.back()};
    }
	</script>
</head>
<body>
	<div>
	<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>

	<div class="container">

		<h1>문의 상세</h1>
		<div class="font-line"></div>
		<div class="flex-wrapper marginTop30"></div>

			<form action="<%=request.getContextPath()%>/cstm/modifyQuestion.jsp" method="get">
				<input type="hidden" name="qNo" value="<%=one.getqNo()%>">
				<input type="hidden" name="productNo" value="<%=one.getProductNo()%>">
				<div class="form-list">
					<div>
						<div>문의번호</div>
						<div><%=one.getqNo() %></div>
					</div>
					<div>
						<div>상품명</div>
						<div><%=product.getProductName() %></div>
					</div>
					<div>
						<div>아이디</div> 
						<div><%=one.getId() %></div>
					</div>
					<div>
						<div>카테고리</div>
						<div><%=one.getqCategory() %></div>
					</div>
					<div>
						<div>답변여부</div>
						<div><%=one.getqAnswer().equals("Y") ? "답변 완료" : "답변 대기" %></div>
					</div>
					<div>
						<div>제목</div> 
						<div><%=one.getqTitle() %></div>
					</div>
					<div>
						<div>내용</div>
						<div><%=one.getqContent() %></div>
					</div>
					<div>
						<div>수정일</div>
						<div><%=one.getUpdatedate() %></div>
					</div>
					<div>
						<div>작성일</div>
						<div><%=one.getCreatedate() %></div>
					</div>
					<button class="style-btn marginTop20" type="button" onclick="backBtnClick()">뒤로가기</button>
				</div>
				<br>
				<!-- 수정 삭제 버튼 -->
				<%//로그인 사용자 = 현재로그인 수정 삭제 가능
		         if(loginId != null) {
		        		if(loginId.equals(one.getId())) {
		 		%>
					<button type="submit" class="style-btn">
						수정	
					</button>
					<button type= "submit" formaction="<%=request.getContextPath()%>/cstm/removeQuestionAction.jsp" class="style-btn">
							삭제
					</button>
				<%
						}
		        }
				%>
				</form>	
				<!-- 답변 -->
				<%
				if(isAdmin) {
					if(answer != null && one.getqNo() == answer.getqNo()) {
					%>
						<!-- 답변리스트 -->
						<div>
							<form id="answerForm" action="<%=request.getContextPath()%>/emp/modifyAnswerAction.jsp">
								<input type="hidden" name="answerNo" value="<%=answer.getAnswerNo()%>">
								<input type="hidden" name="qNo" value="<%=answer.getqNo()%>">
								<div>&#8627;</div>
								<div id = "answer">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea disabled name="comment" rows="4" cols="100"><%=answer.getAnswerContent()%></textarea></div>
								<div>
									<div>
										<div>답변일 : <%=answer.getCreatedate()%></div> 
										<div>수정일 : <%=answer.getUpdatedate()%></div>
									</div>
									<div class="marginTop10">
										<button type="button" id="modifyButton" data-text="<%=loginId%>" class="style-btn">수정</button>
										<button type="submit" id="modifyEnd" style="display: none;" class="style-btn">완료</button>
										<button type="submit" id="deletebtn" formaction="<%=request.getContextPath()%>/emp/removeAnswerAction.jsp" class="style-btn">삭제</button>
									</div>
								</div>
								
							</form>
						</div>
					<%
					} else {
					%>	
						<br>
						<h4>답변입력</h4>
						<form action="<%=request.getContextPath()%>/emp/addAnswerAction.jsp">
							<input type="hidden" name="qNo" value="<%=one.getqNo()%>">
							<input type="hidden" name="id" value="<%=one.getId()%>">
							<textarea rows="3" cols="70" name="comment"></textarea>
							<button type="submit" class="style-btn">등록</button>
						</form>
				<%
					} 
				}
				%>
	</div>

	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	<!-- footer -->
	<jsp:include page="/inc/footer.jsp"></jsp:include>
	
</body>
</html>