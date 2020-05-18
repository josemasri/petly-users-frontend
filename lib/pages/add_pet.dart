import 'package:flutter/material.dart';
import 'package:fluttersecretchat/api/pets_api.dart';
import 'package:fluttersecretchat/models/pet.dart';
import 'package:fluttersecretchat/providers/me.dart';
import 'package:fluttersecretchat/utils/dialogs.dart';
import 'package:fluttersecretchat/widgets/custom_card_item.dart';
import 'package:fluttersecretchat/widgets/custom_top_bar.dart';
import 'package:fluttersecretchat/widgets/input_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPetPage extends StatefulWidget {
  final String title;

  AddPetPage({this.title});

  @override
  _AddPetPageState createState() => _AddPetPageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _AddPetPageState extends State<AddPetPage> {
  AppState state;
  File imageFile;
  String _imageUrl = '';
  int activeStep = 0;
  bool _isValid = false;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String _name = '';
  String _animal = 'Perro';
  int _age = 0;
  String _description = '';

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    final _meProvider = Provider.of<Me>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          SafeArea(child: CustomTopBar()),
          Expanded(
            child: Stepper(
              onStepCancel: () => Navigator.pushNamedAndRemoveUntil(
                context,
                'home',
                (_) => false,
              ),
              onStepContinue: activeStep == 0 && imageFile == null
                  ? null
                  : () async {
                      if (activeStep == 0) {
                        PetsApi.uploadPetImage(
                                context, imageFile, _meProvider.token)
                            .then((res) {
                          setState(() {
                            _imageUrl = res;
                            if (res == '') {
                              activeStep = 0;
                            }
                          });
                        });
                        setState(() {
                          activeStep++;
                        });
                      } else if (activeStep == 1) {
                        setState(() {
                          _isValid = _formKey.currentState.validate();
                        });
                        if (_isValid) {
                          setState(() {
                            activeStep++;
                          });
                        }
                      } else {
                        if (_isValid) {
                          if (_loading) {
                            return;
                          }
                          setState(() {
                            _loading = true;
                          });
                          final res = await PetsApi.addPet(
                            context,
                            token: _meProvider.token,
                            animal: _animal,
                            name: _name,
                            age: _age,
                            description: _description,
                            imageUrl: _imageUrl,
                          );
                          setState(() {
                            _loading = false;
                          });
                          if (res) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              'home',
                              (_) => false,
                            );
                            Dialogs.alert(
                              context,
                              title: 'Agregado con éxito',
                              message:
                                  'Felicidades, tu mascota se publicó con éxito',
                            );
                          }
                        }
                      }
                    },
              onStepTapped: (idx) async {
                setState(() {
                  activeStep = idx;
                });
              },
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Container(
                  width: double.infinity,
                  child: activeStep == 2
                      ? FlatButton(
                          color: Colors.orange,
                          onPressed: onStepContinue,
                          child: const Text(
                            'Publicar',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : FlatButton(
                          color: Colors.orange,
                          onPressed: onStepContinue,
                          child: const Text(
                            'Siguiente',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                );
              },
              currentStep: activeStep,
              physics: BouncingScrollPhysics(),
              type: StepperType.horizontal,
              steps: [
                Step(
                  isActive: activeStep == 0,
                  title: Text("Imagen"),
                  content: Column(
                    children: <Widget>[
                      Text(
                        "Elige la imagen que los usuarios verán sobre tu mascota.",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _CustomImageDisplay(imageFile: imageFile),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (state == AppState.free)
                            IconButton(
                              onPressed: () {
                                _pickImage();
                              },
                              icon: Icon(
                                Icons.photo_size_select_actual,
                                size: 40,
                              ),
                            ),
                          if (state == AppState.free) SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              if (state == AppState.free)
                                _takePicture();
                              else if (state == AppState.picked)
                                _cropImage();
                              else if (state == AppState.cropped) _clearImage();
                            },
                            icon: _buildButtonIcon(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Step(
                  isActive: activeStep == 1,
                  title: Text("Info"),
                  content: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          InputText(
                            label: 'Nombre',
                            icon: FontAwesomeIcons.font,
                            validator: (value) {
                              if (value.length > 2) {
                                _name = value;
                                return null;
                              } else {
                                return 'Ingresa un nombre valido';
                              }
                            },
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.cat,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: DropdownButton<String>(
                                    disabledHint: Text('Selecciona'),
                                    isExpanded: true,
                                    value: _animal,
                                    items: <String>[
                                      'Perro',
                                      'Gato',
                                      'Roedor',
                                      'Pes / marino',
                                      'Reptíl',
                                      'Otro'
                                    ].map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _animal = value;
                                      });
                                    },
                                    // value: 'Perro',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InputText(
                            label: 'Edad',
                            inputType: TextInputType.number,
                            icon: FontAwesomeIcons.sortNumericUp,
                            validator: (age) {
                              if (int.tryParse(age) != null) {
                                if (int.tryParse(age) > 0) {
                                  _age = int.tryParse(age);
                                  return null;
                                }
                              }
                              return 'Ingresa un número valido';
                            },
                          ),
                          InputText(
                            label: 'Descripcion',
                            maxLines: 7,
                            hintText: 'Ingresa una descripción de tu mascota',
                            icon: FontAwesomeIcons.fileContract,
                            validator: (value) {
                              if (value.length > 10) {
                                _description = value;
                                return null;
                              }
                              return 'Descripción demasiasdo corta';
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Step(
                  title: Text('Fin'),
                  isActive: activeStep == 2,
                  content: Container(
                    child: _loading
                        ? Center(child: CircularProgressIndicator())
                        : CustomCardItem(
                            pet: Pet(
                            id: 5,
                            name: _name,
                            animal: _animal,
                            age: _age,
                            createdAt: DateTime.now(),
                            description: _description,
                            imageUrl: _imageUrl,
                            userCounty: 'Mexico',
                            userFirstName: 'Jose',
                          )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.camera, size: 40);
    else if (state == AppState.picked)
      return Icon(
        Icons.crop,
        size: 40,
      );
    else if (state == AppState.cropped)
      return Icon(
        Icons.clear,
        size: 40,
      );
    else
      return Container();
  }

  Future<Null> _takePicture() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }
}

class _CustomImageDisplay extends StatelessWidget {
  const _CustomImageDisplay({
    Key key,
    @required this.imageFile,
  }) : super(key: key);

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 200,
      child: imageFile != null
          ? Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
              height: 530,
              width: 380,
            )
          : Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/img/placeholder_2.jpg'),
              ),
              height: 530,
              width: 380,
            ),
    );
  }
}
