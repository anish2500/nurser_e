import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/core/utils/my_snackbar.dart';
import 'package:nurser_e/features/auth/presentation/pages/login_screens.dart';
import 'package:nurser_e/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Theme configuration
  final Color primaryGreen = Colors.green;
  final Color lightGreen = const Color(0xFFD8F3DC);
  final String fontFamily = 'Poppins Regular';

  // Media state
  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedMediaType;
  String? _profilePictureUrl; // Add this back

  //Permission handling
  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }
    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
          "This feature requires permission to access your camera or gallery. Please enable it in your device settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // --- Media Picking Logic ---
  Future<void> _pickFromGallery() async {
    try {
      final hasPermission = await _requestPermission(Permission.photos);
      if (!hasPermission) return;

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        setState(() {
          _selectedMedia.clear();
          _selectedMedia.add(image);
          _selectedMediaType = 'photo';
        });

        // Upload to server
        await ref.read(authViewModelProvider.notifier).uploadPhoto(file);

        // After upload, get the updated profile picture from session
        final updatedProfileImage = ref
            .read(userSessionServiceProvider)
            .getUserProfileImage();
        if (updatedProfileImage != null && updatedProfileImage.isNotEmpty) {
          setState(() {
            _profilePictureUrl = updatedProfileImage;
          });
        }
      }
    } catch (e) {
      debugPrint('Gallery Error $e');
      if (mounted) {
        showMySnackBar(
          context: context,
          message: 'Unable to access gallery. Please try again.',
          color: Colors.red,
        );
      }
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final hasPermission = await _requestPermission(Permission.camera);
      if (!hasPermission) return;

      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        final file = File(photo.path);
        setState(() {
          _selectedMedia.clear();
          _selectedMedia.add(photo);
          _selectedMediaType = 'photo';
        });

        // Upload to server
        await ref.read(authViewModelProvider.notifier).uploadPhoto(file);

        // After upload, get the updated profile picture from session
        final updatedProfileImage = ref
            .read(userSessionServiceProvider)
            .getUserProfileImage();
        if (updatedProfileImage != null && updatedProfileImage.isNotEmpty) {
          setState(() {
            _profilePictureUrl = updatedProfileImage;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera Error $e');
      if (mounted) {
        showMySnackBar(
          context: context,
          message: 'Unable to access camera. Please try again.',
          color: Colors.red,
        );
      }
    }
  }

  void _handleSelectedMedia(XFile file, String type) {
    setState(() {
      _selectedMedia.clear();
      _selectedMedia.add(file);
      _selectedMediaType = type;
    });
    // Optional: Trigger upload to server here via ViewModel
    // ref.read(authViewModelProvider.notifier).uploadProfileImage(file.path);
  }

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Open Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              if (_selectedMedia.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    setState(() => _selectedMedia.clear());
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Load existing profile picture from session
    _profilePictureUrl = ref
        .read(userSessionServiceProvider)
        .getUserProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    final userSession = ref.watch(userSessionServiceProvider);
    final userName = userSession.getUsername() ?? 'User';
    final userEmail = userSession.getUserEmail() ?? 'Email not available';
    final userProfile =
        userSession.getUserProfileImage() ?? 'Photo not available';

    // Use _profilePictureUrl for consistency
    final displayImage = _profilePictureUrl?.isNotEmpty == true
        ? 'http://192.168.18.4:5050/$_profilePictureUrl'
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // --- Profile Header Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickMedia,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          // Priority: New upload > Stored > Initial
                          backgroundImage: _selectedMedia.isNotEmpty
                              ? FileImage(File(_selectedMedia[0].path))
                              : displayImage != null
                              ? NetworkImage(displayImage!)
                              : null,
                          child:
                              (_selectedMedia.isEmpty && displayImage == null)
                              ? Text(
                                  userName.isNotEmpty
                                      ? userName[0].toUpperCase()
                                      : 'U',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: primaryGreen,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: fontFamily,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryGreen, width: 2),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: primaryGreen,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: fontFamily,
                          ),
                        ),
                        Text(
                          userEmail,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontFamily: fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit_outlined, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- Logout Menu Item ---
            _buildMenuItem(
              icon: Icons.logout_rounded,
              title: "Log out",
              subtitle: "Further secure your account for safety",
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryGreen),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: fontFamily,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Logout',
          style: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontFamily: fontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontFamily: fontFamily),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authViewModelProvider.notifier).logout();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreens()),
                  (route) => false,
                );
              }
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
