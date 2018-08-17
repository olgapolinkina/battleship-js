<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <title>Game</title>

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
<body onload="drawAllShips(); checkActivePlayer(); ">
<div id="wait-fire" class="w3-hide">
    <h3>Please mark where to fire</h3>
    <table>
        <tr style="vertical-align: top">
            <td style="padding-right: 20px;">
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
                                <td id="f1${col}${row}" style="text-align:center; height:15pt; width:15pt; border: 1px dimgray dotted">
                                    <input type="radio" name="firebox" id="${col}${row}" onchange="">
                                </td>
                            </c:forTokens>
                        </tr>
                    </c:forTokens>
                </table>
                <br/>
                <button type="button" onclick="fire();">Fire!</button>
            </td>
            <td style="padding-right: 20px;">
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
                                <td id="m1${col}${row}" style="text-align:center; height:15pt; width:15pt; border: 1px dimgray dotted"> </td>
                            </c:forTokens>
                        </tr>
                    </c:forTokens>
                </table>
            </td>
        </tr>
    </table>
</div>
<div id="wait-another" class="w3-hide">
    <h3>Please wait for opponent's fire</h3>
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
                                <td id="f2${col}${row}" style="text-align:center; height:15pt; width:15pt; border: 1px dimgray dotted"> </td>
                            </c:forTokens>
                        </tr>
                    </c:forTokens>
                </table>
                <br/><br/>
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
                                <td id="m2${col}${row}" style="text-align:center; height:15pt; width:15pt; border: 1px dimgray dotted"> </td>
                            </c:forTokens>
                        </tr>
                    </c:forTokens>
                </table>
            </td>
        </tr>
    </table>
</div>
<script>
    function fire(){
        var checked = document.querySelector('input[name=firebox]:checked');
        var checkedAddr = checked.id;
        console.log("firing addr " + checkedAddr);
        fetch("<c:url value='/api/game/fire'/>/" + checkedAddr, {
            "method": "POST",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            console.log("DONE");
            checkActivePlayer();
        });
    }

    function checkActivePlayer() {
        console.log("get active mark fire position");
        fetch("<c:url value='/api/game/turn'/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response){
            return response.json();
        }).then(function (game) {
            console.log(JSON.stringify(game));
            if (game.status === "FINISHED") {
                console.log("Game finished");
                location.href = "<c:url value='/app/result.jsp'/>";
            } else {
                if (game.playerActive) {
                    document.getElementById("wait-fire").classList.remove("w3-hide");
                    document.getElementById("wait-another").classList.add("w3-hide");
                } else {
                    document.getElementById("wait-fire").classList.add("w3-hide");
                    document.getElementById("wait-another").classList.remove("w3-hide");
                    window.setTimeout(function () {
                        checkActivePlayer();
                    }, 1000);
                }
                drawAllShips();
            }
        })
    }

    function drawAllShips() {
        console.log('GetStartSettings');
        fetch("<c:url value='/api/game/markers'/>", {
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
                var id, tblCelll, checkbox;
                for(i=1;i<=2;i++) {
                    id = (c.targetArea ? "f" : "m") +i.toString()+ c.address;
                    tblCell = document.getElementById(id);
                    tblCell.className = c.state;
                    if (c.targetArea) {
                        var checkbox = document.getElementById(c.address);
                        checkbox.classList.add("w3-hide");
                    }
                }
            });
        });
    }
</script>




</body>
</html>
