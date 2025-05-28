<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
    <div class="container">
        <div class="col-lg-4"></div>
        <div class="col-lg-4">
            <div class="jumbotron" style="padding-top: 20px;">
                <% 
                    String oldUserID = request.getParameter("oldUserID");
                    String userID = request.getParameter("userID");
                    String userPassword = request.getParameter("userPassword");
                    String userName = request.getParameter("userName");
                    String userGender = request.getParameter("userGender");
                    String userEmail = request.getParameter("userEmail");
                    String admin = request.getParameter("admin");

                    // 로그로 파라미터 확인
                    System.out.println("Old User ID: " + oldUserID);
                    System.out.println("New User ID: " + userID);
                    System.out.println("Password: " + userPassword);
                    System.out.println("Name: " + userName);
                    System.out.println("Gender: " + userGender);
                    System.out.println("Email: " + userEmail);
                    System.out.println("Admin: " + admin);

                    // 파라미터가 null인지 확인
                    if (oldUserID == null || oldUserID.isEmpty()) {
                        out.println("<p>Error: oldUserID is missing or empty.</p>");
                    } else {
                        UserDAO userDAO = new UserDAO();
                        User user = new User();
                        user.setUserID(userID);
                        user.setUserPassword(userPassword);
                        user.setUserName(userName);
                        user.setUserEmail(userEmail);
                        user.setAdmin(admin);

                        int updateResult = userDAO.userUpdate(user, oldUserID);

                        if (updateResult > 0) {
            				PrintWriter script = response.getWriter();
                        	script.println("<script>");
                        	script.println("alert('회원 정보 변경을 완료하였습니다.')");
                        	script.println("location.href = 'adminUser.jsp'");
                        	script.println("</script>");
                        } else {
            				PrintWriter script = response.getWriter();
                        	script.println("<script>");
                        	script.println("location.href = 'adminUser.jsp'");
                        	script.println("alert('회원 정보 변경을 실패하였습니다.')");
                        	script.println("</script>");
                        }
                    }
                %>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
