import 'package:aash_india/bloc/auth/auth_bloc.dart';
import 'package:aash_india/bloc/auth/auth_event.dart';
import 'package:aash_india/bloc/auth/auth_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/screens/home/home_page.dart';
import 'package:aash_india/presentations/screens/profile/waiting_approval.dart';
import 'package:aash_india/presentations/widgets/city_autocomplete.dart';
import 'package:aash_india/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteProfile extends StatefulWidget {
  final String name;
  final bool isCustomer;
  const CompleteProfile(
      {required this.name, required this.isCustomer, super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final LocalStorageService _localStorageService = LocalStorageService();
  String _selectedCategory = 'Electronics';
  String _selectedState = 'Bihar';
  bool _showOtherCategoryField = false;

  String? _selectedGender;
  bool _isStepOne = true;

  final List<String> statesAndUTs = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Lakshadweep',
    'Delhi',
    'Puducherry',
    'Ladakh',
    'Jammu and Kashmir'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
        backgroundColor: Color(0xFFa7c957),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
            ));
          } else if (state is AuthNotApproved) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WaitingApproval()),
                (Route<dynamic> route) => false);
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Profile updated'),
              backgroundColor: Colors.green,
            ));
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFa7c957),
                Color(0xFF386641),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hey, ${widget.name}",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Can you provide some details so that we could know you better?",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                if (_isStepOne) _buildPersonalDetailsForm(),
                if (!_isStepOne)
                  widget.isCustomer
                      ? _buildAddressDetailsForm()
                      : _buildBusinessDetailsForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalDetailsForm() {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 0.25),
      ),
      child: Column(
        children: [
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(
              fillColor: Colors.white60,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF386641))),
              labelText: "First Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _lastNameController,
            decoration: InputDecoration(
              fillColor: Colors.white60,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF386641))),
              labelText: "Last Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              fillColor: Colors.white60,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF386641))),
              labelText: "Phone Number",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Gender: "),
              Radio<String>(
                value: "Male",
                groupValue: _selectedGender,
                activeColor: Color(0xFF386641),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const Text("Male"),
              Radio<String>(
                value: "Female",
                groupValue: _selectedGender,
                activeColor: Color(0xFF386641),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const Text("Female"),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final nameRegex = RegExp(r'^[A-Za-z]{2,}$');
              final phoneRegex = RegExp(r'^[6-9][0-9]{9}$');

              if (_firstNameController.text.isEmpty ||
                  !nameRegex.hasMatch(_firstNameController.text) ||
                  _lastNameController.text.isEmpty ||
                  !nameRegex.hasMatch(_lastNameController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter valid first and last names.'),
                  backgroundColor: AppColors.errorColor,
                ));
                return;
              } else if (_phoneNumberController.text.trim().isEmpty ||
                  !phoneRegex.hasMatch(_phoneNumberController.text.trim())) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Please enter a valid 10-digit Indian phone number.'),
                  backgroundColor: AppColors.errorColor,
                ));
                return;
              } else if (_selectedGender == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please select your gender'),
                  backgroundColor: AppColors.errorColor,
                ));
                return;
              } else {
                setState(() {
                  _isStepOne = false;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF386641),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Next",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressDetailsForm() {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 0.25),
      ),
      child: Column(
        children: [
          CityAutocomplete(
              cities: _localStorageService.getCities ?? [],
              cityController: _cityController),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedState,
              items: statesAndUTs.map((state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedState = newValue!;
                });
              },
              decoration: InputDecoration(
                fillColor: Colors.white60,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF386641))),
                labelText: "State",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _zipCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              fillColor: Colors.white60,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF386641))),
              labelText: "Pincode",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.local_post_office),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_cityController.text.isEmpty ||
                  _selectedState.isEmpty ||
                  _zipCodeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('* All fields are required'),
                    backgroundColor: AppColors.errorColor,
                  ),
                );
                return;
              }
              if (!RegExp(r"^[a-zA-Z\s]+$")
                  .hasMatch(_cityController.text.trim())) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a valid city name'),
                    backgroundColor: AppColors.errorColor,
                  ),
                );
                return;
              }
              if (!RegExp(r"^\d{6}$")
                  .hasMatch(_zipCodeController.text.trim())) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a valid 6-digit pincode'),
                    backgroundColor: AppColors.errorColor,
                  ),
                );
                return;
              }
              BlocProvider.of<AuthBloc>(context).add(AuthCompleteProfile({
                "firstname": _firstNameController.text.trim(),
                "lastname": _lastNameController.text.trim(),
                "gender": _selectedGender,
                "phonenumber": _phoneNumberController.text.trim(),
                "city": _cityController.text.trim(),
                "state": _selectedState,
                "pincode": _zipCodeController.text.trim(),
              }));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF386641),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                }
                return const Text(
                  "Finish",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessDetailsForm() {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 0.25),
      ),
      child: Column(
        children: [
          TextField(
            controller: _shopNameController,
            decoration: InputDecoration(
              labelText: "Shop Name",
              prefixIcon: const Icon(Icons.store),
              fillColor: Colors.white60,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF386641))),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          CityAutocomplete(
              cities: _localStorageService.getCities ?? [],
              cityController: _cityController),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedState,
              items: statesAndUTs.map((state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedState = newValue!;
                });
              },
              decoration: InputDecoration(
                fillColor: Colors.white60,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF386641))),
                labelText: "State",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _zipCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Pincode",
              prefixIcon: const Icon(Icons.numbers),
              fillColor: Colors.white60,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF386641))),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: [
              'Electronics',
              'Fashion',
              'Home Essentials',
              'Wellness',
              'Groceries',
              'Others'
            ].map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
                _showOtherCategoryField = _selectedCategory == 'Others';
              });
            },
            decoration: InputDecoration(
              labelText: "Category",
              prefixIcon: const Icon(Icons.category),
              fillColor: Colors.white60,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF386641))),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (_showOtherCategoryField) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: "Enter Category",
                fillColor: Colors.white60,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF386641))),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_shopNameController.text.isEmpty ||
                  _cityController.text.isEmpty ||
                  _selectedState.isEmpty ||
                  _zipCodeController.text.isEmpty ||
                  (_showOtherCategoryField &&
                      _categoryController.text.isEmpty)) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('* All fields are required'),
                  backgroundColor: AppColors.errorColor,
                ));
                return;
              }

              if (!RegExp(r"^[a-zA-Z\s]+$")
                  .hasMatch(_cityController.text.trim())) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter a valid city name'),
                  backgroundColor: AppColors.errorColor,
                ));
                return;
              }

              if (!RegExp(r"^\d{6}$")
                  .hasMatch(_zipCodeController.text.trim())) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter a valid 6-digit pincode'),
                  backgroundColor: AppColors.errorColor,
                ));
                return;
              }

              BlocProvider.of<AuthBloc>(context).add(AuthCompleteProfile({
                "firstname": _firstNameController.text.trim(),
                "lastname": _lastNameController.text.trim(),
                "gender": _selectedGender,
                "phonenumber": _phoneNumberController.text.trim(),
                "shop_name": _shopNameController.text.trim(),
                "shop_city": _cityController.text.trim(),
                "shop_state": _selectedState,
                "shop_pincode": _zipCodeController.text.trim(),
                "shop_category": _showOtherCategoryField
                    ? _categoryController.text.trim()
                    : _selectedCategory,
              }));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF386641),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                }
                return const Text(
                  "Finish",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
