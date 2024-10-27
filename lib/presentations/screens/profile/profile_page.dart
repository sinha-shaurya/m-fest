import 'package:aash_india/bloc/auth/auth_bloc.dart';
import 'package:aash_india/bloc/auth/auth_event.dart';
import 'package:aash_india/bloc/auth/auth_state.dart';
import 'package:aash_india/bloc/coupons/coupon_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:aash_india/bloc/profile/profile_bloc.dart';
import 'package:aash_india/bloc/profile/profile_event.dart';
import 'package:aash_india/bloc/profile/profile_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/screens/auth/login.dart';
import 'package:aash_india/presentations/screens/profile/info_tile.dart';
import 'package:aash_india/presentations/widgets/how_it_works.dart';
import 'package:aash_india/presentations/widgets/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isOtherCategory = false;
  bool _showQRCode = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLogout) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
            }
          },
        ),
        BlocListener<CouponBloc, CouponState>(
          listener: (context, state) {
            if (state is CouponSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Coupon(s) transferred successfully'),
                backgroundColor: Colors.green,
              ));
            }
          },
        ),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileFetched) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProfileImage(state.gender == 'Male'),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: state.id));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Copied to clipboard")),
                          );
                        },
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: _boxDecoration(),
                            child: Text("id: ${state.id}")),
                      ),
                      state.type == 'partner'
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showQRCode = !_showQRCode;
                                });
                              },
                              child: Text(_showQRCode
                                  ? 'Hide QR Code'
                                  : 'Show QR Code'),
                            )
                          : SizedBox(),
                      const SizedBox(height: 20),
                      if (_showQRCode)
                        Container(
                          decoration: _boxDecoration(),
                          child: QrImageView(
                            data: state.id,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ),
                      const SizedBox(height: 20),
                      _buildInfoSection(
                        title: 'Personal Information',
                        content: [
                          InfoTile(
                            label: 'First Name',
                            value: state.fname,
                            icon: Icons.person,
                          ),
                          InfoTile(
                            label: 'Last Name',
                            value: state.lname,
                            icon: Icons.person,
                          ),
                          InfoTile(
                            label: 'Phone Number',
                            value: state.phone,
                            icon: Icons.phone,
                          ),
                        ],
                        onEditPressed: () {
                          _showEditPersonalInfoDialog(context, state);
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildInfoSection(
                        title: state.type == 'customer'
                            ? 'Address Information'
                            : 'Shop Information',
                        content: [
                          state.type == 'partner'
                              ? InfoTile(
                                  label: 'Name',
                                  value: state.shopName ?? "",
                                  icon: Icons.shop,
                                )
                              : SizedBox(),
                          state.type == 'partner'
                              ? InfoTile(
                                  label: 'Category',
                                  value: state.shopCategory ?? "",
                                  icon: Icons.category,
                                )
                              : SizedBox(),
                          InfoTile(
                            label: 'City',
                            value: state.city,
                            icon: Icons.location_city,
                          ),
                          InfoTile(
                            label: 'State',
                            value: state.state,
                            icon: Icons.map_outlined,
                          ),
                          InfoTile(
                            label: 'Pincode',
                            value: state.pincode,
                            icon: Icons.numbers,
                          ),
                        ],
                        onEditPressed: () {
                          state.type == 'customer'
                              ? _showEditAddressDialog(context, state)
                              : _showEditShopInfoDialog(context, state);
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildSettingsSection(state.type == 'partner'),
                      const SizedBox(height: 20),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(
            child: const CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(bool male) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          male ? 'assets/man.jpeg' : 'assets/woman.jpeg',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          height: 200,
          width: 200,
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> content,
    required VoidCallback onEditPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...content,
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: onEditPressed,
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(bool isPartner) {
    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: [
          !isPartner
              ? ListTile(
                  title: Text("Transfer Coupon"),
                  leading: Icon(Icons.swap_horiz),
                  onTap: () {
                    showTransferDialog(context);
                  },
                )
              : const SizedBox(),
          !isPartner ? const Divider() : const SizedBox(),
          const ListTile(
            leading: Icon(Icons.replay),
            title: Text('Change Password'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.mobile_friendly),
            title: const Text('Version'),
            trailing: Text(
              'v1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('How it works'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return HowItWorks();
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.privacy_tip_rounded),
            title: Text('Privacy Policy'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return PrivacyPolicy();
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            trailing: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return CircularProgressIndicator(
                    color: Colors.grey.shade600,
                  );
                }
                return const SizedBox();
              },
            ),
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(AuthLogoutEvent());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Designed & Developed by',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  const url = 'https://www.instagram.com/_sonu.hansda_';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('Sonu Hansda'),
              ),
              const Text(' & '),
              GestureDetector(
                onTap: () async {
                  const url = 'https://www.instagram.com/ayush.kr._singh';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('Ayush Singh'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(width: 0.25),
    );
  }

  void _showEditPersonalInfoDialog(BuildContext context, ProfileFetched state) {
    String updatedFname = state.fname;
    String updatedLname = state.lname;
    String updatedPhone = state.phone;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Edit Personal Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: state.fname,
                  onChanged: (val) {
                    updatedFname = val;
                  },
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: state.lname,
                  onChanged: (val) {
                    updatedLname = val;
                  },
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: state.phone,
                  onChanged: (val) {
                    updatedPhone = val;
                  },
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            TextButton(
              onPressed: () {
                if (updatedFname.isNotEmpty &&
                    updatedLname.isNotEmpty &&
                    updatedPhone.isNotEmpty) {
                  BlocProvider.of<ProfileBloc>(context).add(ProfileUpdateInfo({
                    "firstname": updatedFname,
                    "lastname": updatedLname,
                    "phonenumber": updatedPhone,
                    "city": state.city,
                    "gender": state.gender,
                    "state": state.state,
                    "pincode": state.pincode,
                  }));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("* All fields are required"),
                    backgroundColor: AppColors.errorColor,
                  ));
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void showTransferDialog(BuildContext context) {
    TextEditingController userIdController = TextEditingController();
    int count = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Transfer Coupon"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userIdController,
                decoration: InputDecoration(labelText: "User ID"),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (count > 1) {
                        count--;
                        (context as Element).markNeedsBuild();
                      }
                    },
                  ),
                  Text(count.toString(), style: TextStyle(fontSize: 18)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      count++;
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            BlocBuilder<CouponBloc, CouponState>(
              builder: (context, state) {
                if (state is CouponLoading) {
                  return CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  );
                }
                return ElevatedButton(
                  onPressed: () {
                    if (userIdController.text.isEmpty || count < 1) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Invalid data'),
                        backgroundColor: AppColors.errorColor,
                      ));
                      return;
                    }
                    BlocProvider.of<CouponBloc>(context).add(
                        TransferCouponEvent(
                            userId: userIdController.text, count: count));
                    Navigator.of(context).pop();
                    return;
                  },
                  child: Text("Transfer"),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditAddressDialog(BuildContext context, ProfileFetched state) {
    String updatedCity = state.city;
    String updatedState = state.state;
    String updatedPincode = state.pincode;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Edit Address Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: state.city,
                  onChanged: (val) {
                    updatedCity = val;
                  },
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: state.state,
                  onChanged: (val) {
                    updatedState = val;
                  },
                  decoration: const InputDecoration(labelText: 'State'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: state.pincode,
                  onChanged: (val) {
                    updatedPincode = val;
                  },
                  decoration: const InputDecoration(labelText: 'Pincode'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            TextButton(
              onPressed: () {
                if (updatedCity.isNotEmpty &&
                    updatedState.isNotEmpty &&
                    updatedPincode.isNotEmpty) {
                  BlocProvider.of<ProfileBloc>(context).add(ProfileUpdateInfo({
                    "firstname": state.fname,
                    "lastname": state.lname,
                    "phonenumber": state.phone,
                    "city": updatedCity,
                    "gender": state.gender,
                    "state": updatedState,
                    "pincode": updatedPincode,
                  }));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("* All fields are required"),
                    backgroundColor: AppColors.errorColor,
                  ));
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditShopInfoDialog(BuildContext context, ProfileFetched state) {
    String updatedShopName = state.shopName ?? "";
    String updatedCategory = state.shopCategory ?? "";
    String updatedCity = state.city;
    String updatedState = state.state;
    String updatedPincode = state.pincode;

    isOtherCategory = updatedCategory.toLowerCase() == 'others';
    TextEditingController categoryController =
        TextEditingController(text: isOtherCategory ? updatedCategory : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Edit Shop Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: state.shopName,
                  onChanged: (val) {
                    updatedShopName = val;
                  },
                  decoration: const InputDecoration(labelText: 'Shop Name'),
                ),
                const SizedBox(height: 12),

                // Shop Category field with dropdown
                DropdownButtonFormField<String>(
                  value: isOtherCategory ? 'Others' : updatedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: const [
                    DropdownMenuItem(
                        value: 'Electronics', child: Text('Electronics')),
                    DropdownMenuItem(value: 'Clothes', child: Text('Clothes')),
                    DropdownMenuItem(
                        value: 'Home Appliances',
                        child: Text('Home Appliances')),
                    DropdownMenuItem(value: 'Others', child: Text('Others')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      updatedCategory = value ?? "";
                      if (value == 'Others') {
                        isOtherCategory = true;
                      } else {
                        isOtherCategory = false;
                        updatedCategory = value!;
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Show custom category text field if 'Others' is selected
                isOtherCategory
                    ? TextFormField(
                        controller: categoryController,
                        onChanged: (val) {
                          updatedCategory = val;
                        },
                        decoration:
                            const InputDecoration(labelText: 'Enter Category'),
                      )
                    : const SizedBox(),

                const SizedBox(height: 12),
                TextFormField(
                  initialValue: state.city,
                  onChanged: (val) {
                    updatedCity = val;
                  },
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: state.state,
                  onChanged: (val) {
                    updatedState = val;
                  },
                  decoration: const InputDecoration(labelText: 'State'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: state.pincode,
                  onChanged: (val) {
                    updatedPincode = val;
                  },
                  decoration: const InputDecoration(labelText: 'Pincode'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            TextButton(
              onPressed: () {
                if (updatedShopName.isNotEmpty &&
                    updatedCategory.isNotEmpty &&
                    updatedCity.isNotEmpty &&
                    updatedState.isNotEmpty &&
                    updatedPincode.isNotEmpty) {
                  BlocProvider.of<ProfileBloc>(context).add(ProfileUpdateInfo({
                    "firstname": state.fname,
                    "lastname": state.lname,
                    "phonenumber": state.phone,
                    "shop_name": updatedShopName,
                    "shop_category": updatedCategory,
                    "shop_city": updatedCity,
                    "shop_state": updatedState,
                    "shop_pincode": updatedPincode,
                    "gender": state.gender,
                  }));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("* All fields are required"),
                    backgroundColor: AppColors.errorColor,
                  ));
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
