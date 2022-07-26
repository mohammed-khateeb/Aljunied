import 'dart:math';
import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Components/Create_Transaction_Components/step_four_transaction.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/transaction_controller.dart';
import 'package:aljunied/Models/category.dart';
import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Models/transaction.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:aljunied/Widgets/waiting_widget.dart';
import 'package:flutter/foundation.dart' as web;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Components/Create_Transaction_Components/step_one_transaction.dart';
import '../Components/Create_Transaction_Components/step_three_transaction.dart';
import '../Components/Create_Transaction_Components/step_two_transaction.dart';
import '../Controller/admin_controller.dart';
import '../Controller/notification_controller.dart';
import '../Models/notification.dart';
import '../Push_notification/push_notification_serveice.dart';
import '../Utils/util.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/step_widget.dart';

class CreateEditTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const CreateEditTransactionScreen({Key? key, this.transaction})
      : super(key: key);

  @override
  State<CreateEditTransactionScreen> createState() =>
      _CreateEditTransactionScreenState();
}

class _CreateEditTransactionScreenState
    extends State<CreateEditTransactionScreen> {
  final _formKeyStepOne = GlobalKey<FormState>();
  final _formKeyStepFour = GlobalKey<FormState>();

  TransactionModel transaction = TransactionModel(
      keyWords: [], employees: [], employeesId: [], departments: []);

  PageController pageController = PageController();
  int? index;

  Category? selectedCategory;

  ///Page one
  int selectedTransactionTypeIndex = 0;
  TextEditingController areaController = TextEditingController();

  ///Page two
  int selectedTransactionSubTypeIndex = 0;

  ///Page three
  TextEditingController additionInfoController = TextEditingController();

  ///Page four
  TextEditingController citizenNameController = TextEditingController();
  TextEditingController convertFromController = TextEditingController();
  TextEditingController convertToController = TextEditingController();
  TextEditingController convertToWithinController = TextEditingController();

  TextEditingController currentStageController = TextEditingController();

  String? convertFromId;
  String? convertToId;
  String? convertToToken;

  String? convertToIdOrigin;

  int duration = 5;
  bool isDay = true;

  @override
  void initState() {
    if (CurrentUser.department != null) {
      convertFromId = CurrentUser.department!.id;
    }

    context.read<AdminController>().getAllCategories().then((value) {
      if (context.read<AdminController>().categories!.isNotEmpty) {
        selectedCategory = context.read<AdminController>().categories![0];
      }
      if (widget.transaction != null) {
        setState(() {
          index = 0;
        });
        convertToIdOrigin = widget.transaction!.convertToId;

        transaction = widget.transaction!;
        transaction.convertFrom =
            CurrentUser.department != null && CurrentUser.isAdmin != true
                ? CurrentUser.department!.name
                : widget.transaction!.convertFrom;
        transaction.id = widget.transaction!.id;
        areaController.text = widget.transaction!.area!;
        selectedTransactionTypeIndex = widget.transaction!.selectedTypeIndex!;
        selectedTransactionSubTypeIndex =
            widget.transaction!.selectedSubTypeIndex!;
        additionInfoController.text = widget.transaction!.additionInfo ?? "";
        citizenNameController.text = widget.transaction!.citizenName!;
        currentStageController.text = widget.transaction!.currentStage!;
        convertFromId =
            CurrentUser.department != null && CurrentUser.isAdmin != true
                ? CurrentUser.department!.id
                : widget.transaction!.convertFromId;
        convertFromController.text = widget.transaction!.convertFrom!;
        convertToId = widget.transaction!.convertToId;
        convertToController.text = widget.transaction!.convertTo!;
        currentStageController.text = widget.transaction!.currentStage!;
        duration = widget.transaction!.duration!;

        isDay = widget.transaction!.isDay!;
        selectedCategory = context
            .read<AdminController>()
            .categories!
            .elementAt(selectedTransactionTypeIndex);
      } else {
        setState(() {
          index = 0;
        });
      }
    });

    if (CurrentUser.departmentId != null) {
      if (CurrentUser.isDepartmentBoss == true) {
        context
            .read<AdminController>()
            .getEmployeeToDepartmentBoss(CurrentUser.departmentId!);
      } else {
        context
            .read<AdminController>()
            .getUserByDepartmentId(CurrentUser.departmentId!);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return web.kIsWeb && size.width > 520
        ? CustomScaffoldWeb(
            title: translate(context, "createATransaction"),
            body: Column(
              children: [
                index != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StepWidget(
                              label:
                                  translate(context, "typeOfTransactionStep"),
                              iconPath: "work.png",
                              isSelected: index == 0,
                              completed: index! > 0,
                              onTab: () {
                                if (index! > 0) {
                                  setState(() {
                                    index = 0;
                                  });
                                  pageController.animateToPage(0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                }
                              },
                            ),
                            StepWidget(
                              label: translate(context, "subTypeOfTransaction"),
                              iconPath: "paper.png",
                              isSelected: index == 1,
                              completed: index! > 1,
                              onTab: () {
                                if (index! > 1 ||
                                    (_formKeyStepOne.currentState!.validate() &&
                                        index == 0)) {
                                  setState(() {
                                    index = 1;
                                  });
                                  pageController.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                }
                              },
                            ),
                            StepWidget(
                              label: translate(context, "anotherAdditionStep"),
                              iconPath: "document.png",
                              isSelected: index == 2,
                              completed: index! > 2,
                              onTab: () {
                                if (index! > 2 || index == 1) {
                                  setState(() {
                                    index = 2;
                                  });
                                  pageController.animateToPage(2,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                }
                              },
                            ),
                            StepWidget(
                              label: translate(context, "citizenInformation"),
                              iconPath: "info.png",
                              isSelected: index == 3,
                              completed: index! > 3,
                              onTab: () {
                                if (index == 2) {
                                  setState(() {
                                    index = 3;
                                  });
                                  pageController.animateToPage(3,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(height: 25),
                Container(
                  width: size.width,
                  height: index == 3 ? 800 : 580,
                  margin: EdgeInsets.only(top: size.height * 0.02),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(size.height * 0.03))),
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.05),
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: pageController,
                        children: [
                          Form(
                            key: _formKeyStepOne,
                            child: !context
                                    .watch<AdminController>()
                                    .waitingCategories
                                ? StepOneTransaction(
                                    categories: context
                                        .watch<AdminController>()
                                        .categories,
                                    areaController: areaController,
                                    onSelectType: (selected) {
                                      setState(() {
                                        selectedTransactionTypeIndex = selected;
                                        selectedTransactionSubTypeIndex = 0;
                                        selectedCategory = context
                                            .watch<AdminController>()
                                            .categories![selected];
                                      });
                                    },
                                    selectedIndex: selectedTransactionTypeIndex,
                                    onSubmit: () {
                                      if (_formKeyStepOne.currentState!
                                          .validate()) {
                                        setState(() {
                                          index = 1;
                                        });
                                        pageController.animateToPage(1,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut);
                                      }
                                    },
                                  )
                                : WaitingWidget(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: StepTwoTransaction(
                              onSelectSubType: (index) {
                                setState(() {
                                  selectedTransactionSubTypeIndex = index;
                                });
                              },
                              category: selectedCategory,
                              selectedIndex: selectedTransactionSubTypeIndex,
                              onSubmit: () {
                                setState(() {
                                  index = 2;
                                });
                                pageController.animateToPage(2,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: StepThreeTransaction(
                              infoController: additionInfoController,
                              onSubmit: () {
                                setState(() {
                                  index = 3;
                                });
                                pageController.animateToPage(3,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              },
                            ),
                          ),
                          Form(
                            key: _formKeyStepFour,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: CurrentUser.isDepartmentBoss == true
                                  ? !context
                                          .watch<AdminController>()
                                          .waitingDepartmentBossUsers
                                      ? StepFourTransaction(
                                          isDay: isDay,
                                          edit: widget.transaction != null,
                                          duration: duration,
                                          onChangeDuration: (d, day) {
                                            setState(() {
                                              duration = d;
                                              isDay = day;
                                            });
                                          },
                                          onSelectConvertTo: (emp) {
                                            setState(() {
                                              convertToId = emp.id;
                                              convertToToken = emp.token;
                                            });
                                          },
                                          onChangeHourOrDay: (day) {
                                            setState(() {
                                              isDay = day;
                                            });
                                          },
                                          convertToId: widget.transaction !=
                                                  null
                                              ? widget.transaction!.convertToId
                                              : null,
                                          targets:
                                              CurrentUser.isDepartmentBoss ==
                                                      true
                                                  ? context
                                                      .watch<AdminController>()
                                                      .employeeToDepartmentBoss
                                                  : context
                                                      .watch<AdminController>()
                                                      .departmentEmployee,
                                          nameController: citizenNameController,
                                          currentStageController:
                                              currentStageController,
                                          convertToController:
                                              convertToController,
                                          onSubmit: () {
                                            if (_formKeyStepFour.currentState!
                                                .validate()) {
                                              insertTransaction(size);
                                            }
                                          },
                                          onEndTransaction: () {
                                            if (_formKeyStepFour.currentState!
                                                .validate()) {
                                              Utils.showSureAlertDialog(
                                                  onSubmit: () {
                                                insertTransaction(size,
                                                    end: true);
                                              });
                                            }
                                          },
                                        )
                                      : const WaitingWidget()
                                  : !context
                                          .watch<AdminController>()
                                          .waitingDepartmentEmployee
                                      ? StepFourTransaction(
                                          isDay: isDay,
                                          edit: widget.transaction != null,
                                          duration: duration,
                                          onChangeDuration: (d, day) {
                                            setState(() {
                                              duration = d;
                                              isDay = day;
                                            });
                                          },
                                          onSelectConvertTo: (emp) {
                                            setState(() {
                                              convertToId = emp.id;
                                              convertToToken = emp.token;

                                            });
                                          },
                                          onChangeHourOrDay: (day) {
                                            setState(() {
                                              isDay = day;
                                            });
                                          },
                                          convertToId: widget.transaction !=
                                                  null
                                              ? widget.transaction!.convertToId
                                              : null,
                                          targets:
                                              CurrentUser.isDepartmentBoss ==
                                                      true
                                                  ? context
                                                      .watch<AdminController>()
                                                      .employeeToDepartmentBoss
                                                  : context
                                                      .watch<AdminController>()
                                                      .departmentEmployee,
                                          nameController: citizenNameController,
                                          currentStageController:
                                              currentStageController,
                                          convertToController:
                                              convertToController,
                                          onSubmit: () {
                                            if (_formKeyStepFour.currentState!
                                                .validate()) {
                                              insertTransaction(size);
                                            }
                                          },
                                          onEndTransaction: () {
                                            if (_formKeyStepFour.currentState!
                                                .validate()) {
                                              Utils.showSureAlertDialog(
                                                  onSubmit: () {
                                                insertTransaction(size,
                                                    end: true);
                                              });
                                            }
                                          },
                                        )
                                      : const WaitingWidget(),
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: kPrimaryColor,
            appBar: CustomAppBar(
              title: translate(context, "createATransaction"),
              titleColor: Colors.white,
              arrowColor: Colors.white,
            ),
            body: Column(
              children: [
                index != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StepWidget(
                            label: translate(context, "typeOfTransactionStep"),
                            iconPath: "work.png",
                            isSelected: index == 0,
                            completed: index! > 0,
                            onTab: () {
                              if (index! > 0) {
                                setState(() {
                                  index = 0;
                                });
                                pageController.animateToPage(0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              }
                            },
                          ),
                          StepWidget(
                            label: translate(context, "subTypeOfTransaction"),
                            iconPath: "paper.png",
                            isSelected: index == 1,
                            completed: index! > 1,
                            onTab: () {
                              if (index! > 1 ||
                                  (_formKeyStepOne.currentState!.validate() &&
                                      index == 0)) {
                                setState(() {
                                  index = 1;
                                });
                                pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              }
                            },
                          ),
                          StepWidget(
                            label: translate(context, "anotherAdditionStep"),
                            iconPath: "document.png",
                            isSelected: index == 2,
                            completed: index! > 2,
                            onTab: () {
                              if (index! > 2 || index == 1) {
                                setState(() {
                                  index = 2;
                                });
                                pageController.animateToPage(2,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              }
                            },
                          ),
                          StepWidget(
                            label: translate(context, "citizenInformation"),
                            iconPath: "info.png",
                            isSelected: index == 3,
                            completed: index! > 3,
                            onTab: () {
                              if (index == 2) {
                                setState(() {
                                  index = 3;
                                });
                                pageController.animateToPage(3,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              }
                            },
                          ),
                        ],
                      )
                    : SizedBox(
                        height: size.height * 0.115,
                      ),
                Expanded(
                  child: Container(
                    width: size.width,
                    margin: EdgeInsets.only(top: size.height * 0.02),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(size.height * 0.03))),
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.05),
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: [
                            Form(
                              key: _formKeyStepOne,
                              child: !context
                                      .watch<AdminController>()
                                      .waitingCategories
                                  ? StepOneTransaction(
                                      categories: context
                                          .watch<AdminController>()
                                          .categories,
                                      areaController: areaController,
                                      onSelectType: (selected) {
                                        setState(() {
                                          selectedTransactionTypeIndex =
                                              selected;
                                          selectedTransactionSubTypeIndex = 0;
                                          selectedCategory = context
                                              .read<AdminController>()
                                              .categories![selected];
                                        });
                                      },
                                      selectedIndex:
                                          selectedTransactionTypeIndex,
                                      onSubmit: () {
                                        if (_formKeyStepOne.currentState!
                                            .validate()) {
                                          setState(() {
                                            index = 1;
                                          });
                                          pageController.animateToPage(1,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut);
                                        }
                                      },
                                    )
                                  : WaitingWidget(),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                              ),
                              child: StepTwoTransaction(
                                onSelectSubType: (index) {
                                  setState(() {
                                    selectedTransactionSubTypeIndex = index;
                                  });
                                },
                                category: selectedCategory,
                                selectedIndex: selectedTransactionSubTypeIndex,
                                onSubmit: () {
                                  setState(() {
                                    index = 2;
                                  });
                                  pageController.animateToPage(2,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                              ),
                              child: StepThreeTransaction(
                                infoController: additionInfoController,
                                onSubmit: () {
                                  setState(() {
                                    index = 3;
                                  });
                                  pageController.animateToPage(3,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                },
                              ),
                            ),
                            Form(
                              key: _formKeyStepFour,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.05,
                                ),
                                child: CurrentUser.isDepartmentBoss == true
                                    ? !context
                                    .watch<AdminController>()
                                    .waitingDepartmentBossUsers
                                    ? StepFourTransaction(
                                  isDay: isDay,
                                  edit: widget.transaction != null,
                                  duration: duration,
                                  onChangeDuration: (d, day) {
                                    setState(() {
                                      duration = d;
                                      isDay = day;
                                    });
                                  },
                                  onSelectConvertTo: (emp) {
                                    setState(() {
                                      convertToId = emp.id;
                                      convertToToken = emp.token;

                                    });
                                  },
                                  onChangeHourOrDay: (day) {
                                    setState(() {
                                      isDay = day;
                                    });
                                  },
                                  convertToId: widget.transaction !=
                                      null
                                      ? widget.transaction!.convertToId
                                      : null,
                                  targets:
                                  CurrentUser.isDepartmentBoss ==
                                      true
                                      ? context
                                      .watch<AdminController>()
                                      .employeeToDepartmentBoss
                                      : context
                                      .watch<AdminController>()
                                      .departmentEmployee,
                                  nameController: citizenNameController,
                                  currentStageController:
                                  currentStageController,
                                  convertToController:
                                  convertToController,
                                  onSubmit: () {
                                    if (_formKeyStepFour.currentState!
                                        .validate()) {
                                      insertTransaction(size);
                                    }
                                  },
                                  onEndTransaction: () {
                                    if (_formKeyStepFour.currentState!
                                        .validate()) {
                                      Utils.showSureAlertDialog(
                                          onSubmit: () {
                                            insertTransaction(size,
                                                end: true);
                                          });
                                    }
                                  },
                                )
                                    : const WaitingWidget()
                                    : !context
                                    .watch<AdminController>()
                                    .waitingDepartmentEmployee
                                    ? StepFourTransaction(
                                  isDay: isDay,
                                  edit: widget.transaction != null,
                                  duration: duration,
                                  onChangeDuration: (d, day) {
                                    setState(() {
                                      duration = d;
                                      isDay = day;
                                    });
                                  },
                                  onSelectConvertTo: (emp) {
                                    setState(() {
                                      convertToId = emp.id;
                                      convertToToken = emp.token;

                                    });
                                  },
                                  onChangeHourOrDay: (day) {
                                    setState(() {
                                      isDay = day;
                                    });
                                  },
                                  convertToId: widget.transaction !=
                                      null
                                      ? widget.transaction!.convertToId
                                      : null,
                                  targets:
                                  CurrentUser.isDepartmentBoss ==
                                      true
                                      ? context
                                      .watch<AdminController>()
                                      .employeeToDepartmentBoss
                                      : context
                                      .watch<AdminController>()
                                      .departmentEmployee,
                                  nameController: citizenNameController,
                                  currentStageController:
                                  currentStageController,
                                  convertToController:
                                  convertToController,
                                  onSubmit: () {
                                    if (_formKeyStepFour.currentState!
                                        .validate()) {
                                      insertTransaction(size);
                                    }
                                  },
                                  onEndTransaction: () {
                                    if (_formKeyStepFour.currentState!
                                        .validate()) {
                                      Utils.showSureAlertDialog(
                                          onSubmit: () {
                                            insertTransaction(size,
                                                end: true);
                                          });
                                    }
                                  },
                                )
                                    : const WaitingWidget(),
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ],
            ),
          );
  }

  setSearchKey(String caseNumber) {
    List<String> searchKey = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      searchKey.add(temp);
    }
    return searchKey;
  }

  insertTransaction(Size size, {bool end = false}) async {
    Random random = Random();
    int randomNumber = random.nextInt(900000) + 100000;
    if (widget.transaction == null) {
      Utils.showWaitingProgressDialog();
      bool exist = await context
          .read<TransactionController>()
          .checkIfTransactionNumberExist(randomNumber.toString());
      if (exist) {
        Utils.hideWaitingProgressDialog();
        insertTransaction(size);
        return;
      }
    }
    if (selectedCategory == null ||
        convertFromId == null ||
        convertToId == null) {
      Utils.hideWaitingProgressDialog();
      Utils.showErrorAlertDialog(
          translate(context, "Unknown error, please try again later"));

      return;
    }

    transaction.area = areaController.text;
    transaction.type = selectedCategory!.nameAr;
    transaction.subType = selectedCategory!.subcategories != null &&
            selectedCategory!.subcategories!.isNotEmpty
        ? selectedCategory!
            .subcategories![selectedTransactionSubTypeIndex].nameAr
        : null;
    transaction.citizenName = citizenNameController.text;
    transaction.convertTo = convertToController.text;
    transaction.convertFrom =
        CurrentUser.department != null && CurrentUser.isAdmin != true
            ? CurrentUser.department!.name
            : convertFromController.text;
    transaction.convertFromId = convertFromId;
    transaction.convertToId = convertToId;
    transaction.currentStage = currentStageController.text;
    transaction.additionInfo = additionInfoController.text;
    transaction.duration = duration;
    transaction.isDay = isDay;
    transaction.selectedTypeIndex = selectedTransactionTypeIndex;
    transaction.selectedSubTypeIndex = selectedTransactionSubTypeIndex;
    if (end) {
      transaction.completed = true;
      transaction.convertFrom = CurrentUser.department!.name!;
      transaction.convertFromId = CurrentUser.department!.id!;
      transaction.convertToId = null;
      transaction.convertTo = translate(context, "transactionEnd");
    }

    if (widget.transaction == null) {
      if (CurrentUser.department != null) {
        transaction.employees = [CurrentUser.userName!];
        transaction.employeesId = [CurrentUser.userId!];
        transaction.departments = [CurrentUser.department!.name!];
      }
      transaction.id = randomNumber.toString();
      List<String> keyWordsFromName =
          setSearchKey((transaction.citizenName!).toLowerCase());

      transaction.keyWords!.addAll(keyWordsFromName);

      List<String> keyWordsFromId =
          setSearchKey((transaction.id!).toLowerCase());
      transaction.keyWords!.addAll(keyWordsFromId);
      await context
          .read<TransactionController>()
          .insertTransaction(transaction: transaction);
      if(convertToToken!=null) {
        await sendNotification(
        "معاملة جديدة",
        "تم تحويل معاملة جديدة لك",
          convertToToken!,
          false,
      );
      }
      Utils.hideWaitingProgressDialog();
      Navigator.pop(context);
      Utils.showSuccessAlertDialog(
        translate(context, "referenceNumberFor") +
            " " +
            citizenNameController.text,
        label: translate(context, "TransactionCreatedSuccessfully"),
        details: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                randomNumber.toString().replaceAllMapped(
                    RegExp(r".{3}"), (match) => "${match.group(0)} "),
                style: TextStyle(
                    fontSize: web.kIsWeb && size.width > 520
                        ? 25
                        : size.height * 0.045),
              ),
            ),
            SizedBox(
              width: web.kIsWeb && size.width > 520 ? 15 : size.width * 0.03,
            ),
            CustomInkwell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: randomNumber.toString()));
                Utils.showToast(
                    translate(Utils.navKey.currentContext!, "copied"),
                    web.kIsWeb && size.width > 520 ? 16 : size.height * 0.02);
              },
              child: Image.asset(
                "icons/copy.png",
                height:
                    web.kIsWeb && size.width > 520 ? 30 : size.height * 0.035,
              ),
            ),
          ],
        ),
        bottom: !web.kIsWeb ||
            MediaQuery.of(Utils.navKey.currentContext!).size.width < 520,
      );
    } else {
      if (transaction.employeesId != null &&
          transaction.employeesId!.last != CurrentUser.userId &&
          CurrentUser.department != null) {
        transaction.employeesId!.add(CurrentUser.userId!);
        transaction.employees!.add(CurrentUser.userName!);
        transaction.departments!.add(CurrentUser.department!.name!);
      }
      if (transaction.convertToId != convertToIdOrigin) {
        context
            .read<TransactionController>()
            .convertTransaction(transaction: transaction);
        if (!end) {
          sendNotification(
            "المعاملة " + transaction.id!,
            "تم تحويل المعاملة الى " +
                transaction.convertTo! +
                " - الوقت المقدر : " +
                transaction.duration!.toString() +
                (transaction.isDay == true ? "يوم" : "ساعة"),
            transaction.id!,
            true
          );
          if(convertToToken!=null) {
            sendNotification(
            "المعاملة " + transaction.id!,
            "تم تحويل معاملة لك",
              convertToToken!,
              false
          );

          }
        }
      }
      context
          .read<TransactionController>()
          .updateTransaction(transaction: transaction);
      if (end) {
        sendNotification(
          "المعاملة " + transaction.id!,
          "تم انهاء المعاملة",
          transaction.id!,
          true
        );
      }

      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        Utils.hideWaitingProgressDialog();
        Navigator.pop(context, transaction);
        Utils.showSuccessAlertDialog(translate(context, "editedSuccessfully"),
            bottom: !web.kIsWeb ||
                MediaQuery.of(Utils.navKey.currentContext!).size.width < 520);
      });
    }
  }

  Future sendNotification(String title, String des, String to,bool topic) async {
    NotificationModel notificationModel = NotificationModel();
    notificationModel.title = title;
    notificationModel.des = des;
    notificationModel.target = to;
    await context
        .read<NotificationController>()
        .insertNewNotification(notificationModel);
    if(topic) {
      await PushNotificationServices.sendMessageToTopic(
      title: title,
      body: des,
      topicName: to,
    );
    }
    else{
      PushNotificationServices.sendMessageToAnyUser(
        title: title,
        body: des,
        to: to,
        withLoading: false,

      );
    }
  }
}
