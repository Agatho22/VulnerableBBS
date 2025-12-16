<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 삭제 결과</title>
</head>
<body>
    <%
        // userID를 session에서 가져오거나 request에서 가져오기
        String userID = request.getParameter("userID");
        if (userID == null || userID.trim().isEmpty()) {
            userID = (String) session.getAttribute("userID");
        }

        if (userID == null || userID.trim().isEmpty()) {
            out.println("<script>");
            out.println("alert('유효하지 않은 요청입니다.');");
            out.println("location.href='main.jsp';");
            out.println("</script>");
        } else {
            // UserDAO를 이용해 사용자 삭제
            UserDAO userDAO = new UserDAO();
            boolean result = userDAO.deleteUser(userID);

            if (result) {
                // 회원 삭제 성공
                session.invalidate(); // 세션 종료
                out.println("<script>");
                out.println("alert('회원님의 정보가 성공적으로 삭제되었습니다.');");
                out.println("location.href='main.jsp';");
                out.println("</script>");
            } else {
                // 회원 삭제 실패
                out.println("<script>");
                out.println("alert('정보 삭제에 실패했습니다.');");
                out.println("history.back();");
                out.println("</script>");
            }
        }
    %>
</body>
</html>