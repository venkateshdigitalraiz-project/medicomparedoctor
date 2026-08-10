import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/constants/app_strings.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/core/widget/spraytype.dart';
import 'package:medicompare/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:medicompare/features/auth/login/presentation/bloc/login_event.dart';
import 'package:medicompare/features/auth/login/presentation/bloc/login_state.dart';

const _purple = Color(0xFF601CA3);
const _darkTeal = Color(0xFF17252A);

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LoginBloc(), child: const _LoginView());
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.pushNamed(
              context,
              RouteNames.otp,
              arguments: _phoneController.text.trim(),
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(1.0, -1.0),
              radius: 1.1,
              colors: [Color(0xFFE9DDF7), Colors.white],
              stops: [0.0, 0.6],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: CustomPaint(
                          painter: CornerGradientPainter(
                            color: Color(0xFF601CA3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Center(child: _buildLogo()),
                        const SizedBox(height: 24),
                        Center(child: _buildIllustration()),
                        const SizedBox(height: 32),
                        const Center(
                          child: Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: _darkTeal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Center(
                          child: Text(
                            'Please enter your phone number to Log in\nyour account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildPhoneField(context),
                        const SizedBox(height: 32),
                        _buildContinueButton(context),
                        const SizedBox(height: 20),
                        _buildTermsText(),
                        const SizedBox(height: 16),
                        _buildRegisterRow(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.all(4),
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Image.asset(
          "assets/images/applogo.png",
          width: 87,
          height: 36,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 260,
        maxHeight: 260,
      ),
      child: Image.asset("assets/images/login.png", fit: BoxFit.contain),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    final bloc = context.read<LoginBloc>();

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => _showCountryPicker(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Text(
                          state.flagEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          state.countryCode,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _darkTeal,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(width: 1, height: 24, color: Colors.grey.shade400),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: const TextStyle(fontSize: 16),
                    onChanged: (v) => bloc.add(PhoneNumberChanged(v)),
                    decoration: const InputDecoration(
                      hintText: '8934567890',
                      hintStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(height: 1, color: Colors.grey.shade400),
            if (state.errorText != null) ...[
              const SizedBox(height: 6),
              Text(
                state.errorText!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showCountryPicker(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    const options = [
      {'code': '+91', 'flag': '🇮🇳', 'name': 'India'},
      {'code': '+1', 'flag': '🇺🇸', 'name': 'USA'},
      {'code': '+44', 'flag': '🇬🇧', 'name': 'UK'},
      {'code': '+971', 'flag': '🇦🇪', 'name': 'UAE'},
    ];
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: options
              .map(
                (o) => ListTile(
                  leading: Text(
                    o['flag']!,
                    style: const TextStyle(fontSize: 22),
                  ),
                  title: Text('${o['name']} (${o['code']})'),
                  onTap: () {
                    bloc.add(CountryCodeChanged(o['code']!, o['flag']!));
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 16, left: 30, right: 30),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: state.status == LoginStatus.submitting
                  ? null
                  : () {
                      if (_phoneController.text.length == 10) {
                        bloc.add(const LoginSubmitted());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(AppStrings.enterValid10DigitPhone),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: state.status == LoginStatus.submitting
                  ? SizedBox(
                      width: 60,
                      height: 22,
                      child: AppLoader(
                        color: Colors.white,
                        size: 22,
                      ),
                    )
                  : const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTermsText() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            TextSpan(
              text: 'By using the app, you you agree to ',
              style: TextStyle(fontSize: 10),
            ),
            TextSpan(
              text: 'Terms & Conditions',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterRow() {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, RouteNames.register);
        },
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14, color: Colors.black87),
            children: [
              TextSpan(text: "Don't have an account? "),
              TextSpan(
                text: 'Register',
                style: TextStyle(
                  fontSize: 14,
                  color: _purple,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
