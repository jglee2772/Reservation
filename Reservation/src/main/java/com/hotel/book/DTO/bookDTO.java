package com.hotel.book.DTO;

import lombok.Data;

@Data
public class bookDTO {
	int id;
	int roomid;
	String checkin;
	String checkout;
	String roomname;
	String name;
	String mobile;
	int howmany;
	int howmuch;
}
