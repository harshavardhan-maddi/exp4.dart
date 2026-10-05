import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveOrientationDemo());
}

class ResponsiveOrientationDemo extends StatelessWidget {
  const ResponsiveOrientationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GalleryPage(),
    );
  }
}

class GalleryItem {
  final String title;
  final String description;
  final IconData icon;

  const GalleryItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  final List<GalleryItem> items = const [
    GalleryItem(
      title: 'Laptop',
      description: 'Powerful device for work and study.',
      icon: Icons.laptop,
    ),
    GalleryItem(
      title: 'Mobile',
      description: 'Smart device for communication.',
      icon: Icons.phone_android,
    ),
    GalleryItem(
      title: 'Camera',
      description: 'Capture beautiful moments.',
      icon: Icons.camera_alt,
    ),
    GalleryItem(
      title: 'Headphones',
      description: 'Enjoy high-quality audio.',
      icon: Icons.headphones,
    ),
    GalleryItem(
      title: 'Watch',
      description: 'Track time and daily activities.',
      icon: Icons.watch,
    ),
    GalleryItem(
      title: 'Tablet',
      description: 'Large screen for entertainment.',
      icon: Icons.tablet,
    ),
  ];

  String getCategory(double width) {
    if (width < 600) {
      return 'Mobile';
    } else if (width < 1024) {
      return 'Tablet';
    } else {
      return 'Desktop';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final orientation = mediaQuery.orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Gallery'),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final category = getCategory(constraints.maxWidth);

          return OrientationBuilder(
            builder: (context, orientation) {
              Widget content;

              if (category == 'Mobile') {
                content = _buildMobileLayout(
                  context,
                  orientation,
                );
              } else if (category == 'Tablet') {
                content = _buildTabletLayout(
                  context,
                  orientation,
                );
              } else {
                content = _buildDesktopLayout(context);
              }

              return Column(
                children: [
                  Expanded(child: content),

                  // Footer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.blue,
                    child: Text(
                      'Category: $category | '
                      'Width: ${width.toStringAsFixed(0)} px | '
                      'Orientation: '
                      '${orientation == Orientation.portrait ? "Portrait" : "Landscape"}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // Mobile Layout
  Widget _buildMobileLayout(
    BuildContext context,
    Orientation orientation,
  ) {
    if (orientation == Orientation.portrait) {
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildCard(items[index]);
        },
      );
    }

    // Mobile Landscape
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 220,
          child: _buildCard(items[index]),
        );
      },
    );
  }

  // Tablet Layout
  Widget _buildTabletLayout(
    BuildContext context,
    Orientation orientation,
  ) {
    final padding = orientation == Orientation.portrait ? 16.0 : 28.0;

    return GridView.builder(
      padding: EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: padding,
        mainAxisSpacing: padding,
        childAspectRatio:
            orientation == Orientation.portrait ? 1.3 : 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildCard(items[index]);
      },
    );
  }

  // Desktop Layout
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Navigation Rail
        NavigationRail(
          selectedIndex: 0,
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.photo_library),
              label: Text('Gallery'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings),
              label: Text('Settings'),
            ),
          ],
        ),

        // Three-column grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.4,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildCard(items[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCard(GalleryItem item) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 55,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                item.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}