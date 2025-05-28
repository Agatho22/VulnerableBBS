<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap">
    <title>JSP 게시판 웹 사이트</title>
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
        .footer {
            text-align: center;
            padding: 20px 0;
            background-color: #000;
        }
        .form-container {
            background-color: #222;
            padding: 2rem;
            border-radius: 0.5rem;
            margin-top: 2rem;
        }
        .form-control {
            background-color: #333;
            color: #fff;
            border: 1px solid #555;
        }
        .form-control:focus {
            background-color: #444;
            border-color: #ddd;
        }
        .custom-form-container {
            padding: 2rem;
            border-radius: 0.5rem;
            background: #222;
            margin-top: 2rem;
        }
        .custom-jumbotron {
            padding: 2rem;
            background: #222;
            color: white;
            border-radius: 0.5rem;
        }
        .custom-radio-btn {
            margin: 0.5rem;
        }
        /* Ensure consistent spacing and alignment */
        .nav-item a {
            margin: 0 10px;
        }
        .container, .row {
            height: 100%;
        }
        
        /* Custom iOS-like switch */
        .switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 28px;
        }
        .switch input { 
            opacity: 0;
            width: 0;
            height: 0;
        }
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 28px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        input:checked + .slider {
            background-color: #2196F3;
        }
        input:checked + .slider:before {
            transform: translateX(22px);
        }
        input:focus + .slider {
            box-shadow: 0 0 1px #2196F3;
        }
        input:checked:focus + .slider {
            box-shadow: 0 0 1px #2196F3;
        }
        /* 스위치와 텍스트 간격 */
        .ml-2 {
            margin-left: 8px; /* 텍스트와 스위치 간격 */
        }
        .mr-4 {
            margin-right: 16px; /* 일반 계정과 관리자 계정 간격 */
        }

        /* New styles for radio button containers */
        .radio-container {
            display: flex;
            align-items: center;
            margin-bottom: 1rem; /* Adjust space between radio button groups if needed */
        }

        /* Adjust margin between the radio buttons */
        .radio-container .switch {
            margin-right: 10px; /* Space between switch and label */
        }

        /* Adjust the margin of the text labels */
        .radio-container span {
            margin-left: 5px; /* Space between switch and text */
        }
    </style>
</head>
<body>
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
                            <a class="dropdown-item" href="logoutAction.jsp">로그아웃</a>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container">
        <div class="row">
            <div class="col-lg-4"></div>
            <div class="col-lg-4 custom-form-container">
                <div class="custom-jumbotron">
                    <%
                        String oldUserID = request.getParameter("oldUserID"); // 기존 ID 가져오기
                        String userID = oldUserID; // 수정하는 사용자 ID 설정
                        String adminStatus = request.getParameter("admin"); // 현재 계정 유형 가져오기
                    %>
                    <form method="post" action="adminUpdateAction.jsp">
                        <h3 class="text-center">회원 정보 수정</h3>
                        <input type="hidden" name="oldUserID" value="<%= oldUserID %>">
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="아이디" name="userID" maxlength="20" readonly value="<%= userID %>">
                        </div>
                        <div class="form-group">
                            <input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20">
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="이름" name="userName" maxlength="20">
                        </div>
                        <!-- 라디오 버튼 기반 스위치 -->
                        <div class="form-group text-center">
                            <div class="radio-container">
                                <!-- 일반 계정 -->
                                <label class="switch mb-0">
                                    <input type="radio" name="admin" value="user" <%= "user".equals(adminStatus) ? "checked" : "" %>>
                                    <span class="slider"></span>
                                </label>
                                <span>일반 계정</span>
                            </div>

                            <div class="radio-container">
                                <!-- 관리자 계정 -->
                                <label class="switch mb-0">
                                    <input type="radio" name="admin" value="admin" <%= "admin".equals(adminStatus) ? "checked" : "" %>>
                                    <span class="slider"></span>
                                </label>
                                <span>관리자 계정</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <input type="email" class="form-control" placeholder="이메일" name="userEmail" maxlength="20">
                        </div>
                        <input type="submit" class="btn btn-primary form-control" value="수정">
                    </form>
                </div>
            </div>
            <div class="col-lg-4"></div>
        </div>
    </div>
    <div class="footer">
        <p>© 2024 JSP 게시판 웹 사이트. 모든 권리 보유.</p>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>