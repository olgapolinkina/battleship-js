<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Game</title>
</head>
<body onload="CheckActivePlayer();">
<div id="wait-fire" class="w3-hide">
    <h3>Please mark where to fire</h3>
    <table style="width:100%">
        <tr>
            <td style="width:50%">

                <table style="border:1px solid black; border-collapse: collapse;">
                    <tr style="vertical-align:middle; border-bottom:1pt solid black;">
                        <td style="border-right:1pt solid black;">&nbsp;</td>
                        <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                            <td style="text-align:center; background-color: #f2f2f2; height:15pt; width:15pt;">
                                <c:out value="${col}"/>
                            </td>
                        </c:forTokens>
                    </tr>
                    <c:forTokens items="1,2,3,4,5,6,7,8,9,10" delims="," var="row">
                        <tr>
                            <td style="text-align:right; background-color: #f2f2f2; height:15pt; padding-right: 3px; border-right:1pt solid black;">
                                <c:out value="${row}"/>
                            </td>
                            <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                                <td style="text-align:center; background-color: #ffffff; height:15pt; width:15pt;">
                                    <input type="radio" name="firebox" id="${col}${row}" onchange="">
                                </td>
                            </c:forTokens>
                        </tr>
                    </c:forTokens>
                </table>
                </br>
                <button type="button" onclick="fire();">Fire!</button>


            </td>
            <td style="width:50%">
                <table style="border:1px solid black; border-collapse: collapse;">
                    <tr style="vertical-align:middle; border-bottom:1pt solid black;">
                        <td style="border-right:1pt solid black;">&nbsp;</td>
                        <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                            <td style="text-align:center; background-color: #f2f2f2; height:15pt; width:15pt;">
                                <c:out value="${col}"/>
                            </td>
                        </c:forTokens>
                    </tr>
                    <c:forTokens items="1,2,3,4,5,6,7,8,9,10" delims="," var="row">
                        <tr>
                            <td style="text-align:right; background-color: #f2f2f2; height:15pt; padding-right: 3px; border-right:1pt solid black;">
                                <c:out value="${row}"/>
                            </td>
                            <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                                <td style="text-align:center; background-color: #ffffff; height:15pt; width:15pt;">
                                    &nbsp;
                                </td>
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
    <table style="width:100%">
        <tr>
            <br style="width:50%">

                <table style="border:1px solid black; border-collapse: collapse;">
                    <tr style="vertical-align:middle; border-bottom:1pt solid black;">
                        <td style="border-right:1pt solid black;">&nbsp;</td>
                        <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                            <td style="text-align:center; background-color: #f2f2f2; height:15pt; width:15pt;">
                                <c:out value="${col}"/>
                            </td>
                        </c:forTokens>
                    </tr>
                    <c:forTokens items="1,2,3,4,5,6,7,8,9,10" delims="," var="row">
                        <tr>
                            <td style="text-align:right; background-color: #f2f2f2; height:15pt; padding-right: 3px; border-right:1pt solid black;">
                                <c:out value="${row}"/>
                            </td>
                            <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                                <td style="text-align:center; background-color: #ffffff; height:15pt; width:15pt;">
                                    &nbsp;
                                </td>
                            </c:forTokens>
                        </tr>
                    </c:forTokens>
                </table>
                </br></br>

            </td>
            <td style="width:50%">
                <table style="border:1px solid black; border-collapse: collapse;">
                    <tr style="vertical-align:middle; border-bottom:1pt solid black;">
                        <td style="border-right:1pt solid black;">&nbsp;</td>
                        <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                            <td style="text-align:center; background-color: #f2f2f2; height:15pt; width:15pt;">
                                <c:out value="${col}"/>
                            </td>
                        </c:forTokens>
                    </tr>
                    <c:forTokens items="1,2,3,4,5,6,7,8,9,10" delims="," var="row">
                        <tr>
                            <td style="text-align:right; background-color: #f2f2f2; height:15pt; padding-right: 3px; border-right:1pt solid black;">
                                <c:out value="${row}"/>
                            </td>
                            <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                                <td style="text-align:center; background-color: #ffffff; height:15pt; width:15pt;">
                                    &nbsp;
                                </td>
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
        var firePlace = {}
        fetch("<c:url value='/api/game/fire'/>", {
            "method": "POST",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(firePlace)
        }).then(function (response) {
            console.log("DONE");
            CheckActivePlayer();
        });
    }

    function CheckActivePlayer() {
        console.log("get active player to set a board");
        fetch("<c:url value='/api/game/start'/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response){
            return response.json();
        }).then(function (game) {
            console.log(JSON.stringify(game));
            if (game.playerActive) {
                document.getElementById("wait-fire").classList.remove("w3-hide");
                document.getElementById("wait-another").classList.add("w3-hide");
            } else {
                document.getElementById("wait-fire").classList.add("w3-hide");
                document.getElementById("wait-another").classList.remove("w3-hide");
                window.setTimeout(function () {CheckActivePlayer(); }, 1000);
            }
        })
    }






</script>




</body>
</html>
