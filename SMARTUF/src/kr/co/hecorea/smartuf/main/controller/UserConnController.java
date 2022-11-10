package kr.co.hecorea.smartuf.main.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import com.ibatis.common.logging.Log;
import com.ibatis.common.logging.LogFactory;

import kr.co.hecorea.smartuf.main.dao.UserConnDAO;


@Controller
@RequestMapping("/userConn/*")
public class UserConnController {
	
	@Autowired
	private SqlSession sqlSession;
	
	@Autowired
	HttpSession session;
	
	protected final Log log = LogFactory.getLog(getClass());

	
	
	@RequestMapping("/userLogIn.do")
	public String userLogIn(HttpServletRequest req, Model model) throws Exception {
		String loginCheck = req.getParameter("loginCheck")==null?"":req.getParameter("loginCheck");
		
		model.addAttribute("loginCheck", loginCheck);
		
		return "user/user_login";
	}
	
	
	@RequestMapping("/userLogInProc.do")
	public String userLogInProc(HttpServletRequest req, Model model) throws Exception {
		String userId = req.getParameter("userId")==null?"":req.getParameter("userId");
		String userPw = req.getParameter("userPw")==null?"":req.getParameter("userPw");
		
		String returnUrl = "";
		int loginFlag = 0;
		
		HashMap<String, String> userInfo = new HashMap<String, String>();
		
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("userId", userId);
		param.put("userPw", userPw);
		
		try{
			UserConnDAO userConnDAO = sqlSession.getMapper(UserConnDAO.class);
			loginFlag = userConnDAO.selectUserLogIn(param);
		
			if(loginFlag < 1) {
				returnUrl = "redirect:/userConn/userLogIn.do?loginCheck=N";
				
			} else {
				userInfo = userConnDAO.selectUserInfo(param);
				
				session.setAttribute("loginUserId", userInfo.get("user_id"));
				session.setAttribute("loginUserNm", userInfo.get("user_nm"));
				session.setAttribute("loginUserGd", userInfo.get("user_gd"));
				
				returnUrl = "redirect:/flood/rainfall.do";
			}
			
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		return returnUrl;
	}
	
	
	@RequestMapping("/userLogOut.do")
	public String userLogOut() throws Exception {
		session.invalidate();
		
		return "redirect:/userConn/userLogIn.do";
	}
	
}
