<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=San+Francisco:wght@400;600&display=swap">
<style>
    body {
        font-family: 'San Francisco', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        background-color: #f5f5f7;
        color: #333;
        margin: 0;
        padding: 0;
    }

    .navbar {
        background-color: #f8f9fa;
        border-bottom: 1px solid #e0e0e0;
    }

    .navbar-brand, .nav-link {
        color: #333 !important;
        font-weight: 600;
    }

    .navbar-brand:hover, .nav-link:hover {
        color: #0071e3 !important;
    }

    .dropdown-menu {
        background-color: #ffffff;
        border: none;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .dropdown-item {
        color: #333;
    }

    .dropdown-item:hover {
        background-color: #f1f1f1;
        color: #0071e3;
    }

    .container {
        padding-top: 40px;
    }

    .jumbotron {
        background-color: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        padding: 20px;
    }

    h3 {
        text-align: center;
        font-weight: 700;
        color: #333;
    }

    .form-control {
        border-radius: 20px;
        border: 1px solid #dddddd;
    }

    .btn-primary {
        background-color: #0071e3;
        border-color: #0071e3;
        border-radius: 20px;
        font-weight: 600;
    }

    .btn-primary:hover {
        background-color: #005bb5;
        border-color: #005bb5;
    }

    .btn-group .btn {
        border-radius: 20px;
        font-weight: 600;
    }

    .btn-group .btn.active {
        background-color: #0071e3;
        border-color: #0071e3;
    }

    .nav-item .btn-login {
        background-color: #0071e3;
        color: white;
        border-radius: 20px;
        font-weight: 600;
        padding: 5px 15px;
    }

    .nav-item .btn-login:hover {
        background-color: #005bb5;
        color: white;
    }
</style>
<title>JSP 게시판 웹 사이트</title>
</head>
<body> 
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="navbar-header">
            <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
        </div>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="main.jsp">메인</a></li>
                <li class="nav-item"><a class="nav-link" href="bbs.jsp">게시판</a></li>
            </ul>
            <ul class="navbar-nav ml-auto">
                <li class="nav-item dropdown">
                    <a href="#" class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">접속하기</a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="login.jsp">로그인</a>
                        <a class="dropdown-item active" href="join.jsp">회원가입</a>
                    </div>    
                </li>
                <li class="nav-item">
                    <a href="login.jsp" class="btn btn-login">로그인</a>
                </li>
            </ul>
        </div>
    </nav>
    
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="jumbotron">
                    <form method="post" action="joinAction.jsp">
                        <h3>회원가입 화면</h3>
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="아이디" name="userID" maxlength="20">
                        </div>
                        <div class="form-group">
                            <input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20">
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="이름" name="userName" maxlength="20">
                        </div>
                        <div class="form-group text-center">
                            <div class="btn-group btn-group-toggle" data-toggle="buttons">
                                <label class="btn btn-primary active">
                                    <input type="radio" name="userGender" autocomplete="off" value="male" checked>남자
                                </label>
                                <label class="btn btn-primary">
                                    <input type="radio" name="userGender" autocomplete="off" value="female">여자
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <input type="email" class="form-control" placeholder="이메일" name="userEmail" maxlength="50">
                        </div>
                        <input type="submit" class="btn btn-primary form-control" value="회원가입">
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>  --%>
 <%-- 구버전 회원가입 폼 --%>
