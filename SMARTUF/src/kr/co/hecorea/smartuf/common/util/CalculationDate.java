package kr.co.hecorea.smartuf.common.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

public class CalculationDate {
	
	//currentDate full
	public String CurrentFullDate() throws Exception { 
		Date now = new Date();
		
		SimpleDateFormat date = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREAN);
		String result = date.format(now);
		
		return result;
	}
	
	//current minute
	public String CurrentMinute() throws Exception { 
		Date now = new Date();
		
		SimpleDateFormat date = new SimpleDateFormat("mm", Locale.KOREAN);
		String result = date.format(now);
		
		return result;
	}
	
	//current hour
	public String CurrentHour() throws Exception { 
		Date now = new Date();
		
		SimpleDateFormat date = new SimpleDateFormat("HH", Locale.KOREAN);
		String result = date.format(now);
		
		return result;
	}

	//currentHour +- hour
	public String CurrentDateAgo(String input, String mode, int value) throws Exception {
		int yyyy= Integer.parseInt(input.substring(0,4));
		int mm = Integer.parseInt(input.substring(4,6));
		int dd = Integer.parseInt(input.substring(6,8));
		int hh = Integer.parseInt(input.substring(8,10));
		int nn = Integer.parseInt(input.substring(10,12));
		
	    String year = "";
	    String month = "";
	    String day = "";
	    String hour = "";
	    String minute = "";

	    SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREAN); 
	    
	    Date date = format.parse(input);
	    Calendar calendar = new GregorianCalendar();
	    
	    calendar.setTime(date);
	    
		if(mode.equals("PLUS")) {
			calendar.add(Calendar.HOUR, value);
		} else if(mode.equals("MINUS")) {
			calendar.add(Calendar.HOUR, -value);
		}
	    
	    SimpleDateFormat format01 = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREAN); 
	    String result = format01.format(calendar.getTime());
		
		return result;
	}
	
	//inputDate Array
	public String[] InputDateArray(String input, String file) throws Exception {
		
		String[] result = new String[7];
		
		int yyyy= Integer.parseInt(input.substring(0,4));
		int mm = Integer.parseInt(input.substring(4,6));
		int dd = Integer.parseInt(input.substring(6,8));
		int hh = Integer.parseInt(input.substring(8,10));
		int nn = Integer.parseInt(input.substring(10,12));
		
	    String year = "";
	    String month = "";
	    String day = "";
	    String hour = "";
	    String minute = "";
	    
	    if(file.equals("Y")) minute = "00";
	    else if(file.equals("N")) minute = "50";
		
    	for(int i=0; i<=6; i++) {
		    SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREAN); 
		    
		    Date date = format.parse(input);
		    Calendar calendar = new GregorianCalendar();
		    
		    calendar.setTime(date);
		    
			calendar.add(Calendar.HOUR, i);
		    
		    SimpleDateFormat format01 = new SimpleDateFormat("yyyyMMddHH", Locale.KOREAN); 
		    result[i] = format01.format(calendar.getTime()) + "" + minute;
		}
	    
		return result;
	}
	
	//currentHour +- minute
	public String CurrentDateMinuteAgo(String input, String mode, int value) throws Exception {
		int yyyy= Integer.parseInt(input.substring(0,4));
		int mm = Integer.parseInt(input.substring(4,6));
		int dd = Integer.parseInt(input.substring(6,8));
		int hh = Integer.parseInt(input.substring(8,10));
		int nn = Integer.parseInt(input.substring(10,12));
		
	    String year = "";
	    String month = "";
	    String day = "";
	    String hour = "";
	    String minute = "";
	    
	    SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREAN); 
	    
	    Date date = format.parse(input);
	    Calendar calendar = new GregorianCalendar();
	    
	    calendar.setTime(date);
	    
		if(mode.equals("PLUS")) {
			calendar.add(Calendar.MINUTE, value);
		} else if(mode.equals("MINUS")) {
			calendar.add(Calendar.MINUTE, -value);
		}
	    
	    SimpleDateFormat format01 = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREAN); 
	    String result = format01.format(calendar.getTime());
	    
	    /*
		GregorianCalendar calendar = new GregorianCalendar(yyyy, mm, dd, hh, nn);
		
		if(mode.equals("PLUS")) {
			calendar.add(calendar.MINUTE, value);
		} else if(mode.equals("MINUS")) {
			calendar.add(calendar.MINUTE, -value); 
		}
		
		year =  Integer.toString(calendar.get(calendar.YEAR));
		
		if(calendar.get(calendar.MONTH) < 10) {
			month = "0" + calendar.get(calendar.MONTH);
		} else {
			month = Integer.toString(calendar.get(calendar.MONTH));
		}
		
		if(calendar.get(calendar.DAY_OF_MONTH) < 10) {
			day = "0" + calendar.get(calendar.DAY_OF_MONTH);
		} else {
			day = Integer.toString(calendar.get(calendar.DAY_OF_MONTH));
		}
		
		if(calendar.get(calendar.HOUR_OF_DAY) < 10) {
			hour = "0" + calendar.get(calendar.HOUR_OF_DAY);
		} else {
			hour = Integer.toString(calendar.get(calendar.HOUR_OF_DAY));
		}
		*/
		
		return result;
	}
	
	
	//currentDay +- hour
	public String CurrentDayAgo(String input, String mode, int value) throws Exception {
		int yyyy= Integer.parseInt(input.substring(0,4));
		int mm = Integer.parseInt(input.substring(4,6));
		int dd = Integer.parseInt(input.substring(6,8));
		
	    String year = "";
	    String month = "";
	    String day = "";

	    SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd", Locale.KOREAN); 
	    
	    Date date = format.parse(input);
	    Calendar calendar = new GregorianCalendar();
	    
	    calendar.setTime(date);
	    
		if(mode.equals("PLUS")) {
			calendar.add(Calendar.DATE, value);
			
		} else if(mode.equals("MINUS")) {
			calendar.add(Calendar.DATE, -value);
		}
	    
	    SimpleDateFormat format01 = new SimpleDateFormat("yyyyMMdd", Locale.KOREAN); 
	    String result = format01.format(calendar.getTime());
		
		return result;
	}
	
	
	//currentDay +- hour
		public String CurrentMonthAgo(String input, String mode, int value) throws Exception {
			int yyyy= Integer.parseInt(input.substring(0,4));
			int mm = Integer.parseInt(input.substring(4,6));
			int dd = Integer.parseInt(input.substring(6,8));
			
		    String year = "";
		    String month = "";
		    String day = "";

		    SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd", Locale.KOREAN); 
		    
		    Date date = format.parse(input);
		    Calendar calendar = new GregorianCalendar();
		    
		    calendar.setTime(date);
		    
			if(mode.equals("PLUS")) {
				calendar.add(Calendar.MONTH, value);
				
			} else if(mode.equals("MINUS")) {
				calendar.add(Calendar.MONTH, -value);
			}
		    
		    SimpleDateFormat format01 = new SimpleDateFormat("yyyyMMdd", Locale.KOREAN); 
		    String result = format01.format(calendar.getTime());
			
			return result;
		}
	
	
}
