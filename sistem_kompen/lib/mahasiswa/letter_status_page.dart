import 'package:flutter/material.dart';
import 'package:sistem_kompen/mahasiswa/academic_period.dart';
import 'package:sistem_kompen/mahasiswa/letter_status_card.dart';
import 'package:sistem_kompen/services/academic_service.dart';

class LetterStatusPage extends StatefulWidget {
  const LetterStatusPage({Key? key}) : super(key: key);

  @override
  State<LetterStatusPage> createState() => _LetterStatusPageState();
}

class _LetterStatusPageState extends State<LetterStatusPage> {
  final AcademicService _academicService = AcademicService();
  Future<List<AcademicPeriod>>? _periodsFuture;

  @override
  void initState() {
    super.initState();
    _periodsFuture = _academicService.getAcademicPeriods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengajuan Surat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _periodsFuture = _academicService.getAcademicPeriods();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cetak Surat Bebas Kompen',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pilih tahun ajaran dan semester untuk mencetak surat bebas kompen Anda.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                _buildAcademicPeriodsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcademicPeriodsList() {
    return FutureBuilder<List<AcademicPeriod>>(
      future: _periodsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[300]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _periodsFuture = _academicService.getAcademicPeriods();
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada data periode akademik',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: LetterStatusCard(academicPeriod: snapshot.data![index]),
            );
          },
        );
      },
    );
  }
}
