package kr.co.hecorea.smartuf.main.dao;

import java.util.HashMap;

public interface UserConnDAO {
	
	public int selectUserLogIn(HashMap<String, String> param) throws Exception;
	
	public HashMap<String, String> selectUserInfo(HashMap<String, String> param) throws Exception;
}
