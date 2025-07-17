// lib/models/spring_bed_item.dart
class SpringBedItem {
  final int id;
  final String name;
  final String desc;
  final String imageAsset;

  SpringBedItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.imageAsset,
  });

  factory SpringBedItem.fromJson(Map<String, dynamic> json) {
    return SpringBedItem(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      imageAsset: json['imageAsset'],
    );
  }
}
