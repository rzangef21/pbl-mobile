import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================== HEADER BIRU =====================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              decoration: const BoxDecoration(
                color: Color(0xff1e9ce6), // Warna biru seperti gambar
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  SizedBox(height: 16),

                  // Judul
                  Text(
                    "Informasi Profil",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Data diri pegawai",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // ===================== FORM BODY =====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 20),
                  _ProfileField(title: "Nama Panjang", value: "John"),
                  _ProfileField(title: "Email", value: "JohnDoe@gmail.com"),
                  _ProfileField(title: "Jenis Kelamin", value: "Pria"),
                  _ProfileField(
                    title: "Alamat",
                    value: "Jalan Jakarta no. 10, Jakarta Indonesia",
                  ),
                  _ProfileField(
                    title: "Jabatan",
                    value: "Front-End Developer",
                  ),
                  _ProfileField(
                    title: "Departemen",
                    value: "Teknologi Informasi",
                  ),

                  // JATAH CUTI WARNA KUNING
                  _ProfileField(
                    title: "Jatah Cuti",
                    value: "4",
                    color: Color(0xfffde9b0),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),

            // ===================== TOMBOL =====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Informasi Gaji",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ===================== WIDGET FIELD CUSTOM =====================
class _ProfileField extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const _ProfileField({
    super.key,
    required this.title,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),

        TextField(
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: color ?? const Color(0xfff1f1f1),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: value,
            hintStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}