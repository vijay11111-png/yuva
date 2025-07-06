import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../config/colors.dart';
import '../models/user_registration_model.dart';
import '../models/college_model.dart';
import '../models/course_model.dart';
import '../services/college_service.dart';
import '../services/course_service.dart';
import '../controllers/registration_controller.dart';
import '../widgets/progress_indicator_widget.dart';

class AcademicInfoScreen extends StatefulWidget {
  final String phoneNumber;
  final UserRegistrationModel? existingData;

  const AcademicInfoScreen({
    super.key,
    required this.phoneNumber,
    this.existingData,
  });

  @override
  State<AcademicInfoScreen> createState() => _AcademicInfoScreenState();
}

class _AcademicInfoScreenState extends State<AcademicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _collegeController = TextEditingController();
  final _courseController = TextEditingController();
  final FocusNode _collegeFocusNode = FocusNode();
  final FocusNode _courseFocusNode = FocusNode();

  CollegeModel? _selectedCollege;
  CourseModel? _selectedCourse;
  int? _selectedYear;
  File? _collegeIdImage;
  bool _isLoading = false;
  bool _isSearchingCollege = false;
  bool _isSearchingCourse = false;
  List<CollegeModel> _collegeSearchResults = [];
  List<CourseModel> _courseSearchResults = [];
  Timer? _collegeSearchDebounce;
  Timer? _courseSearchDebounce;
  bool _showAddCollegeOption = false;
  bool _showAddCourseOption = false;

  final CollegeService _collegeService = CollegeService();
  final CourseService _courseService = CourseService();
  final ImagePicker _imagePicker = ImagePicker();

  // Year options
  final List<int> _yearOptions = [1, 2, 3, 4, 5, 6];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
    _collegeController.addListener(_onCollegeTextChanged);
    _courseController.addListener(_onCourseTextChanged);
  }

  @override
  void dispose() {
    _collegeController.removeListener(_onCollegeTextChanged);
    _courseController.removeListener(_onCourseTextChanged);
    _collegeController.dispose();
    _courseController.dispose();
    _collegeFocusNode.dispose();
    _courseFocusNode.dispose();
    _collegeSearchDebounce?.cancel();
    _courseSearchDebounce?.cancel();
    super.dispose();
  }

  void _loadExistingData() {
    if (widget.existingData != null) {
      _courseController.text = widget.existingData!.course ?? '';
      _selectedYear = widget.existingData!.yearOfStudy;

      // Load college name if exists
      if (widget.existingData!.college != null) {
        _collegeController.text = widget.existingData!.college!;
        // Note: We'll need to fetch the actual college object if needed
      }
    }
  }

  void _onCollegeTextChanged() {
    // Cancel previous search
    _collegeSearchDebounce?.cancel();

    final query = _collegeController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _collegeSearchResults.clear();
        _showAddCollegeOption = false;
        _selectedCollege = null;
      });
      return;
    }

    // Debounce search to avoid too many API calls
    _collegeSearchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _searchColleges(query);
      }
    });
  }

  void _onCourseTextChanged() {
    // Cancel previous search
    _courseSearchDebounce?.cancel();

    final query = _courseController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _courseSearchResults.clear();
        _showAddCourseOption = false;
        _selectedCourse = null;
      });
      return;
    }

    // Debounce search to avoid too many API calls
    _courseSearchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _searchCourses(query);
      }
    });
  }

  Future<void> _searchColleges(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearchingCollege = true;
    });

    try {
      final results = await _collegeService.searchColleges(query);

      if (mounted) {
        setState(() {
          _collegeSearchResults = results;
          _showAddCollegeOption = results.isEmpty && query.length >= 2;
          _isSearchingCollege = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _collegeSearchResults.clear();
          _showAddCollegeOption = true;
          _isSearchingCollege = false;
        });
      }
    }
  }

  Future<void> _searchCourses(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearchingCourse = true;
    });

    try {
      final results = await _courseService.searchCourses(query);

      if (mounted) {
        setState(() {
          _courseSearchResults = results;
          _showAddCourseOption = results.isEmpty && query.length >= 2;
          _isSearchingCourse = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _courseSearchResults.clear();
          _showAddCourseOption = true;
          _isSearchingCourse = false;
        });
      }
    }
  }

  void _selectCollege(CollegeModel college) {
    setState(() {
      _selectedCollege = college;
      _collegeController.text = college.name;
      _collegeSearchResults.clear();
      _showAddCollegeOption = false;
    });
    // Remove focus to prevent text input glitch
    _collegeFocusNode.unfocus();
  }

  void _selectCourse(CourseModel course) {
    setState(() {
      _selectedCourse = course;
      _courseController.text = course.name;
      _courseSearchResults.clear();
      _showAddCourseOption = false;
    });
    // Remove focus to prevent text input glitch
    _courseFocusNode.unfocus();
  }

  void _addCustomCollege() {
    setState(() {
      _selectedCollege = null;
      _collegeSearchResults.clear();
      _showAddCollegeOption = false;
    });
    // Remove focus to prevent text input glitch
    _collegeFocusNode.unfocus();
  }

  void _addCustomCourse() {
    setState(() {
      _selectedCourse = null;
      _courseSearchResults.clear();
      _showAddCourseOption = false;
    });
    // Remove focus to prevent text input glitch
    _courseFocusNode.unfocus();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _collegeIdImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _takePhotoWithCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _collegeIdImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to take photo: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Upload College ID',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _takePhotoWithCamera();
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImageFromGallery();
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isFormValid() {
    return _collegeController.text.trim().isNotEmpty &&
        _courseController.text.trim().isNotEmpty &&
        _selectedYear != null &&
        _collegeIdImage != null;
  }

  Future<void> _proceedToNextStep() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final collegeName = _collegeController.text.trim();

      // If no college was selected from search results, add to pending colleges
      if (_selectedCollege == null) {
        final exists = await _collegeService.collegeExists(collegeName);
        if (!exists) {
          await _collegeService.addPendingCollege(collegeName);
        }
      }

      final courseName = _courseController.text.trim();

      // If no course was selected from search results, add to pending courses
      if (_selectedCourse == null) {
        final exists = await _courseService.courseExists(courseName);
        if (!exists) {
          await _courseService.addPendingCourse(courseName);
        }
      }

      // Update registration controller
      final registrationController = RegistrationController();
      registrationController.initialize(widget.phoneNumber);

      registrationController.updateStep2Data(
        college: collegeName,
        course: _courseController.text.trim(),
        yearOfStudy: _selectedYear,
        collegeIdImagePath: _collegeIdImage?.path,
      );

      // Save the data
      final success = await registrationController.saveCurrentStep();

      if (success && mounted) {
        // Navigate to step 3
        final registrationController = RegistrationController();
        registrationController.initialize(widget.phoneNumber);
        registrationController.nextStep();

        Navigator.pushReplacementNamed(
          context,
          '/registration',
          arguments: {'phoneNumber': widget.phoneNumber},
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save data. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close dropdowns when tapping outside
        _collegeFocusNode.unfocus();
        _courseFocusNode.unfocus();
        setState(() {
          _collegeSearchResults.clear();
          _courseSearchResults.clear();
          _showAddCollegeOption = false;
          _showAddCourseOption = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Academic Information'),
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Indicator
                const RegistrationProgressIndicator(currentStep: 2),

                // Form Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // College/Institution Field
                      TextFormField(
                        controller: _collegeController,
                        focusNode: _collegeFocusNode,
                        decoration: InputDecoration(
                          labelText: 'College / Institution',
                          hintText: 'Start typing to search your college',
                          prefixIcon: const Icon(Icons.school),
                          suffixIcon:
                              _isSearchingCollege
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.primaryPurple,
                                        ),
                                      ),
                                    ),
                                  )
                                  : null,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your college name';
                          }
                          return null;
                        },
                      ),

                      // College Search Results Dropdown
                      if (_collegeSearchResults.isNotEmpty ||
                          _showAddCollegeOption)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.borderLight),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search Results
                              ..._collegeSearchResults.map(
                                (college) => ListTile(
                                  dense: true,
                                  title: Text(
                                    college.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  onTap: () => _selectCollege(college),
                                ),
                              ),

                              // Add Custom College Option
                              if (_showAddCollegeOption)
                                ListTile(
                                  dense: true,
                                  leading: const Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.warning,
                                    size: 20,
                                  ),
                                  title: Text(
                                    'Couldn\'t find your college? You can type and add it.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  onTap: _addCustomCollege,
                                ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Course Field
                      TextFormField(
                        controller: _courseController,
                        focusNode: _courseFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Course / Program',
                          hintText: 'Start typing to search your course',
                          prefixIcon: const Icon(Icons.book),
                          suffixIcon:
                              _isSearchingCourse
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.primaryPurple,
                                        ),
                                      ),
                                    ),
                                  )
                                  : null,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your course';
                          }
                          return null;
                        },
                      ),

                    // Course Search Results Dropdown
                    if (_courseSearchResults.isNotEmpty || _showAddCourseOption)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.borderLight),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Search Results
                            ..._courseSearchResults.map(
                              (course) => ListTile(
                                dense: true,
                                title: Text(
                                  course.name,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                onTap: () => _selectCourse(course),
                              ),
                            ),

                            // Add Custom Course Option
                            if (_showAddCourseOption)
                              ListTile(
                                dense: true,
                                leading: const Icon(
                                  Icons.add_circle_outline,
                                  color: AppColors.warning,
                                  size: 20,
                                ),
                                title: Text(
                                  'Couldn\'t find your course? You can type and add it.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                onTap: _addCustomCourse,
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Year of Study
                    const Text(
                      'Year of Study',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderLight),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children:
                            _yearOptions
                                .map((year) => _buildYearOption(year))
                                .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // College ID Upload
                    const Text(
                      'College ID Card',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // NOTE: If you get MissingPluginException for image_picker, do a full stop and restart of the app (not just hot reload)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 32,
                        maxHeight: 220,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                _collegeIdImage != null
                                    ? AppColors.primaryPurple
                                    : AppColors.borderLight,
                            width: _collegeIdImage != null ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            _collegeIdImage != null
                                ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _collegeIdImage!,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _collegeIdImage = null;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: const Text(
                                          'College ID',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : InkWell(
                                  onTap: _showImagePickerDialog,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo,
                                          size: 48,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Upload College ID Card',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Tap to select from camera or gallery',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                      ),
                    ),
                    if (_collegeIdImage == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Please upload a clear photo of your college ID card for verification',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid() ? _proceedToNextStep : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text(
                              'Next Step',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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

  Widget _buildYearOption(int year) {
    final isSelected = _selectedYear == year;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedYear = year;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryPurple.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Year $year',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.primaryPurple : AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
