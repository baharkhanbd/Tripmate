import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Fake data for history details
  final Map<String, dynamic> _fakeHistoryDetails = {
    'id': '1',
    'title': 'Red Fort - Historical Monument',
    'location': 'Delhi, India',
    'year': '1648',
    'description': 'The Red Fort is a historic fort in the city of Delhi in India. It was the main residence of the emperors of the Mughal dynasty for nearly 200 years, until 1857. The fort represents the peak in Mughal architecture under Shah Jahan.',
    'construction': 'Construction began in 1638 and was completed in 1648. The fort was designed by architect Ustad Ahmad Lahori, who also designed the Taj Mahal.',
    'unfinishedStructure': 'The Red Fort showcases the peak of Mughal architecture with its red sandstone walls, white marble inlays, and intricate carvings.',
    'visitingHours': '9:00 AM to 6:00 PM (Closed on Mondays)',
    'additionalInfo': 'The Red Fort was designated a UNESCO World Heritage Site in 2007. It hosts the Indian prime minister\'s speech on Independence Day each year.',
    'imageUrl': 'https://images.unsplash.com/photo-1587474260584-136574528ed5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  };

  // Fake scan data for captured image mode
  final Map<String, dynamic> _fakeScanData = {
    "analysis": {
      "landmark_name": "Red Fort - Historical Monument",
      "location": "Delhi, India",
      "year_completed": "1648",
      "historical_overview": "The Red Fort is a historic fort in the city of Delhi in India. It was the main residence of the emperors of the Mughal dynasty for nearly 200 years, until 1857. The fort represents the peak in Mughal architecture under Shah Jahan.",
      "materials": "Construction began in 1638 and was completed in 1648. The fort was designed by architect Ustad Ahmad Lahori, who also designed the Taj Mahal.",
      "architectural_style": "The Red Fort showcases the peak of Mughal architecture with its red sandstone walls, white marble inlays, and intricate carvings.",
    },
    "scan": {}
  };

  bool _isLoading = false;
  bool _isCapturedImageMode = false; // Toggle between modes
  String? _errorMessage;

  void _toggleMode() {
    setState(() {
      _isCapturedImageMode = !_isCapturedImageMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If in captured image mode
    if (_isCapturedImageMode) {
      return CustomScrollView(
        slivers: [
          // App Bar with Network Image (simulating captured image)
          SliverAppBar(
            expandedHeight: 300.h,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFF5F5F5),
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF666666),
                  size: 20.sp,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1564507592333-c60657eea523?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content for captured image
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: _buildCapturedImageContent(
                _fakeScanData["analysis"], 
                _fakeScanData["scan"], 
                isLoading: _isLoading
              ),
            ),
          ),
        ],
      );
    }

    // For regular history details mode
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: const Color(0xFFCCCCCC),
            ),
            SizedBox(height: 16.h),
            Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                color: const Color(0xFFCCCCCC),
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                Future.delayed(const Duration(seconds: 1), () {
                  setState(() {
                    _isLoading = false;
                  });
                });
              },
              child: const Text('Retry'),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _toggleMode,
              child: const Text('Switch to Camera Mode'),
            ),
          ],
        ),
      );
    }

    // Show history details
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleMode,
        child: Icon(_isCapturedImageMode ? Icons.history : Icons.camera_alt),
      ),
      body: CustomScrollView(
        slivers: [
          // App Bar with Network Image
          SliverAppBar(
            expandedHeight: 300.h,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFF5F5F5),
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF666666),
                  size: 22.sp,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  _showDeleteDialog(context);
                },
                child: Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20.sp,
                  ),
                ),
              ),
              IconButton(
                onPressed: _toggleMode,
                icon: const Icon(Icons.camera_alt),
                tooltip: 'Switch to Camera Mode',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_fakeHistoryDetails['imageUrl']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content for history items
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: _buildHistoryContent(_fakeHistoryDetails),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: const Color(0xFF007AFF),
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: GoogleFonts.inter(
                color: const Color(0xFF007AFF),
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        _buildRichText(
          text: content,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget _buildVisitingHoursSection(String visitingHours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 18.sp,
              color: const Color(0xFF007AFF),
            ),
            SizedBox(width: 8.w),
            Text(
              'Visiting Hours',
              style: GoogleFonts.inter(
                color: const Color(0xFF007AFF),
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              ' (approx.):',
              style: GoogleFonts.inter(
                color: const Color(0xFF333333),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildRichText(
          text: visitingHours,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget _buildRichText({
    required String text,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: const Color(0xFF333333),
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        height: 1.5,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete History',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this history item?',
            style: TextStyle(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('History item deleted'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCapturedImageContent(Map<String, dynamic> analysis, Map<String, dynamic> scan, {required bool isLoading}) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toolbar indicators
            Column(
              children: [
                SizedBox(height: 8.h),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 40.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF666666),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: 40.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF666666),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),

            // Title
            Text(
              analysis["landmark_name"] ?? "Unknown Landmark",
              style: GoogleFonts.inter(
                color: const Color(0xFF333333),
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 16.h),

            // Metadata Row
            Row(
              children: [
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16.sp, color: const Color(0xFF666666)),
                    SizedBox(width: 4.w),
                    Text(
                      analysis["location"] ?? "Unknown Location",
                      style: GoogleFonts.inter(
                        color: const Color(0xFF666666),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 24.w),

                // Year
                Row(
                  children: [
                    Icon(Icons.business, size: 16.sp, color: const Color(0xFF666666)),
                    SizedBox(width: 4.w),
                    Text(
                      analysis["year_completed"]?.toString() ?? "N/A",
                      style: GoogleFonts.inter(
                        color: const Color(0xFF666666),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(width: double.infinity, child: Divider(color: const Color(0xFFCCCCCC), height: 32.h)),
            SizedBox(height: 5.h),

            // Description
            Text(
              analysis["historical_overview"] ?? "No description available.",
              style: GoogleFonts.inter(
                color: const Color(0xFF333333),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),

            SizedBox(height: 24.h),

            // Location Section
            _buildSection(
              "Location",
              analysis["location"] ?? "Unknown location details.",
              Icons.location_on,
            ),

            SizedBox(height: 16.h),

            // Construction Section
            _buildSection(
              "Construction",
              analysis["materials"] ?? "No construction details available.",
              Icons.construction,
            ),

            SizedBox(height: 16.h),

            // Architecture Section
            _buildSection(
              "Architecture",
              analysis["architectural_style"] ?? "No architecture details available.",
              Icons.architecture,
            ),

            SizedBox(height: 24.h),

            // Mode toggle button
            Center(
              child: ElevatedButton(
                onPressed: _toggleMode,
                child: const Text('Switch to History Mode'),
              ),
            ),
          ],
        ),

        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryContent(dynamic details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          details['title'],
          style: GoogleFonts.inter(
            color: const Color(0xFF333333),
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Metadata Row
        (details['location'].length > 30)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.sp,
                        color: const Color(0xFF666666),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          details['location'],
                          style: GoogleFonts.inter(
                            color: const Color(0xFF333333),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16.sp,
                        color: const Color(0xFF666666),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        details['year'],
                        style: GoogleFonts.inter(
                          color: const Color(0xFF333333),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.sp,
                        color: const Color(0xFF666666),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        details['location'],
                        style: GoogleFonts.inter(
                          color: const Color(0xFF333333),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 24.w),
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16.sp,
                        color: const Color(0xFF666666),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        details['year'],
                        style: GoogleFonts.inter(
                          color: const Color(0xFF333333),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

        SizedBox(width: double.infinity, child: Divider(color: const Color(0xFFCCCCCC), height: 24.h)),
        SizedBox(height: 10.h),
        
        // Description
        _buildRichText(
          text: details['description'],
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        
        SizedBox(height: 24.h),
        
        // Location Section
        _buildSection(
          'Location',
          details['location'],
          Icons.location_on,
        ),
        
        SizedBox(height: 16.h),
        
        // Construction Section
        _buildSection(
          'Construction',
          details['construction'],
          Icons.construction,
        ),
        
        SizedBox(height: 16.h),
        
        // Unfinished Structure Section
        _buildSection(
          'Unfinished Structure',
          details['unfinishedStructure'],
          Icons.architecture,
        ),
        
        SizedBox(height: 24.h),
        
        // Visiting Hours Section
        _buildVisitingHoursSection(details['visitingHours']),
        
        SizedBox(height: 24.h),
        
        // Additional Info Section
        if (details['additionalInfo'].isNotEmpty) ...[
          _buildRichText(
            text: details['additionalInfo'],
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 24.h),
        ],

        // Mode toggle button
        Center(
          child: ElevatedButton(
            onPressed: _toggleMode,
            child: const Text('Switch to Camera Mode'),
          ),
        ),
      ],
    );
  }
}