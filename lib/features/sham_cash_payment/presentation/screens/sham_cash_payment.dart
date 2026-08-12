// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order_track/order_track_provider.dart';
import 'package:restaurants_system/features/sham_cash_payment/presentation/providers/sham_cash_provider.dart';
import 'package:restaurants_system/features/sham_cash_payment/presentation/screens/payment_success_screen.dart';
import 'package:restaurants_system/features/sham_cash_payment/presentation/screens/sham_cash_learning.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShamCashPayment extends ConsumerStatefulWidget {
  final String referenceNumber;
  final String tenantId;
  const ShamCashPayment({
    required this.referenceNumber,
    required this.tenantId,
    super.key,
  });

  @override
  ConsumerState<ShamCashPayment> createState() => _ShamCashPaymentState();
}

class _ShamCashPaymentState extends ConsumerState<ShamCashPayment> {
  final TextEditingController _paymentCodeController = TextEditingController();
  String paymentProofType = ""; // receipt أو code

  static const Color _primaryOrange = Color(0xFFFF6B35);
  static const Color _bgColor = Color(0xFFF5F7FA);
  static const Color _cardColor = Colors.white;
  static const Color _textDark = Color(0xFF1F2333);
  static const Color _textMuted = Color(0xFF8A8FA3);

  @override
  void dispose() {
    _paymentCodeController.dispose();
    super.dispose();
  }

  // ====================== Helper Widgets ======================

  Widget _sectionCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String text, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: _primaryOrange),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.5,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  Widget _billRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? _primaryOrange : _textDark,
          ),
        ),
        const Spacer(),
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: _textMuted,
          ),
        ),
      ],
    );
  }

  Widget _proofTypeSelector() {
    Widget option(String value, String label, IconData icon) {
      final bool selected = paymentProofType == value;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => paymentProofType = value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: selected
                  ? _primaryOrange.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? _primaryOrange : Colors.grey.shade300,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: selected ? _primaryOrange : _textMuted,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? _primaryOrange : _textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        option("receipt", "رفع صورة الوصل", Icons.receipt_long_rounded),
        const SizedBox(width: 12),
        option("code", "إدخال Payment Code", Icons.password_rounded),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(orderTrackNotifierProvider);
    final shamState = ref.watch(shamCashNotifierProvider);
    bool isLoading = state.orderStatus == 'loading';

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: const Text(
          "الدفع عبر شام كاش",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: _bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left_outlined, size: 30),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: const Icon(
                Icons.live_help_outlined,
                size: 26,
                color: _primaryOrange,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShamCashLearning()),
                );
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: _bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: shamState.isPaying
                  ? null
                  : () async {
                      final token = await ref
                          .read(authRepositoryProvider)
                          .getCurrentToken();

                      if (token == null || token.isEmpty) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please login again.")),
                        );

                        return;
                      }
                      await ref
                          .read(shamCashNotifierProvider.notifier)
                          .pay(
                            token: token,
                            referenceNumber: widget.referenceNumber,
                            tenantId: widget.tenantId,
                            paymentCode: paymentProofType == "code"
                                ? _paymentCodeController.text.trim()
                                : null,
                            invoice: paymentProofType == "receipt"
                                ? shamState.paymentFile
                                : null,
                          );
                      if (!mounted) return;
                      final newShamState = ref.read(shamCashNotifierProvider);
                      if (newShamState.status == "success") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentSuccessScreen(
                              restaurantId: shamState.restaurantId!,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(newShamState.message)),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: _primaryOrange,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: shamState.isPaying
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "تأكيد الطلب",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.shopping_cart_checkout_rounded, size: 22),
                      ],
                    ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== رسالة توجيهية =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _primaryOrange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: _primaryOrange,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "ادفع على الحساب أدناه ثم أرفق صورة الإيصال أو أدخل رمز الدفع",
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.grey[800],
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                /// ===== QR IMAGE =====
                if (shamState.shamCashAccountBarcode != null)
                  _sectionCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(
                          "امسح رمز QR للدفع",
                          icon: Icons.qr_code_rounded,
                        ),
                        const SizedBox(height: 12),
                        Skeletonizer(
                          enabled: isLoading,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              shamState.shamCashAccountBarcode ?? "",
                              height: MediaQuery.of(context).size.height * 0.42,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // ===== رقم الحساب =====
                if (shamState.shamCashAccountId != null)
                  _sectionCard(
                    child: Column(
                      children: [
                        _sectionTitle(
                          "رقم الحساب",
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _bgColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: SelectableText(
                              shamState.shamCashAccountId ?? '',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: _textDark,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(
                                  text: shamState.shamCashAccountId ?? '',
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: _textDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.greenAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text("تم نسخ الرقم"),
                                    ],
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _primaryOrange,
                              side: const BorderSide(color: _primaryOrange),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            label: const Text(
                              "نسخ الرقم",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        "ملخص الفاتورة",
                        icon: Icons.receipt_long_rounded,
                      ),
                      const SizedBox(height: 18),

                      _billRow("قيمة الطلب", "${shamState.subTotal} SYP"),

                      if (shamState.type == "delivery") ...[
                        const SizedBox(height: 10),
                        _billRow(
                          "رسوم التوصيل",
                          "${shamState.deliveryFee} SYP",
                        ),
                      ],

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(height: 1),
                      ),

                      _billRow(
                        "الإجمالي",
                        "${shamState.total} SYP",
                        isTotal: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ===== طريقة إثبات الدفع =====
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        "طريقة إثبات الدفع",
                        icon: Icons.fact_check_outlined,
                      ),
                      const SizedBox(height: 14),
                      _proofTypeSelector(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ===== رفع الإيصال =====
                if (paymentProofType == "receipt")
                  InkWell(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                      );
                      if (result != null) {
                        ref
                            .read(shamCashNotifierProvider.notifier)
                            .setPaymentFile(result.files.first);
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: shamState.paymentFile == null
                        ? const DottedUploadBox()
                        : Card(
                            elevation: 0,
                            color: _cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: Colors.green.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(shamState.paymentFile!.path!),
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "تم رفع الوصل بنجاح",
                                          style: TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w700,
                                            color: _textDark,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          shamState.paymentFile!.name,
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            color: Colors.grey.shade600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 22,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      ref
                                          .read(
                                            shamCashNotifierProvider.notifier,
                                          )
                                          .removePaymentFile();
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),

                // ===== إدخال الكود =====
                if (paymentProofType == "code")
                  _sectionCard(
                    child: TextField(
                      controller: _paymentCodeController,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        labelText: "Payment Code",
                        hintText: "أدخل رمز الدفع",
                        prefixIcon: const Icon(
                          Icons.password_rounded,
                          color: _primaryOrange,
                        ),
                        filled: true,
                        fillColor: _bgColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: _primaryOrange,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DottedUploadBox extends StatelessWidget {
  const DottedUploadBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.4,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF1EA),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              size: 28,
              color: _ShamCashPaymentStateColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "اضغط لاختيار صورة الوصل",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            "JPG, PNG أو PDF",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _ShamCashPaymentStateColors {
  static const Color primaryOrange = Color(0xFFFF6B35);
}
