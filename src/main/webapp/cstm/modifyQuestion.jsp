<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>

<%
	//인코딩 설정
	request.setCharacterEncoding("utf-8");
	
	//세션 유효성 검사
		if(session.getAttribute("loginId")==null){
			response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
			return;
		}

	//요청값 유효성 검사
	if(request.getParameter("qNo") == null
		|| request.getParameter("qNo").equals("")){
		//home.jsp로
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//요청값 변수에 저장
	int qNo = Integer.parseInt(request.getParameter("qNo"));


	//클래스 객체 생성
	QuestionDao questionDao = new QuestionDao();
	
	//상세페이지 객체 생성
	Question one = questionDao.questionOne(qNo);

	System.out.println(one);
	
	
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
	<!-- jQuery -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
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
	                window.location.href = "<%=request.getContextPath()%>/cstm/questionList.jsp";
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
		<h2>문의 수정</h2>
			<form action="<%=request.getContextPath()%>/cstm/modifyQuestionAction.jsp?msg=success" method="post">
			<input type="hidden" name="qNo" value="<%=one.getqNo()%>">
				<div class="form-list">
					<div>
						<div>qNo</div>
						<div><%=one.getqNo() %></div>
					</div>
					<div>
						<div>id</div>
						<div><input type="text" name="id" value="<%=one.getId()%>" readonly = "readonly" ></div>
					</div>
					<div>	
						<div>카테고리</div>
						<div>
							<select name= "qCategory">
										<option value="상품">상품</option>
										<option value="결제">결제</option>
										<option value="배송">배송</option>
										<option value="기타">기타</option>
							</select>
						</div>
					</div>
					<div>	
						<div>qAnswer</div>
						<div><input type="text" name="qAnswer" value="<%=one.getqAnswer()%>" readonly = "readonly" ></div>
					</div>
					<div>
						<div>제목</div>
						<div>
							<input type= "hidden" name ="id" value=<%=one.getId() %>>
							<input type= "text" name="qTitle"  onclick="if(this.value=='타이틀을 입력하세요'){this.value=''}" value="타이틀을 입력하세요" required="required"> 
						</div>
					</div>
					<div>
						<div>내용</div>
						<div>
							<input type= "hidden" name ="id" value=<%=one.getId() %>>
							<input type= "text" name="qContent" onclick="if(this.value=='내용을 입력하세요'){this.value=''}" value="내용을 입력하세요" required="required"> 
						</div>
					</div>
					<div>
						<div>수정일</div>
						<div>
							<%=one.getUpdatedate() %>
						</div>
					</div>
					<div>
						<div>작성일</div>
						<div><%=one.getCreatedate() %>
						</div>
					</div>
				</div>
					<div class="flex-wrapper marginTop20">	
						<button type="submit" class="style-btn">수정 완료</button>
					</div>

			</form>
		</div>

	
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	
		
		
</body>
</html>