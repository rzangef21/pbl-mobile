import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:client/services/izin_manager_service.dart';
import 'package:client/models/izin_manager_model.dart';

class AdminIzinDetailPage extends StatefulWidget {
  final int id;

  const AdminIzinDetailPage({super.key, required this.id});

  @override
  State<AdminIzinDetailPage> createState() => _AdminIzinDetailPageState();
}

class _AdminIzinDetailPageState extends State<AdminIzinDetailPage> {
  final IzinService izinService = IzinService();

  IzinModel? izinDetail;
  bool loading = true;

  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      final result = await izinService.loadIzinDetail(widget.id);

      if (!mounted) return;

      setState(() {
        izinDetail = result;
        loading = false;
      });

      // Isi notes jika sudah ada sebelumnya
      if (result?.notes != null) {
        notesController.text = result!.notes!;
      }
    } catch (e) {
      debugPrint("ERROR DETAIL: $e");
      setState(() => loading = false);
    }
  }

  Future<void> updateStatus(int newStatus) async {
    try {
      final success = await izinService.updateStatus(
        widget.id,
        newStatus,
        notesController.text,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Status berhasil diperbarui")),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal memperbarui status")),
        );
      }
    } catch (e) {
      debugPrint("ERROR UPDATE: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal memperbarui status")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A8E8),
        title: const Text(
          "Detail Pengajuan Izin",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : izinDetail == null
          ? const Center(child: Text("Data tidak ditemukan"))
          : _buildDetailContent(),
    );
  }

  Widget _buildDetailContent() {
    final item = izinDetail!;

    final color = item.statusCode == 0
        ? Colors.orange
        : item.statusCode == 1
        ? Colors.green
        : Colors.red;

    final bool isFinal = item.statusCode != 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.fullName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("Departemen: ${item.department}"),
                      Text("Surat: ${item.letterName}"),
                      Text("Tanggal Cuti: ${item.requestDate}"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ================= DETAIL IZIN =================
          const Text(
            "Detail Izin",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              item.reason.isNotEmpty ? item.reason : "Tidak ada deskripsi",
              style: const TextStyle(fontSize: 14),
            ),
          ),

          const SizedBox(height: 25),

          // ================= NOTES DISPLAY JIKA FINAL =================
          if (isFinal) ...[
            const Text(
              "Catatan Admin",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                (item.notes != null && item.notes!.isNotEmpty)
                    ? item.notes!
                    : (item.statusCode == 1 ? "Diterima" : "Ditolak"),
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),

            const SizedBox(height: 25),
          ],

          // ================= NOTES INPUT =================
          // ================= NOTES INPUT (HANYA SAAT PENDING) =================
          if (!isFinal)
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Catatan",
                hintText: "Tambahkan catatan...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

          const SizedBox(height: 30),

          // ================= ACTION BUTTONS =================
          if (!isFinal)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => updateStatus(1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Setujui",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => updateStatus(2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Tolak",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
