import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/core/utils/my_snackbar.dart';
import 'package:nurser_e/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final Color primaryGreen = Colors.green;
  final String fontFamily = 'Poppins Regular';

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  String? _existingProfileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userSession = ref.read(userSessionServiceProvider);
    _fullNameController.text = '';
    _usernameController.text = userSession.getUsername() ?? '';
    _emailController.text = userSession.getUserEmail() ?? '';
    _existingProfileImage = userSession.getUserProfileImage();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final status = await Permission.photos.status;
      if (!status.isGranted) {
        final result = await Permission.photos.request();
        if (!result.isGranted) return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      File? profilePictureFile;
      if (_selectedImage != null) {
        profilePictureFile = File(_selectedImage!.path);
      }

      await ref.read(authViewModelProvider.notifier).updateProfile(
        fullName: _fullNameController.text.trim().isEmpty 
            ? null 
            : _fullNameController.text.trim(),
        username: _usernameController.text.trim().isEmpty 
            ? null 
            : _usernameController.text.trim(),
        email: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        profilePicture: profilePictureFile,
      );

      if (mounted) {
        showMySnackBar(
          context: context,
          message: 'Profile updated successfully',
          color: Colors.green,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showMySnackBar(
          context: context,
          message: 'Failed to update profile: $e',
          color: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getProfileImageUrl() {
    final imageUrl = _selectedImage != null
        ? _selectedImage!.path
        : _existingProfileImage;
    
    if (imageUrl == null || imageUrl.isEmpty) {
      return '';
    }
    
    if (_selectedImage != null) {
      return imageUrl;
    }
    
    return 'http://192.168.18.4:5050/$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: context.textPrimary,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: context.surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: _getProfileImageUrl().isNotEmpty
                          ? (_selectedImage != null
                              ? FileImage(File(_selectedImage!.path))
                              : NetworkImage(_getProfileImageUrl()) as ImageProvider)
                          : null,
                      child: _getProfileImageUrl().isEmpty
                          ? Icon(
                              Icons.person,
                              size: 50,
                              color: primaryGreen,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              const SizedBox(height: 16),

              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: context.textPrimary,
                    fontFamily: fontFamily,
                  ),
                  prefixIcon: Icon(Icons.alternate_email, color: primaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryGreen, width: 2),
                  ),
                ),
                style: TextStyle(fontFamily: fontFamily),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Username must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: context.textPrimary,
                    fontFamily: fontFamily,
                  ),
                  prefixIcon: Icon(Icons.email_outlined, color: primaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryGreen, width: 2),
                  ),
                ),
                style: TextStyle(fontFamily: fontFamily),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontFamily,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
