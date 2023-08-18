import 'package:app_ordeus/app/modules/order/controller.dart';
import 'package:app_ordeus/app/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Operacoes {
  faturar;
}

class OrderPage extends StatelessWidget {
  OrderPage({super.key});

  final controller = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async => await controller.getback(),
      child: Scaffold(
        //APPBAR
        appBar: AppBar(
          //
          // TÍTULO
          title: Obx(() => Text(controller.title.value)),

          //BOTÃO PARA FATURAR O PEDIDO
          actions: [
            PopupMenuButton<Operacoes>(
              onSelected: (value) => controller.invoiceOrder(),
              itemBuilder: (context) => [
                if (controller.canfaturar)
                  const PopupMenuItem(
                    value: Operacoes.faturar,
                    child: Text('Faturar'),
                  )
              ],
            ),
          ],
        ),

        //CORPO
        body: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.05, vertical: Get.height * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //

                //INFORMAÇÕES DO PEDIDO NO GERAL
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 1) Informações do pedido
                        // 2) Nome do cliente
                        // 3) Observação do produto

                        CustomTextField(
                          label: 'Nome do Cliente: ',
                          controller: controller.clientNameController,
                          readOnly: controller.currentOrder.value != null,
                        ),
                        CustomTextField(
                          label: 'Observação: ',
                          controller: controller.orderObservationController,
                          textInputType: TextInputType.multiline,
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 10)),

                        // 1) Lista de Produtos enviados à produção
                        // 2) Botão para cancelar o produto enviado à produção

                        if (controller.currentOrder.value != null &&
                            controller.currentOrder.value!.products!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpansionTile(
                                title: const Text('Produtos Solicitados'),
                                collapsedBackgroundColor: Colors.orangeAccent,
                                children: [
                                  for (var product in controller
                                      .currentOrder.value!.products!)
                                    ListTile(
                                      leading: Text(
                                        "R\$ ${product.productPrice!}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      title: Text(
                                        product.productName!,
                                      ),
                                      subtitle: Text(
                                        product.productDescription ??
                                            'Sem Descrição',
                                      ),
                                      trailing: GestureDetector(
                                        onTap: () =>
                                            controller.removeProduct(product),
                                        child: const Icon(Icons.delete),
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Get.width * .05),
                              ),
                            ],
                          ),

                        // 1) Lista de Produtos não enviados à produção
                        // 2) Botão para remover produto

                        Visibility(
                          visible: controller.productsMemory.isNotEmpty,
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            collapsedBackgroundColor: Colors.orangeAccent,
                            title: const Text('Produtos Não Enviados'),
                            children: [
                              for (var productMemory
                                  in controller.productsMemory)
                                ListTile(
                                  leading: Text(
                                    "R\$ ${productMemory.productPrice!}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  title: Text(
                                    productMemory.productName!,
                                  ),
                                  subtitle: Text(
                                    productMemory.productDescription ??
                                        'Sem Descrição',
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () =>
                                        controller.removeProduct(productMemory),
                                    child: const Icon(Icons.delete),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //BOTÕES FIXOS E INFORMAÇÕES DE PREÇO
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1) Informações de Preço
                    // 2) Botão para escolha escolher o produto
                    // 3) Botão para enviar à produção os itens

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          "R\$ ${controller.orderPrice}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height * 0.01)),
                    OutlinedButton.icon(
                      onPressed: () => controller.choiceProduct(),
                      icon: const Icon(Icons.add_shopping_cart_sharp),
                      label: const Text('Adicionar Produtos'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => controller.sendProduction(),
                      icon: const Icon(Icons.dinner_dining),
                      label: const Text('Enviar Para Produção'),
                    ),
                  ],
                ),

                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}
