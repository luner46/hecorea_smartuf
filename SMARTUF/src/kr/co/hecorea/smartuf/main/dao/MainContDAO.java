package kr.co.hecorea.smartuf.main.dao;

import java.util.ArrayList;
import java.util.HashMap;

public interface MainContDAO {
	
	public ArrayList<HashMap<String, String>> selectRainfallData(HashMap<String, String> param) throws Exception;
	public ArrayList<HashMap<String, String>> selectRainfallDatas(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectNodeData(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectNodeDataMax(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectNodeDetail(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectWaterLevelData(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectFloodMapData(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectLandSlideData(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectLandSlideDetail(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectBasinLevelData(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectBasinLevelDetail(HashMap<String, String> param) throws Exception;
	
	public String selectKmaDataImage(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectSubmersionInfo() throws Exception;
	
	public ArrayList<HashMap<String, String>> selectSubmersionData(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectStnfallData(HashMap<String, String> param) throws Exception;
	
	public ArrayList<HashMap<String, String>> selectNodeDataLive(HashMap<String, String> param) throws Exception;
}

