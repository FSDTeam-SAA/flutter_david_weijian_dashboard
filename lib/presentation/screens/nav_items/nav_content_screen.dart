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
              // Reset the form and toggle the "Add Test Center" section

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
                      ? Text('View Test Centres')
                      : Text('Add Test Centre'),
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
                    ? LoadingWidget()
                    : const SizedBox(),
          ),

          // Show the list of test centres or the "Add Test Center" form
          Obx(
            () =>
                _controller.showAddTestCentreButton.value
                    ? _buildAddTestCentreForm()
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
                    title: Text(testCentre['name']),
                    subtitle: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(testCentre['address']),
                        Text(testCentre['postCode']),

                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Set the selected test centre
                        _controller.testCentreId.value = testCentre['_id'];
                        _controller.testCentreName.value = testCentre['name'];
                        _controller.testCentreAddress.value =
                            testCentre['address'];
                        _controller.postCode.value = testCentre['postCode'];
                        _controller.showAddTestCentreButton.value = true;
                        showTestCentreForm(context, _controller);
                      },
                      child: const Text('Select'),
                    ),
                  );
                },
              ),
    );
  }
  void showTestCentreForm(BuildContext context, ContentController controller) {
  final formKey = GlobalKey<FormState>();

  Get.dialog(
    AlertDialog(
      title: Text(controller.selectedTestCentre.isEmpty ? 'Add Test Center' : 'Update Test Center'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: controller.selectedTestCentre['name'] ?? '',
                decoration: const InputDecoration(labelText: 'Test Centre Name'),
                onChanged: (value) => controller.testCentreName.value = value,
                validator: (value) => value?.isEmpty ?? true ? 'This field is required' : null,
              ),
              TextFormField(
                initialValue: controller.selectedTestCentre['address'] ?? '',
                decoration: const InputDecoration(labelText: 'Address'),
                onChanged: (value) => controller.testCentreAddress.value = value,
                validator: (value) => value?.isEmpty ?? true ? 'This field is required' : null,
              ),
              TextFormField(
                initialValue: controller.selectedTestCentre['postCode'] ?? '',
                decoration: const InputDecoration(labelText: 'Post Code'),
                onChanged: (value) => controller.postCode.value = value,
                validator: (value) => value?.isEmpty ?? true ? 'This field is required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final data = {
                "name": controller.testCentreName.value,
                "address": controller.testCentreAddress.value,
                "postCode": controller.postCode.value,
              };
              if (controller.selectedTestCentre.isEmpty) {
                controller.addTestCentre();
              } else {
                controller.updateTestCentre(controller.selectedTestCentre['_id'], data);
              }
              Get.back();
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
}
