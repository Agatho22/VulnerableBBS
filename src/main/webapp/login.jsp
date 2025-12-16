<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Page</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;600&display=swap">
<style>
body {
	font-family: 'Roboto', sans-serif;
	background-color: #f2f2f2;
	color: #000;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	margin: 0;
}

.container {
	width: 100%;
	max-width: 400px;
	padding: 40px;
	background: #fff;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	border-radius: 10px;
}

h1 {
	text-align: center;
	font-weight: 700;
	margin-bottom: 30px;
	color: #222;
}

.tabs {
	display: flex;
	justify-content: space-around;
	margin-bottom: 20px;
	border-bottom: 1px solid #ccc;
}

.tab {
	font-weight: 600;
	cursor: pointer;
	padding: 10px 20px;
	text-align: center;
	flex-grow: 1;
	color: #888;
	transition: all 0.3s;
}

.tab.active {
	border-bottom: 2px solid #007bff;
	color: #007bff;
}

.tab a {
	color: inherit;
	text-decoration: none;
}

.content {
	display: none;
}

.content.active {
	display: block;
}

.inpt {
	width: 100%;
	padding: 10px;
	margin-bottom: 20px;
	border: 1px solid #ccc;
	border-radius: 4px;
	background: #fff;
	color: #000;
}

.submit-wrap {
	display: flex;
	justify-content: center;
	align-items: center;
	margin-bottom: 20px;
}

.submit {
	background-color: #007bff;
	color: #fff;
	padding: 10px 20px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-weight: 600;
	transition: background-color 0.3s;
}

.submit:hover {
	background-color: #0056b3;
}

.more, .back-button, .find-button {
	display: block;
	text-align: center;
	margin-top: 10px;
	color: #007bff;
	text-decoration: none;
	font-size: 0.9rem;
	transition: color 0.3s;
}

.more:hover, .back-button:hover, .find-button:hover {
	color: #0056b3;
}
</style>
</head>
<body>
	<section class="container">
		<h1>My Web Login</h1>
		<div class="tabs">
			<span class="tab signin active"><a href="#signin">Sign in</a></span>
			<span class="tab signup"><a href="#signup">Sign up</a></span>
		</div>
		<div class="content signin-cont active">
			<form method="post" action="loginAction.jsp" onsubmit="return validateLogin();">
				<input type="text" name="userID" id="loginUserID" class="inpt" placeholder="Your ID" maxlength="20" required>
				<input type="password" name="userPassword" id="loginUserPassword" class="inpt" placeholder="Your password" maxlength="20" required>
				<div class="submit-wrap">
					<input type="submit" value="Sign in" class="submit">
				</div>
			</form>
		</div>
		<div class="content signup-cont">
			<form method="post" action="joinAction.jsp" onsubmit="return validateSignup();">
				<input type="text" name="userID" id="signupUserID" class="inpt" required="required" placeholder="Your ID" onkeyup="checkCapsLock(event)">
				<input type="password" name="userPassword" class="inpt" required="required" placeholder="Your password">
				<input type="text" name="userName" class="inpt" required="required" placeholder="Your name">
				<input type="email" name="userEmail" class="inpt" required="required" placeholder="Your email">
				<div class="submit-wrap">
					<input type="submit" value="Sign up" class="submit">
				</div>
			</form>
		</div>
		<a href="find.jsp" class="find-button">Forgot ID / Password?</a>
		<a href="main.jsp" class="back-button">Back to Main Menu</a>
	</section>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<script type="text/javascript">
		function checkCapsLock(event) {
			const capsLockMessage = document.getElementById('capsLockMessage');
			if (event.getModifierState('CapsLock')) {
				if (!capsLockMessage) {
					const message = document.createElement('div');
					message.id = 'capsLockMessage';
					message.style.color = 'red';
					message.style.marginTop = '10px';
					message.innerText = 'Caps Lock is on!';
					event.target.parentNode.insertBefore(message, event.target.nextSibling);
				}
			} else {
				const message = document.getElementById('capsLockMessage');
				if (message) {
					message.remove();
				}
			}
		}

		function validateLogin() {
			const userID = document.getElementById('loginUserID').value;
			if (/[A-Z]/.test(userID)) {
				alert('User ID cannot contain uppercase letters.');
				return false;
			}
			return true;
		}

		function validateSignup() {
			const userID = document.getElementById('signupUserID').value;
			if (/[A-Z]/.test(userID)) {
				alert('User ID cannot contain uppercase letters.');
				return false;
			}
			return true;
		}

		$('.tabs .tab').click(function () {
			$('.tabs .tab').removeClass('active');
			$(this).addClass('active');
			$('.content').removeClass('active');
			if ($(this).hasClass('signin')) {
				$('.signin-cont').addClass('active');
			} else {
				$('.signup-cont').addClass('active');
			}
		});
	</script>
</body>
</html>
