import 'package:flutter/material.dart';
import 'package:wifi_geo_map/Screens/skeleton_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PathPage extends StatefulWidget {
  final Map<int, List<String>> top3;
  const PathPage({super.key, required this.top3});

  @override
  State<PathPage> createState() => _PathPageState();
}

class _PathPageState extends State<PathPage> {
  List<String> selectedTiles = [];
  late Future<DocumentSnapshot> _snapshot;
  String startingPoint = ''; // Starting point from snapshot's gtid
  String destination = ''; // User-entered destination

  @override
  void initState() {
    super.initState();
    _snapshot = getSnapshotForNextCombination();
  }

  Future<DocumentSnapshot> getSnapshotForNextCombination() async {
    for (final entry in widget.top3.entries) {
      final ids = entry.value;
      final val = entry.key;

      for (var id in ids) {
        _snapshot = FirebaseFirestore.instance
            .collection('regions')
            .doc('$id$val')
            .get();
        final snapshot = await _snapshot;
        if (snapshot.exists) {
          return snapshot;
        }
      }
    }

    // If no combination has data, return an empty snapshot
    return FirebaseFirestore.instance.doc('empty/empty').get();
  }

  List<String> findShortestPath(String startingPoint, String destination) {
    // Define grid dimensions
    const int numRows = 4;
    const int numCols = 4;

    // Convert tile labels to grid indices
    Map<String, int> labelToIndex = {};
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        final String label =
            String.fromCharCode('A'.codeUnitAt(0) + i) + (j + 1).toString();
        labelToIndex[label] = i * numCols + j;
      }
    }

    // Create graph representation
    List<List<int>> graph = List.generate(
        numRows * numCols, (_) => List.filled(numRows * numCols, 0));

    // Populate graph edges (assuming adjacent tiles are connected)
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        final int currentIndex = i * numCols + j;
        if (i > 0) graph[currentIndex][currentIndex - numCols] = 1; // Up
        if (i < numRows - 1) {
          graph[currentIndex][currentIndex + numCols] = 1; // Down
        }
        if (j > 0) graph[currentIndex][currentIndex - 1] = 1; // Left
        if (j < numCols - 1) graph[currentIndex][currentIndex + 1] = 1; // Right
      }
    }

    // Convert starting and destination points to indices
    final int startIndex = labelToIndex[startingPoint]!;
    final int destIndex = labelToIndex[destination]!;

    // Dijkstra's algorithm
    List<int> distance = List.filled(numRows * numCols, -1);
    List<int> parent = List.filled(numRows * numCols, -1);
    List<bool> visited = List.filled(numRows * numCols, false);

    distance[startIndex] = 0;

    for (int i = 0; i < numRows * numCols - 1; i++) {
      int minDistance = 3000;
      int minIndex = -1;

      for (int v = 0; v < numRows * numCols; v++) {
        if (!visited[v] && distance[v] != -1 && distance[v] < minDistance) {
          minDistance = distance[v];
          minIndex = v;
        }
      }

      if (minIndex == -1) break;

      visited[minIndex] = true;

      for (int v = 0; v < numRows * numCols; v++) {
        if (!visited[v] &&
            graph[minIndex][v] != 0 &&
            (distance[v] == -1 ||
                distance[v] > distance[minIndex] + graph[minIndex][v])) {
          distance[v] = distance[minIndex] + graph[minIndex][v];
          parent[v] = minIndex;
        }
      }
    }

    // Reconstruct path
    List<String> shortestPath = [];
    int current = destIndex;
    while (current != -1) {
      shortestPath.add(
          String.fromCharCode('A'.codeUnitAt(0) + current ~/ numCols) +
              ((current % numCols) + 1).toString());
      current = parent[current];
    }
    shortestPath = shortestPath.reversed.toList();

    if (shortestPath.length > 2) {
      shortestPath.removeAt(0); // Remove the first element
      shortestPath.removeLast(); // Remove the last element
    }

    return shortestPath;
  }

  @override
Widget build(BuildContext context) {
  return SkeletonPage(
    isSearching: false,
    child: SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: _snapshot,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return const Text('No matching starting position found in database.');
                }
                final data = snapshot.data!.data() as Map<String, dynamic>;
                startingPoint = data['region'];
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: 4 * 4,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final int rowIndex = index ~/ 4;
                    final int colIndex = index % 4;
                    final String tileLabel =
                        String.fromCharCode('A'.codeUnitAt(0) + rowIndex) +
                            (colIndex + 1).toString();
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          destination = tileLabel;
                          selectedTiles = findShortestPath(
                              startingPoint, destination);
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(2),
                        color: selectedTiles.contains(tileLabel)
                            ? Colors.blue
                            : tileLabel == startingPoint
                                ? Colors.green
                                : tileLabel == destination
                                    ? Colors.green
                                    : Colors.grey[300],
                        child: Text(tileLabel),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}

}
