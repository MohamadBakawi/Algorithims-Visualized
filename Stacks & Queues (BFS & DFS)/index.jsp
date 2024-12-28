<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DFS Maze Visualization</title>
<style>
    body {
        font-family: Arial, sans-serif;
        text-align: center;
        background-color: #f4f4f9;
        padding: 20px;
    }

    h1 {
        color: #333;
        margin-bottom: 20px;
    }

    label {
        font-size: 16px;
        margin-right: 10px;
    }

    select {
        font-size: 14px;
        padding: 5px;
        margin: 0 10px;
    }

    .stack {
        width: 200px;
        border: 1px solid #333;
        margin: 20px auto;
        padding: 10px;
        background-color: #fff;
        border-radius: 5px;
    }

    .element {
        height: 30px;
        line-height: 30px;
        text-align: center;
        border-bottom: 1px solid #ccc;
        font-size: 14px;
        background-color: #e9ecef;
    }

    .node {
        width: 50px;
        height: 50px;
        border: 2px solid #333;
        border-radius: 50%;
        display: inline-block;
        margin: 5px;
        text-align: center;
        line-height: 50px;
        font-size: 16px;
        font-weight: bold;
        background-color: #f4f4f9;
    }

    .visited {
        background-color: lightblue;
        color: #333;
    }

    .start {
        background-color: green;
        color: white;
    }

    .goal {
        background-color: red;
        color: white;
    }

    #maze {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 15px;
        justify-content: center;
        margin: 20px auto;
    }

    button {
        background-color: #007BFF;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s ease;
        margin-top: 20px;
    }

    button:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>

<h1>DFS Maze Visualization</h1>

<div>
    <label for="startNode">Start Node:</label>
    <select id="startNode">
        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
        <option value="5">5</option>
        <option value="6">6</option>
        <option value="7">7</option>
        <option value="8">8</option>
        <option value="9">9</option>
        <option value="10">10</option>
        <option value="11">11</option>
        <option value="12">12</option>
    </select>

    <label for="goalNode">Goal Node:</label>
    <select id="goalNode">
        <option value="12">12</option>
        <option value="11">11</option>
        <option value="10">10</option>
        <option value="9">9</option>
        <option value="8">8</option>
        <option value="7">7</option>
        <option value="6">6</option>
        <option value="5">5</option>
        <option value="4">4</option>
        <option value="3">3</option>
        <option value="2">2</option>
        <option value="1">1</option>
    </select>
</div>

<div id="stack" class="stack">
    <!-- Stack visualization will appear here -->
</div>

<div id="maze" style="visibility: hidden;">
    <!-- Dont remove this I was planning on constructing the graoh but meh -->
</div>

<button onclick="startDFS()">Start DFS</button>
<br>
  
  
    <form action="Main Menu.jsp" method="GET">
        <button type="submit">Main Menu</button>
    </form>

<script>
    var stack = [];
    var stackDiv = document.getElementById("stack");
    var mazeDiv = document.getElementById("maze");
    var isGoalFound = false; 


    const mazeGraph = {
        1: [2, 10],
        2: [1, 3, 9],
        3: [2, 4],
        4: [3, 5, 9],
        5: [4, 6],
        6: [5, 7],
        7: [6, 8, 9],
        8: [7, 11],
        9: [2, 4, 7, 10],
        10: [1, 9, 11],
        11: [8, 10, 12],
        12: [11],
    };

    // Async implementation
    async function dfs(node, visited, goal) {
        if (isGoalFound || node === goal) {
            if (!isGoalFound) {
                visited[node] = true;
                stack.push(node);
                var newElement = document.createElement("div");
                newElement.classList.add("element");
                newElement.textContent = node;
                stackDiv.insertBefore(newElement, stackDiv.firstChild);
                var mazeNode = document.getElementById("node" + node);
                mazeNode.classList.add("visited");
            }
            isGoalFound = true;
            alert("Goal node " + goal + " found!");
            return true;
        }

        visited[node] = true;
        stack.push(node);
        var newElement = document.createElement("div");
        newElement.classList.add("element");
        newElement.textContent = node;
        stackDiv.insertBefore(newElement, stackDiv.firstChild);
        var mazeNode = document.getElementById("node" + node);
        mazeNode.classList.add("visited");
        await new Promise(resolve => setTimeout(resolve, 500));

        for (let neighbor of mazeGraph[node]) {
            if (!visited[neighbor]) {
                let found = await dfs(neighbor, visited, goal);
                if (found) return true;
            }
        }

        await new Promise(resolve => setTimeout(resolve, 1000));
        stack.pop();
        stackDiv.removeChild(stackDiv.firstChild);
        return false;
    }

    function startDFS() {
        var visited = {};
        var startNode = parseInt(document.getElementById("startNode").value);
        var goalNode = parseInt(document.getElementById("goalNode").value);

        for (let node in mazeGraph) {
            visited[node] = false;
        }

        isGoalFound = false;
        createMaze(startNode, goalNode);
        dfs(startNode, visited, goalNode).then(found => {
            if (!found) {
                alert("Goal node " + goalNode + " was not reachable from start node " + startNode + ".");
            }
        });
    }

    function createMaze(startNode, goalNode) {
        mazeDiv.innerHTML = "";
        for (let i = 1; i <= 12; i++) {
            var node = document.createElement("div");
            node.id = "node" + i;
            node.classList.add("node");
            node.textContent = i;
            if (i === startNode) {
                node.classList.add("start");
            }
            if (i === goalNode) {
                node.classList.add("goal");
            }
            mazeDiv.appendChild(node);
        }
    }
</script>

</body>
</html>
