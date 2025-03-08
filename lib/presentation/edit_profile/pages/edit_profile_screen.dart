import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/app_colors.dart';
import '../../../common/components/onboarding_components/image_onboarding_component.dart';
import '../../../core/services/user_service.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/profile/bloc/profile_bloc.dart';
import '../../../presentation/profile/bloc/profile_event.dart';
import '../bloc/edit_bloc.dart';
import '../bloc/edit_event.dart';
import '../bloc/edit_state.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditProfileBloc(UserService())..add(FetchUserEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profili Duzenle",
              style: Theme.of(context).textTheme.headlineLarge),
          elevation: 0,
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is EditProfileLoaded && state.wasUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil basariyla guncellendi!'),
                  backgroundColor: Colors.green,
                ),
              );

              // Profil sayfasını güncellemek için ProfileBloc'a LoadingProfile olayını gönder
              BlocProvider.of<ProfileBloc>(context, listen: false)
                  .add(LoadingProfile());

              // Kısa bir gecikme sonra önceki sayfaya dön
              Future.delayed(const Duration(milliseconds: 500), () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              });
            }
          },
          builder: (context, state) {
            if (state is EditProfileLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryYellow),
                    SizedBox(height: 16),
                    Text('Profil guncelleniyor...'),
                  ],
                ),
              );
            } else if (state is EditProfileLoaded) {
              return EditProfileForm(user: state.user);
            } else if (state is EditProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<EditProfileBloc>().add(FetchUserEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryYellow,
                      ),
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  final UserModel user;

  const EditProfileForm({required this.user, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late TextEditingController _bioController;

  String? _imagePath;
  bool _isImageChanged = false;
  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.user.bio);

    _imagePath = widget.user.profilePicture;

    // Değişiklikleri dinle
    _bioController.addListener(_checkChanges);
  }

  @override
  void dispose() {
    _bioController.removeListener(_checkChanges);

    _bioController.dispose();

    super.dispose();
  }

  void _checkChanges() {
    setState(() {
      _hasChanges = _bioController.text != widget.user.bio || _isImageChanged;
    });
  }

  void _saveProfile() {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    context
        .read<EditProfileBloc>()
        .add(UpdateProfileEvent(_imagePath, _bioController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileLoaded || state is EditProfileError) {
          setState(() {
            _isSaving = false;
          });
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Profil Resmi Bölümü
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profil Fotografi",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  "Gercek seni gösteren bir fotograf sec.",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.grey,
                      ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ImageOnboardingComponent(
                    imagePath: _imagePath,
                    onImageSelected: (selectedImagePath) {
                      setState(() {
                        _imagePath = selectedImagePath;
                        _isImageChanged = true;
                        _hasChanges = true;
                      });
                    },
                  ),
                ),
                if (_isImageChanged)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: Text(
                        "Fotograf secildi ve kaydedildiginde yuklenecek",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.primaryYellow,
                              fontStyle: FontStyle.italic,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bio Bölümü
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hakkinda",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  "Eglenceli ve etkileyici bir tanitim yaz.",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.grey,
                      ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _bioController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Kendin hakkinda biraz bilgi...",
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    filled: true,
                    fillColor: AppColors.background,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: AppColors.primaryYellow),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Kaydet Butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _hasChanges && !_isSaving ? _saveProfile : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: AppColors.black,
                disabledBackgroundColor: AppColors.lightGrey,
                disabledForegroundColor: AppColors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isSaving
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Kaydediliyor...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      "Kaydet",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // İptal Butonu
          if (_hasChanges)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Degisiklikleri Iptal Et'),
                      content: const Text(
                          'Yaptigin degisiklikler kaydedilmeyecek. Devam etmek istiyor musun?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hayir'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Dialog'u kapat
                            Navigator.pop(
                                context); // Edit Profile ekranını kapat
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Evet, Iptal Et'),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.lightGrey),
                  ),
                ),
                child: const Text(
                  "Iptal",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
