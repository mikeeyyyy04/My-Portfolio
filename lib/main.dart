import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

/// Project color palette
class AppColors {
  static const navy = Color(0xFF2F4156);
  static const teal = Color(0xFF56708D);
  static const beige = Color(0xFFF5EEE8);
  static const skyBlue = Color(0xFFC0D9E6);
  static const white = Color(0xFFFFFFFF);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.navy,
          onPrimary: AppColors.white,
          secondary: AppColors.teal,
          onSecondary: AppColors.white,
          background: AppColors.beige,
          onBackground: AppColors.navy,
          surface: AppColors.white,
          onSurface: AppColors.navy,
          error: Colors.red,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.beige,
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: AppColors.navy,
          displayColor: AppColors.navy,
        ),
        useMaterial3: true,
      ),
      home: const PortfolioHome(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> with TickerProviderStateMixin {
  String _selectedNav = 'Home';
  bool _isPortfolioSidebarOpen = false;
  String? _selectedPortfolioItem;
  late AnimationController _dogAnimationController;
  late Animation<double> _dogAnimation;
  late AnimationController _sidebarAnimationController;
  late Animation<Offset> _sidebarSlideAnimation;
  late AnimationController _modalAnimationController;
  late Animation<double> _modalFadeAnimation;
  late Animation<Offset> _modalSlideAnimation;

  @override
  void initState() {
    super.initState();
    _dogAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    _dogAnimation = Tween<double>(begin: -50.0, end: 50.0).animate(
      CurvedAnimation(
        parent: _dogAnimationController,
        curve: Curves.linear,
      ),
    );

    _sidebarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _sidebarSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start off-screen to the right
      end: Offset.zero, // End at normal position
    ).animate(CurvedAnimation(
      parent: _sidebarAnimationController,
      curve: Curves.easeInOut,
    ));

    _modalAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _modalFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _modalAnimationController,
      curve: Curves.easeInOut,
    ));

    _modalSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _modalAnimationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _dogAnimationController.dispose();
    _sidebarAnimationController.dispose();
    _modalAnimationController.dispose();
    super.dispose();
  }

  void _navigateToPage(String page) {
    setState(() {
      _selectedNav = page;
    });
  }

  void _togglePortfolioSidebar() {
    setState(() {
      _isPortfolioSidebarOpen = !_isPortfolioSidebarOpen;
      if (_isPortfolioSidebarOpen) {
        _sidebarAnimationController.forward();
      } else {
        _sidebarAnimationController.reverse();
      }
    });
  }

  void _closePortfolioSidebar() {
    setState(() {
      _isPortfolioSidebarOpen = false;
      _sidebarAnimationController.reverse();
    });
  }

  void _openPortfolioModal(String item) {
    setState(() {
      _selectedPortfolioItem = item;
      _modalAnimationController.forward();
    });
  }

  void _closePortfolioModal() {
    _modalAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _selectedPortfolioItem = null;
        });
      }
    });
  }

  Future<void> _openResume() async {
    // TODO: Replace this URL with the actual location of your resume PDF
    final uri = Uri.parse('https://drive.google.com/file/d/173bF-xRDINPHiSXFLRPPhvDHDAsIYOlH/view?usp=drive_link');

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open resume PDF.'),
          ),
        );
      }
    }
  }

  Future<void> _openPortfolioPDF() async {
    String pdfUrl;
    
    // Get PDF URL based on selected portfolio item
    switch (_selectedPortfolioItem) {
      case 'She Captures':
        pdfUrl = 'https://drive.google.com/file/d/1XWDumnLjV8qNG8zhQS90rzJZMa8YZgOM/view?usp=drive_link';
        break;
      case 'She Records':
      case 'She Excels':
      case 'She Volunteers':
      default:
        pdfUrl = 'https://drive.google.com/file/d/18v-n3Q-ABDeBpqGI_ysByb9IDqLN7ROl/view?usp=sharing';
        break;
    }

    final uri = Uri.parse(pdfUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open portfolio PDF.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background with gradient and particles
          _buildBackground(),
          
          // Black background for About page
          if (_selectedNav == 'About')
            Container(
              color: Colors.black,
            ),
          
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Navigation Header
                _buildNavigation(),
                
                // Main content - show different content based on selected nav
                Expanded(
                  child: _selectedNav == 'About' 
                      ? _buildAboutContent()
                      : _buildMainContent(),
                ),
                
                // Footer with social media icons - only show on Home page
                if (_selectedNav == 'Home') _buildFooter(),
              ],
            ),
          ),

          // Portfolio Sidebar
          AnimatedBuilder(
            animation: _sidebarAnimationController,
            builder: (context, child) {
              if (_isPortfolioSidebarOpen || _sidebarAnimationController.value > 0) {
                return SlideTransition(
                  position: _sidebarSlideAnimation,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FractionallySizedBox(
                      widthFactor: 0.5, // Right half of the screen
                      child: _buildPortfolioSidebar(),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Portfolio Modal
          if (_selectedPortfolioItem != null)
            _buildPortfolioModal(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient background (palette-based, no photo)
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.navy,
                  AppColors.teal,
                  AppColors.skyBlue,
                ],
              ),
            ),
          ),
        ),
        // Star particles - only show on Home page
        if (_selectedNav != 'About') const _StarField(),
      ],
    );
  }

  Widget _buildNavigation() {
    final navItems = ['Home', 'About', 'Resume', 'Portfolio'];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Navigation links
          Row(
            children: navItems.map((item) {
              final isSelected = _selectedNav == item;
              return GestureDetector(
                onTap: () {
                  if (item == 'Resume') {
                    _openResume();
                  } else if (item == 'Portfolio') {
                    _togglePortfolioSidebar();
                  } else {
                    _navigateToPage(item);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item,
                        style: GoogleFonts.inter(
                          color: isSelected 
                              ? const Color(0xFF9BA8AB) // Light blue/cyan for selected
                              : const Color(0xFFCCD0CF), // White for unselected
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 2,
                          width: item.length * 8.0,
                          color: const Color(0xFF9BA8AB), // Light blue underline
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          // Phone number
          Row(
            children: [
              const Icon(
                Icons.phone,
                color: Color(0xFFCCD0CF),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '774-555-3021',
                style: GoogleFonts.inter(
                  color: const Color(0xFFCCD0CF),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 40.0),
      child: Row(
        children: [
          // LEFT: Text content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated running dog art above first name
                  AnimatedBuilder(
                    animation: _dogAnimation,
                    builder: (context, child) {
                      // Add slight vertical bounce for running effect
                      final bounce = (math.sin(_dogAnimationController.value * 2 * math.pi) * 5);
                      return Transform.translate(
                        offset: Offset(_dogAnimation.value, bounce),
                        child: Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          child: const Text(
                            '🐕',
                            style: TextStyle(fontSize: 60),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // First name (smaller, lighter)
                  Text(
                    'MIKE LEUSTER',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFCCD0CF),
                      fontSize: 50,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 3,
                    ),
                  ),
                  
                  // Last name (much larger, bold) - moved up for tighter spacing
                  Transform.translate(
                    offset: const Offset(0, -24),
                    child: Text(
                      'ESTRADA',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFCCD0CF),
                        fontSize: 96,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  
                  // Subtitle - moved up for tighter spacing and wider letter spacing to align with last name
                  Transform.translate(
                    offset: const Offset(0, -32),
                    child: Text(
                      'BS in Computer Engineering',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFCCD0CF),
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 9,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Buttons - aligned with subtitle
                  Row(
                    children: [
                      _buildOutlineButton('Resume'),
                      const SizedBox(width: 24),
                      _buildOutlineButton('Portfolio'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 60),

          // RIGHT: Photo with decorative shapes
          Expanded(
            flex: 2,
            child: Align(
              alignment: const Alignment(0.2, 0),
              child: SizedBox(
                width: 720,
                height: 820,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background gradient circles
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _CircularGradientPainter(),
                      ),
                    ),
                    
                    // Large circular outline with white neon gradient
                    CustomPaint(
                      size: const Size(630, 630),
                      painter: _GradientCirclePainter(
                        radius: 315,
                        width: 4.5,
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.7),
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.9),
                        ],
                      ),
                    ),
                    // Medium circular outline with white neon gradient
                    CustomPaint(
                      size: const Size(550, 550),
                      painter: _GradientCirclePainter(
                        radius: 275,
                        width: 4,
                        colors: [
                          Colors.white.withOpacity(0.8),
                          Colors.white.withOpacity(0.6),
                          Colors.white.withOpacity(0.4),
                        ],
                      ),
                    ),
                    // Small circular outline with white neon gradient
                    CustomPaint(
                      size: const Size(470, 470),
                      painter: _GradientCirclePainter(
                        radius: 235,
                        width: 3.5,
                        colors: [
                          Colors.white.withOpacity(0.7),
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.3),
                        ],
                      ),
                    ),

                    // Floating orbs with gradients - top left (large)
                    Positioned(
                      top: 30,
                      left: 15,
                      child: _buildGradientOrb(size: 110),
                    ),
                    // Floating orb - top center
                    Positioned(
                      top: 60,
                      right: 70,
                      child: _buildGradientOrb(size: 65),
                    ),
                    // Floating orb - bottom right
                    Positioned(
                      bottom: 20,
                      right: 10,
                      child: _buildGradientOrb(size: 90),
                    ),
                    // Floating orb - bottom left
                    Positioned(
                      bottom: 50,
                      left: 35,
                      child: _buildGradientOrb(size: 55),
                    ),

                    // Decorative geometric shapes
                    Positioned(
                      top: 90,
                      right: 40,
                      child: _buildGeometricShape(size: 50),
                    ),
                    Positioned(
                      bottom: 70,
                      left: 25,
                      child: _buildGeometricShape(size: 40),
                    ),

                    // Photo (no shadow, no frame) with curved bottom
                    ClipPath(
                      clipper: _CurvedBottomClipper(),
                      child: Image.asset(
                        'assets/images/id.png',
                        width: 500,
                        height: 650,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientOrb({double size = 60}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF6AB0FF).withOpacity(0.9), // Bright sky blue
            const Color(0xFF5AA0F2).withOpacity(0.7), // Medium blue
            const Color(0xFF4A90E2).withOpacity(0.5), // Deep blue
            const Color(0xFF3A80D2).withOpacity(0.3), // Darker blue
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.6, 0.85, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6AB0FF).withOpacity(0.5),
            blurRadius: size * 0.5,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
    );
  }

  Widget _buildGeometricShape({double size = 40}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF7AC0FF).withOpacity(0.6), // Light blue
            const Color(0xFF6AB0FF).withOpacity(0.5), // Sky blue
            const Color(0xFF5AA0F2).withOpacity(0.4), // Medium blue
            const Color(0xFF4A90E2).withOpacity(0.2), // Deep blue
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
        border: Border.all(
          color: const Color(0xFF8AD0FF).withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6AB0FF).withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
  
  Widget _buildOutlineButton(String text) {
    return _AnimatedHoverButton(
      text: text,
      onPressed: () {
        if (text == 'Resume') {
          _openResume();
        } else if (text == 'Portfolio') {
          _togglePortfolioSidebar();
        } else {
          _navigateToPage(text);
        }
      },
    );
  }

  Widget _buildPortfolioSidebar() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.navy,
            AppColors.teal,
            AppColors.skyBlue,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with tech icons and close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tech icons row
                    Expanded(
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          _buildTechIcon(Icons.build, 'Tools'),
                          _buildTechIcon(Icons.settings, 'Settings'),
                          _buildTechIcon(Icons.waves, 'Design'),
                          _buildTechIcon(Icons.code, 'Code'),
                          _buildTechIcon(Icons.image, 'Photo'),
                          _buildTechIcon(Icons.videocam, 'Video'),
                          _buildTechIcon(Icons.palette, 'Creative'),
                          _buildTechIcon(Icons.computer, 'Tech'),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _closePortfolioSidebar,
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFFCCD0CF),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Portfolio grid content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.3,
                children: [
                  _buildPortfolioCard(
                    title: 'She Records',
                    subtitle: 'Videography | Video Editing',
                    imagePath: 'assets/images/edit.jpg',
                    onTap: () => _openPortfolioModal('She Records'),
                  ),
                  _buildPortfolioCard(
                    title: 'She Captures',
                    subtitle: 'Photography',
                    imagePath: 'assets/images/ORG.jpg',
                    onTap: () => _openPortfolioModal('She Captures'),
                  ),
                  _buildPortfolioCard(
                    title: 'She Excels',
                    subtitle: 'Compilation of Certificates',
                    imagePath: 'assets/images/edit.jpg',
                    onTap: () => _openPortfolioModal('She Excels'),
                  ),
                  _buildPortfolioCard(
                    title: 'She Volunteers',
                    subtitle: 'Volunteerism',
                    imagePath: 'assets/images/edit.jpg',
                    onTap: () => _openPortfolioModal('She Volunteers'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechIcon(IconData icon, String label) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFF9BA8AB).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: const Color(0xFFCCD0CF),
        size: 18,
      ),
    );
  }

  Widget _buildPortfolioCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return _AnimatedHoverPortfolioCard(
      title: title,
      subtitle: subtitle,
      imagePath: imagePath,
      onTap: onTap,
    );
  }

  Widget _buildPortfolioModal() {
    if (_selectedPortfolioItem == null) {
      return const SizedBox.shrink();
    }

    // Get content based on selected item
    String headerQuestion;
    String mainText;
    String title;
    String subtitle;
    String description;
    String imagePath;

    switch (_selectedPortfolioItem) {
      case 'She Records':
        headerQuestion = 'Why do you like recording videos?';
        mainText = 'Life is short, choose to be happy always. Capture everything. Document your life. Save Memories. Cherish literally every moment because life has no rewind.';
        title = 'She Records';
        subtitle = 'Videography | Video Editing';
        description = 'I always love the life through lens and making my life like a movie. I have a passion in making videos since I was young, and I\'m still been doing what I love now.';
        imagePath = 'assets/images/edit.jpg';
        break;
      case 'She Captures':
        headerQuestion = 'Why do you like photography?';
        mainText = 'Life is short, choose to be happy always. Capture everything. Document your life. Save Memories. Cherish literally every moment because life has no rewind.';
        title = 'She Captures';
        subtitle = 'Photography';
        description = 'I always love the life through lens and making my life like a movie. I have a passion in making videos since I was young, and I\'m still been doing what I love now.';
        imagePath = 'assets/images/ORG.jpg';
        break;
      case 'She Excels':
        headerQuestion = 'Why do you pursue excellence?';
        mainText = 'Life is short, choose to be happy always. Capture everything. Document your life. Save Memories. Cherish literally every moment because life has no rewind.';
        title = 'She Excels';
        subtitle = 'Compilation of Certificates';
        description = 'I always love the life through lens and making my life like a movie. I have a passion in making videos since I was young, and I\'m still been doing what I love now.';
        imagePath = 'assets/images/edit.jpg';
        break;
      case 'She Volunteers':
        headerQuestion = 'Why do you volunteer?';
        mainText = 'Life is short, choose to be happy always. Capture everything. Document your life. Save Memories. Cherish literally every moment because life has no rewind.';
        title = 'She Volunteers';
        subtitle = 'Volunteerism';
        description = 'I always love the life through lens and making my life like a movie. I have a passion in making videos since I was young, and I\'m still been doing what I love now.';
        imagePath = 'assets/images/edit.jpg';
        break;
      default:
        return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _modalFadeAnimation,
      child: GestureDetector(
        onTap: _closePortfolioModal,
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: SlideTransition(
              position: _modalSlideAnimation,
              child: GestureDetector(
                onTap: () {}, // Prevent closing when tapping inside modal
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  constraints: const BoxConstraints(maxWidth: 800),
                  margin: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5DC), // Crumpled paper color
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with question
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1A1A1A),
                          ),
                          child: Text(
                            headerQuestion,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        // Content area
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text content
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mainText,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF2C2C2C),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 1.6,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Portfolio item details
                                    Text(
                                      title,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF1A1A1A),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      subtitle,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF666666),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      description,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF2C2C2C),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(width: 24),
                              
                              // Image with torn edges effect
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          imagePath,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    const Color(0xFF11212D),
                                                    const Color(0xFF06141B),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    // Decorative doodles (stars, scribbles)
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: Text(
                                        '⭐',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -5,
                                      left: -5,
                                      child: Text(
                                        '✏️',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Visit button
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _openPortfolioPDF();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF9D4EDD), // Purple
                                        Color(0xFF4169E1), // Blue
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4169E1).withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  child: Text(
                                    'Visit',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutContent() {
    return Row(
      children: [
        // Left panel - Text content
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 80.0, right: 60.0, top: 40.0, bottom: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ABOUT title with underline
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ABOUT',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFCCD0CF),
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      height: 2,
                      width: 120,
                      color: const Color(0xFF9BA8AB), // Light blue underline
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Email
                Text(
                  'm.leuster@email.com',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFCCD0CF),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Description
                Text(
                  'Computer Engineering graduate with a passion for technology and innovation. '
                  'I specialize in software development and system design, with expertise in '
                  'implementing effective IT solutions. My greatest strength is problem-solving, '
                  'which enables me to create efficient and scalable applications. I am dedicated '
                  'to continuous learning and staying current with the latest technologies.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFCCD0CF),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 48),
                
                // Location with decorative lines
                Row(
                  children: [
                    Container(
                      height: 1,
                      width: 40,
                      color: const Color(0xFF9BA8AB),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Florida, Orlando',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFCCD0CF),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '12529 State Road 535',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFCCD0CF),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 1,
                      width: 40,
                      color: const Color(0xFF9BA8AB),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Right panel - Image occupying entire right side
        Expanded(
          flex: 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image displayed as PNG itself - no box
              Positioned.fill(
                child: Image.asset(
                  'assets/images/back.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
              // Dark overlay for blending
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final socialIcons = [
      _SocialIcon(icon: Icons.share, url: 'https://facebook.com', label: 'Facebook'),
      _SocialIcon(icon: Icons.business_center, url: 'https://linkedin.com/in/mike-leuster-estrada', label: 'LinkedIn'),
      _SocialIcon(icon: Icons.code, url: 'https://github.com/mikeeyyyy04', label: 'GitHub'),
      _SocialIcon(icon: Icons.photo_camera, url: 'https://instagram.com/_mikeeyyyyyy', label: 'Instagram'),
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 80.0, bottom: 40.0),
      child: Row(
        children: socialIcons.map((socialIcon) {
          return Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: GestureDetector(
              onTap: () async {
                final uri = Uri.parse(socialIcon.url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Icon(
                socialIcon.icon,
                color: const Color(0xFFCCD0CF),
                size: 24,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SocialIcon {
  final IconData icon;
  final String url;
  final String label;

  _SocialIcon({required this.icon, required this.url, required this.label});
}

// Star field widget for background particles
// Animated hover button widget
class _AnimatedHoverButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _AnimatedHoverButton({
    required this.text,
    required this.onPressed,
  });

  @override
  State<_AnimatedHoverButton> createState() => _AnimatedHoverButtonState();
}

class _AnimatedHoverButtonState extends State<_AnimatedHoverButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: _isHovered
                    ? SweepGradient(
                        transform: GradientRotation(_rotationAnimation.value),
                        center: Alignment.center,
                        colors: [
                          const Color(0xFF4169E1), // Royal blue - bright
                          const Color(0xFF1E90FF), // Dodger blue
                          const Color(0xFF0066CC).withOpacity(0.3), // Deep blue - dim
                          const Color(0xFF1E90FF), // Dodger blue
                          const Color(0xFF4169E1), // Royal blue - bright
                          const Color(0xFF1E90FF), // Dodger blue
                          const Color(0xFF0066CC).withOpacity(0.3), // Deep blue - dim
                          const Color(0xFF1E90FF), // Dodger blue
                          const Color(0xFF4169E1), // Royal blue - bright
                        ],
                        stops: const [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0],
                      )
                    : null,
                border: _isHovered
                    ? null
                    : Border.all(
                        color: const Color(0xFFCCD0CF),
                        width: 1.5,
                      ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4169E1).withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                constraints: const BoxConstraints(
                  minWidth: 180,
                  minHeight: 48,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black,
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _isHovered
                          ? const Color(0xFF4169E1)
                          : Colors.white,
                      letterSpacing: 1,
                    ),
                    child: Text(
                      widget.text.toUpperCase(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StarField extends StatelessWidget {
  const _StarField();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
            return const SizedBox.shrink();
          }
          
          final random = math.Random(42); // Fixed seed for consistent stars
          final stars = List.generate(100, (index) {
            return Positioned(
              left: random.nextDouble() * constraints.maxWidth,
              top: random.nextDouble() * constraints.maxHeight,
              child: Container(
                width: 2,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCD0CF).withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
              ),
            );
          });

          return Stack(children: stars);
        },
      ),
    );
  }
}

class _AnimatedHoverPortfolioCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  const _AnimatedHoverPortfolioCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
  });

  @override
  State<_AnimatedHoverPortfolioCard> createState() => _AnimatedHoverPortfolioCardState();
}

class _AnimatedHoverPortfolioCardState extends State<_AnimatedHoverPortfolioCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: _isHovered
                    ? SweepGradient(
                        transform: GradientRotation(_rotationAnimation.value),
                        center: Alignment.center,
                        colors: [
                          const Color(0xFF4169E1), // Royal blue - bright
                          const Color(0xFF1E90FF), // Dodger blue
                          const Color(0xFF0066CC).withOpacity(0.3), // Deep blue - dim
                          const Color(0xFF1E90FF), // Dodger blue
                          const Color(0xFF4169E1), // Royal blue - bright
                          const Color(0xFF1E90FF), // Dodger blue
                          const Color(0xFF0066CC).withOpacity(0.3), // Deep blue - dim
                          const Color(0xFF1E90FF), // Dodger blue
                          const Color(0xFF4169E1), // Royal blue - bright
                        ],
                        stops: const [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0],
                      )
                    : null,
                border: _isHovered
                    ? null
                    : Border.all(
                        color: const Color(0xFF9BA8AB).withOpacity(0.2),
                        width: 1,
                      ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4169E1).withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback gradient if image not found
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF11212D),
                                const Color(0xFF06141B),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // Dark overlay for better text readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Content overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.9),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.inter(
                                color: _isHovered
                                    ? const Color(0xFF4169E1)
                                    : const Color(0xFFCCD0CF),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.subtitle,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF9BA8AB),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Custom painter for circular gradient background
class _CircularGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw multiple gradient circles with rich color transitions
    for (int i = 0; i < 4; i++) {
      final gradient = RadialGradient(
        colors: [
          const Color(0xFF6AB0FF).withOpacity(0.15 - (i * 0.03)), // Bright sky blue
          const Color(0xFF5AA0F2).withOpacity(0.12 - (i * 0.025)), // Medium blue
          const Color(0xFF4A90E2).withOpacity(0.1 - (i * 0.02)), // Deep blue
          const Color(0xFF3A80D2).withOpacity(0.08 - (i * 0.015)), // Darker blue
          const Color(0xFF2A70C2).withOpacity(0.05 - (i * 0.01)), // Dark blue
          Colors.transparent,
        ],
        stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: radius - (i * 35)),
        );

      canvas.drawCircle(
        center,
        radius - (i * 35),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for soft glow effect (like the image)
class _GlowEffectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.3); // Upper-middle position
    
    // Create soft glowing light source
    final glowGradient = RadialGradient(
      colors: [
        Colors.white.withOpacity(0.15), // Bright center
        const Color(0xFFB0D0FF).withOpacity(0.1), // Light blue-white
        const Color(0xFF90C0EF).withOpacity(0.05), // Soft blue
        Colors.transparent,
      ],
      stops: const [0.0, 0.3, 0.6, 1.0],
    );

    final paint = Paint()
      ..shader = glowGradient.createShader(
        Rect.fromCircle(center: center, radius: size.width * 0.4),
      );

    canvas.drawCircle(center, size.width * 0.4, paint);
    
    // Additional subtle glow layers
    for (int i = 1; i <= 2; i++) {
      final subtleGlow = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.08 - (i * 0.02)),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: size.width * (0.3 + i * 0.1)),
        );
      
      canvas.drawCircle(center, size.width * (0.3 + i * 0.1), subtleGlow);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for gradient circle borders
class _GradientCirclePainter extends CustomPainter {
  final double radius;
  final double width;
  final List<Color> colors;

  _GradientCirclePainter({
    required this.radius,
    required this.width,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Create a sweep gradient (circular gradient)
    final gradient = SweepGradient(
      center: Alignment.center,
      colors: colors,
      stops: List.generate(colors.length, (i) => i / (colors.length - 1)),
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    // Draw the circle
    canvas.drawCircle(center, radius, paint);
    
    // Add glow effect with multiple strokes
    for (int i = 1; i <= 3; i++) {
      final glowPaint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: radius),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = width - (i * 0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, i * 2.0);
      
      canvas.drawCircle(center, radius, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom clipper for photo with curved bottom matching circular line
class _CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = 40.0; // Top corner radius
    final curveRadius = 235.0; // Radius of the smallest circle
    final curveHeight = 100.0; // How much the curve dips at center
    
    // Top-left rounded corner
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    
    // Top-right rounded corner
    path.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
    );
    
    // Right side down to where curve starts
    final rightCurveStart = size.height - curveHeight;
    path.lineTo(size.width, rightCurveStart);
    
    // Curved bottom following circular arc
    // The arc center is above the photo, creating a concave curve
    final arcCenterX = size.width / 2;
    final arcCenterY = rightCurveStart - curveRadius;
    
    // Create rect for the arc
    final arcRect = Rect.fromCircle(
      center: Offset(arcCenterX, arcCenterY),
      radius: curveRadius,
    );
    
    // Draw arc from right to left (bottom arc of circle)
    path.arcTo(
      arcRect,
      0.0, // Start angle (right side)
      math.pi, // Sweep angle (180 degrees for bottom half)
      false, // largeArc
    );
    
    // Left side up
    path.lineTo(0, radius);
    
    // Top-left rounded corner
    path.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
    );
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

