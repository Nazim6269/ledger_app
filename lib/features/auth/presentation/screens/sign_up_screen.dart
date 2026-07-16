import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/core/theme/app_spacing.dart';
import 'package:ledger_app/features/auth/domain/failure/auth_failure.dart';
import 'package:ledger_app/features/auth/presentation/screens/login_screen.dart';
import 'package:ledger_app/features/home/screens/home_screen.dart';
import 'package:ledger_app/shared/widgets/generic-button/button.dart';
import 'package:ledger_app/shared/widgets/generic-input/generic_input.dart';
import 'package:ledger_app/shared/widgets/generic-input/input_password_field.dart';
import 'package:ledger_app/shared/widgets/generic-input/input_type.dart';
import 'package:ledger_app/shared/widgets/generic-input/validators.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _signup() async {
    if (_passwordController.text.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref
        .read(authRepositoryProvider)
        .signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        );

    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      failure: (failure) {
        if (failure is EmailConfirmationRequired) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
          Navigator.pop(context);
        } else {
          setState(() => _error = failure.message);
        }
      },
      success: (_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GenericInput(
              controller: _nameController,
              label: 'Name',
              inputType: InputType.text,
            ),
            const SizedBox(height: 12),
            GenericInput(
              controller: _emailController,
              label: 'Email',
              inputType: InputType.email,
              prefixIcon: const Icon(Icons.email_outlined),
              validator: Validators.combine([
                Validators.email(),
                Validators.required(),
              ]),
            ),
            const SizedBox(height: 12),
            GenericInput(
              controller: _passwordController,
              label: 'Password',
              inputType: InputType.password,
              validator: Validators.combine([
                Validators.required(),
                Validators.match(() => _passwordController.text),
              ]),
            ),
            AppPasswordStrengthIndicator(value: _passwordController.text),
            const SizedBox(height: AppSpacing.lg),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            GenericButton(
              label: 'Create Account',
              variant: ButtonVariant
                  .primary, // FilledButton == solid fill == primary
              isLoading: _loading,
              onPressed: _signup,
            ),
            GenericButton(
              label: "Already have an account?",
              variant: ButtonVariant.text,
              size: ButtonSize.small,
              foregroundColor: AppColors.primary2,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
