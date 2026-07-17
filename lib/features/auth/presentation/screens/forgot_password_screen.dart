import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/auth/domain/failure/auth_failure.dart';
import 'package:ledger_app/features/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:ledger_app/shared/widgets/generic-button/button.dart';
import 'package:ledger_app/shared/widgets/generic-input/generic_input.dart';
import 'package:ledger_app/shared/widgets/generic-input/input_type.dart';
import 'package:ledger_app/shared/widgets/generic-input/validators.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(forgotPasswordControllerProvider.notifier)
        .sendResetEmail(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);

    ref.listen(forgotPasswordControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (err, _) {
          final message = err is AuthFailure
              ? err.message
              : 'Something went wrong. Try again.';
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'If an account exists, a reset link has been sent to your email.',
              ),
            ),
          );
          Navigator.pop(context);
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: AppColors.homeAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GenericInput(
                controller: _emailController,
                label: 'Email Address',
                inputType: InputType.email,
                validator: Validators.combine([
                  Validators.required(),
                  Validators.email(),
                ]),
              ),
              const SizedBox(height: 24),
              GenericButton(
                label: 'Send Reset Link',
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
