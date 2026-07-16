import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/auth/domain/failure/auth_failure.dart';
import 'package:ledger_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:ledger_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ledger_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:ledger_app/features/household/presentation/screens/household_gate.dart';
import 'package:ledger_app/shared/widgets/generic-button/button.dart';
import 'package:ledger_app/shared/widgets/generic-input/generic_input.dart';
import 'package:ledger_app/shared/widgets/generic-input/input_password_field.dart';
import 'package:ledger_app/shared/widgets/generic-input/input_type.dart';
import 'package:ledger_app/shared/widgets/generic-input/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(loginControllerProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    ref.listen(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (err, _) {
          final message = err is AuthFailure
              ? err.message
              : 'Login failed. Try again.';
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
        data: (user) {
          if (user != null) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HouseholdGate()),
              (route) => false,
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GenericInput(
                controller: _emailController,
                label: 'Email Address',
                prefixIcon: const Icon(Icons.mail_outline_rounded),
                inputType: InputType.email,
                validator: Validators.combine([
                  Validators.required(),
                  Validators.email(),
                ]),
              ),
              const SizedBox(height: 24),
              GenericInput(
                controller: _passwordController,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                label: 'Password',
                inputType: InputType.password,
              ),
              AppPasswordStrengthIndicator(value: _passwordController.text),
              const SizedBox(height: 24),
              GenericButton(
                label: 'Login',
                isLoading: loginState.isLoading,
                onPressed: _submit,
              ),
              GenericButton(
                label: 'Forgot password?',
                variant: ButtonVariant.text,
                size: ButtonSize.small,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                ),
              ),
              GenericButton(
                label: "Dont't have an account?",
                variant: ButtonVariant.text,
                size: ButtonSize.small,
                foregroundColor: AppColors.primary2,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
