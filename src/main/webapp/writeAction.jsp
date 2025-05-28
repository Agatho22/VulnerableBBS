<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="file.FileDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.File" %>
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

        if (userID == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인을 하세요.')");
            script.println("location.href = 'login.jsp'");
            script.println("</script>");
            return;
        }

        // 파일 업로드 처리
        String directory = application.getRealPath("/upload/");
        File dir = new File(directory);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        int maxSize = 1024 * 1024 * 100; // 100MB
        String encoding = "UTF-8";
        MultipartRequest multipartRequest = null;

        try {
            multipartRequest = new MultipartRequest(request, directory, maxSize, encoding, new DefaultFileRenamePolicy());
        } catch (Exception e) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('파일 업로드 중 오류가 발생했습니다." + e.toString().replace("'","\\'") + "')");
            script.println("history.back()");
            script.println("</script>");
            return;
        }

        String bbsTitle = multipartRequest.getParameter("bbsTitle");
        String bbsContent = multipartRequest.getParameter("bbsContent");
        String isSecret = multipartRequest.getParameter("isSecret");
        if (isSecret == null) {
            isSecret = "N"; // 체크 안 하면 일반글
        }

        if (bbsTitle == null || bbsContent == null || bbsTitle.trim().equals("") || bbsContent.trim().equals("")) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('입력이 안 된 항목이 있습니다.')");
            script.println("history.back()");
            script.println("</script>");
            return;
        }

        String fileName = multipartRequest.getOriginalFileName("file");
        String fileRealName = multipartRequest.getFilesystemName("file");

        // DB에 글 등록 (isSecret 포함)
        BbsDAO bbsDAO = new BbsDAO();
        int newBbsID = bbsDAO.write(bbsTitle, userID, bbsContent, isSecret);

        if (newBbsID == -1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('글 작성에 실패하였습니다.')");
            script.println("history.back()");
            script.println("</script>");
            return;
        }

        // 파일 정보 저장
        if (fileName != null && fileRealName != null) {
            FileDAO fileDAO = new FileDAO();
            int fileResult = fileDAO.upload(fileName, fileRealName, newBbsID);
            if (fileResult <= 0) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('파일 저장 중 오류가 발생했습니다.')");
                script.println("history.back()");
                script.println("</script>");
                return;
            }
        }

        // 권한 따라 페이지 이동
        UserDAO userDAO = new UserDAO();
        int adminCheckResult = userDAO.adminCheck(userID);
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('글 작성 완료하였습니다.')");
        if (adminCheckResult == 0) {
            script.println("location.href = 'bbs.jsp'");
        } else {
            script.println("location.href = 'adminBbs.jsp'");
        }
        script.println("</script>");
    %>
</body>
</html>
