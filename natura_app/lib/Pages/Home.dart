import 'package:flutter/material.dart';
import 'package:natura_app/Components/CommonModalShow.dart';
import 'package:natura_app/Services/ProductServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/CommonTextField.dart';
import '../Components/CustomAppBar.dart';
import '../Components/CustomNavigationDrawer.dart';
import '../Components/ImageContainerBox.dart';
import '../Domain/ProductModels.dart';
import 'Login.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController ChoiceController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  GetContainer(String) async {
    GetFutureProductModel? Values =
        await GetFutureProductService(ChoiceController.text);
    if (Values != null) {
      if (Values.ID != null) {
        Navigator.pop(context);
        showDialog(context: context, builder: (context){
          return AlertDialog(
            content: ImageContainerBox(
              description: Values.Name!,
              value: Values.Value.toString(),
            ),
          );
        });
      } else {
        Navigator.pop(context);
        ImageContainerBox(
          description: "Nenhum Produto Encontrado",
          value: "R\$ 0.00",
        );
      }
    }
  }

  ShowBox() {
    ChoiceController.clear();
    showDialog(
        context: context,
        builder: (context) {
          return CommonModalShow(
            Title: 'Digite o tipo de item que deseja:',
            controller: ChoiceController,
            Label: 'Tipo de Produto',
            onSubmitted: GetContainer,
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(Title: 'Home'),
        drawer: const CustomNavigationDrawer(),
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'lib/Images/background-green_pink_leaves.jpeg'),
                    fit: BoxFit.cover)),
            child: SafeArea(
                child: Center(
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                  FloatingActionButton.extended(
                    icon: Icon(Icons.card_giftcard),
                    label: Text('Descubra sua próximo compra!'),
                    onPressed: ShowBox,
                  )
                ]))))));
  }
}
