import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:firebase_practice/core/widgets/kinetic_card.dart';
import 'package:firebase_practice/features/auth/presentation/controllers/auth_controller.dart';
import 'package:firebase_practice/features/auth/presentation/widgets/login_brand_header.dart';
import 'package:firebase_practice/features/auth/presentation/widgets/login_footer.dart';
import 'package:firebase_practice/features/auth/presentation/widgets/login_form_field.dart';
import 'package:firebase_practice/features/auth/presentation/widgets/login_submit_button.dart';
import 'package:firebase_practice/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _AuthMode { signIn, signUp }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  _AuthMode _mode = _AuthMode.signIn;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get _isSignUp => _mode == _AuthMode.signUp;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -140,
            right: -100,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 170,
                    spreadRadius: 80,
                  ),
                ],
              ),
              child: const SizedBox(width: 260, height: 260),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -120,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    blurRadius: 170,
                    spreadRadius: 80,
                  ),
                ],
              ),
              child: const SizedBox(width: 280, height: 280),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 42,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            const SizedBox(height: 24),
                            LoginBrandHeader(
                              subtitle: _isSignUp
                                  ? 'Deploy account'
                                  : 'Command Center Login',
                            ),
                            const SizedBox(height: 36),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 460),
                              child: KineticCard(
                                glass: true,
                                color: AppColors.surfaceContainer,
                                padding: const EdgeInsets.fromLTRB(
                                  28,
                                  30,
                                  28,
                                  30,
                                ),
                                borderRadius: BorderRadius.circular(28),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      _AuthModeSwitcher(
                                        mode: _mode,
                                        onChanged: isLoading
                                            ? null
                                            : (_AuthMode mode) {
                                                setState(() {
                                                  _mode = mode;
                                                });
                                              },
                                      ),
                                      if (_isSignUp) ...<Widget>[
                                        const SizedBox(height: 20),
                                        _RegisterSectionIntro(
                                          onSurface: AppColors.onSurface,
                                          outline: AppColors.outline,
                                        ),
                                        const SizedBox(height: 24),
                                        LoginFormField(
                                          label: 'Developer Alias',
                                          controller: _displayNameController,
                                          hintText: 'Oscar Villab',
                                          icon: Icons.person_outline_rounded,
                                          textInputAction: TextInputAction.next,
                                          validator: (String? value) {
                                            if (!_isSignUp) {
                                              return null;
                                            }

                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Ingresa un nombre para tu cuenta.';
                                            }

                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 26),
                                      ],
                                      LoginFormField(
                                        label: 'Email Endpoint',
                                        controller: _emailController,
                                        hintText: 'developer@kinetic.io',
                                        icon: Icons.alternate_email_rounded,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        validator: (String? value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Ingresa tu correo.';
                                          }

                                          if (!value.contains('@')) {
                                            return 'Correo inválido.';
                                          }

                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 26),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              _isSignUp
                                                  ? 'CREATE ACCESS KEY'
                                                  : 'ACCESS KEY',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium
                                                  ?.copyWith(
                                                    color: AppColors.onSurface,
                                                    fontSize: 12,
                                                    letterSpacing: 2.1,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ),
                                          if (!_isSignUp)
                                            TextButton(
                                              onPressed: isLoading
                                                  ? null
                                                  : _handleResetPassword,
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    AppColors.secondary,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 0,
                                                    ),
                                                minimumSize: Size.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                              child: Text(
                                                'RESET SECRET',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color:
                                                          AppColors.secondary,
                                                      letterSpacing: 1.6,
                                                    ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      LoginFormField(
                                        label: '',
                                        controller: _passwordController,
                                        hintText: '••••••••••••',
                                        icon: Icons.lock_open_rounded,
                                        obscureText: _obscurePassword,
                                        textInputAction: TextInputAction.done,
                                        trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                            color: AppColors.outline.withValues(
                                              alpha: 0.52,
                                            ),
                                            size: 22,
                                          ),
                                        ),
                                        validator: (String? value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Ingresa tu contraseña.';
                                          }

                                          if (value.trim().length < 6) {
                                            return 'Mínimo 6 caracteres.';
                                          }

                                          return null;
                                        },
                                      ),
                                      if (_isSignUp) ...<Widget>[
                                        const SizedBox(height: 20),
                                        LoginFormField(
                                          label: 'Confirm Access Key',
                                          controller:
                                              _confirmPasswordController,
                                          hintText: '••••••••••••',
                                          icon: Icons.verified_user_outlined,
                                          obscureText: _obscureConfirmPassword,
                                          textInputAction: TextInputAction.done,
                                          trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscureConfirmPassword =
                                                    !_obscureConfirmPassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscureConfirmPassword
                                                  ? Icons.visibility_off_rounded
                                                  : Icons.visibility_rounded,
                                              color: AppColors.outline
                                                  .withValues(alpha: 0.52),
                                              size: 22,
                                            ),
                                          ),
                                          validator: (String? value) {
                                            if (!_isSignUp) {
                                              return null;
                                            }

                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Confirma tu contraseña.';
                                            }

                                            if (value.trim() !=
                                                _passwordController.text
                                                    .trim()) {
                                              return 'Las contraseñas no coinciden.';
                                            }

                                            return null;
                                          },
                                        ),
                                      ],
                                      const SizedBox(height: 30),
                                      LoginSubmitButton(
                                        label: _isSignUp
                                            ? 'Create Account'
                                            : 'Initialize Session',
                                        icon: _isSignUp
                                            ? Icons.rocket_launch_rounded
                                            : Icons.login_rounded,
                                        isLoading: isLoading,
                                        onPressed: isLoading
                                            ? null
                                            : _handleSubmit,
                                      ),
                                      const SizedBox(height: 34),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: AppColors.outlineVariant
                                                  .withValues(alpha: 0.16),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 18,
                                            ),
                                            child: Text(
                                              'EXTERNAL AUTH',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: AppColors.outline,
                                                    letterSpacing: 4.2,
                                                  ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: AppColors.outlineVariant
                                                  .withValues(alpha: 0.16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 32),
                                      SocialAuthButton(
                                        label: 'Continue with Google',
                                        onPressed: isLoading
                                            ? null
                                            : _handleGoogleSignIn,
                                      ),
                                      const SizedBox(height: 28),
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: <Widget>[
                                          Text(
                                            _isSignUp
                                                ? 'Already have access?'
                                                : 'Need an account?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: AppColors.outline,
                                                  fontSize: 15,
                                                ),
                                          ),
                                          GestureDetector(
                                            onTap: isLoading
                                                ? null
                                                : () {
                                                    setState(() {
                                                      _mode = _isSignUp
                                                          ? _AuthMode.signIn
                                                          : _AuthMode.signUp;
                                                    });
                                                  },
                                            child: Text(
                                              _isSignUp
                                                  ? 'Sign in'
                                                  : 'Register',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    color: AppColors.primary,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 48),
                          child: LoginFooter(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      if (_isSignUp) {
        await ref
            .read(authControllerProvider.notifier)
            .signUpWithEmail(
              email: _emailController.text,
              password: _passwordController.text,
              displayName: _displayNameController.text,
            );
      } else {
        await ref
            .read(authControllerProvider.notifier)
            .signInWithEmail(
              email: _emailController.text,
              password: _passwordController.text,
            );
      }
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  Future<void> _handleResetPassword() async {
    final String email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Escribe primero tu correo para enviarte el reset.');
      return;
    }

    try {
      await ref
          .read(authControllerProvider.notifier)
          .sendPasswordResetEmail(email);
      _showMessage('Te envié un correo para restablecer tu contraseña.');
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await ref.read(authControllerProvider.notifier).signInWithGoogle();
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  void _showMessage(String message) {
    final String cleanMessage = message.replaceFirst('Exception: ', '');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(cleanMessage)));
  }
}

class _AuthModeSwitcher extends StatelessWidget {
  const _AuthModeSwitcher({required this.mode, required this.onChanged});

  final _AuthMode mode;
  final ValueChanged<_AuthMode>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _AuthModeChip(
              label: 'Sign In',
              selected: mode == _AuthMode.signIn,
              onTap: onChanged == null
                  ? null
                  : () => onChanged!(_AuthMode.signIn),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _AuthModeChip(
              label: 'Register',
              selected: mode == _AuthMode.signUp,
              onTap: onChanged == null
                  ? null
                  : () => onChanged!(_AuthMode.signUp),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthModeChip extends StatelessWidget {
  const _AuthModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected ? AppColors.surfaceContainerHigh : Colors.transparent,
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? AppColors.primary : AppColors.outline,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _RegisterSectionIntro extends StatelessWidget {
  const _RegisterSectionIntro({required this.onSurface, required this.outline});

  final Color onSurface;
  final Color outline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.person_add_alt_1_rounded,
            color: AppColors.secondary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Register Section',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Create your account to start syncing tasks and Firebase auth state in this practice app.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
