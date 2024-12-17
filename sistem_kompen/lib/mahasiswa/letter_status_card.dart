import 'package:flutter/material.dart';
import 'package:sistem_kompen/mahasiswa/academic_period.dart';
import '../services/academic_service.dart';

class LetterStatusCard extends StatelessWidget {
  final AcademicPeriod academicPeriod;
  final AcademicService _academicService = AcademicService();

  LetterStatusCard({
    Key? key,
    required this.academicPeriod,
  }) : super(key: key);

  Future<void> _handleDownload(BuildContext context) async {
    if (!academicPeriod.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Surat belum tersedia untuk diunduh'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final filePath = await _academicService.downloadPdf(academicPeriod.mahasiswaId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File berhasil diunduh ke: $filePath'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh surat: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleDownload(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: academicPeriod.isAvailable
                          ? [Colors.blue.shade400, Colors.blue.shade600]
                          : [Colors.red.shade400, Colors.red.shade600],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          academicPeriod.isAvailable
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          academicPeriod.isAvailable ? 'LUNAS' : 'BELUM LUNAS',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'NIM',
                        academicPeriod.nim,
                        Icons.badge_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Nama',
                        academicPeriod.mahasiswaNama,
                        Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Tahun Ajaran',
                        academicPeriod.year,
                        Icons.calendar_today_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Semester',
                        academicPeriod.semester,
                        Icons.schedule,
                      ),
                      const SizedBox(height: 16),
                      _buildPointRow(academicPeriod.poin),
                    ],
                  ),
                ),
              ],
            ),
            if (academicPeriod.isAvailable)
              Positioned(
                right: 16,
                top: 16,
                child: Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPointRow(int points) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Poin',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: points > 0 ? Colors.orange : Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              points.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
