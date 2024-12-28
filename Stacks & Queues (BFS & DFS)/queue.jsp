<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BFS Maze Visualization</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background-color: #f4f4f4;
    }

    h1 {
        text-align: center;
        color: #333;
        font-size: 24px;
    }

    .queue {
        width: 50%;
        border: 2px solid #000;
        margin: 20px auto;
        padding: 5px;
        display: flex;
        flex-direction: row-reverse; /* Queue in reverse */
        overflow-x: auto;
        background-color: #fafafa;
        border-radius: 10px;
    }

    .element {
        width: 40px;
        height: 40px;
        line-height: 40px;
        text-align: center;
        border: 1px solid #666;
        margin: 5px;
        border-radius: 5px;
        font-size: 16px;
        background-color: #eaeaea;
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
    }

    .visited {
        background-color: lightblue;
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
        margin: 20px auto;
        width: fit-content;
    }

    select {
        width: 80px;
        padding: 5px;
        margin: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
    }

    button {
        display: block;
        margin: 20px auto;
        padding: 10px 20px;
        font-size: 16px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    button:hover {
        background-color: #0056b3;
    }

    label {
        font-size: 16px;
        margin-right: 5px;
    }

    div {
        margin: 10px auto;
    }
</style>
</head>
<body>

<h1>BFS Maze Visualization</h1>

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

<div id="queue" class="queue">
    <!-- Queue visualization will appear here -->
</div>

<div id="maze" style="visibility: hidden;">
    <!-- Dont remove this I was planning on constructing the graoh but meh -->
</div>

<button onclick="startBFS()">Start BFS</button>
<br>
  
  
    <form action="Main Menu.jsp" method="GET">
        <button type="submit">Main Menu</button>
    </form>

<script>
    var queue = [];
    var queueDiv = document.getElementById("queue");
    var mazeDiv = document.getElementById("maze");
    var isGoalFound = false;  // Flag to stop further operations once goal is found

    // Define the maze graph
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

    // BFS implementation based on the provided Java logic
    async function bfs(start, visited, goal) {
        // Initialize the queue with the start node
        queue.push(start);
        visited[start] = true;

        // Add the start node to the visual queue
        var newElement = document.createElement("div");
        newElement.classList.add("element");
        newElement.textContent = start;
        queueDiv.appendChild(newElement);

        // Highlight the start node in the maze
        var startNode = document.getElementById("node" + start);
        startNode.classList.add("start");

        // Track the goal node appearance in the queue
        let goalInQueue = false;

        while (queue.length > 0) {
            // If goal is found, stop further processing
            if (isGoalFound) {
                return;  // Stop the BFS process immediately once the goal is found
            }

            // Dequeue the front element from the queue
            let currentNode = queue.shift();
            var currentElement = document.querySelector(".element");

            // Highlight the current node as visited
            var mazeNode = document.getElementById("node" + currentNode);
            mazeNode.classList.add("visited");

            // If the goal node is found, stop further processing
            if (currentNode === goal) {
                isGoalFound = true;
                alert("Goal node " + goal + " found!");
                return;  // Exit the BFS function immediately
            }

            // Visualize the current node being processed
            setTimeout(function() {
                currentElement.style.opacity = 1;
            }, 500);

            // Enqueue all unvisited neighbors, but do it only if the goal is not found yet
            for (let neighbor of mazeGraph[currentNode]) {
                // If goal is found, stop enqueuing any more neighbors
                if (!visited[neighbor] && !isGoalFound) {
                    visited[neighbor] = true;
                    queue.push(neighbor);

                    // Add the neighbor to the visual queue
                    var neighborElement = document.createElement("div");
                    neighborElement.classList.add("element");
                    neighborElement.textContent = neighbor;
                    queueDiv.appendChild(neighborElement);
                }
            }

            // Check if the goal node is in the queue
            if (queue.includes(goal) && !goalInQueue) {
                isGoalFound = true;  // Goal reached, stop BFS
                alert("Goal node " + goal + " found!");
                return;
            }

            // Delay to visualize each step in the BFS process
            await new Promise(resolve => setTimeout(resolve, 500));
        }

        alert("Goal node " + goal + " not found.");
    }

    function startBFS() {
        var visited = {};
        var startNode = parseInt(document.getElementById("startNode").value);
        var goalNode = parseInt(document.getElementById("goalNode").value);

        // Initialize visited for all nodes
        for (let node in mazeGraph) {
            visited[node] = false;
        }

        isGoalFound = false; // Reset the goal flag before starting a new BFS
        createMaze(startNode, goalNode);
        bfs(startNode, visited, goalNode);
    }

    function createMaze(startNode, goalNode) {
        // Create maze visualization
        mazeDiv.innerHTML = ""; // Clear previous maze if any
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