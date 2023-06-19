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
		<div id="addressList">
			<%
				for(Address a : addressList){
			%>
				<div class="flex-wrapper">
					<div><%=a.getAddress() %></div>
					<div><%=a.getAddressLastdate() %></div>
					<button type="button">선택</button>
				</div>
			<%
				}
			%>
		</div>
		<button type="button" onclick='addAddressBtnClick()'>배송지추가</button>
	</div>
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	function addAddressBtnClick() {
		new daum.Postcode({
			oncomplete: function(data) {
				console.log(data.address);
			    $("#addressList").append(
			    		'<div class="flex-wrapper">' +
			            '<div>' +
			                data.address +
			                ' <input type="text" placeholder="상세주소" id="detailAddress">' +
			            '</div>' +
			            '<div>-</div>' +
			            '<button type="button">선택</button>' +
			        '</div>');
			}
		}).open();
	}
</script>