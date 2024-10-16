import 'package:flutter/material.dart';
import 'package:nttcs/data/models/tree_node.dart';

class TreeNodeWidget extends StatefulWidget {
  final List<TreeNode> treeNodes;
  final Function(TreeNode) onItemClick;

  const TreeNodeWidget({
    Key? key,
    required this.treeNodes,
    required this.onItemClick,
  }) : super(key: key);

  @override
  _TreeNodeWidgetState createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<TreeNodeWidget> {
  List<TreeNode> displayedNodes = [];

  @override
  void initState() {
    super.initState();
    updateDisplayedNodes();
  }

  @override
  void didUpdateWidget(covariant TreeNodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.treeNodes != widget.treeNodes) {
      updateDisplayedNodes(); // Ensure displayed nodes are updated when treeNodes change
    }
  }

  void updateDisplayedNodes() {
    setState(() {
      displayedNodes = [];
      for (TreeNode node in widget.treeNodes) {
        displayedNodes.add(node);
        if (node.isExpanded) {
          addChildren(node);
        }
      }
    });
  }

  void addChildren(TreeNode parent) {
    for (TreeNode child in parent.children) {
      displayedNodes.add(child);
      if (child.isExpanded) {
        addChildren(child);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: displayedNodes.length,
      itemBuilder: (context, index) {
        TreeNode node = displayedNodes[index];

        return GestureDetector(
          onTap: () => widget.onItemClick(node),
          child: Padding(
            padding: EdgeInsets.only(left: node.level * 16.0),
            child: Row(
              children: [
                if (node.hasChildren())
                  IconButton(
                    icon: Icon(node.isExpanded
                        ? Icons.expand_more
                        : Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        node.isExpanded = !node.isExpanded;
                        updateDisplayedNodes();
                      });
                    },
                  )
                else
                  const SizedBox(width: 32.0, height: 40.0),
                Expanded(
                  child: Text(node.name),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
