package fila.review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import fila.com.util.ConnectionProvider;
import fila.com.util.JdbcUtil;

public class ReviewDAOImpl implements ReviewDAO {

	private static ReviewDAOImpl instance = new ReviewDAOImpl();
	private ReviewDAOImpl() {} 
	public static ReviewDAOImpl getInstance() {
		return instance;
	}
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	

    // 생성자
    public ReviewDAOImpl(Connection conn) {
        this.conn = conn;
    }

    // 1. 리뷰 등록 기능
    @Override
    public int insert(ReviewDTO dto) throws SQLException {
        int result = 0;
        String sql = " INSERT INTO review ( " +
                     "    review_id, product_id, user_number, content, rating, review_img, created_at " + 
                     " ) VALUES ( " +
                     "    seq_review.nextval, ?, ?, ?, ?, ?, SYSDATE " + 
                     " ) ";

        try {
            pstmt = conn.prepareStatement(sql);
            
            // 물음표 순서대로 값 채우기
            pstmt.setString(1, dto.getProduct_id());
            pstmt.setInt(2, dto.getUser_number());
            pstmt.setString(3, dto.getContent());
            pstmt.setInt(4, dto.getRating());
            
            // [핵심] 여기가 빠져있으면 DB에 null로 들어갑니다!
            pstmt.setString(5, dto.getReview_img()); 

            result = pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("> ReviewDAOImpl.insert 에러: " + e.getMessage());
            e.printStackTrace(); // 에러나면 콘솔에 빨간 줄 띄우기
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        }
        return result;
    }

    // 2. 리뷰 목록 조회 (필터링) 기능
    @Override
 	// [중요] 괄호 안에 int userNumber가 반드시 있어야 합니다!
    public List<ReviewDTO> selectListByFilter(String productId, String[] ratingArr, int userNumber, String sort, String keyword) {
     List<ReviewDTO> list = new ArrayList<>();
     StringBuilder sql = new StringBuilder();

     sql.append(" SELECT r.review_id, r.product_id, r.user_number, r.content, r.rating, r.review_img, r.created_at, ");
     sql.append("        u.id as user_id, ");
     sql.append("        (SELECT COUNT(*) FROM review_like l WHERE l.review_id = r.review_id AND l.type = 1) as like_cnt, ");
     sql.append("        (SELECT COUNT(*) FROM review_like l WHERE l.review_id = r.review_id AND l.type = 0) as dislike_cnt, ");
     // [추가] 내 좋아요 상태 체크
     sql.append("        (SELECT type FROM review_like l WHERE l.review_id = r.review_id AND l.user_number = ?) as my_like ");
     sql.append(" FROM review r ");
     sql.append(" JOIN users u ON r.user_number = u.user_number ");
     sql.append(" WHERE r.product_id = ? ");

  // [1] 별점 필터
     if (ratingArr != null && ratingArr.length > 0) {
         sql.append(" AND r.rating IN (");
         for (int i = 0; i < ratingArr.length; i++) {
             sql.append("?"); 
             if (i < ratingArr.length - 1) sql.append(", ");
         }
         sql.append(") ");
     }
     
     // [2] 검색어 필터
     if (keyword != null && !keyword.trim().equals("")) {
         sql.append(" AND r.content LIKE ? ");
     }

     // [3] 정렬 로직 (이것 하나만 남겨야 합니다!)
     sql.append(" ORDER BY ");
     
     // 3-1. '포토 우선'이면 사진 있는 걸 맨 위로 (우선순위 0순위)
     if ("photo".equals(sort) || "photo_rate".equals(sort)) {
         sql.append(" (CASE WHEN r.review_img IS NOT NULL THEN 0 ELSE 1 END) ASC, ");
     }
     
     // 3-2. 그 다음 정렬 기준 (별점순 vs 최신순)
     if ("rate".equals(sort) || "photo_rate".equals(sort)) {
         // 별점 높은순 -> 그 다음 최신순
         sql.append(" r.rating DESC, r.created_at DESC ");
     } else {
         // 기본: 최신순
         sql.append(" r.created_at DESC ");
     }

     try {
         pstmt = conn.prepareStatement(sql.toString());
         int pIndex = 1;
         
         // [중요] 첫 번째 물음표가 userNumber입니다.
         pstmt.setInt(pIndex++, userNumber); 
         pstmt.setString(pIndex++, productId);

         if (ratingArr != null && ratingArr.length > 0) {
             for (String r : ratingArr) {
                 pstmt.setInt(pIndex++, Integer.parseInt(r));
             }
         }

         // 검색어 바인딩
         if (keyword != null && !keyword.trim().equals("")) {
             pstmt.setString(pIndex++, "%" + keyword + "%"); // 앞뒤로 % 붙여서 부분일치 검색
         }
         
         rs = pstmt.executeQuery();

         while (rs.next()) {
             ReviewDTO dto = new ReviewDTO();
             dto.setReview_id(rs.getInt("review_id"));
             dto.setProduct_id(rs.getString("product_id"));
             dto.setUser_number(rs.getInt("user_number"));
             dto.setContent(rs.getString("content"));
             dto.setRating(rs.getInt("rating"));
             dto.setReview_img(rs.getString("review_img"));
             dto.setRegdate(rs.getDate("created_at"));
             dto.setUser_id(rs.getString("user_id"));
             dto.setLike_cnt(rs.getInt("like_cnt"));
             dto.setDislike_cnt(rs.getInt("dislike_cnt"));

             // 내 좋아요 상태 담기
             if (rs.getObject("my_like") != null) {
                 dto.setMyLike(rs.getInt("my_like"));
             } else {
                 dto.setMyLike(-1);
             }
             list.add(dto);
         }
     } catch (Exception e) {
         System.out.println("> ReviewDAOImpl.selectListByFilter 에러");
         e.printStackTrace();
     } finally {
         if (rs != null) try { rs.close(); } catch (Exception e) {}
         if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
     }
     return list;
 }
    
    @Override
    public Map<String, Object> getReviewSummary(String productId) throws Exception {
        Map<String, Object> summary = new HashMap<>();
        String sql = "SELECT COUNT(*) as total_cnt, " +
                     "       NVL(AVG(rating), 0) as avg_score, " +
                     "       COUNT(CASE WHEN rating = 5 THEN 1 END) as best_cnt " +
                     "FROM review WHERE product_id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int total = rs.getInt("total_cnt");
                    double avg = rs.getDouble("avg_score");
                    int best = rs.getInt("best_cnt");
                    // 아주 좋아요 비율 계산 (5점 개수 / 전체 개수 * 100)
                    int bestRate = (total > 0) ? (int)((double)best / total * 100) : 0;

                    summary.put("total_cnt", total);
                    summary.put("avg_score", avg);
                    summary.put("best_rate", bestRate);
                }
            }
        }
        return summary;
    }
    
    // 도움돼요, 도움안돼요 버튼
    public int insertReviewLike(int reviewId, int userNumber, int type) throws Exception {
        // 이미 해당 리뷰에 대해 액션을 취했는지 확인 (중복 방지)
        String checkSql = "SELECT COUNT(*) FROM review_like WHERE review_id = ? AND user_number = ?";
        String insertSql = "INSERT INTO review_like (like_id, review_id, user_number, type) VALUES (seq_review_like.NEXTVAL, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
            pstmt.setInt(1, reviewId);
            pstmt.setInt(2, userNumber);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return -1; // 이미 참여함
            }
        }

        try (PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
            pstmt.setInt(1, reviewId);
            pstmt.setInt(2, userNumber);
            pstmt.setInt(3, type);
            return pstmt.executeUpdate(); // 1 성공
        }
    }
    
    @Override
    public boolean isPurchased(int userNumber, String productId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean canReview = false;

        try {
            conn = ConnectionProvider.getConnection();

            // ---------------------------------------------------------
            // 1단계: '배송완료'된 주문 건수가 몇 개인지 조회
            // ---------------------------------------------------------
            String buySql = " SELECT COUNT(*) "
                          + " FROM ORDERS o "
                          + " JOIN ORDER_ITEMS oi ON o.ORDER_ID = oi.ORDER_ID "
                          + " WHERE o.USER_NUMBER = ? "
                          + "   AND oi.PRODUCT_ID = ? "
                          + "   AND o.ORDER_STATUS = '배송완료' "; // '배송완료'만 허용

            pstmt = conn.prepareStatement(buySql);
            pstmt.setInt(1, userNumber);
            pstmt.setString(2, productId);
            rs = pstmt.executeQuery();

            int buyCount = 0;
            if (rs.next()) {
                buyCount = rs.getInt(1);
            }
            
            // 자원 해제 후 재사용
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);

            // ---------------------------------------------------------
            // 2단계: 이미 작성한 리뷰 건수가 몇 개인지 조회
            // ---------------------------------------------------------
            String reviewSql = " SELECT COUNT(*) FROM REVIEW "
                             + " WHERE USER_NUMBER = ? AND PRODUCT_ID = ? ";
            
            pstmt = conn.prepareStatement(reviewSql);
            pstmt.setInt(1, userNumber);
            pstmt.setString(2, productId);
            rs = pstmt.executeQuery();

            int reviewCount = 0;
            if (rs.next()) {
                reviewCount = rs.getInt(1);
            }

            // ---------------------------------------------------------
            // 3단계: 주문 횟수가 리뷰 횟수보다 많을 때만 작성 가능 (1주문 1리뷰)
            // ---------------------------------------------------------
            if (buyCount > reviewCount) {
                canReview = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
            JdbcUtil.close(conn);
        }
        return canReview;
    }
    
}