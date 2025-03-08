import 'dart:io';

import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/core/services/user_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageOnboardingComponent extends StatefulWidget {
  String? imagePath;
  final Function(String) onImageSelected;

  ImageOnboardingComponent(
      {super.key, required this.imagePath, required this.onImageSelected});

  @override
  State<ImageOnboardingComponent> createState() =>
      _ImageOnboardingComponentState();
}

class _ImageOnboardingComponentState extends State<ImageOnboardingComponent> {
  final UserService _service = UserService();
  bool _isLocalImage = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _updateImageState();
  }

  @override
  void didUpdateWidget(ImageOnboardingComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _updateImageState();
    }
  }

  void _updateImageState() {
    setState(() {
      _isLocalImage = widget.imagePath != null &&
          !widget.imagePath!.startsWith('http://') &&
          !widget.imagePath!.startsWith('https://');
      _errorMessage = null;
    });
    print('Image path: ${widget.imagePath}, isLocalImage: $_isLocalImage');
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final selectedImagePath = await _service.pickImage();
      print('Selected image path: $selectedImagePath');

      if (selectedImagePath.isNotEmpty) {
        // Check if file exists and is readable
        final file = File(selectedImagePath);
        if (await file.exists()) {
          final fileSize = await file.length();
          print('File size: $fileSize bytes');

          if (fileSize > 0) {
            setState(() {
              widget.imagePath = selectedImagePath;
              _isLocalImage = true;
              _isLoading = false;
            });
            widget.onImageSelected(selectedImagePath);
          } else {
            setState(() {
              _errorMessage = "Selected file is empty";
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _errorMessage = "Selected file does not exist";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      setState(() {
        _errorMessage = "Error selecting image: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _pickImage,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 320,
        width: 200,
        decoration: BoxDecoration(
            color: AppColors.transparentGrey,
            borderRadius: BorderRadius.circular(20)),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
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
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey),
            ),
          ],
        ),
      );
    }

    if (widget.imagePath == null) {
      return const Center(
        child: Icon(
          Icons.add_rounded,
          size: 64,
          color: AppColors.lightGrey,
        ),
      );
    }

    if (_isLocalImage) {
      try {
        return Image.file(
                    File(widget.imagePath!),
                    fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading file image: $error');
            return const Center(
                child: Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.lightGrey,
              ),
            );
          },
        );
      } catch (e) {
        print('Exception loading file image: $e');
        return const Center(
          child: Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.lightGrey,
          ),
        );
      }
    } else {
      return Image.network(
        widget.imagePath!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading network image: $error');
          return const Center(
            child: Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.lightGrey,
            ),
          );
        },
      );
    }
  }
}
