<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <title>Game Results</title>

    <style>
        table {
            border-collapse: collapse;
        }
        td {
            border-width: 1px;
        }
        td.SHIP {
            background-color: black;
        }
        td.MISS {
            background-color: aqua;
        }
        td.HIT {
            background-color: red;
        }
    </style>
</head>
<body onload="resultMessage();">

<div id="all-ships">
    <table>
        <tr style="vertical-align: top">
            <td style="padding-right: 20px">
                <table style="border:1pt solid black; border-collapse: collapse;">
                    <tr style="vertical-align:middle; border-bottom:1pt solid black;">
                        <td style="border-right:1pt solid black; border-bottom:1px dotted black;"> </td>
                        <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                            <td style="text-align:center; border-right:1px dotted black; background-color: #f2f2f2; height:15pt; width:15pt;">
                                <c:out value="${col}"/>
                            </td>
                        </c:forTokens>
                    </tr>
                    <c:forTokens items="1,2,3,4,5,6,7,8,9,10" delims="," var="row">
                        <tr>
                            <td style="text-align:right; border-bottom:1px dotted black; background-color: #f2f2f2; height:15pt; padding-right: 3px; border-right:1pt solid black;">
                                <c:out value="${row}"/>
                            </td>
                            <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                                <td id="f${col}${row}" style="text-align:center; height:15pt; width:15pt; border: 1px dimgray dotted"> </td>
                            </c:forTokens>
                        </tr>
                    </c:forTokens>
                </table>
            </td>
            <td style="padding-right: 20px">
                <table style="border:1pt solid black; border-collapse: collapse;">
                    <tr style="vertical-align:middle; border-bottom:1pt solid black;">
                        <td style="border-right:1pt solid black; border-bottom:1px dotted black;"> </td>
                        <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                            <td style="text-align:center; border-right:1px dotted black; background-color: #f2f2f2; height:15pt; width:15pt;">
                                <c:out value="${col}"/>
                            </td>
                        </c:forTokens>
                    </tr>
                    <c:forTokens items="1,2,3,4,5,6,7,8,9,10" delims="," var="row">
                        <tr>
                            <td style="text-align:right; border-bottom:1px dotted black; background-color: #f2f2f2; height:15pt; padding-right: 3px; border-right:1pt solid black;">
                                <c:out value="${row}"/>
                            </td>
                            <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                                <td id="m${col}${row}" style="text-align:center; height:15pt; width:15pt; border: 1px dimgray dotted"> </td>
                            </c:forTokens>
                        </tr>
                    </c:forTokens>
                </table>
            </td>
        </tr>
        <tr><td colspan="2" style="text-align:center;">
            <div id="win-message" class="w3-hide">
                <h1 style="color:green">You won!</h1>
            </div>
            <div id="lose-message" class="w3-hide">
                <h1 style="color:darkred">You lost!</h1>
            </div>
            <button type="button" onclick="goToStartPage();">Back to Menu</button>
        </td></tr>
    </table>
</div>


<script>
    function resultMessage(){
        drawAllShips();
        fetch("<c:url value='/api/game/turn'/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response){
            return response.json();
        }).then(function (game) {
            if (game.playerActive) {
                document.getElementById("win-message").classList.remove("w3-hide");
                document.getElementById("lose-message").classList.add("w3-hide");
            } else {
                document.getElementById("win-message").classList.add("w3-hide");
                document.getElementById("lose-message").classList.remove("w3-hide");
            }
        });
    }

    function drawAllShips() {
        console.log('GetStartSettings');
        fetch("<c:url value='/api/game/result'/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            return response.json();
        }).then(function (cells) {
            console.log(JSON.stringify(cells));
            cells.forEach(function (c) {
                var id = (c.targetArea ? "f" : "m")+ c.address;
                var tblCell = document.getElementById(id);
                tblCell.className = c.state;
            });
        });
    }



    function goToStartPage(){
        console.log("redirect to start.jsp");
        location.href = "<c:url value='/app/start.jsp'/>";
    }


</script>


</body>
</html>
