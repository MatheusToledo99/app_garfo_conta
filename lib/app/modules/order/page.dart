import 'package:app_ordeus/app/modules/order/controller.dart';
import 'package:app_ordeus/app/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Operacoes {
  faturar,
  busy,
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
          // TÍTULO
          title: Obx(
            () => Text(
              controller.title.value,
              style: TextStyle(fontSize: Get.width * 0.041),
            ),
          ),

          //BOTÃO PARA FATURAR O PEDIDO
          actions: [
            PopupMenuButton<Operacoes>(
              onSelected: (value) =>
                  controller.choiceOperation(context, operacao: value),
              itemBuilder: (context) => [
                if (controller.currentOrder.value == null) ...[
                  PopupMenuItem(
                    value: Operacoes.busy,
                    child: Text(
                      controller.bill.billBusy!
                          ? 'Liberar esta comanda'
                          : 'Reservar esta comanda',
                    ),
                  ),
                ] else ...[
                  PopupMenuItem(
                    value: Operacoes.faturar,
                    child: Text(
                      controller.currentOrder.value!.products!.isNotEmpty
                          ? 'Faturar'
                          : 'Cancelar Pedido',
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),

        //CORPO
        body: FutureBuilder<void>(
            future: controller.initializeData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Indicador de carregamento
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar os dados.'));
              } else {
                return Obx(
                  () => Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.05,
                        vertical: Get.height * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Informações do pedido
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // 1) Informações do pedido
                                // 2) Nome do cliente
                                // 3) Observação do produto

                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ExpansionTile(
                                    shape: const RoundedRectangleBorder(
                                      side: BorderSide.none,
                                    ),
                                    collapsedBackgroundColor:
                                        Colors.orangeAccent,
                                    title: const Text('Informações do Pedido'),
                                    children: [
                                      CustomTextField(
                                        label: 'Nome do Cliente: ',
                                        controller: controller
                                            .orderResponsibleController,
                                      ),
                                      CustomTextField(
                                        maxLines: 3,
                                        label: 'Observação: ',
                                        controller: controller
                                            .orderObservationController,
                                        textInputType: TextInputType.multiline,
                                      ),
                                    ],
                                  ),
                                ),

                                // 1) Lista de Produtos enviados à produção
                                // 2) Botão para cancelar o produto enviado à produção
                                Visibility(
                                  visible: controller.currentOrder.value !=
                                          null &&
                                      controller.currentOrder.value?.products !=
                                          null &&
                                      controller.currentOrder.value!.products!
                                          .isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ExpansionTile(
                                      shape: const RoundedRectangleBorder(
                                        side: BorderSide.none,
                                      ),
                                      title: const Text('Produtos Solicitados'),
                                      collapsedBackgroundColor:
                                          Colors.orangeAccent,
                                      children: [
                                        for (var product in controller
                                                .currentOrder.value?.products ??
                                            [])
                                          ListTile(
                                            leading: Text(
                                              "R\$ ${product.productPrice!}",
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            title: Text(product.productName!),
                                            subtitle: Text(
                                              product.productDescription ??
                                                  'Sem Descrição',
                                            ),
                                            trailing: GestureDetector(
                                              onTap: () => controller
                                                  .removeProduct(product),
                                              child: const Icon(Icons.delete),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Verifica se está ocupada e a lista de produtos esta vazia
                                Visibility(
                                  visible:
                                      controller.currentOrder.value == null &&
                                          controller.productsMemory.isEmpty,
                                  replacement:
                                      controller.currentOrder.value?.products !=
                                                  null &&
                                              controller.currentOrder.value!
                                                  .products!.isEmpty &&
                                              controller.productsMemory.isEmpty
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  top: Get.height * 0.2),
                                              child: const Text(
                                                'Comanda tem pedido, contudo este pedido está sem produtos.',
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: Get.height * 0.2),
                                    child: Text(
                                      controller.bill.billBusy!
                                          ? 'Esta comanda está reservada, porém não há pedido registrado nela.'
                                          : 'Esta comanda está livre e não há pedido registrado nela.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),

                                // Lista de produtos não enviados à produção
                                Visibility(
                                  visible: controller.productsMemory.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ExpansionTile(
                                      shape: const RoundedRectangleBorder(
                                        side: BorderSide.none,
                                      ),
                                      initiallyExpanded: true,
                                      collapsedBackgroundColor:
                                          Colors.orangeAccent,
                                      title:
                                          const Text('Produtos Não Enviados'),
                                      children: [
                                        for (var productMemory
                                            in controller.productsMemory)
                                          ListTile(
                                            leading: Text(
                                              "R\$ ${productMemory.productPrice!}",
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            title: Text(
                                                productMemory.productName!),
                                            subtitle: Text(
                                              productMemory
                                                      .productDescription ??
                                                  'Sem Descrição',
                                            ),
                                            trailing: GestureDetector(
                                              onTap: () => controller
                                                  .removeProduct(productMemory),
                                              child: const Icon(Icons.delete),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //Botões e Precificação
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
                                padding: EdgeInsets.symmetric(
                                    vertical: Get.height * 0.01)),
                            OutlinedButton.icon(
                              onPressed: () => controller.choiceProduct(),
                              icon: const Icon(Icons.add_shopping_cart_sharp),
                              label: const Text('Adicionar Produtos'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => controller.sendProduction(),
                              icon: const Icon(Icons.dinner_dining),
                              label: const Text('Enviar/Atualizar Dados'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}


// Visibility(
                                //   visible: controller.currentOrder.value !=
                                //           null &&
                                //       controller.currentOrder.value?.products !=
                                //           null &&
                                //       controller.currentOrder.value!.products!
                                //           .isNotEmpty,
                                //   child: Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       ExpansionTile(
                                //         title:
                                //             const Text('Produtos Solicitados'),
                                //         collapsedBackgroundColor:
                                //             Colors.orangeAccent,
                                //         children: [
                                //           for (var product in controller
                                //                   .currentOrder
                                //                   .value
                                //                   ?.products ??
                                //               [])
                                //             ListTile(
                                //               leading: Text(
                                //                 "R\$ ${product.productPrice!}",
                                //                 style: const TextStyle(
                                //                     fontSize: 18),
                                //               ),
                                //               title: Text(
                                //                 product.productName!,
                                //               ),
                                //               subtitle: Text(
                                //                 product.productDescription ??
                                //                     'Sem Descrição',
                                //               ),
                                //               trailing: GestureDetector(
                                //                 onTap: () => controller
                                //                     .removeProduct(product),
                                //                 child: const Icon(Icons.delete),
                                //               ),
                                //             ),
                                //         ],
                                //       ),
                                //       Padding(
                                //         padding: EdgeInsets.symmetric(
                                //             vertical: Get.width * .05),
                                //       ),
                                //     ],
                                //   ),
                                // ),

                                // // Verifica se a comanda está ocupada e sem pedido.
                                // Visibility(
                                //   visible:
                                //       controller.currentOrder.value == null &&
                                //           controller.productsMemory.isEmpty,
                                //   replacement:
                                //       controller.currentOrder.value?.products !=
                                //                   null &&
                                //               controller.currentOrder.value!
                                //                   .products!.isEmpty &&
                                //               controller.productsMemory.isEmpty
                                //           ? Padding(
                                //               padding: EdgeInsets.only(
                                //                   top: Get.height * 0.1),
                                //               child: const Text(
                                //                   textAlign: TextAlign.center,
                                //                   'Comanda tem pedido, contudo este pedido está sem produtos.'),
                                //             )
                                //           : const SizedBox.shrink(),
                                //   child: Padding(
                                //     padding:
                                //         EdgeInsets.only(top: Get.height * 0.1),
                                //     child: Text(
                                //         textAlign: TextAlign.center,
                                //         controller.bill.billBusy!
                                //             ? 'Esta comanda está reservada, porém não há pedido registrado nela.'
                                //             : 'Esta comanda está livre e não há pedido registrado nela.'),
                                //   ),
                                // ),

                                // // 1) Lista de Produtos não enviados à produção
                                // // 2) Botão para remover produto
                                // Visibility(
                                //   visible: controller.productsMemory.isNotEmpty,
                                //   child: ExpansionTile(
                                //     initiallyExpanded: true,
                                //     collapsedBackgroundColor:
                                //         Colors.orangeAccent,
                                //     title: const Text('Produtos Não Enviados'),
                                //     children: [
                                //       for (var productMemory
                                //           in controller.productsMemory)
                                //         ListTile(
                                //           leading: Text(
                                //             "R\$ ${productMemory.productPrice!}",
                                //             style:
                                //                 const TextStyle(fontSize: 18),
                                //           ),
                                //           title: Text(
                                //             productMemory.productName!,
                                //           ),
                                //           subtitle: Text(
                                //             productMemory.productDescription ??
                                //                 'Sem Descrição',
                                //           ),
                                //           trailing: GestureDetector(
                                //             onTap: () => controller
                                //                 .removeProduct(productMemory),
                                //             child: const Icon(Icons.delete),
                                //           ),
                                //         ),
                                //     ],
                                //   ),
                                // ),