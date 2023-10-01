import 'package:flutter/material.dart';
import 'package:natura_app/Services/ProductServices.dart';

import '../Components/CommonModalDrop.dart';
import '../Components/CustomAppBar.dart';
import '../Components/CustomNavigationDrawer.dart';
import '../Components/ImageContainerBox.dart';
import '../Domain/ProductModels.dart';

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
  GetContainer(String x) async {
    GetFutureProductModel? Values =
        await GetFutureProductService(x);
    if (Values != null) {
      if (Values.ID != null) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: ImageContainerBox(
                  description: Values.Name!,
                  value: Values.Value.toString(),
                  ImageInf: Values.Photo,
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

  ShowBox() async {
    List<GetProductTypes?> ResponseMap = await GetTypesList();
    Map<String, String?> productTypeMap = {};

    for (var productType in ResponseMap) {
      if (productType != null) {
        productTypeMap[productType.producttypeid.toString()] = productType.type;
      }
    }

    ChoiceController.clear();
    showDialog(
        context: context,
        builder: (context) {
          return CommonModalDrop(
            DpItems: productTypeMap,
            SelectedValue: '1',
            onChanged: (String x) {
              GetContainer(x);
            },
            Title: 'Escolha o Tipo de Produto',
            Label: 'Diga a IA o que procura',
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
