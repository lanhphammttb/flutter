import 'package:json_annotation/json_annotation.dart';
import 'location.dart';

part 'tree_node.g.dart';

@JsonSerializable(explicitToJson: true)
class TreeNode extends Location {
  List<TreeNode> children;
  bool isExpanded;

  TreeNode({
    required int parentId,
    required String code,
    required String cityCode,
    required String codeSearch,
    required String name,
    required String description,
    required int order,
    required bool deleted,
    required int siteId,
    required int attributes,
    required int level,
    required String levelToText,
    String? longitude,
    String? latitude,
    required int totalUsers,
    String? mediaProjectCategories,
    required int id,
    String? createdTime,
    required String createdUser,
    String? modifiedTime,
    required String modifiedUser,
    List<TreeNode>? children,
    bool? isExpanded,
  })  : children = children ?? [],
        // Ensure children is a mutable list
        isExpanded = isExpanded ?? (level == 1),
        // Automatically expand if level == 1
        super(
          parentId: parentId,
          code: code,
          cityCode: cityCode,
          codeSearch: codeSearch,
          name: name,
          description: description,
          order: order,
          deleted: deleted,
          siteId: siteId,
          attributes: attributes,
          level: level,
          levelToText: levelToText,
          longitude: longitude,
          latitude: latitude,
          totalUsers: totalUsers,
          mediaProjectCategories: mediaProjectCategories,
          id: id,
          createdTime: createdTime,
          createdUser: createdUser,
          modifiedTime: modifiedTime,
          modifiedUser: modifiedUser,
        );

  factory TreeNode.fromJson(Map<String, dynamic> json) =>
      _$TreeNodeFromJson(json);

  Map<String, dynamic> toJson() => _$TreeNodeToJson(this);

  bool hasChildren() => children.isNotEmpty;

  void addChild(TreeNode child) {
    children.add(child);
  }

  /// Build tree structure from the list of locations
  static List<TreeNode> buildTree(List<Location> locations) {
    Map<int, TreeNode> nodeMap = {};
    List<TreeNode> roots = [];

    for (Location location in locations) {
      TreeNode node = TreeNode.fromJson(location.toJson());
      nodeMap[node.id] = node; // Create a map of nodes by ID
    }

    for (TreeNode node in nodeMap.values) {
      TreeNode? parent = nodeMap[node.parentId]; // Find the parent node
      if (parent != null) {
        parent.addChild(node); // Add node to its parent’s children
      } else {
        roots.add(node); // If no parent found, it is a root node
      }
    }

    return roots;
  }

  /// DFS tree trimming
  static List<TreeNode> trimTreeDFS(List<TreeNode> roots, String target) {
    List<TreeNode> validRoots = [];

    for (TreeNode root in roots) {
      TreeNode? result = _trimSingleNodeDFS(root, target);
      if (result != null) {
        validRoots.add(result);
      }
    }

    return validRoots;
  }

  static TreeNode? _trimSingleNodeDFS(TreeNode node, String target) {
    bool isMatch = node.name.toLowerCase().contains(target.toLowerCase());

    // Create a deep copy if the node itself matches the target
    if (isMatch) {
      return deepCopyTree(node);
    }

    // We will only create newNode if any child matches the search
    TreeNode? newNode;
    bool hasValidDescendant = false;

    for (TreeNode child in node.children) {
      TreeNode? childCopy = _trimSingleNodeDFS(child, target);
      if (childCopy != null) {
        // Only create newNode if we find a matching child
        if (newNode == null) {
          newNode = TreeNode.fromJson(node.toJson()); // Copy current node
          newNode.children = []; // Ensure it starts with empty children
        }
        newNode.addChild(childCopy);
        hasValidDescendant = true;
        newNode.isExpanded = true; // Expand parent if any child matches
      }
    }

    // Return the new node if any children matched
    return hasValidDescendant ? newNode : null;
  }

  static TreeNode deepCopyTree(TreeNode node) {
    TreeNode copy = TreeNode(
      parentId: node.parentId,
      code: node.code,
      cityCode: node.cityCode,
      codeSearch: node.codeSearch,
      name: node.name,
      description: node.description,
      order: node.order,
      deleted: node.deleted,
      siteId: node.siteId,
      attributes: node.attributes,
      level: node.level,
      levelToText: node.levelToText,
      longitude: node.longitude,
      latitude: node.latitude,
      totalUsers: node.totalUsers,
      mediaProjectCategories: node.mediaProjectCategories,
      id: node.id,
      createdTime: node.createdTime,
      createdUser: node.createdUser,
      modifiedTime: node.modifiedTime,
      modifiedUser: node.modifiedUser,
      children: [], // Start with an empty list of children
      isExpanded: node.isExpanded,
    );

    // Recursively deep copy each child
    for (TreeNode child in node.children) {
      copy.addChild(deepCopyTree(child));
    }

    return copy;
  }
}
