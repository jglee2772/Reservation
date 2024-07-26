package com.hotel.book.DAO;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import com.hotel.book.DTO.bookDTO;
import com.hotel.book.DTO.roomDTO;
import com.hotel.book.DTO.roomtypeDTO;

@Mapper
public interface RoomDAO {
	ArrayList<roomtypeDTO> getTypeList();
	void insertRoom(String a, int b, int c, int d);
	ArrayList<roomDTO> getRoomList();
	void deleteRoom(int a);
	void updateRoom(int a, String b, int c, int d, int e);
	ArrayList<roomDTO> getSelect(int a);
	void insertBook(int a, int b, int c, String d, String e, String f, String g);
	ArrayList<bookDTO> getBookList();
	roomDTO typeName(String a);
	void deleteBook(int a);
	bookDTO dateSum(int a);
	ArrayList<bookDTO> getFutureBookList();
}
