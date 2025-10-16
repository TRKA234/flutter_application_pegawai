class Pegawai {
  final int id;
  final String nama;
  final String jabatan;
  final int gaji;

  const Pegawai({
    required this.id,
    required this.nama,
    required this.jabatan,
    required this.gaji,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    final dynamic idValue = json['id'];
    final int parsedId = idValue is String
        ? int.tryParse(idValue) ?? 0
        : (idValue as int? ?? 0);
    final dynamic gajiValue = json['gaji'];
    final int parsedGaji = gajiValue is String
        ? int.tryParse(gajiValue) ?? 0
        : (gajiValue as int? ?? 0);
    return Pegawai(
      id: parsedId,
      nama: (json['nama'] ?? '').toString(),
      jabatan: (json['jabatan'] ?? '').toString(),
      gaji: parsedGaji,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'jabatan': jabatan, 'gaji': gaji};
  }
}
