<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #111;
        color: #fff;
    }
    .navbar {
        background-color: #000;
    }
    .navbar-brand, .nav-link {
        color: #fff !important;
    }
    .navbar-brand {
        font-weight: bold;
    }
    .nav-link {
        margin-right: 20px;
    }
    .dropdown-menu {
        background-color: #000;
    }
    .dropdown-item {
        color: #fff;
    }
    .dropdown-item:hover {
        background-color: #444444;
        color: #ffffff;
    }
    .jumbotron {
        background-color: #111;
        color: #fff;
        text-align: center;
    }
    .jumbotron h1 {
        font-size: 3rem;
        font-weight: bold;
    }
    .btn-primary {
        background-color: #fff;
        color: #000;
        border: none;
    }
    .btn-primary:hover {
        background-color: #ccc;
    }
    .carousel-inner img {
        width: 100%;
        height: 60vh;
    }
    .carousel-control-prev-icon, .carousel-control-next-icon {
        background-color: #000;
    }
    .footer {
        text-align: center;
        padding: 20px 0;
        background-color: #000;
    }

    /* Table styles */
    table {
        color: #ffffff; /* Default text color for table */
    }
    /* Change the text color for the table rows */
    table tbody tr td {
        color: #ffffff; /* Set text color to white */
    }
    /* Change the background color on hover */
    table tbody tr:hover {
        background-color: #444; /* Dark gray background on hover */
    }
</style>
<title>JSP 파일 업로드</title>
</head>
<body>
    <% 
        String userID = null;
        if (session.getAttribute("userID") != null) { 
            userID = (String) session.getAttribute("userID");
        }
        int pageNumber = 1;
        if (request.getParameter("pageNumber") != null) {
            pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
        }
    %>
     <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
             <a class="navbar-brand" href="adminMain.jsp">
                <img src="flower.jpg" alt="Admin page" style="height: 30px;">
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item"><a class="nav-link" href="adminUser.jsp">회원 관리</a></li>
                    <li class="nav-item"><a class="nav-link" href="adminBbs.jsp">게시판 관리</a></li>
                </ul>
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">메뉴</a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <% if (userID == null) { %>
                            <a class="dropdown-item" href="login.jsp">로그인</a>
                            <a class="dropdown-item" href="join.jsp">회원가입</a>
                            <% } else { %>
                            <a class="dropdown-item" href="logoutAction.jsp">로그아웃</a>
                            <% } %>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container">
        <h2>관리자 : <%= userID %>님</h2>
        <div class="row">
            <form method="post" action="adminUpdateAction.jsp" class="w-100">
                <table class="table table-hover">
                    <thead>
                        <tr style= "color:white">
                            <th>아이디</th>
                            <th>비밀번호</th>
                            <th>이름</th>
                            <th>이메일</th>
                            <th>권한</th>
                            <th>수정</th>
                            <th>삭제</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            UserDAO userDAO = new UserDAO();
                            ArrayList<User> list = userDAO.getUserList();
                            for(User user : list) {
                                String ID = user.getUserID(); 
                                int adminCheckResult = userDAO.adminCheck(ID);
                        %>
                        <tr>
                            <td><%= user.getUserID() %></td>
                            <td><%= user.getUserPassword() %></td>
                            <td><%= user.getUserName() %></td>
                            <td><%= user.getUserEmail() %></td>
                            <td><%= adminCheckResult == 1 ? "관리자" : "회원" %></td>
                            <td>
                                <a href="adminUpdate.jsp?userID=<%= ID %>&oldUserID=<%= ID %>" class="btn btn-warning btn-sm">
                                    <i class="fas fa-edit"></i> 수정
                                </a> 
                            </td>
                            <td>
                                <a href="#" onclick="confirmDelete('<%= ID %>')" class="btn btn-danger btn-sm">
                                    <i class="fas fa-trash-alt"></i> 삭제
                                </a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </form>
        </div>
    </div>
    <div class="footer">
        &copy; 2024 관리자 페이지. 모든 권리 보유.
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        function confirmDelete(userID) {
            if (confirm("정말로 이 회원을 삭제하시겠습니까?")) {
                window.location.href = 'adminDeleteAction.jsp?userID=' + userID;
            }
        }
    </script>
</body>
</html>