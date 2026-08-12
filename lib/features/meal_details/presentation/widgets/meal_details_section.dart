// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/meal_details/presentation/providers/meal_details_notifier.dart';
import 'package:restaurants_system/features/meal_details/presentation/providers/meal_details_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

bool _isArabicText(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);

class MealDetailsSection extends ConsumerStatefulWidget {
  const MealDetailsSection({super.key});

  @override
  ConsumerState<MealDetailsSection> createState() => _MealDetailsSectionState();
}

class _MealDetailsSectionState extends ConsumerState<MealDetailsSection> {
  final TextEditingController _noteController = TextEditingController();
  final Map<int, bool> _expandedGroup = {};

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mealDetailsProvider);
    final notifier = ref.read(mealDetailsProvider.notifier);
    final selectedVariantId = state.selectedVariantId;
    final selectedModifier = state.selectedModifier;
    final isLoading = state.status == "loading";

    ref.listen<MealState>(mealDetailsProvider, (previous, next) {
      final wasLoading = previous == null || previous.status == "loading";
      final justLoaded = wasLoading && next.status != "loading";
      if (justLoaded && _noteController.text != next.note) {
        _noteController.text = next.note;
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return Skeletonizer(
          enabled: isLoading,
          effect: ShimmerEffect(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ).copyWith(top: 10, bottom: 10),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: _isArabicText(state.menuItem.name)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (state.menuItem.variants.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: _isArabicText(state.menuItem.name)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: const [
                        Text(
                          "اختر الحجم",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.layers_outlined,
                          color: Color(0xFFFF6B35),
                          size: 25,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.menuItem.variants.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: state.menuItem.variants.length >= 3
                            ? 3
                            : state.menuItem.variants.length,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (_, i) {
                        final v = state.menuItem.variants[i];
                        final isOn = selectedVariantId == v.id;
                        final isUnavailable = !v.isAvailable;

                        return Opacity(
                          opacity: isUnavailable ? 0.45 : 1,
                          child: GestureDetector(
                            onTap: isUnavailable
                                ? null
                                : () => notifier.selectVariant(v.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: isOn
                                    ? const Color(0xFFFFF4EF)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isOn
                                      ? const Color(0xFFFF6B35)
                                      : const Color(0xFFEDE9E2),
                                  width: isOn ? 1.8 : 1,
                                ),
                                boxShadow: isOn
                                    ? [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF6B35,
                                          ).withOpacity(0.15),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isOn
                                          ? const Color(0xFFFF6B35)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isOn
                                            ? const Color(0xFFFF6B35)
                                            : const Color(0xFFDDDDDD),
                                        width: 2,
                                      ),
                                    ),
                                    child: isOn
                                        ? const Icon(
                                            Icons.check,
                                            size: 11,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    v.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isOn
                                          ? const Color(0xFF1A1A1A)
                                          : const Color(0xFF444444),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    isUnavailable
                                        ? 'غير متوفر'
                                        : '${v.price.toInt()} SYP',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isOn
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: isUnavailable
                                          ? Colors.red.shade400
                                          : isOn
                                          ? const Color(0xFFFF6B35)
                                          : const Color(0xFFAAAAAA),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                  if (state.menuItem.modifierGroups.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: _isArabicText(state.menuItem.name)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: const [
                        Text(
                          "اختر الإضافات",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.layers_outlined,
                          color: Color(0xFFFF6B35),
                          size: 25,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: state.menuItem.modifierGroups.map((group) {
                        final isExpanded = _expandedGroup[group.id] ?? false;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: _isArabicText(group.name)
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => setState(
                                  () => _expandedGroup[group.id] = !isExpanded,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              _isArabicText(group.name)
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          children: [
                                            AnimatedRotation(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              turns: isExpanded ? 0.5 : 0,
                                              child: const Icon(
                                                Icons.keyboard_arrow_down,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: group.isRequired
                                                    ? const Color(0xFFFFF0EE)
                                                    : const Color(0xFFF2F0EB),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                group.isRequired
                                                    ? "مطلوب"
                                                    : "اختياري",
                                                style: TextStyle(
                                                  color: group.isRequired
                                                      ? Colors.red
                                                      : Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                group.name,
                                                textDirection:
                                                    _isArabicText(group.name)
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                textAlign:
                                                    _isArabicText(group.name)
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (isExpanded)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    bottom: 16,
                                  ),
                                  child: Column(
                                    children: group.modifiers.map((modifier) {
                                      final selected =
                                          selectedModifier[group.id]?.contains(
                                            modifier.id,
                                          ) ??
                                          false;
                                      return InkWell(
                                        onTap: () => notifier.toggleModifier(
                                          group.id,
                                          modifier.id,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              group.isMultiple
                                                  ? Checkbox(
                                                      value: selected,
                                                      onChanged: (_) => notifier
                                                          .toggleModifier(
                                                            group.id,
                                                            modifier.id,
                                                          ),
                                                    )
                                                  : Radio<int>(
                                                      value: modifier.id,
                                                      groupValue:
                                                          selectedModifier[group
                                                                      .id]
                                                                  ?.isNotEmpty ==
                                                              true
                                                          ? selectedModifier[group
                                                                    .id]!
                                                                .first
                                                          : null,
                                                      onChanged: (_) => notifier
                                                          .toggleModifier(
                                                            group.id,
                                                            modifier.id,
                                                          ),
                                                    ),
                                              Text(modifier.name),
                                              if (modifier.price > 0)
                                                Expanded(
                                                  child: Text(
                                                    "+${modifier.price.toInt()} SYP",
                                                    style: const TextStyle(
                                                      color: Color(0xFFFF6B35),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: _isArabicText(state.menuItem.name)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: const [
                        Text(
                          "ملاحظات إضافية",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.layers_outlined,
                          color: Color(0xFFFF6B35),
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    textDirection: TextDirection.rtl,
                    onChanged: notifier.setNote,
                    decoration: InputDecoration(
                      hintText:
                          "أضف ملاحظاتك أو طلباتك الخاصة (قد تؤثر على السعر حسب الاختيار).",
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFFF6B35)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
