#TESTING PUSH PULL

import dash
from dash import dcc
from dash import html
from dash.dependencies import Input, Output
import networkx as nx
import plotly.graph_objs as go
import random
import webbrowser
import time

G = nx.Graph()
# By Mohamad Bakawi
# Yes I'm proud of it

def add_random_edges(G, num_edges):
    nodes = list(G.nodes())
    for _ in range(num_edges):
        node1, node2 = random.sample(nodes, 2)
        if not G.has_edge(node1, node2):
            G.add_edge(node1, node2, weight=random.randint(1, 10))

def generate_fixed_layout(G):
    pos = {}
    for node in G.nodes():
        pos[node] = (random.uniform(-1, 1), random.uniform(-1, 1))
    return pos

def initialize_graph():
    num_nodes = 33
    G.add_nodes_from([f"Node {i + 1}" for i in range(num_nodes)])
    pos = generate_fixed_layout(G)
    add_random_edges(G, num_edges=num_nodes * 2)

    source_node = "Node 1"
    goal_node = "Node 10"

    if G.has_edge(source_node, goal_node):
        G.remove_edge(source_node, goal_node)

    return pos

def dijkstra_steps(G, source):
    visited = set()
    unvisited = set(G.nodes())
    distances = {node: float('inf') for node in G.nodes()}
    distances[source] = 0
    predecessors = {node: None for node in G.nodes()}
    steps = []

    while unvisited:
        current_node = min(unvisited, key=lambda node: distances[node])
        unvisited.remove(current_node)
        visited.add(current_node)

        considered_edges = [(current_node, neighbor) for neighbor in G.neighbors(current_node) if neighbor not in visited]
        steps.append((visited.copy(), predecessors.copy(), distances.copy(), considered_edges))

        for neighbor in G.neighbors(current_node):
            if neighbor not in visited:
                new_distance = distances[current_node] + G[current_node][neighbor]['weight']
                if new_distance < distances[neighbor]:
                    distances[neighbor] = new_distance
                    predecessors[neighbor] = current_node

    final_path = []
    node = goal_node
    while predecessors[node] is not None:
        final_path.append((predecessors[node], node))
        node = predecessors[node]

    steps.append((visited, predecessors, distances, final_path))
    return steps

pos = initialize_graph()
source_node = "Node 1"
goal_node = "Node 10"
steps = dijkstra_steps(G, source_node)

app = dash.Dash(__name__)

app.layout = html.Div([
    dcc.Graph(
        id='graph',
        style={'height': '100vh', 'width': '100vw'},
        config={'displayModeBar': False, 'staticPlot': True}
    ),
    dcc.Interval(id='interval-component', interval=1000, n_intervals=0)
], style={'height': '100vh', 'width': '100vw', 'margin': 0, 'padding': 0})

def generate_node_traces(steps, num):
    visited, predecessors, distances, _ = steps[num]

    node_trace = go.Scatter(
        x=[pos[node][0] for node in G.nodes()],
        y=[pos[node][1] for node in G.nodes()],
        text=[f'{node}: {distances[node]}' for node in G.nodes()],
        mode='markers+text',
        textposition='bottom center',
        hoverinfo='text',
        marker=dict(
            showscale=False,
            color=[
                'black' if node == source_node else
                'yellow' if node == goal_node else
                'lightgreen' if node in visited else 'lightblue'
                for node in G.nodes()
            ],
            size=30,
            line=dict(width=2)
        )
    )
    return [node_trace]

def generate_edge_traces(steps, num):
    visited, predecessors, distances, considered_edges = steps[num]
    edge_traces = []

    for edge in considered_edges:
        edge_trace = go.Scatter(
            x=[pos[edge[0]][0], pos[edge[1]][0], None],
            y=[pos[edge[0]][1], pos[edge[1]][1], None],
            mode='lines',
            line=dict(color='red', width=2),
            hoverinfo='none'
        )
        edge_traces.append(edge_trace)

    if num == len(steps) - 1:
        final_path = considered_edges
        for edge in final_path:
            edge_trace = go.Scatter(
                x=[pos[edge[0]][0], pos[edge[1]][0], None],
                y=[pos[edge[0]][1], pos[edge[1]][1], None],
                mode='lines',
                line=dict(color='red', width=4),
                hoverinfo='none'
            )
            edge_traces.append(edge_trace)

    default_edge_trace = go.Scatter(
        x=sum([[pos[u][0], pos[v][0], None] for u, v in G.edges()], []),
        y=sum([[pos[u][1], pos[v][1], None] for u, v in G.edges()], []),
        mode='lines',
        line=dict(color='gray', width=1),
        hoverinfo='none'
    )
    edge_traces.append(default_edge_trace)

    return edge_traces

def update_graph(step_num):
    node_traces = generate_node_traces(steps, step_num)
    edge_traces = generate_edge_traces(steps, step_num)
    return node_traces + edge_traces

@app.callback(
    Output('graph', 'figure'),
    [Input('interval-component', 'n_intervals')]
)
def update_graph_figure(n_intervals):
    step_num = min(n_intervals, len(steps) - 1)
    traces = update_graph(step_num)

    fig = go.Figure(data=traces)
    fig.add_annotation(
        text="Made by Mohamad Bakawi",
        xref="paper", yref="paper",
        x=0.5, y=-0.1,
        showarrow=False,
        font=dict(size=14)
    )

    return fig

if __name__ == '__main__':
    webbrowser.open('http://127.0.0.1:8050/')
    time.sleep(1)
    app.run_server(debug=True)
