class MahasiswaAlpha {
  int idAlpha;
  String ni;
  String? nama; // Add the nama field
  int jamAlpha;
  int semester;
  int? jamKompen;

  MahasiswaAlpha({
    required this.idAlpha,
    required this.ni,
    required this.nama, // Initialize the nama field
    required this.jamAlpha,
    required this.semester,
    this.jamKompen,
  });

  factory MahasiswaAlpha.fromJson(Map<String, dynamic> json) {
    return MahasiswaAlpha(
      idAlpha: json['id_alpha'] ?? 0, // Default value
      ni: json['ni'] ?? 'N/A', // Handle null values
      nama: json['nama'] ?? 'N/A',
      jamAlpha: json['jam_alpha'] ?? 0,
      semester: json['semester'] ?? 0,
      jamKompen: json['jam_kompen'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_alpha': idAlpha,
      'ni': ni,
      'nama': nama, // Add the nama field to the JSON map
      'jam_alpha': jamAlpha,
      'semester': semester,
      'jam_kompen': jamKompen,
    };
  }
}
