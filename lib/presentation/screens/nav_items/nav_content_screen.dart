import 'package:drive_test_admin_dashboard/model/route_model.dart';
import 'package:drive_test_admin_dashboard/model/stops_model.dart';
import 'package:drive_test_admin_dashboard/presentation/widgets/loading_widget.dart';
import 'package:drive_test_admin_dashboard/presentation/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drive_test_admin_dashboard/controller/content_controller.dart';

class NavContentScreen extends StatelessWidget {
  final ContentController _controller = Get.put(ContentController());

  NavContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Route'),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Toggle the "Add Test Center" section
              _controller.showAddTestCentreButton.toggle();

              if (_controller.showAddTestCentreButton.value) {
                // Reset the form
                _controller.resetTestCentreForm();
              }
            },
            child: Obx(
              () =>
                  _controller.showAddTestCentreButton.value
                      ? const Text('View Test Centres')
                      : const Text('Add Test Centre'),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Stack(
        children: [
          // Show loading indicator
          Obx(
            () =>
                _controller.isLoading.value
                    ? const LoadingWidget()
                    : const SizedBox(),
          ),

          // Show the list of test centres or the "Add Test Center" form
          Obx(
            () =>
                _controller.showAddTestCentreButton.value
                    ? _buildAddTestCentreForm()
                    : _controller.showRouteDetails.value
                    ? _buildRouteDetailsWidget(_controller.routeResponse.value!)
                    : _buildTestCentreList(),
          ),
        ],
      ),
    );
  }

  // Build the "Add Test Center" form
  Widget _buildAddTestCentreForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
                                  ? null // Disable button when loading
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
                                  ? null // Disable button when loading
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
                                  ? null // Disable button when loading
                                  : _controller.createRoute,
                          child: const Text('Create Route'),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  // Build the list of test centres
  Widget _buildTestCentreList() {
    return Obx(
      () =>
          _controller.testCentres.isEmpty
              ? const Center(child: Text('No test centres found'))
              : ListView.builder(
                itemCount: _controller.testCentres.length,
                itemBuilder: (context, index) {
                  final testCentre = _controller.testCentres[index];
                  return ListTile(
                    title: Text(testCentre.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(testCentre.address),
                        Text(testCentre.postCode),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Fetch and show route details for the selected test centre
                        _controller.getAllRoutes(testCentre.id);
                      },
                      child: const Text('Select'),
                    ),
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
            Text('No route details available'),
            ElevatedButton(
              onPressed: () {
                _controller.showRouteDetails.value = false;
              },
              child: Text('Back to Test Centres'),
            ),
          ],
        ),
      );
    }

    final route = routeResponse.data.first;

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
          _buildDetailRow('Name', route.testCentreName), // Handle null
          _buildDetailRow('Address', route.address), // Handle null
          _buildDetailRow('Pass Rate', '${route.passRate}%'), // Handle null
          const SizedBox(height: 20),

          // Route Details
          _buildSectionTitle('Route Details'),
          _buildDetailRow('Route Name', route.routeName), // Handle null
          _buildDetailRow('From', route.from), // Handle null
          _buildDetailRow('To', route.to), // Handle null
          _buildDetailRow(
            'Expected Time',
            '${route.expectedTime} minutes',
          ), // Handle null
          _buildDetailRow('Share URL', route.shareUrl), // Handle null
          const SizedBox(height: 20),

          // Start and End Coordinates
          _buildSectionTitle('Coordinates'),
          _buildDetailRow(
            'Start',
            'Lat: ${route.startCoordinator['lat'] ?? 0.0}, Lng: ${route.startCoordinator['lng'] ?? 0.0}',
          ),
          _buildDetailRow(
            'End',
            'Lat: ${route.endCoordinator['lat'] ?? 0.0}, Lng: ${route.endCoordinator['lng'] ?? 0.0}',
          ),
          const SizedBox(height: 20),

          // List of Stops
          _buildSectionTitle('Stops'),
          ...route.listOfStops.map((stop) => _buildStopCard(stop)),
        ],
      ),
    );
  }

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
