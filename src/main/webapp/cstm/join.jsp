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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
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
		
		// 아이디 중복체크
		// 이전에 입력된 아이디 저장
		let previousId = ""; 

	    // 아이디 값 유효성 검사
	    function ckIdValue() {
	    	// 각각 변수에 저장
	        const idInput = $('input[name="id"]');
	        const ckIdButton = $('input[name="ckId"]');
	        const idErMsg = $('#idErMsg');
	        // 아이디 정규식
	        /*
	        (?=.*[a-zA-Z]): 영문자가 최소한 하나 이상 포함되어야 함
			(?=.*\d): 숫자가 최소한 하나 이상 포함되어야 함
			.{4,}: 모든 문자를 포함하며, 적어도 4글자 이상이어야 함
			*/
			const condition = /^(?=.*[a-zA-Z])(?=.*\d).{4,}$/;
			
	        // 입력된 value에 영문자가 최소하나 이전값과 같다면(중복검사 후 사용가능 버튼 클릭 이후)
	        								// 최초 입력값과 최초 이전값("")
	        if (idInput.val().length < 4 || idInput.val() == previousId || !condition.test(idInput.val())) {
		        ckIdButton.prop('disabled', true);
		        idErMsg.show();
		    } else {
		        ckIdButton.prop('disabled', false);
		        idErMsg.hide();
		    }
	    }
	    
	 	// 아이디 중복확인 버튼 클릭 시 확인 창 호출되는 함수
	    function confirmId() {
	        url = "idCheckForm.jsp?id=" + document.join.id.value;
	        open(url, "confirm", "toolbar=no,location=no,status=no,menubar=no,scrollbars-=no,resizable=no,width=300,height=200");
	    }
	    
	    // 아이디 중복체크 안하고 회원가입 시도 시, 알림
	    function signUp() {
	        const ckIdButton = document.join.ckId;
	        const emSelect = $('select[name="email2"]');
	        const idErMsg = $('#idErMsg');
	        // 아이디 중복체크 버튼이 활성화되어있으면 = 중복체크를 안했으면 알림
	        if (!ckIdButton.disabled) {
	            alert("아이디 중복체크 버튼을 눌러주세요.");
	            return;
	        }
	        if(idErMsg.is(":visible")){
	        	alert("아이디 형식이 올바르지않습니다.");
	        	return;
	        }
	        if(emSelect.val() == '선택하세요'){
	        	alert("이메일 도메인을 선택하세요.");
	        	return;
	        }
	        $('#signUpBtn').prop('disabled', true);
	    }
	    
		// 비밀번호 유효성 검사
	    function ckPwValue(){
	    	const pwInput = $('input[name="pw"]');
	    	const rePwInput = $('input[name="rePw"]');
	    	const pwErMsg = $('#pwErMsg');
	    	const pwErMsg2 = $('#pwErMsg2');
	    	
	    	if(pwInput.val().length<4){
	    		pwErMsg.show();
	    	} else {
	    		pwErMsg.hide();
	    	}
	    	
	    	// 비밀번호 입력과 재입력이 다르면 에러메세지 표시
	    	if(pwInput.val().length>=4 && rePwInput.val().length>0 && pwInput.val() != rePwInput.val()) {
	    		pwErMsg2.show();
	    	} else {
	    		pwErMsg2.hide();
	    	}
	    }
		
		// 이름 유효성 검사
		function ckNmValue(){
			const nmInput = $('input[name="name"]');
			const nmErMsg = $('#nmErMsg');
			
			if(nmInput.val().length==1 || nmInput.val().length>4){
				nmErMsg.show();
			} else {
				nmErMsg.hide();
			}
		}
		
		// 생년월일 유효성검사
		function ckBrValue(){
			const brInput = $('input[name="birth"]');
			const birthPattern = /^(19[0-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
			const brErMsg = $('#brErMsg');
			
	        // 입력된 value에 영문자가 최소하나 이전값과 같다면(중복검사 후 사용가능 버튼 클릭 이후)
	        								// 최초 입력값과 최초 이전값("")
	        if (!birthPattern.test(brInput.val())) {
		        brErMsg.show();
		    } else {
		    	brErMsg.hide();
		    } 
		}
		// 연락처 유효성검사
		function ckPhValue(){
			const phInput = $('input[name="phone2"]').val();
			const phInput2 = $('input[name="phone3"]').val();
			const phNm = phInput.length + phInput2.length;
			const phErMsg = $('#phErMsg');
			
			if(phNm>8) {
				phErMsg.show();
			} else {
				phErMsg.hide();
			}
		}
		
		// 이메일 유효성검사
		function ckEmValue(){
			const emSelect = $('select[name="email2"]');
			const emErMsg = $('#emErMsg');
			
			if(emSelect.val() == '선택하세요'){
				emErMsg.show();
			} else {
				emErMsg.hide();
			}
		}
	</script>
</head>
<body>
	<h1>회원가입</h1>
	<form action="<%=request.getContextPath()%>/cstm/joinAction.jsp" method="post" name="join">
		<table>
			<tr>
				<th>아이디</th>
				<td>
					<input type="text" name="id" placeholder="아이디를 입력하세요" required="required" oninput="ckIdValue()">
					<input type="button" name="ckId" value="아이디 중복확인" onclick="confirmId()" disabled> <!-- 버튼 기본값 비활성화 -->
					<span id="idErMsg" style="color: red; display: none;">아이디는 4글자 이상, 영문자,숫자가 최소 하나씩 포함되어야 합니다.</span>
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
					<input type = "password" name = "pw" required="required" oninput="ckPwValue()">
					<span id="pwErMsg" style="color: red; display: none;">비밀번호는 4글자 이상이어야 합니다.</span>
				</td>
			</tr>
			<tr>
				<th>비밀번호 재입력</th>
				<td>
					<input type = "password" name = "rePw" required="required" oninput="ckPwValue()">
					<span id="pwErMsg2" style="color: red; display: none;">비밀번호가 일치하지 않습니다.</span>
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td>
					<input type = "text" name = "name" required="required" oninput="ckNmValue()">
					<span id="nmErMsg" style="color: red; display: none;">이름은 한글자 이상 네글자 이하로 입력하세요</span>
				</td>
			</tr>
			<tr>
				<th>성별</th>
				<td>
					<input type = "radio" name = "gender" value= "남" checked="checked" required="required">남
					<input type = "radio" name = "gender" value= "여" required="required">여
				</td> 
			</tr>
			<tr>
				<th>생년월일</th>
				<td>
					<input type = "date" name = "birth" required="required" oninput="ckBrValue()">
					<span id="brErMsg" style="color: red; display: none;">생년월을 정확하게 입력해주세요</span>
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
					<input type = "number" name = phone2 required="required" oninput="ckPhValue()"> - 
					<input type = "number" name = phone3 required="required" oninput="ckPhValue()"> 
					<span id="phErMsg" style="color: red; display: none;">연락처는 8글자까지 입력 가능합니다</span>
				</td>
			</tr>
			<tr>
				<th>이메일</th>
				<td>
					<input type = "text" name = "email1" required="required"> @
					<select name = "email2" onchange="ckEmValue()">
						<option value="선택하세요" selected="selected">선택하세요</option>
						<option value="naver.com">naver.com</option>
						<option value="daum.net">daum.net</option>
						<option value="gmail.com">gamil.com</option>
					</select>
					<span id="emErMsg" style="color: red; display: none;">도메인을 선택하세요</span>
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
		<button type="submit" id="signUpBtn" onclick="signUp()">회원가입</button>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/login.jsp'">로그인으로</button>
	</form>
</body>
</html>