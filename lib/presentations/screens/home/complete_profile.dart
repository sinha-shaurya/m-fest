import 'package:aash_india/bloc/auth/auth_bloc.dart';
import 'package:aash_india/bloc/auth/auth_event.dart';
import 'package:aash_india/bloc/auth/auth_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/screens/home/home_page.dart';
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
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  String? _selectedGender;
  bool _isStepOne = true;

  // void _autoDetectLocation() {
  //   setState(() {
  //     _cityController.text = "Auto-detected City";
  //     _stateController.text = "Auto-detected State";
  //     _zipCodeController.text = "123456";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
            ));
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                if (!_isStepOne) _buildAddressDetailsForm(),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 0.25),
      ),
      child: Column(
        children: [
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
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
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
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
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
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
                activeColor: AppColors.primaryColor,
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
                activeColor: AppColors.primaryColor,
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
              if (_firstNameController.text.isEmpty ||
                  _lastNameController.text.isEmpty ||
                  _phoneNumberController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('* All fields are required'),
                  backgroundColor: AppColors.errorColor,
                ));
                return;
              } else if (_phoneNumberController.text.trim().length != 10) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter a valid phone number'),
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
              backgroundColor: AppColors.primaryColor,
              padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 120),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 0.25),
      ),
      child: Column(
        children: [
          // ElevatedButton.icon(
          //   onPressed: _autoDetectLocation,
          //   icon: const Icon(
          //     Icons.location_on,
          //     color: AppColors.primaryColor,
          //   ),
          //   label: const Text(
          //     "Detect Location",
          //     style: TextStyle(color: AppColors.primaryColor),
          //   ),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.white,
          //     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8),
          //         side: BorderSide(color: Colors.grey.shade600)),
          //   ),
          // ),
          // const SizedBox(height: 16),
          // const Text("Or"),
          // const SizedBox(height: 16),
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
              labelText: "City",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.location_city),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _stateController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
              labelText: "State",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.margin_sharp),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _zipCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
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
                  _stateController.text.isEmpty ||
                  _zipCodeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('* All fields are required'),
                  backgroundColor: AppColors.errorColor,
                ));
                return;
              } else if (_zipCodeController.text.trim().length != 6) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter a valid pincode'),
                  backgroundColor: AppColors.errorColor,
                ));
                return;
              } else {
                BlocProvider.of<AuthBloc>(context).add(AuthCompleteProfile({
                  "firstname": _firstNameController.text.trim(),
                  "lastname": _lastNameController.text.trim(),
                  "gender": _selectedGender,
                  "phonenumber": _phoneNumberController.text.trim(),
                  "city": _cityController.text.trim(),
                  "state": _stateController.text.trim(),
                  "pincode": _zipCodeController.text.trim(),
                }));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 120),
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
