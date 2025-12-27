import 'package:flutter_test/flutter_test.dart';
import 'package:gt_image_viewer_example/main.dart';

void main() {
  testWidgets('ImageViewerExampleScreen displays correctly', (
    WidgetTester tester,
  ) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('GT Image Viewer Example'), findsOneWidget);

    // Verify section titles are present
    expect(find.text('Network Image (Cached)'), findsOneWidget);
    expect(find.text('Circular Image'), findsOneWidget);
    expect(find.text('Styled Container'), findsOneWidget);

    // Verify cache button is present
    expect(find.text('Clear Image Cache'), findsOneWidget);
  });
}
