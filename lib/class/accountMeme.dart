class AccountMeme {
  String user_name;
  String nama_depan;
  String nama_belakang;
  String password;
  String tanggal_daftar;
  String link_gambar;

  AccountMeme({
    this.user_name = "",
    this.nama_depan = "",
    this.nama_belakang = "",
    this.password = "",
    this.tanggal_daftar = "",
    this.link_gambar = "",
  });

  factory AccountMeme.fromJson(Map<String, dynamic> json) {
    return AccountMeme(
        user_name: json['username'],
        nama_depan: json['nama_depan'],
        nama_belakang: json['nama_belakang'] ?? "",
        password: json['password'],
        tanggal_daftar: json['tanggal_daftar'],
        link_gambar: json['link_gambar'] ?? "");
  }
}
