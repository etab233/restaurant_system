import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:restaurants_system/providers/restaurant_request_provider.dart';
import 'package:restaurants_system/view/restaurant-request/map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurants_system/constants.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class RestaurantRequest extends ConsumerStatefulWidget {
  const RestaurantRequest({super.key});
  @override
  ConsumerState<RestaurantRequest> createState() => _RestaurantRequestState();
}

class _RestaurantRequestState extends ConsumerState<RestaurantRequest> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'SY');
  final _addressController = TextEditingController();
  final _mapController = MapController();
  List<int> selected = [];

  // إذا اختار المستخدم موقع على الخريطة غير صحيح
  void showNoLocationMessage() {
    final newState = ref.read(restaurantRequestProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newState.message),
        margin: EdgeInsets.all(5),
        behavior: SnackBarBehavior.floating,
        elevation: 10,
        backgroundColor: const Color(0xFFFF6347),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      if (token != null) {
        await ref
            .read(restaurantRequestProvider.notifier)
            .fetchCategories(token: token);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantRequestProvider);
    if (_addressController.text != state.addressField) {
      _addressController.text = state.addressField;
    }

    ref.listen(restaurantRequestProvider, (previous, next) {
      if (previous?.message != next.message && next.message.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message)));
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, size: 30),
        ),
        title: const Text(
          "Restaurant request form",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: (state.isLoadCategories)
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "register your restaurant and grow with us",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(Constants.orangeColor),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // resturant name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "restaurant name is required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Reataurant name",
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  prefixIcon: Icon(
                                    Icons.restaurant,
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(Constants.orangeColor),
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // description
                              TextFormField(
                                controller: _descriptionController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "description is required";
                                  }
                                  return null;
                                },
                                minLines: 1,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: "Description",
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  prefixIcon: Icon(
                                    Icons.description_rounded,
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(Constants.orangeColor),
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // number field
                              InternationalPhoneNumberInput(
                                initialValue: _phoneNumber,
                                textFieldController: _phoneNumberController,
                                onInputChanged: (PhoneNumber number) {
                                  _phoneNumber = number;
                                },
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DROPDOWN,
                                  setSelectorButtonAsPrefixIcon: true,
                                  showFlags: false,
                                ),

                                countries: ['SY'],
                                keyboardType: TextInputType.phone,
                                maxLength: 11,
                                formatInput: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "restaurant phone is required";
                                  }
                                  return null;
                                },
                                inputDecoration: InputDecoration(
                                  labelText: "Restaurant phone",
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(Constants.orangeColor),
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                              // category select
                              MultiSelectDialogField(
                                listType: MultiSelectListType.LIST,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1.5,
                                  ),
                                ),
                                dialogHeight:
                                    (state.categories.length * 55.0) + 50,
                                buttonText: Text("Select Category"),
                                title: Text("Categories"),
                                searchable: true,
                                items: state.categories.entries.map((e) {
                                  return MultiSelectItem<int>(e.value, e.key);
                                }).toList(),
                                onConfirm: (values) {
                                  setState(() {
                                    selected = List<int>.from(
                                      values,
                                    );
                                  });
                                },
                              ),
                              const SizedBox(height: 20),

                              // address field
                              TextFormField(
                                controller: _addressController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "address is required";
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) async {
                                  await ref
                                      .read(restaurantRequestProvider.notifier)
                                      .searchAddress(value);
                                  final location = ref
                                      .read(restaurantRequestProvider)
                                      .pickedLocation;
                                  _mapController.move(location, 15);
                                },
                                decoration: InputDecoration(
                                  labelText: "Address",
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      await ref
                                          .read(
                                            restaurantRequestProvider.notifier,
                                          )
                                          .getCurrentLocation();
                                      final location = ref
                                          .read(restaurantRequestProvider)
                                          .pickedLocation;
                                      _mapController.move(location, 15);
                                    },
                                    icon: Icon(Icons.my_location),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(Constants.orangeColor),
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Restaurant location",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            children: [
                              Container(
                                height: 270,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: FlutterMap(
                                  mapController: _mapController,
                                  options: MapOptions(
                                    initialCenter: LatLng(35.5317, 35.7903),
                                    initialZoom: 12,
                                    minZoom: 1,
                                    maxZoom: 18,
                                    onTap: (tapPosition, latlng) {
                                      ref
                                          .read(
                                            restaurantRequestProvider.notifier,
                                          )
                                          .updateAddressFromMap(latlng);
                                    },
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                      userAgentPackageName:
                                          "com.example.notes_app",
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: state.pickedLocation,
                                          child: Icon(
                                            Icons.location_on,
                                            color: const Color(0xFFFF6347),
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.open_in_full),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MapScreen(
                                            initialLocation:
                                                state.pickedLocation,
                                          ),
                                        ),
                                      );
                                      if (result != null) {
                                        ref
                                            .read(
                                              restaurantRequestProvider
                                                  .notifier,
                                            )
                                            .updateAddressFromMap(result);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 35),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final token = prefs.getString("token");
                                if (token == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("يرجى تسجيل الدخول أولاً"),
                                    ),
                                  );
                                  return;
                                }
                                await ref
                                    .read(restaurantRequestProvider.notifier)
                                    .sendRestaurantRequest(
                                      name: _nameController.text,
                                      description: _descriptionController.text,
                                      number: _phoneNumber.phoneNumber!,
                                      address: _addressController.text,
                                      latitude: state.pickedLocation.latitude,
                                      longitude: state.pickedLocation.longitude,
                                      categories: selected,
                                      token: token,
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(Constants.orangeColor),
                                foregroundColor: Colors.black,
                                elevation: 10,
                                padding: EdgeInsets.all(15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.send),
                                  SizedBox(width: 5),
                                  Text(
                                    "Submit Request",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
