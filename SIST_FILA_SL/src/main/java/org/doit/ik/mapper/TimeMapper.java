package org.doit.ik.mapper;

import org.apache.ibatis.annotations.Select;

public interface TimeMapper {
	String getTime();
	// TimeMapper.xml
	
	@Select("SELECT sysdate+1 FROM dual")
	String getNextTime();
}
