# example

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

使用
```dart
    AutoWidhtTheme(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    )
```

```dart
    AutoWidth(
      sizes: <double, int>{
        sm: 24,
        md: 12,
        lg: 8,
        xl: 6,
        ll: 4,
      },
      height: 50,
      builder: (context, constraints, useSize) {
        return Text(
          "data",
        );
      },
    )
```