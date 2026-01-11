import 'package:flutter/material.dart';
import 'package:staffku/shared/constants/colors.dart';

class DetailSectionTitle extends StatelessWidget {
  const DetailSectionTitle({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final subtitleText = (subtitle ?? '').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: ColorConstants.black,
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 0.2,
            fontFamily: 'Poppins',
          ),
        ),
        if (subtitleText.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitleText,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.62),
              fontWeight: FontWeight.w500,
              fontSize: 12.5,
              height: 1.2,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ],
    );
  }
}

class DetailSectionCard extends StatelessWidget {
  const DetailSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.0,
          color: ColorConstants.borderColor.withValues(alpha: 0.90),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18.0,
            spreadRadius: 0.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: child,
    );
  }
}

class DetailInfoRow extends StatelessWidget {
  const DetailInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final valueText = value.trim().isEmpty ? '-' : value.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Colors.black.withValues(alpha: 0.65),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withValues(alpha: 0.62),
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valueText,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.black,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

