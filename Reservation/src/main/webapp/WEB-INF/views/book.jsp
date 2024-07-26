<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>객실 예약</title>
</head>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f0f0f0;
        margin: 0;
        padding: 0;
    }

    .container {
        max-width: 1550px;
        margin: 20px auto;
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        overflow: hidden;
    }

    h1 {
        text-align: center;
        margin-bottom: 20px;
        color: #333;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        background-color: #fff;
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
    
    #tblone tbody tr:hover,
    #tblthree tbody tr:hover {
        background-color: #f5f5f5;
    }
    
    
    input[type="date"], input[type="text"], input[type="number"], select, input[type="button"] {
        padding: 8px;
        width: 100%;
        box-sizing: border-box;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 14px;
    }

    input[type="button"] {
        background-color: #4CAF50;
        color: #fff;
        cursor: pointer;
    }

    input[type="button"]:hover {
        background-color: #45a049;
    }
    
   
    .flex-container {
        display: flex;
        justify-content: space-between;
    }

    .column1 {
        flex: 24%;
        padding: 10px;
    }
    
    .column2 {
    	flex: 26%;
        padding: 10px;
    }
    
    .column3 {
    	flex: 50%;
        padding: 10px;
    }

    .column table {
        width: 100%;
        margin-top: 10px;
    }
    

    .column input[type="button"] {
        margin-top: 10px;
    }

    .hidden {
        display: none;
    }
</style>
</head>
<body>
<input type=hidden id=hid>
<div class="container">
    <h1>예약 현황</h1>
    <h4><a href="/">객실 관리</a></h4>
    <div class="flex-container">
        <div class="column1">
            <table id="tblone">
                <thead>
                    <tr><th colspan="4">숙박기관</th></tr>
                    <tr><td colspan="4"><input type="date" id="datea"> ~ <input type="date" id="dateb"></td></tr>
                    <tr><td colspan="4">객실종류</td></tr>
                    <tr><td colspan="4"><select id="roomselect"></select> <input type="button" id="btnser" value="찾기"></td></tr>
                    <tr style="font-size:15px;"><th>객실번호</th><th>객실명</th><th>숙박가능인원</th><th>1박비용</th></tr>
                </thead>
                <tbody style="font-size:13px;">
                </tbody>
            </table>
        </div>
        <div class="column2">
            <table id="tbltwo">
                <tr><td>id</td><td><input type="number" id="twoid" readonly></td></tr>
                <tr><td>객실종류</td><td><input type="text" id="twotype" readonly></td></tr>
                <tr><td>객실명</td><td><input type="text" id="twoname" readonly></td></tr>
                <tr><td>숙박기간</td><td><input type="date" id="twodate1" readonly> ~ <input type="date" id="twodate2" readonly></td></tr>
                <tr><td>예약자명</td><td><input type="text" id="tworealname"></td></tr>
                <tr><td>모바일</td><td><input type="text" id="twomobile"></td></tr>
                <input type="hidden" id="twoprice">
                <tr><td>총숙박비</td><td><input type="number" id="twosum" readonly></td></tr>
                <tr><td>숙박인원</td><td><input type="number" id="twoperson"></td></tr>
                <tr><td colspan="2"><input type="button" id="btntwoon" value="등록"><input type="button" id="btntwocancel" value="삭제"><input type="button" id="btntwoclear" value="비우기"></td></tr>
            </table>
        </div>
        <div class="column3">
            <table id="tblthree">
                <thead>
                    <tr><th>예약번호</th><th>숙박기간</th><th>객실명</th><th>예약자</th><th>모바일</th><th>숙박인원</th><th>숙박비</th></tr>
                </thead>
                <tbody style="font-size:13px;">
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
$(document)
.ready(function(){
	loadRoomtype();
	loadBook();
})
.on('click','#btntwoclear',function(){
	$('#hid').val('');
	$('#twoid').val('');
    $('#twotype').val('');
    $('#twoname').val('');
    $('#twodate1').val('');
    $('#twodate2').val('');
    $('#tworealname').val('');
    $('#twomobile').val('');
    $('#twosum').val('');
    $('#twoperson').val('');
    $('#twoprice').val('');
    $('#datea').val('');
    $('#dateb').val('');
    $('#tblone tbody').empty();
})
.on('click','#btntwocancel',function(){
	let id = $('#twoid').val();
	if(id=='') {
		alert("삭제할 예약번호를 입력해주세요.");
		return false;
	}
	if(!confirm("정말로 삭제하시겠습니까?")) {
		$('#btnclear').trigger('click');
		return false;
	}
	$.ajax({
		url:'/deletebook',type:'post',data:{id:id},dataType:'text',
		success:function(data){
			if(data=='ok') {
				$('#btntwoclear').trigger('click');
				$('#tblone tbody').empty();
				loadBook();
			}
		}
	})
})
.on('click','#btnser', function() {
    let typeid = $('#roomselect').find('option:selected').val();
    let datea = $('#datea').val();
    let dateb = $('#dateb').val();

    loadReservedRooms().then(function(reservedRooms) {
        $.ajax({
            url: '/roomser',
            type: 'post',
            data: { typeid: typeid },
            dataType: 'json',
            success: function(data) {
                $('#tblone tbody').empty();

                data.forEach(function(room) {
                    if (!reservedRooms.includes(room.rname)) {
                        let strn = '<tr>';
                        strn += '<td>' + room.id + '</td><td>' + room.rname + '</td><td>' + room.personal + '</td><td>' + room.price + '</td></tr>';
                        $('#tblone tbody').append(strn);
                    }
                });
            }
        });
    });
})
.on('click','#tblone tbody tr',function(){
	let date1 = $('#datea').val();
	let date2 = $('#dateb').val();
	if(date1==''||date2=='') {
		alert("날짜를 정해주세요.");
		return false;
	}
	let type = $('#roomselect').find('option:selected').text();
	let id = $(this).find("td:eq(0)").text();
	let typename = $(this).find("td:eq(1)").text();
	let price = $(this).find("td:eq(3)").text();
	let datea = new Date(date1);
    let dateb = new Date(date2);
    let datems = Math.abs(dateb - datea);
    let Days = Math.ceil(datems / (1000 * 60 * 60 * 24));
	
	$('#hid').val(id);
	$('#twodate1').val(date1);
	$('#twodate2').val(date2);
	$('#twotype').val(type);
	$('#twoname').val(typename);
	$('#twoprice').val(price);
	$('#twoperson').val(0);
	$('#twosum').val(price*Days);
})
.on('click','#tblthree tbody tr',function(){
	let id = $(this).find("td:eq(0)").text();
	let datea = $(this).find("td:eq(1)").text();
	let dateb = datea.split("~");
	let checkin = dateb[0];
	let checkout = dateb[1];
	let roomname = $(this).find("td:eq(2)").text();
	let name = $(this).find("td:eq(3)").text();
	let mobile = $(this).find("td:eq(4)").text();
	let howmany = $(this).find("td:eq(5)").text();
	let howmuch = $(this).find("td:eq(6)").text();
	$('#twoid').val(id);
	$('#twodate1').val(checkin);
	$('#twodate2').val(checkout);
	$('#twoname').val(roomname);
	$('#tworealname').val(name);
	$('#twomobile').val(mobile);
	$('#twoperson').val(howmany);
	$('#twosum').val(howmuch);
	callType(roomname);
	
})
.on('click','#btntwoon',function(){
	let id = $('#twoid').val();
	let roomid = $('#hid').val();
	let howmany = $('#twoperson').val();
	let howmuch = $('#twosum').val();
	let checkin = $('#twodate1').val();
	let checkout = $('#twodate2').val();
	let name = $('#tworealname').val();
	if(name=='') {
		alert("이름을 입력해주세요.");
		return false;
	}
	let mobile = $('#twomobile').val();
	if(mobile=='') {
		alert("전화번호를 입력해주세요.");
		return false;
	}
	if(howmany==0) {
		alert("인원수를 정해주세요.");
		return false;
	}
	if(id==''||id==null) {
		$.ajax({
			url:'/insertbook',type:'post',data:{roomid:roomid,howmany:howmany,howmuch:howmuch,checkin:checkin,checkout:checkout,name:name,mobile:mobile},dataType:'text',
			success:function(data){
				if(data=="ok") {
					$('#btntwoclear').trigger('click');
					$('#tblone tbody').empty();
					loadBook();
				}
			}
		})
	} else {
		$.ajax({
			url:'/updatebook',type:'post',data:{id:id,roomid:roomid,howmany:howmany,howmuch:howmuch,checkin:checkin,checkout:checkout,name:name,mobile:mobile},dataType:'text',
			success:function(data){
				if(data=='ok'){
					$('#btntwoclear').trigger('click');
					loadBook();
				}
			}
		})
	}
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
function loadBook() {
	$.ajax({
		url:'/loadfuturebook',type:'post',data:{},dataType:'json',
		success:function(data){
			$('#tblthree tbody').empty();
			for(let x of data) {
				strn = '<tr>';
				strn += '<td>'+x['id']+'</td><td>'+x['checkin']+'~'+x['checkout']+'</td><td>'+x['roomname']+'</td><td>'+x['name']+'</td><td>'+x['mobile']+'</td><td>'+x['howmany']+'</td><td>'+x['howmuch']+'</td></tr>';
				$('#tblthree tbody').append(strn);
			}
		}
	})
}
function callType(a) {
	roomname = a;
	$.ajax({
		url:'/loadtwo',type:'post',data:{roomname:roomname},dataType:'text',
		success:function(data){
			$('#twotype').val(data);
		}
	})
}
function loadReservedRooms() {
    return $.ajax({
        url: '/loadbook',
        type: 'post',
        dataType: 'json'
    }).then(function(data) {
        let reservedRooms = [];
        let datea = new Date($('#datea').val());
        let dateb = new Date($('#dateb').val());

        data.forEach(function(book) {
            let checkin = new Date(book.checkin);
            let checkout = new Date(book.checkout);

            // 예약된 날짜가 선택된 날짜 범위 내에 포함되는 방의 이름을 추가
            if ((checkin <= dateb && checkout >= datea) || 
                (checkin <= datea && checkout >= datea) || 
                (checkin <= dateb && checkout >= dateb)) {
                reservedRooms.push(book.roomname);
            }
        });
        
        return reservedRooms;
    });
}
</script>
</html>