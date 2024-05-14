import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vtv_common/guest.dart';

import '../../domain/entities/full_address.dart';

class AddressPickerDialog extends StatefulWidget {
  const AddressPickerDialog({super.key, required this.sl});

  final GetIt sl;

  @override
  State<AddressPickerDialog> createState() => _AddressPickerDialogState();
}

class _AddressPickerDialogState extends State<AddressPickerDialog> {
  String? _provinceName;
  String? _provinceCode;
  String? _districtName;
  String? _districtCode;
  String? _wardName;
  String? _wardCode;

  String fullAddress = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          _provinceName != null ? Text('Tỉnh/thành phố: ${_provinceName!}') : const Text('Chọn tỉnh/thành phố'),
          _districtName != null
              ? Text('Quận/huyện: $_districtName')
              : _provinceName == null
                  ? const SizedBox.shrink()
                  : const Text('Chọn quận/huyện'),
          _wardName != null
              ? Text('Phường/xã: $_wardName')
              : _districtName == null
                  ? const SizedBox.shrink()
                  : const Text('Chọn phường/xã'),
          if (_wardName == null) ...[
            Expanded(
              child: FutureBuilder<dynamic>(
                  future: _provinceName == null
                      ? widget.sl<GuestDataSource>().getProvinces()
                      : _districtName == null
                          ? widget.sl<GuestDataSource>().getDistrictsByProvinceCode(_provinceCode!)
                          : widget.sl<GuestDataSource>().getWardsByDistrictCode(_districtCode!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.data.length,
                        itemBuilder: (context, index) {
                          final obj = snapshot.data!.data[index];
                          return ListTile(
                            title: Text(obj.name),
                            onTap: () {
                              setState(() {
                                if (_provinceName == null) {
                                  _provinceName = obj.name;
                                  _provinceCode = obj.provinceCode;
                                } else if (_districtName == null) {
                                  _districtName = obj.name;
                                  _districtCode = obj.districtCode;
                                } else {
                                  _wardName = obj.name;
                                  _wardCode = obj.wardCode;
                                }
                              });
                            },
                          );
                        },
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            )
          ] else ...[
            // Full address text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    fullAddress = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ cụ thể (đường, số nhà, tòa nhà,...)',
                ),
              ),
            ),
            const SizedBox(height: 8.0),
          ],

          // Save button
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final addr = FullAddress(
                    provinceName: _provinceName!,
                    provinceCode: _provinceCode!,
                    districtName: _districtName!,
                    districtCode: _districtCode!,
                    wardName: _wardName!,
                    wardCode: _wardCode!,
                    fullAddress: fullAddress,
                  );

                  Navigator.of(context).pop(addr);
                },
                child: const Text('Lưu'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
