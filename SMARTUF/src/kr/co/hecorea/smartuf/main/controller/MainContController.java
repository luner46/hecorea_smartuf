package kr.co.hecorea.smartuf.main.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.ibatis.session.SqlSession;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.hecorea.smartuf.common.util.CalculationDate;
import kr.co.hecorea.smartuf.main.dao.MainContDAO;


@Controller
@RequestMapping("/floodCont/*")
public class MainContController {
	
	@Autowired
	@Resource(name="sqlMySession")
	private SqlSession sqlSession;
	
	@Autowired
	HttpSession session;
	
	@Value("#{config['geoserverPath']}") String geoserverPath;
	
	private final Logger log = Logger.getLogger(getClass());
	
	
	@RequestMapping(value="/selectRainfallData.do")
	public String selectRainfallData(HttpServletRequest req, Model model) throws Exception {
		String issueDate = req.getParameter("dt")==null?"":req.getParameter("dt");
		
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		ArrayList<HashMap<String, String>> stnList = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> param = new HashMap<String, String>();
		
		try{
			CalculationDate calculationDate = new CalculationDate();
			
			log.info("issueDate: " + issueDate.substring(0, 10));
			
			param.put("dt0H", issueDate.substring(0, 10));
			param.put("dt1H", calculationDate.CurrentDateMinuteAgo(issueDate, "MINUS", 1 * 60).substring(0, 10));
			param.put("dt2H", calculationDate.CurrentDateMinuteAgo(issueDate, "MINUS", 2 * 60).substring(0, 10));
			
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			dataList = mainContDAO.selectRainfallData(param);
			stnList = mainContDAO.selectStnfallData(param);
			
			log.info("dataList.size: " + dataList.size());
			
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("dataList", dataList);
		model.addAttribute("stnList", stnList);
		
		return "jsonView";
	}
	
	
	@RequestMapping(value="/selectNodeData.do")
	public String selectNodeData(HttpServletRequest req, Model model) throws Exception {
		String dt = req.getParameter("dt")==null?"":req.getParameter("dt");
		String acc = req.getParameter("acc")==null?"":req.getParameter("acc");
		String step = req.getParameter("step")==null?"":req.getParameter("step");
		
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		ArrayList<HashMap<String, String>> liveList = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> param = new HashMap<String, String>();
		
		String currentDate = "";
		String currentHour = "";
		String issueDate = "";
		
		CalculationDate calculationDate = new CalculationDate();
		currentDate = calculationDate.CurrentFullDate();
		currentHour = calculationDate.CurrentHour();
		
		int min = Integer.parseInt(calculationDate.CurrentMinute());
		
		if(min <= 15) {
			issueDate = calculationDate.CurrentDateMinuteAgo(currentDate, "MINUS", 1 * 60);
			
		} else {
			issueDate = currentDate;
		}
		
		try{
			log.info("acc: " + acc);
			log.info("step: " + step);
			log.info("dt: " + issueDate.substring(0, 10));
			
			param.put("dt", issueDate.substring(0, 10));
			param.put("acc", acc);
			param.put("step", step);
			
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			liveList = mainContDAO.selectNodeDataLive(param);	
			
			if(step.equals("999")) {
				dataList = mainContDAO.selectNodeDataMax(param);
				
			} else {
				dataList = mainContDAO.selectNodeData(param);	
			}
			
			log.info("dataList.size: " + dataList.size());
			
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("liveList", liveList);
		model.addAttribute("dataList", dataList);
		
		return "jsonView";
	}
	
	
	@RequestMapping(value="/selectNodeDetail.do")
	public String selectNodeDetail(HttpServletRequest req, Model model) throws Exception {
		String acc = req.getParameter("acc")==null?"":req.getParameter("acc");
		String node = req.getParameter("node")==null?"1001":req.getParameter("node");
		
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> param = new HashMap<String, String>();
		
		try{
			log.info("acc: " + acc);
			log.info("node: " + node);
			
			param.put("acc", acc);
			param.put("node", node);
			
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			dataList = mainContDAO.selectNodeDetail(param);
			
			log.info("dataList.size: " + dataList.size());
			
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("dataList", dataList);
		
		return "jsonView";
	}
	
	
	@RequestMapping(value="/selectWaterLevelData.do")
	public String selectWaterLevelData(HttpServletRequest req, Model model) throws Exception {
		String dt = req.getParameter("dt")==null?"":req.getParameter("dt");
		String gid = req.getParameter("gid")==null?"1001":req.getParameter("gid");
		String dt24H = "";
		
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> param = new HashMap<String, String>();
		
		try{
			log.info("dt: " + dt);
			log.info("gid: " + gid);
			
			CalculationDate calculationDate = new CalculationDate();
			dt24H = calculationDate.CurrentDateMinuteAgo(dt + "00", "MINUS", 24 * 60).substring(0, 10) + "00";
			
			param.put("dt24H", dt24H);
			///log.info("issueDate: " + issueDate.substring(0, 10));
			
			//param.put("dt0H", issueDate.substring(0, 10));
			//param.put("dt1H", calculationDate.CurrentDateMinuteAgo(issueDate, "MINUS", 24 * 60).substring(0, 10));
			//param.put("dt2H", calculationDate.CurrentDateMinuteAgo(issueDate, "MINUS", 2 * 60).substring(0, 10));
			
			
			param.put("dt", dt + "00");
			param.put("gid", gid);
			
			log.info("1dt: " + dt + "00");
			log.info("2dt24H: " + calculationDate.CurrentDateMinuteAgo(dt + "00", "MINUS", 24 * 60).substring(0, 10) + "00");
			
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			dataList = mainContDAO.selectWaterLevelData(param);
			
			log.info("dataList.size: " + dataList.size());
			
		}catch(Exception e) {
			log.error(e.toString());
		}
		model.addAttribute("dt24H", dt24H);
		model.addAttribute("dataList", dataList);
		model.addAttribute("dataList", dataList);
		
		return "jsonView";
	}
	
	
	@RequestMapping(value="/selectFloodMapData.do")
	public String selectFloodMapData(HttpServletRequest req, Model model) throws Exception {
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> param = new HashMap<String, String>();
		
		try{
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			dataList = mainContDAO.selectFloodMapData(param);
			
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("dataList", dataList);
		
		return "jsonView";
	}
	
	
	@RequestMapping(value="/selectLandSlideData.do")
	public String selectLandSlideData(HttpServletRequest req, Model model) throws Exception {
		String dt = req.getParameter("dt")==null?"":req.getParameter("dt");
		
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> param = new HashMap<String, String>();
		
		try{
			param.put("dt", dt);
			
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			dataList = mainContDAO.selectLandSlideData(param);
				
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("dataList", dataList);
		
		return "jsonView";
	}
	
	
	@RequestMapping(value="/selectLandSlideDetail.do")
	public String selectLandSlideDetail(HttpServletRequest req, Model model) throws Exception {
		String lsCd = req.getParameter("lsCd")==null?"":req.getParameter("lsCd");
		String dt = req.getParameter("dt")==null?"":req.getParameter("dt");
		
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> param = new HashMap<String, String>();
		
		try{
			param.put("lsCd", lsCd);
			param.put("dt", dt);
			
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			dataList = mainContDAO.selectLandSlideDetail(param);
				
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("dataList", dataList);
		
		return "jsonView";
	}
	
	
	@RequestMapping(value="/selectBasinLevelData.do")
	public String selectBasinLevelData(HttpServletRequest req, Model model) throws Exception {
		String lsCd = req.getParameter("lsCd")==null?"":req.getParameter("lsCd");
		String dt = req.getParameter("dt")==null?"":req.getParameter("dt");
		
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		String fileName = "";
		String resultFile = "";
		String resultText = "";
		
		HashMap<String, String> param = new HashMap<String, String>();
		
		try{
			param.put("lsCd", lsCd);
			param.put("dt", dt);
			param.put("yyyymmdd", dt.substring(0, 8));
			
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			dataList = mainContDAO.selectBasinLevelData(param);
			fileName = mainContDAO.selectKmaDataImage(param);
			
			log.info("yyyymmdd: " + dt.substring(0, 8));
			
			if(fileName == null) {
				resultFile = "http://sk.hecorea.co.kr/images/no_wrng.png";
				resultText = "특보 발표현황 (없음)";
				
			} else {
				String yy = dt.substring(0, 4);
				String mm = dt.substring(4, 6);
				String dd = dt.substring(6, 8);
				
				resultFile = "http://sk.hecorea.co.kr/kma_data_images/" + yy + "/" + mm + "/"  + dd + "/" + fileName;
				
				String[] arr = fileName.split("_");
				
				System.out.println(arr[1]);
				
				
				resultText = "특보 발표현황 (" + arr[1].substring(0, 4) + "." + arr[1].substring(4, 6) + "." + arr[1].substring(6, 8) + " " + arr[1].substring(8, 10) + ":" + arr[1].substring(10, 12) + " 이후)";
			}
			
			log.info("resultFile: " + resultFile);
			
			/*
			URL url = new URL("http://sk.hecorea.co.kr");
			
			BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream()));
			StringBuffer sourceCode = new StringBuffer();
			
			String sourceLine = "";
			
			while((sourceLine = br.readLine()) != null) {
				sourceCode.append(sourceLine + "\n");
				
				System.out.println(sourceCode);
			}
			*/
				
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("dataList", dataList);
		model.addAttribute("resultFile", resultFile);
		model.addAttribute("resultText", resultText);
		
		return "jsonView";
	}
	
	
	@RequestMapping(value="/selectBasinLevelDetail.do")
	public String selectBasinLevelDetail(HttpServletRequest req, Model model) throws Exception {
		String wlobscd = req.getParameter("wlobscd")==null?"":req.getParameter("wlobscd");
		String dt = req.getParameter("dt")==null?"":req.getParameter("dt");
		
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> param = new HashMap<String, String>();
		
		try{
			param.put("wlobscd", wlobscd);
			param.put("dt", dt);
			
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			dataList = mainContDAO.selectBasinLevelDetail(param);
				
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("dataList", dataList);
		
		return "jsonView";
	}
	
	
	@RequestMapping("/selectSubmersionData.do")
	public String submersionData(HttpServletRequest req, Model model) throws Exception {
		String infoId = req.getParameter("infoId")==null?"":req.getParameter("infoId");
		
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> param = new HashMap<String, String>();
		
		try{
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			param.put("infoId", infoId);
			
			dataList = mainContDAO.selectSubmersionData(param);
			
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("dataList", dataList);
		
		return "jsonView";
	}
	
	/*
	@RequestMapping(value="/selectNodeDataLive.do")
	public String selectNodeDataLive(HttpServletRequest req, Model model) throws Exception {
		String dt = req.getParameter("dt")==null?"":req.getParameter("dt");
		//String step = req.getParameter("step")==null?"":req.getParameter("step");
		
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> param = new HashMap<String, String>();
		
		try{
			param.put("dt", dt);
			
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			dataList = mainContDAO.selectNodeDataLive(param);	
			
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("dataList", dataList);
		
		return "jsonView";
	}
	*/
	
}
