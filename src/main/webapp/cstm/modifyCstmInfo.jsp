<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 _ 로그인전이면 로그인폼으로 돌아가게
	if(session.getAttribute("고객") == null){ 
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;		
	}
	
	String loginMemberId = (String)session.getAttribute("고객");
	// System.out.println(loginMemberId);
	
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	
	// 고객정보출력 메소드
	Customer cstm = new Customer();
	cstm = dao.selectCustomerInfo(loginMemberId);
	
	// 이메일 @ 앞/뒤 부분 잘라서 변수에 저장
	String email = cstm.getCstmEmail();
	int idx = cstm.getCstmEmail().indexOf("@");
	String email1 = email.substring(0, idx);
	String email2 = email.substring(idx+1);
	
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
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script>
		$(document).ready(function() {
			
			// 이름 
			let names = $('input[name="names"]');
    		let namePattern = /^[가-힣]+$/;
    		
			names.blur(function() {
				// 이름값은 한글, 한글자 이상 여섯 글자 이하
				// 경고 띄우고 원래값으로
				if(names.val().length < 1 || names.val().length > 6 || !namePattern.test(names.val())){
					swal("경고", "이름은 1~6글자까지 \n한글만 입력 가능합니다.", "warning");
					names.val('<%=cstm.getCstmName()%>')
				}
		    });
			
			// ===========================================	
			// 성별 값 기본 설정
			var genderValue = '<%=cstm.getCstmGender()%>';
			
			$('input[name="gender"]').each(function() {
			    if ($(this).val() === genderValue) {
			      $(this).prop('checked', true);
				}
			});
			
			// ===========================================	
			// 생년월일
			let birth = $('input[name="birth"]');
			let birthPattern = /^(19[0-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
			
			birth.blur(function(){
			// 생년월일 패턴을 만족하지 않을때
				if (!birthPattern.test(birth.val())) {
					swal("경고", "생년월일을 정확하게 입력해주세요.", "warning");
					birth.val('<%=cstm.getCstmBirth().substring(0, 10)%>');
				}
			});
			
			// ===========================================
			// 연락처
			let phone1 = $('input[name="phone1"]')
			let phone2 = $('input[name="phone2"]')
			let phone3 = $('input[name="phone3"]');
			let phonePattern1 = /^01[01679]\d{1}$/;
			let phonePattern2 = /^\d{3,4}$/;
			let phonePattern3 = /^\d{4}$/;
			
			phone.blur(function(){
				// 폰번호 패턴에 부합할 때
				// 중간 번호만 확인
				if(!phonePattern1.test(phone1.val()) || !phonePattern2.test(phone2.val()) || !phonePattern3.test(phone3.val())){
					swal("경고", "연락처를 정확하게 입력해주세요.", "warning");
					phone1.val('<%=cstm.getCstmPhone().substring(0, 3)%>');
					phone2.val('<%=cstm.getCstmPhone().substring(3, 7)%>');
					phone3.val('<%=cstm.getCstmPhone().substring(7, 11)%>');
				}
			});
			
			// ===========================================	
			// 이메일 도메인 선택값 value설정
			$('#domain').change(function(){
				$('#domainInput').val($('#domain').val());
			});
			
			
			// ===========================================	
			// 주소
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

			
			// ===========================================
			// 약관동의 값 기본 설정
			var agreeValue = '<%=cstm.getCstmAgree()%>';
			
			$('input[name="agree"]').each(function() {
			    if ($(this).val() === agreeValue) {
			      $(this).prop('checked', true);
			    }
			  });
			
			
			// ===========================================
			// 비밀번호 필수 입력
			let pwMsg = $('#pwMsg');
			
			// 비밀번호 입력이 안되면 입력창 focus > 메세지 표시
			$('input[name="pw"]').focus(function() {
				pwMsg.text('현재 비밀번호를 입력해주세요');
		    })
		    
		    // 입력 후 focus 안하면 > 메세지 공백
			$('input[name="pw"]').focusout(function() {
				pwMsg.text('');
		    })
		});
	</script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<form action="<%=request.getContextPath()%>/cstm/modifyCstmInfoAction.jsp" method="post">
			<h1>내 정보 수정</h1>
			<table>
				<tr>
					<th>아이디</th>
					<td><%=cstm.getId()%></td>
				</tr>
				<tr>
					<th>이름</th>
					<td>
						<input type="text" name="names" value="<%=cstm.getCstmName()%>" required="required">
					</td>
				</tr>
				<tr>
					<th>성별</th>
					<td>
						<input type="radio" name="gender" value="남">남
						<input type="radio" name="gender" value="여">여
					</td>
				</tr>
				<tr>
					<th>생년월일</th>
					<td>
						<input type="date" name="birth" value="<%=cstm.getCstmBirth().substring(0, 10)%>" required="required">
					</td>
				</tr>
				<tr>
					<th>연락처</th>
					<td>
						<input type="number" name="phone1" value="<%=cstm.getCstmPhone().substring(0, 3)%>" maxlength="3"> -
						<input type="number" name="phone2" value="<%=cstm.getCstmPhone().substring(3, 7)%>" maxlength="4"> - 
						<input type="number" name="phone3" value="<%=cstm.getCstmPhone().substring(7, 11)%>" maxlength="4">
					</td>
				</tr>
				<tr>
					<th>이메일</th>
					<td>
						<input type = "text" name = "email1" value="<%=email1%>" required="required"> @
						<input type = "text" id="domainInput" name = "email2" value="<%=email2%>" readonly="readonly" required="required"> 
						<select id="domain">
							<option value="naver.com">naver.com</option>
							<option value="daum.net">daum.net</option>
							<option value="gmail.com">gmail.com</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>주소</th>
					<td>
						<textarea style="resize: none;" rows="1" cols="40" id="address" name="address1" readonly="readonly" required="required"><%=cstm.getCstmAddress()%></textarea>
						<button type="button" id="address_kakao">주소 검색</button>
					</td>
				</tr>
				<tr>
					<th>상세주소</th>
					<td>
						<textarea style="resize: none;" rows="2" cols="40" name="address2"></textarea>
					</td>
				</tr>
				<tr>
					<th>약관 동의</th>
					<td>
						<input type="radio" name="agree" value="Y">Y
						<input type="radio" name="agree" value="N">N
					</td>
				</tr>
				<tr>
					<th>보유 포인트</th>
					<td><%=cstm.getCstmPoint()%></td>
				</tr>
				<tr>
					<th>현재 등급</th>
					<td><%=cstm.getCstmRank()%></td>
				</tr>
				<tr>
					<th>가입 일자</th>
					<td><%=cstm.getCreatedate().substring(0, 10)%></td>
				</tr>
				<tr>
					<th>현재 비밀번호</th>
					<td>
						<input type = "password" name = "pw" required="required">
						<span id="pwMsg" style="color: red;"></span>
					</td>
				</tr>
			</table>
			<button type="submit">저장</button>
			<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/cstmInfo.jsp?id=<%=cstm.getId()%>'">뒤로가기</button>
		</form>
	</div>
</body>
</html>