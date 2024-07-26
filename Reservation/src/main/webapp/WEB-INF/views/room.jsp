<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>객실 관리 시스템</title>
<style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f0f0f0;
        padding: 20px;
    }
    h1 {
        text-align: center;
        color: #333;
    }
    table {
        width: 100%;
        margin-bottom: 20px;
        border-collapse: collapse;
        background-color: #fff;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    th, td {
        padding: 12px;
        text-align: center;
        border: 1px solid #ddd;
    }
    th {
        background-color: #f2f2f2;
        font-weight: bold;
        color: #555;
    }
    tr:hover {
        background-color: #f5f5f5;
    }
    .form-container {
        background-color: #fff;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        margin-bottom: 20px;
        max-width: 600px;
        margin: 0 auto;
        border-radius: 6px;
    }
    .form-container h2 {
        margin-bottom: 15px;
        color: #333;
        text-align: center;
    }
    .form-group {
        margin-bottom: 15px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        color: #666;
    }
    .form-group input[type="text"], 
    .form-group input[type="number"], 
    .form-group select {
        width: 100%;
        padding: 10px;
        font-size: 14px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }
    .form-group input[type="number"] {
        width: calc(50% - 6px);
    }
    .form-group select {
        width: 100%;
    }
    .btn-container {
        text-align: center;
        margin-top: 20px;
    }
    .btn-container button {
        padding: 12px 24px;
        font-size: 14px;
        border: none;
        background-color: #4CAF50;
        color: #fff;
        cursor: pointer;
        border-radius: 4px;
        transition: background-color 0.3s;
    }
    .btn-container button:hover {
        background-color: #45a049;
    }
</style>
</head>
<body>
<input type=hidden id=cid>
<a href='/book'>예약현황</a>
<h1>객실 관리 시스템</h1>
<div class="form-container">
    <h2>객실 정보 입력</h2>
    <div class="form-group">
        <label for="roomselect">객실타입</label>
        <select id="roomselect">
        </select>
    </div>
    <div class="form-group">
        <label for="roomname">객실명</label>
        <input type="text" id="roomname">
    </div>
    <div class="form-group">
        <label for="personal">숙박 가능 인원</label>
        <input type="number" id="personal" min="1"> 명
    </div>
    <div class="form-group">
        <label for="price">1박 요금</label>
        <input type="number" id="price"> 원
    </div>
    <div class="btn-container">
        <button id="btnon">등록</button>
        <button id="btnclear">비우기</button>
        <button id="btncancel">삭제</button>
    </div>
</div>
<br>
<table id="tblRoom">
    <thead>
        <tr>
            <th>id</th>
            <th>타입이름</th>
            <th>객실명</th>
            <th>숙박인원</th>
            <th>가격</th>
        </tr>
    </thead>
    <tbody>
    </tbody>
</table>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
$(document)
.ready(function(){
	loadRoomtype();
	loadRoom();
})
.on('click','#btnclear', function(){
	$('#roomname').val('');
	$('#personal').val(null);
	$('#price').val(null);
	$('#cid').val('');
})
.on('click','#btncancel',function(){
	let id = $('#cid').val();
	if(id==''||id==null) {
		alert("객실정보를 입력하세요.");
		return false;
	}
	if(!confirm("정말로 삭제하시겠습니까?")) {
		$('#btnclear').trigger('click');
		return false;
	}
	$.ajax({
		url:'/deleteroom',type:'post',data:{id:id},dataType:'text',
		success:function(data) {
			if(data=='ok') {
				$('#btnclear').trigger('click');
				loadRoom();
			}
		}
	})
})
.on('click','#btnon',function(){
	let id = $('#cid').val();
	let typenum = $('#roomselect').find('option:selected').val();
	let name = $('#roomname').val();
	let personal = $('#personal').val();
	let price = $('#price').val();
	if(name==''||personal==''||price=='') {
		alert("내용을 입력해주세요.");
		return false;
	}
	if(id==''||id==null) {
		$.ajax({
			url:'/insertroom',type:'post',data:{type:typenum,name:name,personal:personal,price:price},dataType:'text',
			success:function(data){
				if(data=='ok') {
					$('#btnclear').trigger('click');
					loadRoom();
				}
			}
		})
	} else {
		$.ajax({
			url:'/updateroom',type:'post',data:{id:id,type:typenum,name:name,personal:personal,price:price},dataType:'text',
			success:function(data) {
				if(data=='ok') {
					$('#btnclear').trigger('click');
					loadRoom();
				}
			}
		})
	}
	return false;
})
.on('click','#tblRoom tbody tr',function(){
	let id=$(this).find('td:eq(0)').text();
	let typename=$(this).find('td:eq(1)').text();
	let name=$(this).find('td:eq(2)').text();
	let personal=$(this).find('td:eq(3)').text();
	let price=$(this).find('td:eq(4)').text();
	$('#cid').val(id);
	$('#roomselect option').each(function() {
        if ($(this).text() == typename) {
            $(this).prop('selected', true);
        }
    });
	$('#roomname').val(name);
	$('#personal').val(personal);
	$('#price').val(price);
})
;
function loadRoomtype() {
	$.ajax({
		url:'/roomtype',type:'post',data:{},dataType:'json',
		success:function(data){
			$('#roomselect').empty();
			for(let x of data) {
				strn = '<option value='+x["id"]+'>'+x["typename"]+'</option>';
				$('#roomselect').append(strn);
			}
		}
	})
	return false;
}
function loadRoom() {
	$.ajax({
		url:'/loadroom',type:'post',data:{},dataType:'json',
		success:function(data){
			$('#tblRoom tbody').empty();
			for(let x of data){
				let strm = '<tr>';
				strm+='<td>'+x['id']+'</td><td>'+x['typename']+'</td><td>'+x['name']+'</td><td>'+x['personal']+'</td><td>'+x['price']+'</td></tr>';
				$('#tblRoom tbody').append(strm);
			}
		}
	})
	return false;
}
</script>
</html>