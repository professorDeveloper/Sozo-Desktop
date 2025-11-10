import 'package:flutter/cupertino.dart';
import '';
import '../../../core/network/network_response.dart';
abstract class DetailRepository {
  Future<NetworkResponse> getAnimeByID(int id);
  Future<NetworkResponse> getCharacterById(int id);



}
