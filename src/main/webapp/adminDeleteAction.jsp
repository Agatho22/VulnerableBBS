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
        String userID = request.getParameter("userID");  // 요청에서 userID를 가져옴

        UserDAO userDAO = new UserDAO();
        boolean result = userDAO.deleteUser(userID);  // userID로 삭제 메소드 호출

        if (result) {
        	PrintWriter script = response.getWriter();
    		script.println("<script>");
    		script.println("alert('회원님의 정보가 성공적으로 삭제되었습니다.')");
    		script.println("location.href = 'adminUser.jsp'");
    		script.println("</script>");
        } else {
        	PrintWriter script = response.getWriter();
    		script.println("<script>");
    		script.println("alert('정보 삭제에 실패했습니다.')");
			script.println("history.back()");
    		script.println("</script>");
            out.println("<p>정보 삭제에 실패했습니다.</p>");
        }
    %>
</body>
</html>