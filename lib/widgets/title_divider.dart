import 'package:flutter/material.dart';

class TitleDivider extends StatelessWidget {
  const TitleDivider({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Divider(
              color: Theme.of(context).primaryColor,
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
