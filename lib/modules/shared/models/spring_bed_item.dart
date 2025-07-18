class SpringBedItem {
  final int id;
  final String name;
  final String desc;
  final String imageAsset;
  final double rate;

  SpringBedItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.imageAsset,
    required this.rate,
  });

  factory SpringBedItem.fromJson(Map<String, dynamic> json) {
    return SpringBedItem(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      imageAsset: json['imageAsset'],
      rate: (json['rate'] ?? 0).toDouble(),
    );
  }
}
