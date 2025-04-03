import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../lib/auth/noInternetConnection.dart';
import '../lib/main.dart';
import '../lib/provider.dart';

void main() {
  testWidgets('MyApp displays NoConnectionPage when there is no connection', (WidgetTester tester) async {
    // Arrange: Create a mock DataProvider
    final mockProvider = DataProvider();

    // Act: Build the MyApp widget with no connection
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => mockProvider,
        child: MyApp(hasConnection: false), // Pass hasConnection as false
      ),
    );

    // Assert: Check if NoConnectionPage is displayed
    expect(find.byType(NoConnectionPage), findsOneWidget);
  });
}
