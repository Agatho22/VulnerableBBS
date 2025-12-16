<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>테스트 게시판</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }

    int bbsID = 0;
    if (request.getParameter("bbsID") != null) {
        bbsID = Integer.parseInt(request.getParameter("bbsID"));
    }

    if (bbsID == 0) {
        PrintWriter script = response.getWriter();
        script.println("<script>alert('유효하지 않은 글입니다.'); location.href = 'bbs.jsp';</script>");
        return;
    }

    Bbs bbs = new BbsDAO().getBbs(bbsID);

    if (bbs == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>alert('존재하지 않는 글입니다.'); location.href = 'bbs.jsp';</script>");
        return;
    }

    // 취약하게 만든 비밀글 접근 제한 - 로그인만 했으면 누구나 접근 가능
    if ("Y".equals(bbs.getIsSecret())) {
        if (userID == null) {
%>
	<script>alert("비밀글입니다. 로그인 후 열람 가능합니다."); history.back();</script>
<%
            return;
        }
    }
%>

<div class="container mt-5">
    <h2>게시글 상세 보기</h2>
    <table class="table table-bordered">
        <tr>
            <th>글 제목</th>
            <td>
                <%= bbs.getBbsTitle() %> <% if ("Y".equals(bbs.getIsSecret())) { %> 🔒 <% } %>
            </td>
        </tr>
        <tr>
            <th>작성자</th>
            <td><%= bbs.getUserID() %></td>
        </tr>
        <tr>
            <th>작성일자</th>
            <td><%= bbs.getBbsDate() %></td>
        </tr>
        <tr>
            <th>내용</th>
            <td><%= bbs.getBbsContent() %></td>
        </tr>
    </table>

    <div class="mt-3">
        <a href="bbs.jsp" class="btn btn-secondary">목록</a>
        <a href="fileDownload.jsp?bbsID=<%= bbsID %>" class="btn btn-info">파일 다운로드</a>
        <% if (userID != null && userID.equals(bbs.getUserID())) { %>
            <a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-warning">수정</a>
            <a href="deleteAction.jsp?bbsID=<%= bbsID %>" onclick="return confirm('정말로 삭제하시겠습니까?');" class="btn btn-danger">삭제</a>
        <% } %>
    </div>

    <hr>
    <h4 style="color:red;">[테스트 영역]</h4>
    <form method="get" action="">
        <input type="hidden" name="bbsID" value="<%= bbsID %>">
        파일 경로: <input type="text" name="path" size="60" value="<%= request.getParameter("path") != null ? request.getParameter("path") : "" %>">
        <input type="submit" value="읽기">
    </form>

<%
    String path = request.getParameter("path");
    if (path != null) {
        try {
            File file = new File(path);
            if (file.exists() && file.isFile()) {
                out.println("<pre style='background:#000; color:#0f0; padding:15px;'>");
                BufferedReader br = new BufferedReader(new FileReader(file));
                String line;
                while ((line = br.readLine()) != null) {
                    out.println(line);
                }
                br.close();
                out.println("</pre>");
            } else {
                out.println("<p style='color:red;'>[오류] 파일이 존재하지 않거나 일반 파일이 아닙니다.</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>[예외] " + e.getMessage() + "</p>");
        }
    }
%>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
