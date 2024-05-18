// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../core/constants/types.dart';

class CategoryEntity extends Equatable {
  final int categoryId;
  final String name;
  final String image;
  final String description;
  final bool child;
  final Status status;
  final int? parentId;

  const CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.image,
    required this.description,
    required this.child,
    required this.status,
    this.parentId,
  });

  @override
  List<Object?> get props {
    return [
      categoryId,
      name,
      image,
      description,
      child,
      status,
      parentId,
    ];
  }

  CategoryEntity copyWith({
    int? categoryId,
    String? name,
    String? image,
    String? description,
    bool? child,
    Status? status,
    int? parentId,
  }) {
    return CategoryEntity(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      child: child ?? this.child,
      status: status ?? this.status,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryId': categoryId,
      'name': name,
      'image': image,
      'description': description,
      'child': child,
      'status': status.name,
      'parentId': parentId,
    };
  }

  factory CategoryEntity.fromMap(Map<String, dynamic> map) {
    return CategoryEntity(
      categoryId: map['categoryId'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
      child: map['child'] as bool,
      status: Status.values.firstWhere((e) => e.name == map['status'] as String),
      parentId: map['parentId'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryEntity.fromJson(String source) => CategoryEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'CategoryEntity(categoryId: $categoryId, name: $name, image: ${image.isNotEmpty}, description: $description, child: $child, status: $status, parentId: $parentId)';
  }
}
