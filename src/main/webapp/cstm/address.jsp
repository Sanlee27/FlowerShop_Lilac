<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 세션에서 아이디 가져오기
	String loginId = (String)session.getAttribute("loginId");
	
	// AddressDao 객체 선언
	AddressDao addressDao = new AddressDao();
	
	// AddressDao에서 id가 주문한 배송지 리스트 가져오기
	ArrayList<Address> addressList = addressDao.selectHistoryAddress(loginId);
%>
<div class="modal-container" id="addressModal">
	<div class="modal">
		<h2>최근배송지</h2>
		<button type="button" onclick='addressModalClose()' class="closeBtn">
				<img src="<%=request.getContextPath() %>/images/close.png">
		</button>
		<div id="addressList">
			<%
				for(Address a : addressList){
			%>
				<div class="flex-wrapper">
					<div class="address"><%=a.getAddress() %></div>
					<div><%=a.getAddressLastdate() %></div>
					<button type="button" class="selectBtn style-btn" onclick="selectBtnClick(this)">선택</button>
					<button type="button" class="deleteBtn style-btn" onclick="deleteBtnClick(this, <%=a.getAddressNo()%>)">삭제</button>
				</div>
			<%
				}
			%>
		</div>
		<button type="button" onclick='addAddressBtnClick()' class="style-btn">배송지추가</button>
	</div>
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	let initialValue = "";
	$(document).ready(function(){
		initialValue = $("#address").text();
	})
	function addAddressBtnClick() {
		new daum.Postcode({
			oncomplete: function(data) {
				console.log(data.address);
			    $("#addressList").append(
		    		'<div class="flex-wrapper new-address">' +
			            '<div class="address">' +
			                '<span>' + data.address + '</span>' + 
			                ' <input type="text" placeholder="상세주소" id="detailAddress">' +
			            '</div>' +
			            '<div>-</div>' +
			            '<button type="button" class="selectBtn style-btn" onclick="selectBtnClick(this)">선택</button>' +
			        	'<button type="button" class="deleteBtn style-btn" onclick="deleteBtnClick(this, null)">삭제</button>' +
			         '</div>');
			}
		}).open();
	}
	function selectBtnClick(button){
		let address = $(button).prevAll(".address").text();
		let detailAddress = $(button).closest(".flex-wrapper").find("#detailAddress").val();

		if($(button).parent().hasClass("new-address")){
			if(detailAddress == ""){
				swal("경고", "상세주소를 입력하세요", "warning");
				return;
			}
		}
		$('#address').text(address + (detailAddress ? detailAddress : ""));
	}
	function deleteBtnClick(button, addressNo){
		let address = $(button).prevAll(".address").text();
		let detailAddress = $(button).closest(".flex-wrapper").find("#detailAddress").val();
		let totalAddress = address + detailAddress;
		console.log(totalAddress);
		console.log($("#address").text())
		
		if(totalAddress == $("#address").text()){
			$("#address").text(initialValue);
		}
		$(button).closest(".flex-wrapper").remove();
		 
		 if(addressNo == null){
			 return;
		 }
		 let xhr = new XMLHttpRequest();
		 let url = '<%=request.getContextPath()%>/cstm/removeAddressAction.jsp';
		 let params = 'addressNo=' + encodeURIComponent(addressNo);
		 
		 xhr.open('POST', url, true);
		    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
		
		    xhr.onreadystatechange = function() {
		        if (xhr.readyState === 4) {
		            if (xhr.status === 200) {
		            	console.error('주소 삭제 성공');

		            } else {
		                // 요청이 실패한 경우
		                console.error('주소 삭제 실패');
		            }
		        }
		    };
		
		    xhr.send(params);
	}
	function addressModalClose(){
		$('#addressModal').hide();
	}
</script>