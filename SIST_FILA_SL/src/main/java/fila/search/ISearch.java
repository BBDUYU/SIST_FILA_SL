package fila.search;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import fila.search.SearchDTO;

public interface ISearch {
	void upsertKeyword(String keyword);
	ArrayList<SearchDTO> selectTopKeywords(int limit);

}