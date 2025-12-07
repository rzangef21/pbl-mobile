import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:client/models/leave_type_model.dart';
import 'package:client/models/leave_request_model.dart';
import 'package:client/services/leave_request_service.dart';
import 'package:client/utils/api_wrapper.dart';

class LeaveRequestFormScreen extends StatefulWidget {
  @override
  _LeaveRequestFormScreenState createState() => _LeaveRequestFormScreenState();
}

class _LeaveRequestFormScreenState extends State<LeaveRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameC = TextEditingController();
  final TextEditingController positionC = TextEditingController();
  final TextEditingController deptC = TextEditingController();
  final TextEditingController reasonC = TextEditingController();

  LeaveType? _selectedType;
  DateTime? startDate;
  DateTime? endDate;

  late Future<ApiResponse<List<LeaveType>>> leaveTypesFuture;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    leaveTypesFuture = LeaveRequestService.instance.getLeaveTypes();
  }

  Future<void> pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? startDate : endDate) ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) return _snack("Pilih jenis izin");
    if (startDate == null || endDate == null) {
      return _snack("Isi tanggal mulai & selesai");
    }

    setState(() => submitting = true);

    final payload = LeaveRequestPayload(
      letterFormatId: _selectedType!.id,
      title: "Pengajuan Izin ${nameC.text}",
      startDate: startDate!.toIso8601String().split("T")[0],
      endDate: endDate!.toIso8601String().split("T")[0],
      notes: reasonC.text,
      employee: {
        "name": nameC.text,
        "position": positionC.text,
        "department": deptC.text,
      },
    );

    final res = await LeaveRequestService.instance.submitLeave(payload);

    setState(() => submitting = false);

    if (res.success) {
      _snack(res.message);
      Navigator.pop(context, true);
    } else {
      _snack(res.message, error: true);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat("dd/MM/yy");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A8E8),
        foregroundColor: Colors.white,
        title: const Text("Surat Izin"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<ApiResponse<List<LeaveType>>>(
        future: leaveTypesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.success) {
            return Center(child: Text(snapshot.data!.message));
          }

          final types = snapshot.data!.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _fieldLabel("Nama Karyawan"),
                  _input(nameC),

                  _fieldLabel("Jabatan"),
                  _input(positionC),

                  _fieldLabel("Departemen"),
                  _input(deptC),

                  _fieldLabel("Jenis Izin"),
                  _dropdown(types),

                  _fieldLabel("Alasan Izin"),
                  _input(reasonC, maxLines: 3),

                  _fieldLabel("Tanggal Mulai"),
                  _dateButton(
                    startDate != null ? df.format(startDate!) : "dd/mm/yy",
                    () => pickDate(true),
                  ),

                  _fieldLabel("Tanggal Selesai"),
                  _dateButton(
                    endDate != null ? df.format(endDate!) : "dd/mm/yy",
                    () => pickDate(false),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: submitting ? null : submit,
                      child: submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Simpan",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- UI COMPONENTS ----------

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  Widget _dropdown(List<LeaveType> types) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<LeaveType>(
        decoration: const InputDecoration(border: InputBorder.none),
        value: _selectedType,
        items: types
            .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
            .toList(),
        onChanged: (v) => setState(() => _selectedType = v),
      ),
    );
  }

  Widget _dateButton(String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 18),
            const SizedBox(width: 12),
            Text(value),
          ],
        ),
      ),
    );
  }
}
