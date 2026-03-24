package com.japansport;

import java.sql.SQLException;
import java.util.List;

public interface IDAO<T> {
    List<T> getAll();
    T getById(int id);
    void save(T t);
    void delete(T t);
    int insert(T t) throws SQLException;
    int update(T t);
    int inserts(List<T> t);
}
