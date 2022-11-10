package kr.co.hecorea.smartuf.main.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
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
@RequestMapping("/flood/*")
public class MainController {
	
	@Autowired
	@Resource(name="sqlMySession")
	private SqlSession sqlSession;
	
	@Autowired
	HttpSession session;
	
	@Value("#{config['geoserverPath']}") String geoserverPath;
	
	private final Logger log = Logger.getLogger(getClass());
	
	
	
	/**
	 * 강우실황
	 * @return String
	 * @throws Exception
	*/
	@RequestMapping("/rainfall.do")
	public String rainfall(Model model) throws Exception {
		String currentDate = "";
		String currentHour = "";
		String issueDate = "";
		
		try {
			CalculationDate calculationDate = new CalculationDate();
			currentDate = calculationDate.CurrentFullDate();
			currentHour = calculationDate.CurrentHour();
			
			int min = Integer.parseInt(calculationDate.CurrentMinute());
			
			if(min <= 15) {
				issueDate = calculationDate.CurrentDateMinuteAgo(currentDate, "MINUS", 1 * 60);
				
			} else {
				issueDate = currentDate;
			}
			
		} catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("issueDate", issueDate);
		model.addAttribute("currentDate", currentDate);
		model.addAttribute("issueHour", issueDate.substring(8, 10));
		
		return "main/01/rainfall";
	}
	
	
	/**
	 * 예측강우
	 * @return String
	 * @throws Exception
	*/
	@RequestMapping("/forecastRainfall.do")
	public String forecastRainfall(Model model) throws Exception {
		String currentDate = "";
		String currentHour = "";
		String issueDate = "";
		
		try {
			CalculationDate calculationDate = new CalculationDate();
			currentDate = calculationDate.CurrentFullDate();
			currentHour = calculationDate.CurrentHour();
			
			int min = Integer.parseInt(calculationDate.CurrentMinute());
			
			if(min <= 15) {
				issueDate = calculationDate.CurrentDateMinuteAgo(currentDate, "MINUS", 1 * 60);
				
			} else {
				issueDate = currentDate;
			}
			
		} catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("issueDate", issueDate);
		model.addAttribute("currentDate", currentDate);
		model.addAttribute("issueHour", issueDate.substring(8, 10));
		
		return "main/02/forecastRainfall";
	}
	
	
	/**
	 * 1차원홍수정보
	 * @return String
	 * @throws Exception
	*/
	@RequestMapping("/floodLive.do")
	public String floodLive(Model model) throws Exception {
		String currentDate = "";
		String currentHour = "";
		String issueDate = "";
		
		try {
			CalculationDate calculationDate = new CalculationDate();
			currentDate = calculationDate.CurrentFullDate();
			currentHour = calculationDate.CurrentHour();
			
			int min = Integer.parseInt(calculationDate.CurrentMinute());
			
			if(min <= 15) {
				issueDate = calculationDate.CurrentDateMinuteAgo(currentDate, "MINUS", 1 * 60);
				
			} else {
				issueDate = currentDate;
			}
			
		} catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("issueDate", issueDate);
		
		return "main/03/floodLive";
	}
	
	/**
	 * 1차원홍수정보
	 * @return String
	 * @throws Exception
	*/
	@RequestMapping("/floodInfo.do")
	public String floodInfo(Model model) throws Exception {
		try {
			
		} catch(Exception e) {
			log.error(e.toString());
		}
		
		return "main/03/floodInfo";
	}
	
	
	/**
	 * 1차원홍수정보
	 * @return String
	 * @throws Exception
	*/
	@RequestMapping("/floodLiveB.do")
	public String floodInfoB(Model model) throws Exception {
		String currentDate = "";
		String currentHour = "";
		String issueDate = "";
		
		try {
			CalculationDate calculationDate = new CalculationDate();
			currentDate = calculationDate.CurrentFullDate();
			currentHour = calculationDate.CurrentHour();
			
			int min = Integer.parseInt(calculationDate.CurrentMinute());
			
			if(min <= 15) {
				issueDate = calculationDate.CurrentDateMinuteAgo(currentDate, "MINUS", 1 * 60);
				
			} else {
				issueDate = currentDate;
			}
			
		} catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("issueDate", issueDate);
		
		return "main/03/floodLiveb";
	}
	
	
	/**
	 * 2차원침수정보
	 * @return String
	 * @throws Exception
	*/
	@RequestMapping("/submersionInfo.do")
	public String submersionInfo(HttpServletRequest req, Model model) throws Exception {
		ArrayList<HashMap<String, String>> dataList = new ArrayList<HashMap<String, String>>();
		
		try{
			MainContDAO mainContDAO = sqlSession.getMapper(MainContDAO.class);
			dataList = mainContDAO.selectSubmersionInfo();
			
			log.info("dataList.size: " + dataList.size());
			
		}catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("geoserverPath", geoserverPath);
		model.addAttribute("dataList", dataList);
		
		return "main/04/submersionInfo";
	}
	
	
	/**
	 * 수위실황
	 * @return String
	 * @throws Exception
	*/
	@RequestMapping("/waterlevel.do")
	public String waterlevel(Model model) throws Exception {
		String currentDate = "";
		String currentHour = "";
		String issueDate = "";
		
		try {
			CalculationDate calculationDate = new CalculationDate();
			currentDate = calculationDate.CurrentFullDate();
			currentHour = calculationDate.CurrentHour();
			
			int min = Integer.parseInt(calculationDate.CurrentMinute());
			
			log.info(min);
			
			if(min <= 15) {
				issueDate = calculationDate.CurrentDateMinuteAgo(currentDate, "MINUS", 1 * 60);
				
			} else {
				issueDate = currentDate;
			}
			
			log.info(issueDate);
			
		} catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("issueDate", issueDate);
		model.addAttribute("currentDate", currentDate);
		model.addAttribute("issueHour", issueDate.substring(8, 10));
		
		return "main/05/waterlevel";
	}
	
	
	/**
	 * 하천수위실황
	 * @return String
	 * @throws Exception
	*/
	@RequestMapping("/basinlevel.do")
	public String basinlevel(Model model) throws Exception {
		String currentDate = "";
		String currentHour = "";
		String issueDate = "";
		
		try {
			CalculationDate calculationDate = new CalculationDate();
			currentDate = calculationDate.CurrentFullDate();
			currentHour = calculationDate.CurrentHour();
			
			int min = Integer.parseInt(calculationDate.CurrentMinute());
			
			log.info(min);
			
			if(min <= 15) {
				issueDate = calculationDate.CurrentDateMinuteAgo(currentDate, "MINUS", 20);
				
			} else {
				issueDate = calculationDate.CurrentDateMinuteAgo(currentDate, "MINUS", 20);
			}
			
			log.info(issueDate);
			
		} catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("issueDate", issueDate);
		model.addAttribute("currentDate", currentDate);
		model.addAttribute("issueHour", issueDate.substring(8, 10));
		model.addAttribute("issueMin", issueDate.substring(10, 11));
		
		return "main/05/basinlevel";
	}
	
	
	/**
	 * 홍수취약성지도
	 * @return String
	 * @throws Exception
	*/
	@RequestMapping("/floodMap.do")
	public String floodMap(Model model) throws Exception {
		try {
			
		} catch(Exception e) {
			log.error(e.toString());
		}
		
		return "main/06/floodMap";
	}
	
	
	/**
	 * 산사태예경보
	 * @return String
	 * @throws Exception
	*/
	@RequestMapping("/landSlide.do")
	public String landSlide(Model model) throws Exception {
		String currentDate = "";
		String issueDate = "";
		
		try {
			CalculationDate calculationDate = new CalculationDate();
			currentDate = calculationDate.CurrentFullDate();
			
			int min = Integer.parseInt(calculationDate.CurrentMinute());
			
			if(min <= 20) {
				issueDate = calculationDate.CurrentDateMinuteAgo(currentDate, "MINUS", 2 * 60);
				
			} else {
				issueDate = calculationDate.CurrentDateMinuteAgo(currentDate, "MINUS", 1 * 60);
			}
			
		} catch(Exception e) {
			log.error(e.toString());
		}
		
		model.addAttribute("issueHour", issueDate.substring(8, 10));
		model.addAttribute("issueDate", issueDate);
		return "main/07/landSlide";
	}
	
}
