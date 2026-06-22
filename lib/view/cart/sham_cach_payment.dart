// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/cart_provider.dart';
import 'package:restaurants_system/view/cart/sham_cach_learning.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShamCashPayment extends ConsumerStatefulWidget {
  const ShamCashPayment({super.key});

  @override
  ConsumerState<ShamCashPayment> createState() => _ShamCashPaymentState();
}

class _ShamCashPaymentState extends ConsumerState<ShamCashPayment> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(cartProvider);
    bool isLoading = state.status == 'loading';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: const Text("الدفع عبر شام كاش"),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F7FF),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left_outlined, size: 30),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                Icons.live_help_outlined,
                size: 30,
                color: Color(0xFFFF6B35),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ShamCashLearning()),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: (state.paymentFile != null)
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ShamCashPayment()),
                      );
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("إرفع إيصال الدفع أولاً")),
                      );
                    },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFFF6B35),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Confirm Order",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.shopping_cart_checkout, size: 25),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              /// QR IMAGE
              if (state.cartContent!.shamCachAccountBarcode != null)
                Skeletonizer(
                  enabled: isLoading,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: double.infinity,
                      state.cartContent!.shamCachAccountBarcode ?? "",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              if (state.cartContent!.shamCachAccountId != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "رقم الحساب",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),

                      const SizedBox(height: 10),
                      SelectableText(
                        // يمكن الضغط عليه مطولاً لنسخه يدوياً
                        state.cartContent!.shamCachAccountId!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 12),

                      OutlinedButton.icon(
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(
                              text: state.cartContent!.shamCachAccountId!,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("تم نسخ الرقم")),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text("نسخ الرقم"),
                      ),
                    ],
                  ),
                ),

              InkWell(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                  );
                  if (result != null) {
                    ref
                        .read(cartProvider.notifier)
                        .setPaymentFile(result.files.first);
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: state.paymentFile == null
                          ? Colors.grey.shade300
                          : Colors.green.shade300,
                      width: 0.5,
                    ),
                  ),
                  child: state.paymentFile == null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 30,
                              color: Colors.grey.shade500,
                            ),

                            const SizedBox(height: 5),

                            const Text(
                              "اختر صورة الوصل",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              "JPG أو PNG أو PDF",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        )
                      : Card(
                          elevation: 3,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "تم رفع الوصل بنجاح",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(state.paymentFile!.path!),
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Text(
                                        state.paymentFile!.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    Column(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 22,
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            ref
                                                .read(cartProvider.notifier)
                                                .removePaymentFile();
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
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
}
