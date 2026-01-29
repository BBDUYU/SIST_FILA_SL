package productsqna;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

public class QnaDAOImpl implements QnaDAO {

    // 싱글톤 패턴 (필요 없으면 제거하고 일반 객체로 쓰셔도 됨)
    private static QnaDAOImpl instance = new QnaDAOImpl();
    private QnaDAOImpl() {}
    public static QnaDAOImpl getInstance() {
        return instance;
    }

    // 1. 상품 문의 등록
    @Override
    public int insert(QnaDTO dto) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            conn = ConnectionProvider.getConnection();
            
            // [SQL] 컬럼명은 DB 테이블에 맞게 수정해주세요.
            // qna_id는 시퀀스 사용, status는 기본값 'WAITING', 날짜는 SYSDATE
            String sql = " INSERT INTO qna ( "
                       + "     qna_id, product_id, user_number, type, "
                       + "     question, is_secret, status, created_at "
                       + " ) VALUES ( "
                       + "     seq_qna.nextval, ?, ?, ?, "
                       + "     ?, ?, 'WAITING', SYSDATE "
                       + " ) ";

            pstmt = conn.prepareStatement(sql);

            // 매개변수 바인딩 (DTO 타입에 맞춰서)
            pstmt.setString(1, dto.getProduct_id());
            pstmt.setInt(2, dto.getUser_number());  // user_number (int)
            pstmt.setString(3, dto.getType());      // 문의유형
            pstmt.setString(4, dto.getQuestion());  // 질문내용
            pstmt.setInt(5, dto.getIs_secret());    // 비밀글여부 (0 or 1)

            result = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException(e);
        } finally {
            JdbcUtil.close(pstmt);
            JdbcUtil.close(conn);
        }
        return result;
    }

    // 2. 상품 문의 목록 조회 (회원 아이디 JOIN 포함)
    @Override
    public List<QnaDTO> selectList(String productId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<QnaDTO> list = new ArrayList<>();

        try {
            conn = ConnectionProvider.getConnection();

            // [SQL] qna 테이블과 users 테이블을 조인해서 작성자 ID(user_id)까지 가져옴
            // u.id는 users 테이블의 실제 로그인 ID 컬럼명이라고 가정했습니다.
            String sql = " SELECT q.*, u.id AS user_id "
                       + " FROM qna q "
                       + " LEFT JOIN users u ON q.user_number = u.user_number "
                       + " WHERE q.product_id = ? "
                       + " ORDER BY q.qna_id DESC ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productId);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                QnaDTO dto = new QnaDTO();
                
                // QNA 기본 정보 매핑
                dto.setQna_id(rs.getInt("qna_id"));
                dto.setProduct_id(rs.getString("product_id"));
                dto.setUser_number(rs.getInt("user_number"));
                dto.setType(rs.getString("type"));
                dto.setQuestion(rs.getString("question"));
                dto.setAnswer(rs.getString("answer")); // 답변이 없으면 null일 수 있음
                dto.setStatus(rs.getString("status"));
                dto.setIs_secret(rs.getInt("is_secret"));
                dto.setCreated_at(rs.getDate("created_at"));
                dto.setUser_id(rs.getString("user_id")); 
                dto.setAnswered_at(rs.getTimestamp("answered_at"));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException(e);
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
            JdbcUtil.close(conn);
        }
        return list;
    }
    
    // 3. 관리자용 전체 목록 조회 (Exception 추가로 NamingException 해결)
    @Override
    public List<QnaDTO> selectAdminQnaList() throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<QnaDTO> list = new ArrayList<>();
        
        String sql = "SELECT q.*, u.name FROM qna q " +
                     "JOIN users u ON q.user_number = u.user_number " +
                     "ORDER BY q.qna_id DESC"; 
        
        try {
            conn = ConnectionProvider.getConnection(); 
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                QnaDTO dto = new QnaDTO();
                dto.setQna_id(rs.getInt("qna_id"));
                dto.setType(rs.getString("type"));
                dto.setProduct_id(rs.getString("product_id"));
                dto.setName(rs.getString("name"));
                dto.setUser_number(rs.getInt("user_number")); 
                dto.setQuestion(rs.getString("question"));
                dto.setAnswer(rs.getString("answer"));
                dto.setIs_secret(rs.getInt("is_secret"));
                dto.setCreated_at(rs.getTimestamp("created_at"));
                list.add(dto);
            }
        } finally {
            JdbcUtil.close(rs); JdbcUtil.close(pstmt); JdbcUtil.close(conn);
        }
        return list;
    }

    // 4. 상세 조회
    @Override
    public QnaDTO selectQnaDetail(int qnaId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        QnaDTO dto = null;
        
        String sql = "SELECT q.*, u.name FROM qna q " +
                     "JOIN users u ON q.user_number = u.user_number " +
                     "WHERE q.qna_id = ?";
        
        try {
            conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, qnaId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                dto = new QnaDTO();
                dto.setQna_id(rs.getInt("qna_id"));
                dto.setType(rs.getString("type"));
                dto.setProduct_id(rs.getString("product_id"));
                dto.setName(rs.getString("name"));
                dto.setUser_number(rs.getInt("user_number"));
                dto.setQuestion(rs.getString("question"));
                dto.setAnswer(rs.getString("answer"));
                dto.setIs_secret(rs.getInt("is_secret"));
                dto.setCreated_at(rs.getTimestamp("created_at"));
            }
        } finally {
            JdbcUtil.close(rs); JdbcUtil.close(pstmt); JdbcUtil.close(conn);
        }
        return dto;
    }

    // 5. 답변 저장
    @Override
    public int updateAnswer(int qnaId, String answer) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE qna SET answer = ?, status = 'COMPLETE', answered_at = SYSDATE WHERE qna_id = ?";
        try {
            conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, answer);
            pstmt.setInt(2, qnaId);
            return pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt); JdbcUtil.close(conn);
        }
    }
    
}