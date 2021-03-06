// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_declarations, prefer_const_constructors

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/provider/cart_provider.dart';

class PaymentConfirmPage extends StatelessWidget {
  final String pilihan;

  PaymentConfirmPage({required this.pilihan, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.white;
    CartProvider _order = Provider.of<CartProvider>(context, listen: false);
    var _orderData = _order.orders;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,

          title: Text(
            'Pembayaran',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          //icon tombol back
          leading: Container(
            margin:
                const EdgeInsets.only(left: 7, top: 4, right: 10, bottom: 10),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 11,
                  offset: const Offset(6, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Center(
                child: IconButton(
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: backgroundColor,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                pilihan,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'UG Foodcourt',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '089761272',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Jumlah : ${NumberFormat.currency(
                  locale: 'id',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(_order.sum)}',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: (() {}),
                child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: Text(
                    'Upload bukti bayar disini',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                height: 50,
                minWidth: 300,
                onPressed: () {
                  //TODO: implementasi fungsi tombol akan diubah menjadi fungsi mengirim data ke backend jika sudah ada
                  for (var orders in _orderData) {
                    print('orderid: ' + orders.orderid);
                    print('userid: ' + orders.userid.toString());
                    print('restoid: ' + orders.restaurantid.toString());
                    print('productid: ' + orders.productid.toString());
                    print('desc: ' + orders.desc.toString());
                    print('total: ' + orders.total.toString());
                    print('metode: ' + orders.metode);
                    print('buktibayar: img');
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                child: const Text(
                  'KONFIRMASI',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                color: Colors.deepOrange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
