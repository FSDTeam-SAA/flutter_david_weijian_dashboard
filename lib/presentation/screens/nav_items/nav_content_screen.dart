import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drive_test_admin_dashboard/controller/content_controller.dart';
import 'package:drive_test_admin_dashboard/model/route_model.dart';
import 'package:drive_test_admin_dashboard/model/stops_model.dart';
import 'package:drive_test_admin_dashboard/presentation/widgets/loading_widget.dart';
import 'package:drive_test_admin_dashboard/presentation/widgets/text_field_widget.dart';

class NavContentScreen extends StatelessWidget {
  final ContentController _controller = Get.put(ContentController());

  NavContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Todo: Check both mobile and desktop layouts, and mainly the add test centre form button opening and closing in mobile
      // appBar: AppBar(
      //   title: const Text('Create Route'),
      //   actions: [
      //     // Toggle between "Add Test Centre" and "View Test Centres"
      //     ElevatedButton(
      //       onPressed: () {
      //         _controller.showAddTestCentreButton.toggle();
      //         if (_controller.showAddTestCentreButton.value) {
      //           _controller.resetTestCentreForm();
      //         }
      //       },
      //       child: Obx(
      //         () =>
      //             _controller.showAddTestCentreButton.value
      //                 ? const Text('View Test Centres')
      //                 : const Text('Add Test Centre'),
      //       ),
      //     ),
      //     const SizedBox(width: 20),
      //   ],
      // ),
      body: ResponsiveLayout(
        mobileBody: _buildMobileBody(),
        desktopBody: _buildDesktopBody(),
      ),
    );
  }

  // Mobile Layout
  Widget _buildMobileBody() {
    return Stack(
      children: [
        // Loading Indicator
        Obx(
          () =>
              _controller.isLoading.value
                  ? const LoadingWidget()
                  : const SizedBox(),
        ),

        // Main Content
        Obx(
          () =>
              _controller.showAddTestCentreButton.value
                  ? _buildAddTestCentreForm()
                  : _controller.showRouteDetails.value
                  ? _buildRouteDetailsWidget(_controller.routeResponse.value!)
                  : _buildTestCentreList(),
        ),
      ],
    );
  }

  // Desktop Layout
  Widget _buildDesktopBody() {
    return Row(
      children: [
        // Navigation Rail for Desktop
        NavigationRail(
          selectedIndex: _controller.showAddTestCentreButton.value ? 0 : 1,
          onDestinationSelected: (index) {
            _controller.showAddTestCentreButton.value = index == 0;
          },
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.add),
              label: Text('Add Test Centre'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.list),
              label: Text('View Test Centres'),
            ),
          ],
        ),

        // Main Content
        Expanded(
          child: Stack(
            children: [
              // Loading Indicator
              Obx(
                () =>
                    _controller.isLoading.value
                        ? const LoadingWidget()
                        : const SizedBox(),
              ),

              // Main Content
              Obx(
                () =>
                    _controller.showAddTestCentreButton.value
                        ? Align(
                          alignment: Alignment.topCenter,
                          child: _buildAddTestCentreForm(),
                        )
                        : _controller.showRouteDetails.value
                        ? _buildRouteDetailsWidget(
                          _controller.routeResponse.value!,
                        )
                        : _buildTestCentreList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build the "Add Test Centre" Form
  Widget _buildAddTestCentreForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(.0),
      child: SizedBox(
        width: Get.width * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () =>
                  _controller.testCentreId.isEmpty
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add Test Center',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),
                          CustomTextField(
                            label: 'Test Centre Name',
                            onChanged:
                                (value) =>
                                    _controller.testCentreName.value = value,
                          ),
                          CustomTextField(
                            label: 'Address',
                            onChanged:
                                (value) =>
                                    _controller.testCentreAddress.value = value,
                          ),
                          CustomTextField(
                            label: 'Post Code',
                            onChanged:
                                (value) => _controller.postCode.value = value,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed:
                                _controller.isLoading.value
                                    ? null
                                    : _controller.addTestCentre,
                            child: const Text('Add Test Center'),
                          ),
                        ],
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Test Center: ${_controller.testCentreName.value}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Route Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: 'Route Name',
                            onChanged:
                                (value) => _controller.routeName.value = value,
                          ),
                          CustomTextField(
                            label: 'Share URL',
                            onChanged:
                                (value) => _controller.shareUrl.value = value,
                          ),
                          CustomTextField(
                            label: 'Address',
                            onChanged:
                                (value) => _controller.address.value = value,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed:
                                _controller.isLoading.value
                                    ? null
                                    : _controller.pickAndParseGPXFile,
                            child: const Text('Pick GPX File'),
                          ),
                          Obx(
                            () =>
                                _controller.fileName.isNotEmpty
                                    ? Text(
                                      'Picked File: ${_controller.fileName.value}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    )
                                    : const SizedBox(),
                          ),
                          const SizedBox(height: 20),
                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_controller.from.isNotEmpty)
                                  Text('From: ${_controller.from.value}'),
                                if (_controller.to.isNotEmpty)
                                  Text('To: ${_controller.to.value}'),
                                if (_controller.expectedTime.value > 0)
                                  Text(
                                    'Expected Time: ${_controller.expectedTime.value} minutes',
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed:
                                _controller.isLoading.value
                                    ? null
                                    : _controller.createRoute,
                            child: const Text('Create Route'),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the list of test centres
  Widget _buildTestCentreList() {
    return Obx(
      () =>
          _controller.testCentres.isEmpty
              ? const Center(child: Text('No test centres found'))
              : LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate the number of columns based on the available width
                  int crossAxisCount =
                      (constraints.maxWidth / 300)
                          .floor(); // Adjust 200 as needed

                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio:
                          3 / 2, // Adjust the aspect ratio as needed
                    ),
                    itemCount: _controller.testCentres.length,
                    itemBuilder: (context, index) {
                      final testCentre = _controller.testCentres[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            _controller.getAllRoutes(testCentre.id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    testCentre.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Flexible(
                                  child: Text(
                                    testCentre.address,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Flexible(
                                  child: Text(
                                    testCentre.postCode,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }

  // Build the RouteDetailsScreen as a widget
  Widget _buildRouteDetailsWidget(RouteResponse routeResponse) {
    if (routeResponse.data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No route details available'),
            ElevatedButton(
              onPressed: () {
                _controller.showRouteDetails.value = false;
              },
              child: const Text('Back to Test Centres'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button to return to the test centre list
          ElevatedButton(
            onPressed: () {
              _controller.showRouteDetails.value = false;
            },
            child: const Text('Back to Test Centres'),
          ),
          const SizedBox(height: 20),

          // Test Centre Details
          _buildSectionTitle('Test Centre Details'),
          _buildDetailRow('Name', routeResponse.data.first.testCentreName),
          _buildDetailRow('Address', routeResponse.data.first.address),
          _buildDetailRow('Pass Rate', '${routeResponse.data.first.passRate}%'),
          const SizedBox(height: 20),

          // Add New Route Button
          ElevatedButton(
            onPressed: () {
              // Reset the route form and show the add route form
              // _controller.clearRouteForm();

              _controller.testCentreId.value = routeResponse.data.first.testCentreId;
              _controller.showAddTestCentreButton.value = true;
              _controller.showAddTestCentre.value = false;
              
            },
            child: const Text('Add New Route'),
          ),
          const SizedBox(height: 20),

          // Route Details for All Routes
          _buildSectionTitle('Route Information'),
          ...routeResponse.data.map((route) => _buildRouteCard(route)),
        ],
      ),
    );
  }

  // Build a card for each route
  Widget _buildRouteCard(RouteModel route) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route Name
            Text(
              'Route Name: ${route.routeName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Route Details
            _buildDetailRow('From', route.from),
            _buildDetailRow('To', route.to),
            _buildDetailRow('Expected Time', '${route.expectedTime} minutes'),
            _buildDetailRow('Share URL', route.shareUrl),
            const SizedBox(height: 10),

            // Start and End Coordinates
            _buildDetailRow(
              'Start Coordinates',
              'Lat: ${route.startCoordinator['lat'] ?? 0.0}, Lng: ${route.startCoordinator['lng'] ?? 0.0}',
            ),
            _buildDetailRow(
              'End Coordinates',
              'Lat: ${route.endCoordinator['lat'] ?? 0.0}, Lng: ${route.endCoordinator['lng'] ?? 0.0}',
            ),
            const SizedBox(height: 10),

            // List of Stops
            _buildSectionTitle('Stops'),
            ...route.listOfStops.map((stop) => _buildStopCard(stop)),
            const SizedBox(height: 10),

            // Edit and Delete Buttons for the Route
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Edit Button
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Set the selected route for editing
                    // _controller.setSelectedRoute(route);
                    _controller.showAddTestCentreButton.value = true;
                  },
                ),
                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteRouteConfirmationDialog(route.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show a confirmation dialog for deleting a route
  void _showDeleteRouteConfirmationDialog(String routeId) {
    Get.defaultDialog(
      title: 'Delete Route',
      middleText: 'Are you sure you want to delete this route?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back(); // Close the dialog
        // await _controller.deleteRoute(routeId); // Call the delete method
      },
      onCancel: () {
        // Do nothing, just close the dialog
      },
    );
  }

  // Helper Methods
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildStopCard(Stop stop) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Stop ID: ${stop.id}'),
        subtitle: Text('Lat: ${stop.lat}, Lng: ${stop.lng}'),
      ),
    );
  }
}

// Responsive Layout Widget
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileBody;
        } else {
          return desktopBody;
        }
      },
    );
  }
}
