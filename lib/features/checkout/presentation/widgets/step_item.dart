import 'package:flutter/material.dart';

class StepItem extends StatelessWidget{
  final String title; 
  final IconData icon; 
  final bool isActive;

  const StepItem({
    super.key, 
    required this.title, 
    required this.icon, 
    required this.isActive
  });

  @override  
  Widget build(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFFFF6B35) : Colors.grey.shade300,
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 70,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.black : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}