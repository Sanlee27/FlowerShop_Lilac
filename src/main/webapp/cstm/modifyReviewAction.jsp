<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="java.net.URLEncoder"%>


<%

//후기 입력 액션 페이지

	//인코딩
	request.setCharacterEncoding("utf-8");
	
	//string 타입 변수 선언
	String msg = "";
	String dir = request.getServletContext().getRealPath("/review");

	//System.out.println(dir+ "<-modifyReviewAction dir");
	
	int max = 100*1024*1024; //100M
	
	//request 객체 랩핑(for. MultipartRequest api 사용)
		//DefaultFileRenamePolicy -> 파일 이름 중복 방지
		
	//파일 업로드
	MultipartRequest mReq = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	//System.out.println(mReq.getContentType("modReviewImg"));		
			
	//업로드 된 파일 이름 반환
	
	if(mReq.getContentType("modReviewImg").equals("image/jpg") == false
		&& mReq.getContentType("modReviewImg").equals("image/png") == false
		&& mReq.getContentType("modReviewImg").equals("image/jpeg") == false){
		
		//넘어온 파일 확장자가 jpg가 '아닌' 경우 파일 삭제
		//System.out.println("jpg 파일이 아닙니다");
		
		String saveFilename = mReq.getFilesystemName("modReviewImg");
		File f = new File(dir +"/"+saveFilename); //지우는 파일의 풀네임
			if(f.exists()){ //db에 저장되지 않은 정보 삭제
				f.delete();
				System.out.println(dir+"/");
			}
		response.sendRedirect(request.getContextPath()+"/cstm/modifyReview.jsp");
		return;
	}
	

	
	//요청값 변수에 저장
	//1) input type="text" 값 반환
	int orderNo = Integer.parseInt(mReq.getParameter("orderNo"));
	
	String reviewTitle = mReq.getParameter("mTitle");
	String reviewContent = mReq.getParameter("mContent");
	
	/*디버깅
	System.out.println(orderNo);
	System.out.println(reviewTitle);
	System.out.println(reviewContent);
	*/
	
	//2) input type="file" 값 반환
	String type = mReq.getContentType("modReviewImg");
	String originFilename = mReq.getOriginalFileName("modReviewImg");
	String saveFilename = mReq.getFilesystemName("modReviewImg");
	
	/*디버깅	
	System.out.println(type +"<-- modifyReviewAction type");
	System.out.println(originFilename + "<--modifyReviewAction originFilename");
	System.out.println(saveFilename+ "<--modifyReviewAction saveFilename");
	*/
	


	//클래스 객체 생성
	ReviewDao reviewDao = new ReviewDao();
	
	//객체 생성해 요청값 저장
	
	Review review = new Review();
	ReviewImg reviewImg = new ReviewImg();
	
	review.setOrderNo(orderNo);
	review.setReviewTitle(reviewTitle);
	review.setReviewContent(reviewContent);
	
	reviewImg.setOrderNo(orderNo);
	reviewImg.setReviewOriFilename(originFilename);
	reviewImg.setReviewSaveFilename(saveFilename);
	reviewImg.setReviewFiletype(type);
	
	//System.out.println(review + "<-modifyReviewAction reviewImg");
	

	
	//review, reviewImg의 HashMap 객체 선언
	HashMap<String, Object> map = new HashMap<>();
	map.put("review", review);
	map.put("reviewImg", reviewImg);
	
	
	//후기 수정 메서드 실행
	int row = reviewDao.modReview(map);
	
	if(row == 0){ //수정 성공
		msg = URLEncoder.encode("후기 수정 성공!","utf-8");
		response.sendRedirect(request.getContextPath()+"/cstm/reviewList.jsp?msg="+ msg);
		return;
	}
	
	//액션 끝나고 돌아가기
	response.sendRedirect(request.getContextPath()+"/cstm/reviewList.jsp");





%>

