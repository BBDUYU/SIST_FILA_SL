package fila.admin.persistence;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import fila.admin.domain.CreateproductDTO;

public interface ICreateProduct {
    String generateProductId(Connection conn, int categoryId) throws SQLException;
    int insertProduct(Connection conn, CreateproductDTO dto) throws SQLException;
    int[] insertProductImages(Connection conn, ArrayList<CreateproductDTO> imgList) throws SQLException;
    void insertCategoryRelations(Connection conn, String productId, String[] categoryIds) throws SQLException;
    Map<Integer, List<Map<String, Object>>> selectAllOptions(Connection conn) throws SQLException;
    void insertProductOptions(Connection conn, String productId, String genderOption, String sportOption, String[] sizeOptions) throws SQLException;
    void insertDefaultStock(Connection conn, String productId, String[] sizeOptions) throws SQLException;
}