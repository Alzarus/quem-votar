import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:quem_votar/core/errors/exceptions.dart';
import 'package:quem_votar/core/network/dio_exception_mapper.dart';
import 'package:quem_votar/data/models/candidate_detail_dto.dart';
import 'package:quem_votar/data/models/candidate_list_envelope_dto.dart';
import 'package:quem_votar/data/models/cargos_envelope_dto.dart';
import 'package:quem_votar/data/models/election_dto.dart';

/// Contrato abstrato para a fonte remota de dados do Tribunal Superior Eleitoral.
abstract interface class TseRemoteDataSource {
  /// Consulta a relacao oficial de pleitos ordinarios registrados no TSE.
  Future<List<ElectionDto>> getOrdinarias();

  /// Consulta a relacao de cargos disputados em determinado pleito e UF/circunscricao.
  Future<CargosEnvelopeDto> getCargos({required int electionId, required String ufOrBr});

  /// Recupera a listagem sintetizada de candidatos concorrentes em um cargo especifico.
  Future<CandidateListEnvelopeDto> getCandidates({
    required int year,
    required String ufOrMun,
    required int electionId,
    required int roleCode,
  });

  /// Recupera a ficha cadastral detalhada e bens de um candidato individual.
  Future<CandidateDetailDto> getCandidateDetail({
    required int year,
    required String ufOrMun,
    required int electionId,
    required int candidateId,
  });
}

/// Implementacao concreta do datasource remoto do TSE consumindo via cliente Dio.
class TseRemoteDataSourceImpl implements TseRemoteDataSource {
  final Dio _dio;

  const TseRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<ElectionDto>> getOrdinarias() async {
    const context = 'TseRemoteDataSource.getOrdinarias';
    try {
      final response = await _dio.get<dynamic>('eleicao/ordinarias');
      final list = _decodeList(response.data, context);
      return list
          .whereType<Map<dynamic, dynamic>>()
          .map((item) => ElectionDto.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false);
    } on DioException catch (e) {
      throw DioExceptionMapper.map(error: e, operationalContext: context);
    } on TseException {
      rethrow;
    } catch (e) {
      throw TseServerException(
        statusCode: null,
        message: 'Erro inesperado na recuperacao de pleitos ordinarios: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<CargosEnvelopeDto> getCargos({required int electionId, required String ufOrBr}) async {
    final cleanUf = ufOrBr.trim().toUpperCase();
    final context = 'TseRemoteDataSource.getCargos(electionId: $electionId, uf: $cleanUf)';
    try {
      final path = 'eleicao/listar/municipios/$electionId/$cleanUf/cargos';
      final response = await _dio.get<dynamic>(path);
      final map = _decodeMap(response.data, context);
      return CargosEnvelopeDto.fromJson(map);
    } on DioException catch (e) {
      throw DioExceptionMapper.map(error: e, operationalContext: context);
    } on TseException {
      rethrow;
    } catch (e) {
      throw TseServerException(
        statusCode: null,
        message: 'Erro inesperado na recuperacao de cargos da unidade: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<CandidateListEnvelopeDto> getCandidates({
    required int year,
    required String ufOrMun,
    required int electionId,
    required int roleCode,
  }) async {
    final cleanUfOrMun = ufOrMun.trim().toUpperCase();
    final context =
        'TseRemoteDataSource.getCandidates(ano: $year, uf: $cleanUfOrMun, '
        'eleicao: $electionId, cargo: $roleCode)';
    try {
      final path = 'candidatura/listar/$year/$cleanUfOrMun/$electionId/$roleCode/candidatos';
      final response = await _dio.get<dynamic>(path);
      final map = _decodeMap(response.data, context);
      return CandidateListEnvelopeDto.fromJson(map);
    } on DioException catch (e) {
      throw DioExceptionMapper.map(error: e, operationalContext: context);
    } on TseException {
      rethrow;
    } catch (e) {
      throw TseServerException(
        statusCode: null,
        message: 'Erro inesperado na listagem oficial de candidaturas: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<CandidateDetailDto> getCandidateDetail({
    required int year,
    required String ufOrMun,
    required int electionId,
    required int candidateId,
  }) async {
    final cleanUfOrMun = ufOrMun.trim().toUpperCase();
    final context =
        'TseRemoteDataSource.getCandidateDetail(ano: $year, uf: $cleanUfOrMun, '
        'eleicao: $electionId, candidato: $candidateId)';
    try {
      final path = 'candidatura/buscar/$year/$cleanUfOrMun/$electionId/candidato/$candidateId';
      final response = await _dio.get<dynamic>(path);
      final map = _decodeMap(response.data, context);
      return CandidateDetailDto.fromJson(map);
    } on DioException catch (e) {
      throw DioExceptionMapper.map(error: e, operationalContext: context);
    } on TseException {
      rethrow;
    } catch (e) {
      throw TseServerException(
        statusCode: null,
        message: 'Erro inesperado na recuperacao da ficha detalhada do candidato: $e',
        operationalContext: context,
      );
    }
  }

  Map<String, dynamic> _decodeMap(dynamic data, String context) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map<dynamic, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    if (data is String) {
      return _parseStringAsMap(data, context);
    }
    throw TseDataParseException(
      receivedValue: data?.runtimeType.toString() ?? 'null',
      expectedFormat: 'Map<String, dynamic> ou JSON Object',
      operationalContext: context,
    );
  }

  Map<String, dynamic> _parseStringAsMap(String rawJson, String context) {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map<dynamic, dynamic>) return Map<String, dynamic>.from(decoded);
    } catch (_) {
      // Excecao tratada e convertida abaixo
    }
    throw TseDataParseException(
      receivedValue: rawJson.length > 80 ? '${rawJson.substring(0, 80)}...' : rawJson,
      expectedFormat: 'JSON Map String',
      operationalContext: context,
    );
  }

  List<dynamic> _decodeList(dynamic data, String context) {
    if (data is List<dynamic>) {
      return data;
    }
    if (data is String) {
      return _parseStringAsList(data, context);
    }
    throw TseDataParseException(
      receivedValue: data?.runtimeType.toString() ?? 'null',
      expectedFormat: 'List<dynamic> ou JSON Array',
      operationalContext: context,
    );
  }

  List<dynamic> _parseStringAsList(String rawJson, String context) {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is List<dynamic>) return decoded;
    } catch (_) {
      // Excecao tratada e convertida abaixo
    }
    throw TseDataParseException(
      receivedValue: rawJson.length > 80 ? '${rawJson.substring(0, 80)}...' : rawJson,
      expectedFormat: 'JSON List String',
      operationalContext: context,
    );
  }
}
