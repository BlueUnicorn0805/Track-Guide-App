import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({Key? key}) : super(key: key);

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController dlIssueDateCtrl = TextEditingController();
  TextEditingController dlExpireDateCtrl = TextEditingController();

  //text editing controller for text field
  TextEditingController driverNameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController contactCtrl = TextEditingController();
  TextEditingController dlNoCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  var selectedImage;

  ImagePicker _picker = ImagePicker();
  File? pickedImage;

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  void onSubmit() async {
    if (driverNameCtrl.text == "" ||
        dateinput.text == "" ||
        mobileCtrl.text == "" ||
        emailCtrl.text == "" ||
        dlNoCtrl.text == "" ||
        dlIssueDateCtrl.text == "" ||
        dlExpireDateCtrl.text == "" ||
        addressCtrl.text == "" ||
        contactCtrl.text == "" ||
        pickedImage == null) {
      SmartDialog.showToast("Please input all information");
      return;
    }
    SmartDialog.showLoading(msg: "Loading...");
    var res = await ApiService.addDriver(
        driverNameCtrl.text,
        dateinput.text,
        mobileCtrl.text,
        emailCtrl.text,
        dlNoCtrl.text,
        dlIssueDateCtrl.text,
        dlExpireDateCtrl.text,
        addressCtrl.text,
        contactCtrl.text,
        pickedImage);
    SmartDialog.dismiss();
    if (res) {
      SmartDialog.showToast("Success!!!");
      Navigator.pop(context, "success");
    } else {
      SmartDialog.showToast("Something went wrong.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff182f61),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_outlined,
                color: Color(0xff1574a4),
              )),
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Driver",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: ThemeColor.primarycolor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: textField1(
                    context, "Enter Driver Name*", driverNameCtrl, false),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child:
                    textField1(context, "Enter Mobile No*", mobileCtrl, true),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: textField1(context, "Enter Email*", emailCtrl, false),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: textField1(
                    context, "Enter Emergency Contact No*", contactCtrl, false),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: textField2(context, "Enter date of Birth*"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  //   height: Get.size.height * 0.12,
                  width: Get.size.width * 0.95,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffcbd5d5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 10),
                    child: Column(
                      children: [
                        Container(
                          //     height: Get.size.height * 0.04,
                          color: Colors.white,
                          child: textField3(
                              context, "Enter DL Issue date*", dlIssueDateCtrl),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Container(
                            //      height: Get.size.height * 0.04,
                            color: Colors.white,
                            child: textField3(context, "Enter DL Expiry date*",
                                dlExpireDateCtrl),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: textField4(context, "Enter DL NO*", dlNoCtrl),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: textField4(context, "Enter address*", addressCtrl),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: InkWell(
                  onTap: () async {
                    var pickRes = await showDialog(
                        context: context,
                        builder: (bContext) {
                          return Dialog(
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text("Select Option",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text("Take Photo"),
                                    onTap: () {
                                      Navigator.pop(context, "photo");
                                    },
                                  ),
                                  ListTile(
                                    title: Text("Choose From Gallery"),
                                    onTap: () {
                                      Navigator.pop(context, "gallery");
                                    },
                                  ),
                                  ListTile(
                                    title: Text("Cancel"),
                                    onTap: () {
                                      Navigator.pop(context, "");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                    print(pickRes);
                    if (pickRes == "") {
                      return;
                    }
                    ImageSource imgSrc = ImageSource.camera;
                    if (pickRes == "photo") {
                      await Permission.camera.isDenied.then((value) {
                        if (value) {
                          Permission.camera.request();
                        }
                      });
                      imgSrc = ImageSource.camera;
                    } else if (pickRes == "gallery") {
                      imgSrc = ImageSource.gallery;
                    }
                    var image = await _picker.pickImage(source: imgSrc);
                    setState(() {
                      if (image != null) {
                        pickedImage = File(image.path);
                      }
                    });
                  },
                  child: Container(
                    height: Get.size.height * 0.13,
                    width: Get.size.width * 0.95,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffcbd5d5)),
                    child: Center(
                      child: pickedImage == null ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                              radius: 25,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 34,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              "Upload Photo",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey.shade600),
                            ),
                          ),
                        ],
                      ) : Image.file(pickedImage!),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    height: Get.size.height * 0.09,
                    width: Get.size.width * 0.95,
                    decoration: BoxDecoration(
                      color: Color(0xffcbd5d5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: MaterialButton(
                        color: ThemeColor.darkblue,
                        onPressed: () {
                          onSubmit();
                        },
                        child: Center(
                            child: Text(
                          "CREATE DRIVER",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Get.size.height * 0.03,
              )
            ],
          ),
        ),
      ),
    );
  }

  textField2(context, txt) {
    return Container(
      //  height: Get.size.height * 0.06,
      width: Get.size.width * 0.95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xffcbd5d5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
        child: Container(
          color: Colors.white,
          child: Center(
            child: TextField(
              controller: dateinput, //editing controller of this TextField
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),

                hintText: txt,
                hintStyle: TextStyle(
                    //    alignment: Alignment.centerLeft,
                    fontSize: 15.0,
                    color: Colors.grey.shade500), //label text of field
              ),
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(
                        2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  //you can implement different kind of Date Format here according to your requirement

                  setState(() {
                    dateinput.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {
                  print("Date is not selected");
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  textField3(context, txt, ctrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: TextField(
        controller: ctrl, //editing controller of this TextField
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: txt,
          hintStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.grey.shade500), //label text of field
        ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101));

          if (pickedDate != null) {
            print(
                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            print(
                formattedDate); //formatted date output using intl package =>  2021-03-16
            //you can implement different kind of Date Format here according to your requirement

            setState(() {
              ctrl.text = formattedDate; //set output date to TextField value.
            });
          } else {
            print("Date is not selected");
          }
        },
      ),
    );
  }
}

textField1(context, txt, ctrl, isNumber) {
  return Container(
    height: Get.size.height * 0.06,
    width: Get.size.width * 0.95,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Color(0xffcbd5d5)),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: ctrl,
        inputFormatters: <TextInputFormatter>[
          if (isNumber) FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          hintText: txt,
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey.shade500),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          isDense: true,
        ),
      ),
    ),
  );
}

textField4(context, txt, ctrl) {
  return Container(
    //  height: Get.size.height * 0.06,
    width: Get.size.width * 0.95,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Color(0xffcbd5d5)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
      child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              controller: ctrl,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintText: txt, //label text of field
                hintStyle:
                    TextStyle(fontSize: 15.0, color: Colors.grey.shade500),
              ),
            ),
          )),
    ),
  );
}

class TimeController extends GetxController {
  var selectedTime = TimeOfDay.now().obs;
  @override
  void onClose() {}
  chooseTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: selectedTime.value,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                      primary: const Color(0xfff42a41))),
              child: child!);
        },
        initialEntryMode: TimePickerEntryMode.dial,
        helpText: 'Select Time',
        cancelText: 'Close',
        confirmText: 'Confirm',
        errorInvalidText: 'Provide valid time',
        hourLabelText: 'Select Hour',
        minuteLabelText: 'Select Minute');
    if (pickedTime != null && pickedTime != selectedTime.value) {
      selectedTime.value = pickedTime;
    }
  }
}

class TimePicker extends StatelessWidget {
  TimePicker({Key? key}) : super(key: key);
  final controller = Get.put(TimeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.chooseTime();
        },
        child: Container(
          width: Get.size.width * 0.95,
          child: Text(
            "${controller.selectedTime.value.hour}:${controller.selectedTime.value.minute}",
            style: TextStyle(fontSize: 15, color: ThemeColor.greycolor),
          ),
        ),
      ),
    );
  }
}
