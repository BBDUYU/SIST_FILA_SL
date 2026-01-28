package org.doit.ik;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.doit.ik.mapper.TimeMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller
public class TimeMybatisController {
	
	@Autowired
	private TimeMapper timeMapper;
	
	private static final Logger logger = LoggerFactory.getLogger(TimeMybatisController.class);
	

	@RequestMapping(value = "/time", method = RequestMethod.GET)
	public String time(Locale locale, Model model) {
		logger.info("> TimeMybatisContoller.time()");
		
		String currentTime = this.timeMapper.getTime();
		String nextTime = this.timeMapper.getNextTime();
		
		model.addAttribute("currentTime", currentTime );
		model.addAttribute("nextTime", nextTime );
		
		return "time";
	}
	
}
