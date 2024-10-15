import 'package:aash_india/bloc/coupons/coupon_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:aash_india/bloc/profile/profile_bloc.dart';
import 'package:aash_india/bloc/profile/profile_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/widgets/coupon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCoupon extends StatefulWidget {
  const CreateCoupon({super.key});

  @override
  State<CreateCoupon> createState() => _CreateCouponState();
}

class _CreateCouponState extends State<CreateCoupon> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;

  String couponTitle = "New Coupon";
  int price = 100;
  String couponDescription = "Coupon Description";
  int discountPercent = 20;
  bool isActive = true;
  Color selectedColor = const Color(0xFF880E4F);
  DateTime? couponValidity;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: price.toString());
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CouponBloc, CouponState>(
      listener: (context, state) {
        if (state is CouponFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: AppColors.errorColor,
          ));
        } else if (state is CouponSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Added successfully"),
            backgroundColor: Colors.green,
          ));
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CouponCard(
                title: couponTitle,
                discountPercent: discountPercent,
                active: isActive,
                subtitle: couponDescription,
                color: selectedColor,
                validity: couponValidity,
                price: price,
              ),
              const SizedBox(height: 20),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColorOptions(),
            const SizedBox(height: 24),
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildPriceField(),
            const SizedBox(height: 16),
            _buildDiscountField(),
            const SizedBox(height: 16),
            _buildDateField(),
            const SizedBox(height: 16),
            _buildActiveSwitch(),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildColorOption(
            AppColors.primaryColor, selectedColor == AppColors.primaryColor),
        _buildColorOption(Colors.red, selectedColor == Colors.red),
        _buildColorOption(Colors.blue, selectedColor == Colors.blue),
        _buildColorOption(Colors.green, selectedColor == Colors.green),
        _buildColorOption(Colors.orange, selectedColor == Colors.orange),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      initialValue: couponTitle,
      decoration: InputDecoration(
        labelText: "Coupon Title",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "Please enter a coupon title";
        }
        return null;
      },
      onChanged: (val) {
        setState(() {
          couponTitle = val;
        });
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      decoration: InputDecoration(
        labelText: "Price",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "Please enter a price";
        }
        return null;
      },
      onChanged: (val) {
        setState(() {
          price = int.parse(val);
        });
      },
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Coupon Validity",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: couponValidity ?? DateTime.now(),
          firstDate: DateTime.now(), // current date
          lastDate: DateTime(2100), // future date limit
        );

        if (pickedDate != null) {
          setState(() {
            couponValidity = pickedDate;
          });
        }
      },
      validator: (val) {
        if (couponValidity == null) {
          return "Please select a valid date";
        }
        return null;
      },
      controller: TextEditingController(
        text: couponValidity != null
            ? "${couponValidity!.day}/${couponValidity!.month}/${couponValidity!.year}"
            : "",
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      initialValue: couponDescription,
      decoration: InputDecoration(
        labelText: "Coupon Subtitle",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "Please enter a coupon description";
        }
        return null;
      },
      onChanged: (val) {
        setState(() {
          couponDescription = val;
        });
      },
    );
  }

  Widget _buildDiscountField() {
    return TextFormField(
      initialValue: discountPercent.toString(),
      decoration: InputDecoration(
        labelText: "Discount %",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (val) {
        if (val == null ||
            int.tryParse(val) == null ||
            int.tryParse(val)! <= 0) {
          return "Please enter a valid discount percentage";
        }
        return null;
      },
      onChanged: (val) {
        setState(() {
          discountPercent = int.tryParse(val) ?? 0;
        });
      },
    );
  }

  Widget _buildActiveSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Active"),
        Switch(
          value: isActive,
          onChanged: (val) {
            setState(() {
              isActive = val;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<CouponBloc, CouponState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is! CouponLoading ? _onCreateCouponPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 120),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: state is CouponLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Create",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
        );
      },
    );
  }

  void _onCreateCouponPressed() {
    if (_formKey.currentState!.validate()) {
      final profileState = BlocProvider.of<ProfileBloc>(context).state;

      if (profileState is ProfileFetched) {
        String hexColor =
            '#${selectedColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
        final shopCategory = profileState.shopCategory;
        BlocProvider.of<CouponBloc>(context).add(CreateCouponEvent(
          title: couponTitle,
          category: shopCategory ?? "none",
          discountPercentage: discountPercent,
          active: isActive,
          style: {"color": hexColor},
          validTill: couponValidity!,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Unable to create coupon"),
          backgroundColor: AppColors.errorColor,
        ));
      }
    }
  }

  Widget _buildColorOption(Color color, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
