import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungtanfun/models/product_model.dart';
import 'package:ungtanfun/utility/my_style.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ProductModel> productModels = List();
  int page = 10;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readProduct();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('Position is Bottom');
        setState(() {
          page += 10;
        });
      }
    });
  }

  Future<Null> readProduct() async {
    String path = 'https://jsonplaceholder.typicode.com/photos';
    await Dio().get(path).then((value) {
      print('value = $value');
      for (var item in value.data) {
        ProductModel model = ProductModel.fromMap(item);
        // print('title = ${model.title}');
        setState(() {
          productModels.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: productModels.length == 0
          ? MyStyle().showProgress()
          : ListView.builder(
              controller: scrollController,
              itemCount: page,
              itemBuilder: (context, index) => Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyStyle().showTitleH1(
                            'id => ${productModels[index].id.toString()}'),
                        MyStyle().showTitleH2(productModels[index].title),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Image.network(productModels[index].url),
                  )
                ],
              ),
            ),
    );
  }
}
