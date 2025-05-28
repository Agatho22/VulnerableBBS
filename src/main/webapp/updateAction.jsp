<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="file.FileDAO" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.io.IOException" %> <!-- IOException import 추가 -->
<%@ page import="java.io.PrintWriter" %> <!-- PrintWriter import 추가 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
    <%
        String userID = null;

        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }

        // 로그인 체크
        if (userID == null) {
            displayAlertAndRedirect(response, "로그인을 하세요.", "login.jsp");
            return;
        }

        // bbsID 체크
        int bbsID = 0;
        if (request.getParameter("bbsID") != null) {
            bbsID = Integer.parseInt(request.getParameter("bbsID"));
        }

        if (bbsID == 0) {
            displayAlertAndRedirect(response, "유효하지 않은 글입니다.", "bbs.jsp");
            return;
        }


// 게시글 조회
Bbs bbs = new BbsDAO().getBbs(bbsID);

// 게시글이 존재하지 않거나, 작성자가 아니면 권한 없음 처리
if (bbs == null) {
    displayAlertAndRedirect(response, "해당 게시글이 존재하지 않습니다.", "bbs.jsp");
    return;
}

// 관리자 여부 확인
boolean isAdmin = "admin".equals(userID);  // 관리자 아이디가 "admin"이라고 가정

// 게시글 작성자나 관리자가 아닌 경우
if (!userID.equals(bbs.getUserID()) && !isAdmin) {
    displayAlertAndRedirect(response, "권한이 없습니다.", "bbs.jsp");
    return;
}

// 게시글 작성자 또는 관리자일 경우만 이후 코드 실행

        // 게시글 수정
        if (request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null
            || request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals("")) {
            displayAlertAndGoBack(response, "입력이 안 된 사항이 있습니다.");
            return;
        } else {
            BbsDAO bbsDAO = new BbsDAO();
            int result = bbsDAO.update(bbsID, request.getParameter("bbsTitle"), request.getParameter("bbsContent"));
            if (result == -1) {
                displayAlertAndGoBack(response, "글 수정에 실패했습니다.");
            } else {
                displayAlertAndRedirect(response, "수정이 완료되었습니다.", "bbs.jsp");
            }
        }

        // 파일 업로드 처리
        String directory = application.getRealPath("/upload/"); // 실제 경로로 수정
        int maxSize = 1024 * 1024 * 100;
        String encoding = "UTF-8";

        MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding, new DefaultFileRenamePolicy());

        // 경고를 무시하고 unchecked conversion을 처리
        @SuppressWarnings("unchecked")
        Enumeration<String> fileNames = multipartRequest.getFileNames();
        while (fileNames.hasMoreElements()) {
            String parameter = fileNames.nextElement();
            String fileName = multipartRequest.getOriginalFileName(parameter);
            String fileRealName = multipartRequest.getFilesystemName(parameter);

            if (fileName == null) continue; // 파일이 없으면 건너뜀

            // 파일 확장자 검사
            if (!isValidFileExtension(fileName)) {
                new File(directory + fileRealName).delete(); // 잘못된 확장자 파일 삭제
                displayAlertAndGoBack(response, "업로드할 수 없는 확장자입니다.");
                return;
            } else {
                FileDAO fileDAO = new FileDAO();
                fileDAO.update(fileName, fileRealName, bbsID); // 파일 DB 업데이트
            }
        }
    %>

    <%!
        // 파일 확장자 검사 메소드
        private boolean isValidFileExtension(String fileName) {
            return fileName.endsWith(".doc") || fileName.endsWith(".hwp")
                || fileName.endsWith(".pdf") || fileName.endsWith(".xls")
                || fileName.endsWith(".jpg");
        }

        // 경고 메시지와 리디렉션 처리
        private void displayAlertAndRedirect(HttpServletResponse response, String message, String url) throws IOException {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('" + message + "')");
            script.println("location.href = '" + url + "'");
            script.println("</script>");
        }

        // 경고 메시지와 이전 페이지로 돌아가기
        private void displayAlertAndGoBack(HttpServletResponse response, String message) throws IOException {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('" + message + "')");
            script.println("history.back()");
            script.println("</script>");
        }
    %>

</body>
</html>
