package mypage.service;

import java.sql.Connection;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.util.ConnectionProvider;

import mypage.domain.WishListDTO;
import mypage.persistence.WishListDAO;

public class WishListService {

    private WishListService() {}
    private static WishListService instance = new WishListService();
    public static WishListService getInstance() { return instance; }

    private WishListDAO dao = WishListDAO.getInstance();

    // 1) 유저 위시리스트 목록 조회
    public List<WishListDTO> getWishList(int userNumber) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return dao.selectWishListByUser(conn, userNumber);
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // ✅ 2) 위시리스트 추가 (SIZE_TEXT 저장 포함)
    public void addWish(int userNumber, String productId, String sizeText) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            if (sizeText == null) sizeText = "";
            dao.insertWish(conn, userNumber, productId, sizeText); // ✅ 오버로드 탄다
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 기존 호환용 (혹시 다른 곳에서 호출하면 NPE 안 나게)
    public void addWish(int userNumber, String productId) {
        addWish(userNumber, productId, "");
    }

    // 3) 단건 삭제
    public void deleteOne(int userNumber, int wishlistId) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            dao.deleteOne(conn, userNumber, wishlistId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 4) 선택 삭제
    public void deleteSelected(int userNumber, List<Integer> ids) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            dao.deleteSelected(conn, userNumber, ids);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5) 찜 취소(삭제) - product_id로
    public void deleteByProduct(int userNumber, String productId) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            dao.deleteByProduct(conn, userNumber, productId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
	// 6) 상세페이지: 찜 여부
    public boolean isWished(int userNumber, String productId) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return dao.existsByProduct(conn, userNumber, productId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
	
    // 7) 메인/리스트용: 찜 상품ID Set
    public Set<String> getWishedSet(int userNumber) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return new HashSet<>(dao.selectWishedProductIds(conn, userNumber));
        } catch (Exception e) {
            e.printStackTrace();
            return new HashSet<>();
        }
    }
    
    // 8) 찜 토글 (있으면 삭제, 없으면 추가)
    public boolean toggleWished(int userNumber, String productId, String sizeText) {
        try (Connection conn = ConnectionProvider.getConnection()) {

            boolean exists = dao.existsByProduct(conn, userNumber, productId);

            if (exists) {
                dao.deleteByProduct(conn, userNumber, productId);
                return false;
            } else {
                // ✅ [유지/확인] sizeText가 빈값이면 null로 저장되게
                if (sizeText == null || sizeText.trim().isEmpty()) sizeText = null;
                dao.insertWish(conn, userNumber, productId, sizeText); // null 들어가면 DB에도 NULL
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 기존 코드 호환용(너 Handler가 아직 2개짜리 호출해도 살려줌)
    public boolean toggleWished(int userNumber, String productId) {
        return toggleWished(userNumber, productId, "미선택");
    }
    
}