<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<script>
	$(document).ready(function() {
		
		// 아이디======================================
		let id = $('input[name="id"]'); // 아이디 값
		let ckIdButton = $('input[name="ckId"]'); // 아이디 중복체크 버튼
		let idMsg = $('#idMsg'); // 에러메세지
		let pw = $('input[name="pw"]'); // 비밀번호 값
		// 아이디 정규식
        /*
        (?=.*[a-zA-Z]): 영문자가 최소한 하나 이상 포함되어야 함
		(?=.*\d): 숫자가 최소한 하나 이상 포함되어야 함
		.{4,}: 모든 문자를 포함하며, 적어도 4글자 이상이어야 함
		*/
		let condition = /^(?=.*[a-zA-Z])(?=.*\d).{4,}$/;
			
		// id유효성 체크
		// blur함수 : 커서가 없어질때
	    id.blur(function() {
	    	// 아이디 정규식을 만족하지 않는다면
			if(!condition.test(id.val())) {
				alert('아이디는 영문과 숫자를 합쳐 최소 4자를 충족해야합니다.');
	        	idMsg.text('아이디는 영문과 숫자를 합쳐 최소 4자를 충족해야합니다.');
	        	ckIdButton.prop('disabled', true);
	        // 정규식 만족한다면 아이디 중복체크 메세지 표시 
			} else {
	        	idMsg.text('아이디 중복체크를 먼저 해주세요');
	        	ckIdButton.prop('disabled', false);
        	}
		});
		
		// 아이디 중복확인 버튼 클릭 이벤트
		// 버튼 클릭시 아이디 중복체크 메세지 삭제
			// 아이디 사용가능 시 해당 아이디 사용 > 중복체크 버튼 비활성화
			// 아이디 사용불가시 '다시입력하세요' 메세지 출력, 중복체크 다시해야됨
	    ckIdButton.click(function() {
	    	confirmId();
	    	idMsg.text('');
		});
		
	    // 버튼 클릭시 아이디 확인폼 출력
	    function confirmId(){
    		url = "idCheckForm.jsp?id=" + id.val();
 	        open(url, "confirm", "toolbar=no,location=no,status=no,menubar=no,scrollbars-=no,resizable=no,width=300,height=200");
 	    }
	    
	    // 비밀번호=======================================
	    pw = $('input[name="pw"]'); // 비밀번호값
    	let rePw = $('input[name="rePw"]'); // 비밀번호 재입력값
    	let pwMsg = $('#pwMsg'); // 비밀번호 에러메시지
    	let pwMsg2 = $('#pwMsg2'); // 비밀번호 / 재입력 불일치 에러메시지
    	
    	// 비밀번호입력 후 커서 뗄때
    	pw.blur(function(){
    		// 비밀번호가 4글자를 넘지않는다면
    		if(pw.val().length < 4){
    			alert('비밀번호는 최소 4자를 충족해야합니다.');
    			pwMsg.text('비밀번호는 최소 4자를 충족해야합니다.');
    		} else {
    			pwMsg.text('');
    		}
    	});
    	
    	// 비밀번호 재입력 후 커서 뗄때
    	rePw.blur(function(){
    		if(pw.val() != rePw.val()){
    			alert('비밀번호가 일치하지 않습니다.');
    			pwMsg2.text('비밀번호가 일치하지 않습니다.');
    		} else {
    			pwMsg2.text('');
    		}
    	});
    	
    	// 이름=======================================	
    	let names = $('input[name="names"]');
    	let namePattern = /^[가-힣]+$/;
		let nameMsg = $('#nmErMsg');
    	
		// 이름 입력 후 커서 뗄때
		names.blur(function(){
			// 이름값은 한글, 한글자 이상 여섯 글자 이하
			if(names.val().length < 1 || names.val().length > 6 || !namePattern.test(names.val())){
				alert('이름은 최소 한글자, 최대 여섯글자까지 한글만 입력 가능합니다.')
				nameMsg.text('이름은 최소 한글자, 최대 여섯글자까지 한글만 입력 가능합니다.')
			} else {
				nameMsg.text('');
			}
		});
		
		// 생년월일=======================================	
		let birth = $('input[name="birth"]');
		let birthPattern = /^(19[0-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
		let birthMsg = $('#birthMsg');
		
		birth.blur(function(){
			// 생년월일 패턴을 만족하지 않을때
			if (!birthPattern.test(birth.val())) {
				alert('생년월일을 정확하게 입력해주세요')
				birthMsg.text('생년월일을 정확하게 입력해주세요') 
			 } else {
				birthMsg.text('');
			 }
		});
		
		// 주소=======================================	
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
		
		let address = $('textarea[name="address1"]');
		let detailAddress = $('textarea[name="address2"]');
		let adrMsg = $('#adrMsg');
		
		detailAddress.blur(function(){
			// 주소 미입력시에
			if(address.val() == '' || detailAddress.val() == ''){
				alert('주소를 입력해주세요')
				adrMsg.text('주소를 입력해주세요') 
			} else {
				adrMsg.text('');
			}
		});
		
		// 연락처=======================================
		let phone = $('input[name="phone2"]')
		let phone2 = $('input[name="phone3"]');
		let phonePattern = /^\d{3,4}$/;
		let phonePattern2 = /^\d{4}$/;
		let phMsg = $('#phMsg');
		
		phone.blur(function(){
			// 폰번호 패턴에 부합할 때
			// 중간 번호만 확인
			if(!phonePattern.test(phone.val())){
				alert('연락처를 정확하게 입력해주세요')
				phMsg.text('연락처를 정확하게 입력해주세요') 
			} else {
				phMsg.text('');
			}
		});
		
		phone2.blur(function(){
			// 폰번호 패턴에 부합할 때
			// 중간 번호 / 뒷번호 둘다 확인
			if(!phonePattern.test(phone.val()) || !phonePattern2.test(phone2.val())){
				alert('연락처를 정확하게 입력해주세요')
				phMsg.text('연락처를 정확하게 입력해주세요') 
			} else {
				phMsg.text('');
			}
		});
		
		// 이메일=======================================
		let email1 = $('input[name="email1"]')
		let email2 = $('select[name="email2"]')
		let emMsg = $('#emMsg');
		
		// 이메일 전체 값을 합쳐서 패턴에 적용
		function ckEmail(){
			let email = email1.val() + '@' + email2.val();
			let emailPattern =  /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;
			
			if(!emailPattern.test(email)){
				alert('이메일을 정확하게 입력해주세요')
				emMsg.text('이메일을 정확하게 입력해주세요') 
			} else {
				emMsg.text('');
			}
		}
		
		// 이메일 검사
		email2.blur(function(){
			ckEmail();
		});
			
		// ========================================
		// 회원가입 버튼 활성화/비활성화 체크
		   	// keyup = 키보드를 떼었을때 = 입력을 다했을때 감지
		$('input[name="id"], input[name="pw"], input[name="rePw"], input[name="names"],	input[name="birth"], textarea[name="address1"], textarea[name="address2"], input[name="phone2"], input[name="phone3"], input[name="email1"], select[name="email2"]').keyup(function() {
			let idValue = $('input[name="id"]').val();
			let pwValue = $('input[name="pw"]').val();
			let rePwValue = $('input[name="rePw"]').val();
			let nameValue = $('input[name="names"]').val();
			let birthValue = $('input[name="birth"]').val();
			let adrValue = $('textarea[name="address1"]').val();
			let adr2Value = $('textarea[name="address2"]').val();
			let phoneValue = $('textarea[name="phone2"]').val();
			let phone2Value = $('textarea[name="phone3"]').val();
			let email1Value = $('input[name="email1"]').val();
			let email2Value = $('select[name="email2"]').val();
				
			// trim = 앞뒤공백제거
			// 1. 각 값이 공백이거나
			// 2. id값이 다시입력하세요 = 이미 있는 아이디일때 표시되는 메세지이거나
			// 3. id중복체크버튼이 활성화 되어있거나
			// 4. 비밀번호가 일치하지 않거나
			// 5. 생년월일이 조건에 맞지않거나
			// 6. 연락처가 조건에 맞지않거나
			// 모든 메시지중 하나라도 표현이 된다면(?)
			// 회원가입 버튼 비활성화
			if (idValue.trim() === '' || idValue.trim() === '아이디를다시입력하세요' 
					|| !ckIdButton.prop('disabled') || pwValue.trim() === '' 
					|| rePwValue.trim() === ''		|| pwValue != rePwValue  
					|| nameValue.trim() === ''		|| !birthPattern.test(birthValue)
					|| adrValue.trim() === ''		|| adr2Value.trim() === ''
					|| phoneValue.trim() === ''		|| phone2Value.trim() === ''
					|| !phonePattern.test(phoneValue) || !phonePattern2.test(phone2Value)
					|| email1Value.trim() === ''	|| email2Value.trim() === '') {
				$('button[type="submit"]').prop('disabled', true);
			} else {
				$('button[type="submit"]').prop('disabled', false);
			}
		});
	});
	</script>
</head>
<body>
	<h1>회원가입</h1>
	<form action="<%=request.getContextPath()%>/cstm/joinAction.jsp" method="post">
		<table>
			<tr>
				<th>아이디</th>
				<td>
					<input type="text" name="id" placeholder="아이디를 입력하세요" required="required">
					<input type="button" name="ckId" value="아이디 중복확인" onclick="confirmId()" > 
					<span id="idMsg" style="color: red;"></span>
				</td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td>
					<input type = "password" name = "pw" required="required">
					<span id="pwMsg" style="color: red;"></span>
				</td>
			<tr>
				<th>비밀번호 재입력</th>
				<td>
					<input type = "password" name = "rePw" required="required">
					<span id="pwMsg2" style="color: red;"></span>
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td>
					<input type = "text" name = "names" required="required">
					<span id="nameMsg" style="color: red;"></span>
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
					<input type = "date" name = "birth" required="required">
					<span id="birthMsg" style="color: red;"></span>
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
					<span id="adrMsg" style="color: red;"></span>
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
					<input type = "text" name = phone2 maxlength="4" required="required"> - 
					<input type = "text" name = phone3 maxlength="4" required="required"> 
					<span id="phMsg" style="color: red;"></span>
				</td>
			</tr>
			<tr>
				<th>이메일</th>
				<td>
					<input type = "text" name = "email1" required="required"> @
					<select name = "email2">
						<option value="선택하세요" selected="selected">선택하세요</option>
						<option value="naver.com">naver.com</option>
						<option value="daum.net">daum.net</option>
						<option value="gmail.com">gamil.com</option>
					</select>
					<span id="emMsg" style="color: red;"></span>
				</td>
			</tr>
			<tr>
				<th>약관동의</th>
				<td>
					가입시 사용했던 아이디는 탈퇴 후 재가입시에 사용 불가능합니다. 동의하십니까?
					<input type = "radio" name = "agree" value = "Y" checked="checked" required="required">Y
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