import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:messaging_core/core/services/network/exception.dart';

class HttpHelper {
  Future<dynamic> httpDownload(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    // CancelToken? cancelToken,
    Function(int count, int total)? onReceiveProgress,
  }) async {
    try {
      return _responseData(await Dio().download(
        path,
        savePath,
        queryParameters: queryParameters,
        // cancelToken: cancelToken,
        deleteOnError: true,
        options: Options(
          receiveTimeout: const Duration(seconds: 600),
        ),
        onReceiveProgress: onReceiveProgress,
      ));
    } on DioException catch (e) {
      return _responseData(e.response, error: e);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> _responseData(Response? response,
      {DioException? error}) async {
    if (response == null) {
      if (error == null) {
        throw NotHandleException(
          "",
          'This Status Code Not Handled',
        );
      }
      if (error.type == DioExceptionType.cancel) {
        throw CancelRequestException(
          "",
          'The request has been cancelled',
        );
      }
      throw NotHandleException(
        "",
        'This Status Code Not Handled',
      );
    }
    // response.statusCode = HttpStatus.forbidden;

    try {
      switch (response.statusCode) {
        // 200
        case HttpStatus.ok:
          return response;
        // 201
        case HttpStatus.created:
          return response;
        // 204
        case HttpStatus.noContent:
          break;
        // 400
        case HttpStatus.badRequest:
          throw BadRequestException(
            response.requestOptions.path,
            jsonDecode(jsonEncode(response.data)),
            response.data['message'],
          );
        // 401
        case HttpStatus.unauthorized:
          throw UnauthorisedException(
            response.requestOptions.path,
            response.data['message'] ?? 'authorization_forbidden',
          );
        // 403
        case HttpStatus.forbidden:
          throw ForbiddenException(
            response.requestOptions.path,
            response.data['message'] ?? 'forbidden_exception',
          );
        // 404
        case HttpStatus.notFound:
          throw NotFoundException(
            response.requestOptions.path,
            response.data['message'] ?? 'This Uri Not Founded',
          );
        // 409
        case HttpStatus.conflict:
          throw NotFoundException(
            response.requestOptions.path,
            response.data['message'] ?? 'Conflict Exception',
          );
        //
        case HttpStatus.unprocessableEntity:
          throw BadRequestException(
            response.requestOptions.path,
            jsonDecode(jsonEncode(response.data)),
            response.data['message'],
          );
        // 429
        case HttpStatus.tooManyRequests:
          throw TooManyRequestException(
            response.requestOptions.path,
            'Too Many Request',
          );
        // 500
        case HttpStatus.internalServerError:
          throw ServerException(
            response.requestOptions.path,
            'server_exception',
          );
        // Others
        default:
          throw NotHandleException(
            response.requestOptions.path,
            'This Status Code Not Handled',
          );
      }
    } on JsonUnsupportedObjectError {
      throw ServerException(
        response!.requestOptions.path,
        'Server Unsupported Json Object',
      );
    } on FormatException {
      throw ServerException(
        response!.requestOptions.path,
        'Server Unsupported Json Format',
      );
    }
  }
}
