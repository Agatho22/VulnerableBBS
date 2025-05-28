<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap">
<style type="text/css">
body {
	font-family: 'Roboto', sans-serif;
	background-color: #ffffff;
	color: #000000;
}

.navbar {
	background-color: #f8f9fa;
	border-bottom: 1px solid #e0e0e0;
}

.navbar-brand, .nav-link {
	color: #000000 !important;
	font-weight: 600;
}

.navbar-brand:hover, .nav-link:hover {
	color: #555555 !important;
}

.table th, .table td {
	background-color: #ffffff;
	color: #000000;
	border-color: #dee2e6;
}

.table-hover tbody tr:hover td {
	background-color: #f2f2f2;
}

a, a:hover {
	color: #000000;
	text-decoration: none;
}

.btn {
	background-color: #e0e0e0;
	color: #000000;
	border: none;
}

.btn:hover {
	background-color: #d0d0d0;
}
</style>
<title>JSP 게시판 웹 사이트</title>
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
	String search = request.getParameter("search");
	%>

	<!-- 네비게이션 바 -->
	<nav class="navbar navbar-expand-lg navbar-light">
		<a class="navbar-brand" href="main.jsp">JSP Board</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarNav" aria-controls="navbarNav"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active"><a class="nav-link" href="main.jsp">Home</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs.jsp">Board</a></li>
			</ul>
			<ul class="navbar-nav ml-auto">
				<%
				if (userID == null) {
				%>
				<li class="nav-item dropdown"><a
					class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
					role="button" data-toggle="dropdown" aria-haspopup="true"
					aria-expanded="false"> Sign In </a>
					<div class="dropdown-menu" aria-labelledby="navbarDropdown">
						<a class="dropdown-item" href="login.jsp">Login</a>
					</div></li>
				<%
				} else {
				%>
				<li class="nav-item dropdown"><a
					class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
					role="button" data-toggle="dropdown" aria-haspopup="true"
					aria-expanded="false"> Account </a>
					<div class="dropdown-menu" aria-labelledby="navbarDropdown">
						<a class="dropdown-item" href="logoutAction.jsp">Logout</a> <a
							class="dropdown-item"
							href="userDeleteAction.jsp?userID=<%=userID%>"
							onclick="return confirm('정말로 계정을 삭제하시겠습니까?');">Delete ID</a>
					</div></li>
				<%
				}
				%>
			</ul>
		</div>
	</nav>

	<div class="container mt-4">
		<!-- 검색 폼 -->
		<form method="get" action="bbs.jsp" class="form-inline mb-3">
			<input type="text" name="search" class="form-control mr-2"
				placeholder="Search..." value=<%=search != null ? search : ""%>>
			<button type="submit" class="btn">Search</button>
		</form>

		<!-- 게시글 리스트 -->
		<table class="table table-hover">
			<thead>
				<tr>
					<th>Number</th>
					<th>Title</th>
					<th>Author</th>
					<th>Date</th>
				</tr>
			</thead>
			<tbody>
				<%
				BbsDAO bbsDAO = new BbsDAO();
				ArrayList<Bbs> list = (search != null && !search.trim().equals("")) ? bbsDAO.searchList(search, pageNumber)
						: bbsDAO.getList(pageNumber);

				if (list.size() == 0) {
				%>
				<tr>
					<td colspan="4" class="text-center">검색 결과가 없습니다.</td>
				</tr>
				<%
				} else {
				for (Bbs b : list) {
				%>
				<tr>
					<td><%=b.getBbsID()%></td>
					<td><a href="view.jsp?bbsID=<%=b.getBbsID()%>"> <%=b.getBbsTitle()%>
							<%
							if ("Y".equals(b.getIsSecret())) {
							%> 🔒 <%
							}
							%>
					</a></td>
					<td><%=b.getUserID()%></td>
					<td><%=b.getBbsDate().substring(0, 11) + b.getBbsDate().substring(11, 13) + "시 " + b.getBbsDate().substring(14, 16)
		+ "분"%></td>
				</tr>
				<%
				}
				}
				%>
			</tbody>
		</table>

		<!-- 페이지 이동 및 글쓰기 버튼 -->
		<div class="d-flex justify-content-between">
			<div>
				<%
				if (pageNumber != 1) {
				%>
				<a
					href="bbs.jsp?pageNumber=<%=pageNumber - 1%>&search=<%=search != null ? search : ""%>"
					class="btn">Previous</a>
				<%
				}
				%>
				<%
				if (bbsDAO.nextPage(pageNumber + 1)) {
				%>
				<a
					href="bbs.jsp?pageNumber=<%=pageNumber + 1%>&search=<%=search != null ? search : ""%>"
					class="btn">Next</a>
				<%
				}
				%>
			</div>
			<a href="write.jsp" class="btn">Write</a>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
