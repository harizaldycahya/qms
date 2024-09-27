part of 'widgets.dart';

class FailedUI extends StatelessWidget {
  const FailedUI({
    super.key,
    this.icon,
    required this.message,
    this.margin,
  });
  final IconData? icon;
  final String message;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        margin: margin,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error,
              color: Colors.grey,
              size: 30,
            ),
            const Gap(20),
            Text(
              message,
              style: TextStyle(color: AppColor.textBody),
            ),
          ],
        ),
      ),
    );
  }
}