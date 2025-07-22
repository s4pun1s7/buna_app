import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/common/index.dart';
import '../../config/mock_data.dart';
import 'package:buna_app/l10n/app_localizations.dart';
import '../../widgets/navigation/buna_app_bar.dart';

/// QR code scanner screen for festival interactions
class QRScreen extends ConsumerStatefulWidget {
  const QRScreen({super.key});

  @override
  ConsumerState<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends ConsumerState<QRScreen> {
  bool _isScanning = false;
  bool _isLoading = false;
  String? _lastScannedCode;
  final List<String> _scanHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BunaAppBar(
        title: AppLocalizations.of(context)!.qrScanner,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: AppLocalizations.of(context)!.aboutQRScanner,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Scanner area
            Expanded(child: _buildScannerArea()),
            // Description and instructions (formerly _buildHeader)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.scanFestivalQRCodes,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.scanQRCodesDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  // ...existing code...

  Widget _buildScannerArea() {
    if (_isLoading) {
      return const LoadingIndicator();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Scanner frame
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Corner indicators
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                        left: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                        right: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                        left: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                        right: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                // Scanning animation
                if (_isScanning)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Theme.of(context).primaryColor,
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: const LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                // Center icon
                Center(
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Instructions
          Text(
            'Position the QR code within the frame',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'The scanner will automatically detect and process the code',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 32),
          // Scan button
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isScanning ? null : _startScanning,
              icon: Icon(_isScanning ? Icons.stop : Icons.qr_code_scanner),
              label: Text(_isScanning ? 'Stop Scanning' : 'Start Scanning'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (_lastScannedCode != null) ...[
            _buildLastScanResult(),
            const SizedBox(height: 16),
          ],
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildLastScanResult() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.qr_code, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Last Scanned',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _lastScannedCode!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _processQRCode(_lastScannedCode!),
                    child: const Text('Process'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _shareQRCode(_lastScannedCode!),
                    child: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.qr_code_2,
            title: 'Generate QR',
            subtitle: 'Create your own QR codes',
            onTap: _generateQRCode,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.photo_library,
            title: 'From Gallery',
            subtitle: 'Scan from photos',
            onTap: _scanFromGallery,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startScanning() {
    setState(() {
      _isScanning = !_isScanning;
    });

    if (_isScanning) {
      // Simulate scanning process
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isScanning) {
          _simulateQRScan();
        }
      });
    }
  }

  void _simulateQRScan() {
    // Simulate scanning a QR code
    final mockCodes = MockData.qrCodes;
    final randomCode = mockCodes[DateTime.now().millisecond % mockCodes.length];

    setState(() {
      _lastScannedCode = randomCode;
      _scanHistory.add(randomCode);
      _isScanning = false;
    });

    _showScanResult(randomCode);
  }

  void _showScanResult(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scanned!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code: $code'),
            const SizedBox(height: 16),
            const Text('What would you like to do with this code?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _processQRCode(code);
            },
            child: const Text('Process'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _processQRCode(String code) {
    setState(() {
      _isLoading = true;
    });

    // Simulate processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      if (code.contains('event')) {
        _showEventInfo(code);
      } else if (code.contains('venue')) {
        _showVenueInfo(code);
      } else if (code.contains('artist')) {
        _showArtistInfo(code);
      } else if (code.contains('workshop')) {
        _showWorkshopInfo(code);
      } else if (code.contains('reward')) {
        _showRewardInfo(code);
      } else {
        _showGenericInfo(code);
      }
    });
  }

  void _showEventInfo(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.eventInformation),
        content: Text(AppLocalizations.of(context)!.eventInfoContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _showVenueInfo(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.venueInformation),
        content: Text(AppLocalizations.of(context)!.venueInfoContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _showArtistInfo(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.artistInformation),
        content: Text(AppLocalizations.of(context)!.artistInfoContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _showWorkshopInfo(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.workshopInformation),
        content: Text(AppLocalizations.of(context)!.workshopInfoContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _showRewardInfo(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.rewardUnlocked),
        content: Text(AppLocalizations.of(context)!.rewardInfoContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.claim),
          ),
        ],
      ),
    );
  }

  void _showGenericInfo(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.qrCodeInformation),
        content: Text(AppLocalizations.of(context)!.qrCodeInfoContent(code)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _shareQRCode(String code) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.sharingQRCode(code)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _generateQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.generateQRCode),
        content: Text(AppLocalizations.of(context)!.qrCodeGenerationComingSoon),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _scanFromGallery() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.scanFromGallery),
        content: Text(AppLocalizations.of(context)!.galleryScanningComingSoon),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About QR Scanner'),
        content: const Text(
          '• Point your camera at any QR code around the festival\n'
          '• QR codes can unlock event information, artist details, and rewards\n'
          '• Make sure the code is clearly visible within the scanning frame\n'
          '• You can also scan QR codes from photos in your gallery',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
