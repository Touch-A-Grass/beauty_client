import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/asset_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class CodeScreen extends StatefulWidget {
  final VoidCallback backToPhonePressed;

  const CodeScreen({super.key, required this.backToPhonePressed});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            bottom: false,
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 64),
                    AssetIcon(
                      'assets/icons/beauty_service.svg',
                      size: 164,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 64),
                    OtpTextField(
                      autoFocus: true,
                      numberOfFields: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 64,
                    left: 32,
                    right: 32,
                    top: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: widget.backToPhonePressed,
                      child: Text(S.of(context).changePhoneButton),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
