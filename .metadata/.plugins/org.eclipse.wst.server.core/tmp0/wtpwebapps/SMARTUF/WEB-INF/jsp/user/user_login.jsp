<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>SMARTUF</title>
    <meta name="Keywords" content="" />
    <meta name="Description" content="" />
    <link rel="stylesheet" type="text/css" href="/css/font.css" />
    <link rel="stylesheet" type="text/css" href="/css/common.css" />
    
    <script type="text/javascript" src="/js/plugin/jquery/jquery-1.11.1.min.js"></script>
	<script type="text/javascript" src="/js/plugin/jquery/jquery-ui-1.11.1.min.js"></script>
    
    <script type="text/javascript">

	function goLogIn() {
		if(document.form.userId.value == "") {
			alert('아이디를 입력하세요');
			$("#user_id").focus();
			return;
		}
		
		if(document.form.userPw.value == "") {
			alert('비밀번호를 입력하세요');
			$("#user_pw").focus();
			return;
		}
		
		document.form.action="/userConn/userLogInProc.do";
		document.form.submit();
	}
	
	$(document).ready(function() {
		$("#user_id").focus();
	    
		var loginCheck = '${loginCheck}'; 
		
		if(loginCheck == 'N') {
			alert('아이디 또는 비밀번호가 틀렸습니다');
			false;
		}
	});
	
	$(document).on('submit', '#login_form', function() {
		goLogIn();
	});
	
	</script>
    
</head>
<body class="loginbody">
    <form id="login_form" name="form" method="post">
        <!-- login -->
        <div id="login" class="">
            <div class="logintoplogo"><img src="/images/dg_logo.png" alt="대구광역시" /></div>
            <div class="login">
                <h1><em>도시홍수</em><strong>상황인지시스템</strong></h1>
                <div class="inputwrap">
                    <p class="txt_input">
                        <span>Username</span><br />
                        <input id="user_id" type="text" maxlength="20" title="아이디입력" value="" name="userId" class="inbox" />
                    </p>
                    <p class="txt_input">
                        <span>Password</span><br />
                        <input id="user_pw" type="password" title="비밀번호입력" value="" name="userPw" class="inbox" />
                    </p>
                    <p class="btn_login"><input class="img_input" type="submit" value="Log in" /></p>
                </div>
            </div>
        </div>
        <div class="loginfooter">
            <div>
                <address>(41911) 대구광역시 중구 공평로 88 | 별관: 대구광역시 북구 연암로 40<br />전화번호 : 053)120, 053)803-0114</address>
                <p>© Daegu Metropolitan City all rights reserved.</p>
            </div>
        </div>
        <!-- //login -->
    </form>
</body>
</html>