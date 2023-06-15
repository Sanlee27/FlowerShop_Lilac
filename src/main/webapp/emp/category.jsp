<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CategoryDao"%> 
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//세션 유효성 검사
	if(session.getAttribute("loginId")==null){
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;
	}
	
	//변수
	String loginId = (String)session.getAttribute("loginId");
		System.out.println(loginId+ "<--loginId");

	//DAO 불러오기
	CategoryDao categorydao = new CategoryDao();
	
	//ArrayList<Category>로 반환되는 categorydao를 categoryList에 저장
	ArrayList<Category> categoryList = categorydao.selectCategoryList();
	
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
	<script>
	 $(document).ready(function() {
		 $('.modifyButton').click(function() {
	            var form = $(this).closest('form');
	            var category = form.find('input[name="oriCategory"]').val();
	            
	            // list-iem에 있는 모든 입력 필드 비활성화
	            $('.list-item input[name="newCategory"]').prop('disabled', true);
	            
	            // 클릭한 버튼에 해당하는 입력 필드만 활성화
	            // form내에서 name속성이 newCategory인 input을 찾아라
	            form.find('input[name="newCategory"]').prop('disabled', false);
	            
	            // 폼의 액션 속성 설정
	            form.attr('action', '<%=request.getContextPath()%>/emp/modifyCategoryAction.jsp?category=' + category);
	            
	            // 해당하는 수정 완료 버튼 표시
	            $('.modifyEnd').hide();
	            form.find('.modifyEnd').show();
	            
	            // 다른 수정 버튼 숨기기
	            $('.modifyButton').show();
	            $(this).hide();
	            
	            // 다른 삭제 버튼 숨기기
	            $('.deletebtn').show();
	            form.find('.deletebtn').hide();
	        });
	        
			//경고창
			if("<%=request.getParameter("msg")%>" == "상품을 모두 삭제 후 카테고리를 삭제해주세요.") {
				swal("경고", "<%=request.getParameter("msg")%>", "warning");
			}else if("<%=request.getParameter("msg")%>" != "null") {
				swal("완료", "<%=request.getParameter("msg")%>", "success");
			}
		});
	</script>
</head>
<body>
<!-- 메인메뉴 -->
<div>
<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
	
<div class="container">	
	<!-- 카테고리 리스트 -->
	<div class="list-wrapper5">
		<h2>카테고리 리스트</h2>
		<a href="<%=request.getContextPath()%>/emp/addCategory.jsp">✚</a>	
	<br>
		<div class="list-item">
			<div>카테고리명</div>
			<div>생성일</div>
			<div>수정일</div>
			<div>&nbsp;</div>
			<div>&nbsp;</div>
		</div>

		<%
			for(Category c : categoryList) {
		%>
			<form action="<%=request.getContextPath()%>/emp/modifyCategoryAction.jsp" method="post" id="answerForm">
				<div class="list-item">
					<div id="answer">
						 <input type="hidden" name="oriCategory" value = "<%=c.getCategoryName()%>">
						 <input type="text" name="newCategory" disabled value = "<%=c.getCategoryName()%>">
					</div>
					
					<div>
						<%=c.getCreatedate()%>
					</div>
					
					<div>
						<%=c.getUpdatedate()%>
					</div>
					
					<div>
						<button type="button" class="modifyButton" data-text="<%=loginId%>">수정</button>
						<button type="submit" class="modifyEnd" style="display: none;">완료</button>
					</div>
					
					<div>
						<button type="submit" class="deletebtn" formaction="<%=request.getContextPath()%>/emp/removeCategoryAction.jsp?categoryName=<%=c.getCategoryName()%>">삭제</button>
					</div>
				</div>
			</form>
		<%
			}
		%>
		</div>
</div>
</body>
</html>