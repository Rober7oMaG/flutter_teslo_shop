import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/shared/shared.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground( 
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox( height: 80 ),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        if (!context.canPop()) return;

                        context.pop();
                      }, 
                      icon: const Icon(
                        Icons.arrow_back_rounded, 
                        size: 40, 
                        color: Colors.white
                      )
                    ),
                    const Spacer(flex: 1),
                    Text(
                      'Sign Up', 
                      style: textStyles.titleLarge?.copyWith(color: Colors.white )
                    ),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox( height: 50 ),
    
                Container(
                  height: size.height - 260, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _RegisterForm(),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  void showSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red
      )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;

      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('Register', style: textStyles.titleMedium),
          const SizedBox(height: 50),

          CustomTextFormField(
            label: 'Full Name',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerFormProvider.notifier).onNameChanged,
            errorMessage: registerForm.isFormPosted
              ? registerForm.fullName.errorMessage
              : null,
          ),
          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChanged,
            errorMessage: registerForm.isFormPosted
              ? registerForm.email.errorMessage
              : null,
          ),
          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Password',
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordChanged,
            errorMessage: registerForm.isFormPosted
              ? registerForm.password.errorMessage
              : null,
          ),
    
          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Repeat your password',
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordConfirmationChanged,
            errorMessage: registerForm.isFormPosted
              ? registerForm.passwordConfirmation.errorMessage
              : null,
          ),
    
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Create Account',
              buttonColor: Colors.black,
              onPressed: registerForm.isPosting
                ? null
                : ref.read(registerFormProvider.notifier).onFormSubmit,
            )
          ),

          const Spacer(flex: 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(
                onPressed: (){
                  if (context.canPop()){
                    return context.pop();
                  }

                  context.go('/login');
                }, 
                child: const Text('Sign In')
              )
            ],
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}