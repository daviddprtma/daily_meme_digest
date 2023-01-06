class GetLeaderboard {
  int id;
  String nama_depan;
  String nama_belakang;
  String link_meme;
  int likes;

  GetLeaderboard(
      {required this.id,
      required this.nama_depan,
      this.nama_belakang = "",
      this.link_meme = "https://i.pravatar.cc/300",
      required this.likes});

  factory GetLeaderboard.fromJson(Map<String, dynamic> json) {
    return GetLeaderboard(
        id: json['id'] as int,
        nama_depan: json['nama_depan'] ?? "",
        nama_belakang: json['nama_belakang'] ?? "",
        link_meme: json['link_meme'] ?? "https://i.pravatar.cc/300",
        likes: json['likes'] as int);
  }
}
