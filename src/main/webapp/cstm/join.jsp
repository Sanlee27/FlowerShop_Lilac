<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String loginMemberId = (String)session.getAttribute("loginMemberId");

	String msg = null;
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript">
		// 카카오 주소 API
		window.onload = function(){
		    document.getElementById("address_kakao").addEventListener("click", function(){ //주소입력칸을 클릭하면
		        //카카오 주소찾기 팝업 열림
		        new daum.Postcode({
		        	// 주소 선택값
		            oncomplete: function(data) { 
		            	// address_textarea에 자동 입력
		                document.getElementById("address").value = data.address;
		            }
		        }).open();
		    });
		}
		// 아이디 비밀번호 유효성 검사
		function check(){
			if(!document.join.id.value){
				alert("아이디를 입력하세요");
				return false;
			}
			if(!document.join.pw.value){
				alert("비밀번호를 입력하세요");
				return false;
			}
			if(document.join.pw.value != document.join.rePw.value){
				alert("비밀번호가 일치하지 않습니다.");
				return false;
			}
		}
		// 아이디 중복체크
		// 이전에 입력된 아이디 저장
		let previousId = ""; 

	    // 아이디 값이 변경될 때마다 호출되는 함수
	    function checkIdValue() {
	        const idInput = document.join.id;
	        const ckIdButton = document.join.ckId;
	
	        // 입력된 아이디를 계속 사용시 중복체크버튼 비활성화
	        if (idInput.value === previousId) {
	            ckIdButton.disabled = true;
	            return;
	        }
	
	        // 중복체크 이후 아이디 재입력시 중복체크버튼 재활성화
	        ckIdButton.disabled = false;
	        previousId = idInput.value;
	    }
	
	    // 아이디 중복확인 버튼 클릭 시 호출되는 함수
	    function confirmId() {
	        if (document.join.id.value === "") {
	            alert("아이디를 입력하세요");
	            return;
	        }
	
	        url = "idCheckForm.jsp?id=" + document.join.id.value;
	        open(url, "confirm", "toolbar=no,location=no,status=no,menubar=no,scrollbars-=no,resizable=no,width=300,height=200");
	    }
	</script>
</head>
<body>
	<h1>회원가입</h1>
	<form action="<%=request.getContextPath()%>/cstm/joinAction.jsp" method="post" name="join" onSubmit="return check())">
		<table>
			<tr>
				<th>아이디</th>
				<td>
					<input type="text" name="id" placeholder="아이디를 입력하세요" required="required" oninput="checkIdValue()">
					<input type="button" name="ckId" value="아이디 중복확인" onclick="confirmId()" disabled> <!-- 버튼 기본값 비활성화 -->
				</td>
			</tr>
				<%
					if(msg != null){
				%>
						<%=msg%>
				<%
					}
				%>
			<tr>
				<th>비밀번호</th>
				<td>
					<input type = "password" name = "pw" required="required">
				</td>
			</tr>
			<tr>
				<th>비밀번호 재입력</th>
				<td>
					<input type = "password" name = "rePw" required="required">
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td>
					<input type = "text" name = "name" required="required">
				</td>
			</tr>
			<tr>
				<th>성별</th>
				<td>
					<input type = "radio" name = "gender" value= "남" required="required">남
					<input type = "radio" name = "gender" value= "여" required="required">여
				</td> 
			</tr>
			<tr>
				<th>생년월일</th>
				<td>
					<input type = "date" name = "birth" required="required">
				</td>
			</tr>
			<tr>
				<th>주소</th>
				<td>
					<textarea rows="1" cols="40" id="address" name="address1" placeholder = "주소를 선택하세요" readonly="readonly" required="required"></textarea>
					<button type="button" id="address_kakao">주소 검색</button>
				</td>
			</tr>
			<tr>
				<th>상세주소</th>
				<td>
					<textarea rows="1" cols="40" name="address2" required="required"></textarea>
				</td>
			</tr>
			<tr>
				<th>연락처</th>
				<td>
					<select name = "phone1">
						<option value="010" selected="selected">010</option>
						<option value="011">011</option>
						<option value="016">016</option>
						<option value="017">017</option>
						<option value="019">019</option>
					</select> - 
					<input type = "text" name = phone2 required="required"> - 
					<input type = "text" name = phone3 required="required"> 
				</td>
			</tr>
			<tr>
				<th>이메일</th>
				<td>
					<input type = "text" name = "email1" required="required"> @
					<select name = "email2">
						<option value="선택" selected="selected">선택하세요</option>
						<option value="naver.com">naver.com</option>
						<option value="daum.net">daum.net</option>
						<option value="gmail.com">gamil.com</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>약관동의</th>
				<td>
					<input type = "radio" name = "agree" value = "Y" required="required">Y
					<input type = "radio" name = "agree" value = "N" required="required">N
				</td>
				<!-- 약관내용 -->
			</tr>
		</table>
		<button type="submit">회원가입</button>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/login.jsp'">로그인으로</button>
	</form>
</body>
</html>