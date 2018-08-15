<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <title>Ship Placement</title>
</head>
<body onload="checkStatus()">
<div id="wait-another" class="w3-hide">
    <h1>Please wait another player</h1>
</div>
< id="placement-field" class="w3-hide">
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
                        <input type="checkbox" id="${col}${row}" onchange="cellClicked('${col}${row}')">
                    </td>
                </c:forTokens>
            </tr>
        </c:forTokens>
    </table>
    </br>
    <button type="button" onclick="ready()">Ready!</button>
</div>
<script>
    var data = {};

    function cellClicked(id) {
        var checkbox = document.getElementById(id);
        console.log(id + " " + checkbox.checked);
        data[id] = checkbox.checked ? "SHIP" : "EMPTY";
    }

    function ready() {
        console.log(JSON.stringify(data));
        fetch("<c:url value='/api/game/cells'/>", {
            "method": "POST",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        }).then(function (response) {
            console.log("DONE");
            checkStatus();
        });
    }

    function checkStatus() {
        console.log("checking status");
        fetch("<c:url value='/api/game/status'/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            return response.json();
        }).then(function (game) {
            console.log(JSON.stringify(game));
            if (game.status === "PLACEMENT" && game.playerActive) {
                document.getElementById("placement-field").classList.remove("w3-hide");
                document.getElementById("wait-another").classList.add("w3-hide");
            } else {
                document.getElementById("placement-field").classList.add("w3-hide");
                document.getElementById("wait-another").classList.remove("w3-hide");
                window.setTimeout(function () { checkStatus(); }, 1000);
            }
        });
    }
</script>
</body>
</html>