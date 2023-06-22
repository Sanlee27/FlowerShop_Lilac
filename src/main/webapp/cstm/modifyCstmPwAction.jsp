<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 _ 로그인전이면 로그인폼으로 돌아가게
	if(session.getAttribute("loginId") == null){ 
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;		
	}
	
	
	String id = null;
    String pw = null;
    String newPw = null;
    String newPw2 = null;
	
    // 값을 request.getParameter로 받아오지 못해 getInputStream을 시도한 방법.
    // request.getInputStream()은 요청 본문의 데이터를 바이트 스트림으로 읽을 수 있는 메서드
    // 값을 읽어오는 방법
    BufferedReader reader = null;
    try {
        StringBuilder stringBuilder = new StringBuilder();
        reader = new BufferedReader(new InputStreamReader(request.getInputStream(), StandardCharsets.UTF_8));
        String line;
        while ((line = reader.readLine()) != null) {
            stringBuilder.append(line);
        }
        String requestBody = stringBuilder.toString();

        // 파싱된 요청 본문에서 값 추출
        String[] params = requestBody.split("&");
        for (String param : params) {
            String[] keyValue = param.split("=");
            if (keyValue.length == 2) {
                String key = URLDecoder.decode(keyValue[0], "UTF-8");
                String value = URLDecoder.decode(keyValue[1], "UTF-8");
                if (key.equals("id")) {
                    id = value;
                } else if (key.equals("pw")) {
                    pw = value;
                } else if (key.equals("newPw")) {
                    newPw = value;
                } else if (key.equals("newPw2")) {
                    newPw2 = value;
                }
            }
        }
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        if (reader != null) {
            try {
                reader.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
	// ==================================
			
    //System.out.println(id);
    //System.out.println(pw);
    //System.out.println(newPw);
    //System.out.println(newPw2);
    
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	
	// 현재 비밀번호가 맞는지
	Id curPw = new Id();
	curPw.setId(id);
	curPw.setLastPw(pw);
	
	int ckPw = dao.ckPw(curPw);
	// System.out.println(ckPw);
	if(ckPw != 1){
		response.setStatus(400); // 잘못된 요청 상태 코드 (Bad Request)
        response.getWriter().write("curPwMismatch");
        return;
    }
	// 비밀번호 이력에서 새로운 비밀번호가 현재 포함 최근 비밀번호 3개와 다른지
	int ckPwHistory = dao.checkPwHistory(curPw, newPw);
	// System.out.println(ckPwHistory);
	// 같은게 있다면 경고 띄우고 리다이렉트
	if(ckPwHistory > 0){
 		response.setStatus(400); // 잘못된 요청 상태 코드 (Bad Request)
        response.getWriter().write("newPwSameAsHistory");
		return;
	}
	// 위에 2개 다 통과하면 비밀번호 업데이트
	int uptPw = dao.updatePw(curPw, newPw);
	// System.out.println(uptPw);
	response.setStatus(200); // 성공 상태 코드 (OK)
    return;
%>