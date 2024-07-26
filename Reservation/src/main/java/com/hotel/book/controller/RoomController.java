package com.hotel.book.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Set;
import java.util.stream.Collectors;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hotel.book.DAO.RoomDAO;
import com.hotel.book.DTO.bookDTO;
import com.hotel.book.DTO.roomDTO;
import com.hotel.book.DTO.roomtypeDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class RoomController {
	@Autowired RoomDAO rdao;
	
	@GetMapping("/")
	public String room() {
		return "room";
	}
	@PostMapping("/roomtype")
	@ResponseBody
	public String roomtype(HttpServletRequest req) {
		ArrayList<roomtypeDTO> arRoom = rdao.getTypeList();
		JSONArray ra = new JSONArray();
		for(roomtypeDTO rdto : arRoom) {
			JSONObject ro = new JSONObject();
			ro.put("id", rdto.getId());
			ro.put("typename", rdto.getTypename());
			ra.put(ro);
		}
		return ra.toString();
	}
	@PostMapping("/insertroom")
	@ResponseBody
	public String insertroom(HttpServletRequest req) {
		String name = req.getParameter("name");
		int type = Integer.parseInt(req.getParameter("type"));
		int personal = Integer.parseInt(req.getParameter("personal"));
		int price = Integer.parseInt(req.getParameter("price"));
		rdao.insertRoom(name, type, personal, price);
		return "ok";
	}
	@PostMapping("/updateroom")
	@ResponseBody
	public String updateroom(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		String name = req.getParameter("name");
		int type = Integer.parseInt(req.getParameter("type"));
		int personal = Integer.parseInt(req.getParameter("personal"));
		int price = Integer.parseInt(req.getParameter("price"));
		rdao.updateRoom(id, name, type, personal, price);
		return "ok";
	}
	@PostMapping("/loadroom")
	@ResponseBody
	public String loadroom(HttpServletRequest req) {
		ArrayList<roomDTO> arRoom = rdao.getRoomList();
		JSONArray ra = new JSONArray();
		for(roomDTO rdto : arRoom) {
			JSONObject ro = new JSONObject();
			ro.put("id", rdto.getId());
			ro.put("typename", rdto.getTypename());
			ro.put("name", rdto.getName());
			ro.put("personal", rdto.getPersonal());
			ro.put("price", rdto.getPrice());
			ra.put(ro);
		}
		return ra.toString();
	}
	@PostMapping("/deleteroom")
	@ResponseBody
	public String deleteroom(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		rdao.deleteRoom(id);
		return "ok";
	}
	@GetMapping("/book")
	public String book() {
		return "book";
	}
	@PostMapping("/roomser")
	@ResponseBody
	public String roomser(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("typeid"));
		ArrayList<roomDTO> arRoom = rdao.getSelect(id);
		JSONArray ra = new JSONArray();
		for(roomDTO rdto : arRoom) {
			JSONObject ro = new JSONObject();
			ro.put("id", rdto.getId());
			ro.put("rname", rdto.getName());
			ro.put("personal", rdto.getPersonal());
			ro.put("price", rdto.getPrice());
			ra.put(ro);
		}
		return ra.toString();
	}
	@PostMapping("/loadbook")
	@ResponseBody
	public String loadbook(HttpServletRequest req) {
		ArrayList<bookDTO> arBook = rdao.getBookList();
		JSONArray ba = new JSONArray();
		for(bookDTO bdto : arBook) {
			JSONObject bo = new JSONObject();
			bo.put("id", bdto.getId());
			bo.put("checkin", bdto.getCheckin());
			bo.put("checkout", bdto.getCheckout());
			bo.put("roomname", bdto.getRoomname());
			bo.put("name", bdto.getName());
			bo.put("mobile", bdto.getMobile());
			bo.put("howmany", bdto.getHowmany());
			bo.put("howmuch", bdto.getHowmuch());
			ba.put(bo);
		}
		return ba.toString();
	}
	@PostMapping("/loadfuturebook")
	@ResponseBody
	public String loadFutureBook(HttpServletRequest req) {
	    ArrayList<bookDTO> arBook = rdao.getFutureBookList();
	    JSONArray ba = new JSONArray();
	    for (bookDTO bdto : arBook) {
	        JSONObject bo = new JSONObject();
	        bo.put("id", bdto.getId());
	        bo.put("checkin", bdto.getCheckin());
	        bo.put("checkout", bdto.getCheckout());
	        bo.put("roomname", bdto.getRoomname());
	        bo.put("name", bdto.getName());
	        bo.put("mobile", bdto.getMobile());
	        bo.put("howmany", bdto.getHowmany());
	        bo.put("howmuch", bdto.getHowmuch());
	        ba.put(bo);
	    }
	    return ba.toString();
	}
	@PostMapping("/loadtwo")
	@ResponseBody
	public String loadtwo(HttpServletRequest req) {
		String name = req.getParameter("roomname");
		roomDTO rdto = rdao.typeName(name);
		return rdto.getTypename();
	}
	@PostMapping("/insertbook")
	@ResponseBody
	public String insertbook(HttpServletRequest req) {
		int roomid = Integer.parseInt(req.getParameter("roomid"));
		int howmany = Integer.parseInt(req.getParameter("howmany"));
		int howmuch = Integer.parseInt(req.getParameter("howmuch"));
		String checkin = req.getParameter("checkin");
		String checkout = req.getParameter("checkout");
		String name = req.getParameter("name");
		String mobile = req.getParameter("mobile");
		rdao.insertBook(roomid, howmany, howmuch, checkin, checkout, name, mobile);
		return "ok";
	}
	@PostMapping("/deletebook")
	@ResponseBody
	public String deletebook(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		rdao.deleteBook(id);
		return "ok";
	}
	@PostMapping("/datesum")
	@ResponseBody
	public String datesum(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		bookDTO rdto = rdao.dateSum(id);
		return rdto.getCheckin();
	}
}
