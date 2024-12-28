<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Graph Traversal Options</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background-color: #f4f4f9;
        }
        h1 {
            color: #333;
        }
        form {
            margin: 20px;
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
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h1>Select Traversal Method</h1>
    <!-- Form for DFS -->
    <form action="index.jsp" method="GET">
        <button type="submit">DFS</button>
    </form>
    
    <!-- Form for BFS -->
    <form action="queue.jsp" method="GET">
        <button type="submit">BFS</button>
    </form>
</body>
</html>
