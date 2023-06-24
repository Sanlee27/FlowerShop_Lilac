<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 _ 로그인전이면 로그인폼으로 돌아가게
	if(session.getAttribute("loginId") == null){ 
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;		
	}
	
	String loginId = (String)session.getAttribute("loginId");
	// System.out.println(loginMemberId);
	
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	
	// 고객정보출력 메소드
	Customer cstm = new Customer();
	cstm = dao.selectCustomerInfo(loginId);
	
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
			let genderValue = '<%=cstm.getCstmGender()%>';
			
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
			
			phone1.blur(function(){
				// 폰번호 패턴에 틀릴 때
				// 첫번째 번호 변경후
				if(!phonePattern1.test(phone1.val())){
					swal("경고", "연락처를 정확하게 입력해주세요.", "warning");
					phone1.val('<%=cstm.getCstmPhone().substring(0, 3)%>');
				}
			});
			
			phone2.blur(function(){
				// 폰번호 패턴에 틀릴 때
				// 중간 번호 변경후
				if(!phonePattern2.test(phone2.val())){
					swal("경고", "연락처를 정확하게 입력해주세요.", "warning");
					phone2.val('<%=cstm.getCstmPhone().substring(3, 7)%>');
				}
			});
			
			phone3.blur(function(){
				// 폰번호 패턴 틀릴 때
				// 마지막 번호 변경후
				if(!phonePattern3.test(phone3.val())){
					swal("경고", "연락처를 정확하게 입력해주세요.", "warning");
					phone3.val('<%=cstm.getCstmPhone().substring(7, 11)%>');
				}
			});
			
			
			
			// ===========================================	
			// 이메일 도메인 선택값 value설정
			$('#domain').change(function(){
				$('#domainInput').val($('#domain').val());
			});
			
			// 이메일 패턴값 틀릴때 함수
			let email1 = $('input[name="email1"]')
			let email2 = $('#domain')
			
			function ckEmail(){
				let email = email1.val() + '@' + email2.val();
				let emailPattern =  /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;
				
				if(!emailPattern.test(email)){
					swal("경고", "이메일을 정확하게 입력해주세요.", "warning");
					email1.val('<%=email1%>')
					email2.val('<%=email2%>')
				}
			}
			
			// 이메일 커서떼었을때 함수 실행
			email1.blur(function(){
				ckEmail();
			});
			email2.blur(function(){
				ckEmail();
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
			let agreeValue = '<%=cstm.getCstmAgree()%>';
			
			$('input[name="agree"]').each(function() {
			    if ($(this).val() === agreeValue) {
			      $(this).prop('checked', true);
			    }
			  });
			
			// ===========================================
			// 비밀번호 필수 입력
			let pw = $('input[name="pw"]');
			let ckPwButton = $('input[name="ckPw"]');
			let pwMsg = $('#pwMsg');
			
			// 비밀번호 입력이 안되면 입력창 focus > 메세지 표시
			pw.focus(function() {
				pwMsg.text('현재 비밀번호를 입력해주세요');
		    })
		    
		    // 비밀번호입력 후 커서 뗄때
    		pw.blur(function(){
    			// 비밀번호가 4글자를 넘지않는다면
	    		if(pw.val().length < 4){
	    			swal("경고", "비밀번호는 최소 4자를 충족해야합니다.", "warning");
	    			pwMsg.text('비밀번호는 최소 4자를 충족해야합니다.');
	    			ckPwButton.prop('disabled', true);
	    		} else {
	    			pwMsg.text('');
	    			ckPwButton.prop('disabled', false);
	    		}
	    	});
		    
		 	// 비밀번호 확인 버튼========================
		 	let id = $('input[name="id"]'); // 아이디 값
		 	ckPwButton = $('input[name="ckPw"]');
		 	pw = $('input[name="pw"]');
		 	let submitButton = $('button[type="submit"]');
	 	    
	 	  	function pwCkBtn(){
	 	  		let xhr = new XMLHttpRequest();
				let url = '<%=request.getContextPath()%>/cstm/pwCheckFormByModifyCstmInfo.jsp';
				let params = {
					id : "<%=cstm.getId()%>",
					pw : $('input[name="pw"]').val()
				};
				xhr.open('POST', url, true);
				xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
				xhr.onreadystatechange = function() {
				    if (xhr.readyState === 4) {
						if (xhr.status === 200) {
							swal("성공", "비밀번호가 일치합니다", "success");
							ckPwButton.prop('disabled', true);
						} else {
					        // 요청이 실패한 경우
					    	swal("실패", "비밀번호가 일치하지 않습니다", "error");
					    	$("input[name='pw']").val('');
					    	pwMsg.text('비밀번호가 일치하지 않습니다');
						}
				    }
				};
				xhr.send($.param(params));
			}
	 	  	
	 	  	ckPwButton.click(function(){
	 	  		pwCkBtn();
	 	  	});
	 	  	
	 	    // 비밀번호 확인을 안하고 저장을 먼저 눌렀을때.
	 	    submitButton.click(function(event){
	 	    	if(!ckPwButton.prop('disabled')){
	 	    		event.preventDefault(); // submit막음
	 	    		swal("경고", "비밀번호 확인을 먼저 해주세요", "warning");
	 	    		pwMsg.text('비밀번호 확인을 먼저 해주세요');
	 	    	} else {
	 	    		pwMsg.text('');
	 	    	}
	 	    });
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
			<div class="font-line"></div>
			<div class="form-list">
				<div>
					<div>아이디</div>
					<div>
						<%=cstm.getId()%>
						<input type="hidden" name="id" value="<%=cstm.getId()%>">
					</div>
				</div>
				<div>
					<div>이름</div>
					<div>
						<input type="text" name="names" value="<%=cstm.getCstmName()%>" required="required">
					</div>
				</div>
				<div>
					<div>성별</div>
					<div>
						<input type="radio" name="gender" value="남">남
						<input type="radio" name="gender" value="여">여
					</div>
				</div>
				<div>
					<div>생년월일</div>
					<div>
						<input type="date" name="birth" value="<%=cstm.getCstmBirth().substring(0, 10)%>" required="required">
					</div>
				</div>
				<div>
					<div>연락처</div>
					<div>
						<input type="number" name="phone1" value="<%=cstm.getCstmPhone().substring(0, 3)%>" maxlength="3"> -
						<input type="number" name="phone2" value="<%=cstm.getCstmPhone().substring(3, 7)%>" maxlength="4"> - 
						<input type="number" name="phone3" value="<%=cstm.getCstmPhone().substring(7, 11)%>" maxlength="4">
					</div>
				</div>
				<div>
					<div>이메일</div>
					<div>
						<input type = "text" name = "email1" value="<%=email1%>" required="required"> @
						<input type = "text" id="domainInput" name = "email2" value="<%=email2%>" readonly="readonly" required="required"> 
						<select id="domain">
							<option value="naver.com">naver.com</option>
							<option value="daum.net">daum.net</option>
							<option value="gmail.com">gmail.com</option>
						</select>
					</div>
				</div>
				<div>
					<div>주소</div>
					<div>
						<textarea style="resize: none;" rows="1" cols="40" id="address" name="address1" readonly="readonly" required="required"><%=cstm.getCstmAddress()%></textarea>
						<button type="button" class="style-btn" id="address_kakao">주소 검색</button>
					</div>
				</div>
				<div>
					<div>상세주소</div>
					<div>
						<textarea style="resize: none;" rows="2" cols="40" name="address2" placeholder="상세주소를 입력하세요"></textarea>
					</div>
				</div>
				<div>
					<div>약관 동의</div>
					<div>
						<input type="radio" name="agree" value="Y">Y
						<input type="radio" name="agree" value="N">N
					</div>
				</div>
				<div>
					<div>보유 포인트</div>
					<div>
						<fmt:formatNumber value="<%=cstm.getCstmPoint()%>" pattern="###,###,###"/>
					</div>
				</div>
				<div>
					<div>현재 등급</div>
					<div><%=cstm.getCstmRank()%></div>
				</div>
				<div>
					<div>가입 일자</div>
					<div><%=cstm.getCreatedate().substring(0, 10)%></div>
				</div>
				<div>
					<div>현재 비밀번호</div>
					<div>
						<input type = "password" name = "pw" required="required" placeholder="현재 비밀번호를 입력하세요">
						<input type="button" class="style-btn" name="ckPw" value="비밀번호 확인" >
						<span id="pwMsg" style="color: red;"></span>
					</div>
				</div>
			</div>
			<br>
			<button type="submit" class="style-btn">저장</button>
			<button type="button" class="style-btn" onclick="location.href='<%=request.getContextPath()%>/cstm/cstmInfo.jsp?id=<%=cstm.getId()%>'">뒤로가기</button>
		</form>
	</div>
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	<!-- footer -->
	<jsp:include page="/inc/footer.jsp"></jsp:include>
</body>
</html>