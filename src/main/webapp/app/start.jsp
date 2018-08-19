<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Start Game</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <script src="https://www.w3schools.com/lib/w3.js"></script>
</head>
<body onload="drawTopTable();" class="w3-container">
<button type="button" onclick="logout()">Log out</button>
<button type="button" onclick="startGame()">Start Game</button>

<h2>Top-10 Results</h2>

<table id="topTable" class="w3-table-all">
    <tr>
        <th>N</th>
        <th>Player</th>
        <th>Move Count</th>
    </tr>
    <tr w3-repeat="players">
        <td>{{place}}</td>
        <td>{{userName}}</td>
        <td>{{hitCount}}</td>
    </tr>
</table>

<script>
    function logout() {
        fetch("<c:url value='/api/auth/logout'/>", {"method": "POST"})
            .then(function (response) {
                location.href = "/";
            });
    }
    function startGame() {
        fetch("<c:url value='/api/game'/>", {"method": "POST"})
            .then(function (response) {
                location.href = "/app/placement.jsp";
            });
    }

    function drawTopTable(){
        console.log( "Top-10 players table" );
        fetch("<c:url value='/api/game/top10'/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            return response.json();
        }).then(function (game) {
            var tableData = {"players": game };
            console.log(JSON.stringify(tableData));
            w3.displayObject("topTable", tableData);

            var tdCells = document.querySelectorAll('td');
            tdCells.forEach( function(td) {
               if ((td.innerHTML=="0") || (td.innerHTML==" - empty - ")) {
                   td.style.color = 'LightGray';
               } else {td.style.color = 'Black';}
            });
        });
    }
</script>
</body>
</html>