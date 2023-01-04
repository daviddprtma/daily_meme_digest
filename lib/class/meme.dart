class Meme {
  int id;
  String link_meme;
  String teks_atas;
  String teks_bawah;
  int likes;
  final List? user;

  Meme(
      {required this.id,
      required this.link_meme,
      required this.teks_atas,
      required this.teks_bawah,
      required this.likes,
      required this.user});

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
        id: json['id'] as int,
        link_meme: json['link_meme'] as String,
        teks_atas: json['teks_atas'] as String,
        teks_bawah: json['teks_bawah'] as String,
        likes: json['likes'] ?? "" as int,
        user: json['user']);
  }
}
