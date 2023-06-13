// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/color_schemes.g.dart';
import 'package:front/data/data.dart';
import 'package:front/data/lost_item.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import 'uploading_dialog.dart';

class AddPage extends StatefulWidget {
  final Data localData;

  AddPage({super.key, required this.localData});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _nameController = TextEditingController(text: " ");
  final TextEditingController _descriptionController = TextEditingController(text: " ");
  final TextEditingController _locationController = TextEditingController(text: " ");

  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  DateTime? _selectedDate;

  bool _isAddPageHidden = false;

  XFile? _image;

  double initial = 0.0;
  double distance = 0.0;

  double screenWidth = 0;
  double screenHeight = 0;
  
  String uploadingText = "Uploading";
  Timer? uploadingTimer;


  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();

  bool _isNameError = false;
  bool _isDescriptionError = false;
  bool _isLocationError = false;
  bool _isImageError = false;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_handleNameFocusChange);
    _descriptionFocusNode.addListener(_handleDescriptionFocusChange);
    _locationFocusNode.addListener(_handleLocationFocusChange);
  }

  @override
  void dispose() {
    _nameFocusNode.removeListener(_handleNameFocusChange);
    _nameFocusNode.dispose();
    _descriptionFocusNode.removeListener(_handleDescriptionFocusChange);
    _descriptionFocusNode.dispose();
    _locationFocusNode.removeListener(_handleLocationFocusChange);
    _locationFocusNode.dispose();
    super.dispose();
  }

  void _handleNameFocusChange() {
    _handleFocusChange(_nameController, _nameFocusNode);
  }

  void _handleDescriptionFocusChange() {
    _handleFocusChange(_descriptionController, _descriptionFocusNode);
  }

  void _handleLocationFocusChange() {
    _handleFocusChange(_locationController, _locationFocusNode);
  }

  void _handleFocusChange(TextEditingController controller, FocusNode node) {
    setState(() {
      if (node.hasFocus) {
        controller.text = controller.text.trim();
      } else {
        controller.text = '${controller.text} ';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onVerticalDragStart: (DragStartDetails details) {
        initial = details.globalPosition.dy;
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        distance = details.globalPosition.dy - initial;
        if (distance > 0.0) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: !_isAddPageHidden 
          ? Stack(
            children: [
              buildCardHero(),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                      height: 5.0,
                      width: 50.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    buildTitle(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildImageView(),
                        buildTextField(_nameController, _nameFocusNode, "Name", 290, _isNameError),
                      ],
                    ),
                    buildTextField(_locationController, _locationFocusNode,"Location", 350, _isLocationError),
                    buildTimePicker(context, 350),
                    buildDescriptionTextField(),
                    buildSubmitButton(),
                  ],
                ),
              ),
            ],
          )
          : SizedBox(),
      ),
    );
  }

  Container buildDescriptionTextField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: 350,
      height: 300,
      child: TextField(
        controller: _descriptionController,
        focusNode: _descriptionFocusNode,
        maxLines: null,
        expands: true,
        textInputAction: TextInputAction.done,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          labelText: "Description",
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: _isDescriptionError ? lightColorScheme.error : Colors.grey,
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: _isDescriptionError ? lightColorScheme.error : Colors.grey,
            )
          ),
        ),
      ),
    );
  }

  Hero buildCardHero() {
    return Hero(
      tag: "add lost and found container",
      child: Container(
        decoration: BoxDecoration(
          color: lightColorScheme.background,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      _isImageError = false;
    });
  }

  Widget buildImageView() {
    double width = 60;
    double height = 60;
    return GestureDetector(
      onTap: pickImage,
      child: _image == null
          ? Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: (_isImageError) ? lightColorScheme.error: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            width: width,
            height: height,
            child: Icon(Icons.camera_alt, size: width * 0.9, color: (_isImageError) ? lightColorScheme.error: Colors.grey,),
          )
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(_image!.path),
                  fit: BoxFit.fill,
                ),
              ),
            ),
    );
  }

  Container buildTitle(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 20),
      child: Hero(
        tag: "add lost and found title",
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add item",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, FocusNode focusNode, String labelText, double width, bool isError) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: width,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: isError ? lightColorScheme.error : Colors.grey,
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: isError ? lightColorScheme.error : Colors.grey,
            )
          ),
        ),
      ),
    );
  }

  Widget buildTimePicker(BuildContext context, double width) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: width,
      child: InkWell(
        onTap: () async {
          setState(() {
            _isAddPageHidden = true;
          });
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null && pickedDate != _selectedDate) {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              _selectedDate = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
            }
          }
          setState(() {
            _isAddPageHidden = false;
          });
        },
        child: IgnorePointer(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Select Date and Time",
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  width: 1,
                  color: _isDescriptionError ? lightColorScheme.error : Colors.grey,
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  width: 1,
                  color: _isDescriptionError ? lightColorScheme.error : Colors.grey,
                )
              ),
            ),
            controller: (_selectedDate != null) 
                ? TextEditingController(text: DateFormat('yyyy-MM-dd - kk:mm').format(_selectedDate!))
                : TextEditingController(text: "\n"),
          ),
        ),
      ),
    );
  }

  void startUploadingAnimation() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (_, animation, secondaryAnimation) => UploadingDialog(),
      ),
    );
  }


  void stopUploadingAnimation() {
    if (uploadingTimer != null) {
      setState(() {
        _isAddPageHidden = true;
      });
      uploadingTimer!.cancel();
      uploadingTimer = null;
      Navigator.pop(context);
    }
  }

  ElevatedButton buildSubmitButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _isNameError = _nameController.text.trim().isEmpty;
          _isDescriptionError = _descriptionController.text.trim().isEmpty;
          _isLocationError = _locationController.text.trim().isEmpty;
          _isImageError = _image == null;
        });
        if (!_isNameError && !_isDescriptionError && !_isLocationError && _selectedDate != null && _image != null) {
          Map<String, String> itemData = {
            "item_name": _nameController.text,
            "description": _descriptionController.text,
            "location_found": _locationController.text,
            "date_found": _selectedDate!.toString(),
            "status": "2",
          };
          startUploadingAnimation();
          setState(() {_isAddPageHidden = true; });
          var result = await widget.localData.apiService.postLostAndFound(itemData, File(_image!.path));
          stopUploadingAnimation();
          if (result["status"] == "success") {
            widget.localData.lostAndFounds.add(LostItem.fromJson({
              "id": result["id"],
              "item_name": _nameController.text,
              "description": _descriptionController.text,
              "image_url": "${widget.localData.apiService.baseUrl}/data/lost-and-found/image/${result["id"]}",
              "location_found": _locationController.text,
              "date_found": _selectedDate!.toString(),
              "status": 2,
              "submitter_id": widget.localData.user?.id,
            }));
          }
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      child: Text("Submit"),
    );
  }
}