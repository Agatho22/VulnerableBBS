<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.User" %>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="user" class="user.User" scope="request" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body> 
    <%
        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }
        if (userID != null) {
            out.println("<script>");
            out.println("alert('이미 로그인 되어 있습니다.')");
            out.println("location.href = 'main.jsp';");
            out.println("</script>");
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        int result = userDAO.login(user.getUserID(), user.getUserPassword());
        
        if (result == 1) {
            // 사용자 정보를 세션에 저장
            session.setAttribute("userID", user.getUserID());
            session.setAttribute("userName", user.getUserName());

            // 관리자 계정인지 확인
            int adminResult = userDAO.adminCheck(user.getUserID()); 

            if (adminResult == 1) { // 관리자라면
                out.println("<script>");
                out.println("location.href = 'adminMain.jsp';");
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("location.href = 'main.jsp';");
                out.println("</script>");
            }
        } else if (result == 0) {
            out.println("<script>");
            out.println("alert('비밀번호가 틀립니다.');");
            out.println("history.back();");
            out.println("</script>");
        } else if (result == -1) {
            out.println("<script>");
            out.println("alert('존재하지 않는 아이디입니다.');");
            out.println("history.back();");
            out.println("</script>");
        } else if (result == -2) {
            out.println("<script>");
            out.println("alert('데이터베이스 오류가 발생했습니다.');");
            out.println("history.back();");
            out.println("</script>");
        } else {
            out.println("<script>");
            out.println("alert('오류가 발생했습니다.');");
            out.println("history.back();");
            out.println("</script>");
        }
    %>
</body>
</html>