package notice;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NoticeDTO {
	
	private int notice_id;
	private String category_name;
	private String title;
	private String created_id;
	private Date created_at;
	private String updated_id;
	private Date updated_at;
	private String image_url;
	
}