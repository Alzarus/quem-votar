// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ElectionsTableTable extends ElectionsTable
    with TableInfo<$ElectionsTableTable, ElectionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ElectionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anoMeta = const VerificationMeta('ano');
  @override
  late final GeneratedColumn<int> ano = GeneratedColumn<int>(
    'ano',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta('descricao');
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abrangenciaMeta = const VerificationMeta('abrangencia');
  @override
  late final GeneratedColumn<String> abrangencia = GeneratedColumn<String>(
    'abrangencia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turnoMeta = const VerificationMeta('turno');
  @override
  late final GeneratedColumn<int> turno = GeneratedColumn<int>(
    'turno',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataEleicaoMeta = const VerificationMeta('dataEleicao');
  @override
  late final GeneratedColumn<String> dataEleicao = GeneratedColumn<String>(
    'data_eleicao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _situacaoMeta = const VerificationMeta('situacao');
  @override
  late final GeneratedColumn<String> situacao = GeneratedColumn<String>(
    'situacao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ano,
    nome,
    descricao,
    tipo,
    abrangencia,
    turno,
    dataEleicao,
    situacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'elections';
  @override
  VerificationContext validateIntegrity(
    Insertable<ElectionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ano')) {
      context.handle(_anoMeta, ano.isAcceptableOrUnknown(data['ano']!, _anoMeta));
    } else if (isInserting) {
      context.missing(_anoMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(_nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(_tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('abrangencia')) {
      context.handle(
        _abrangenciaMeta,
        abrangencia.isAcceptableOrUnknown(data['abrangencia']!, _abrangenciaMeta),
      );
    } else if (isInserting) {
      context.missing(_abrangenciaMeta);
    }
    if (data.containsKey('turno')) {
      context.handle(_turnoMeta, turno.isAcceptableOrUnknown(data['turno']!, _turnoMeta));
    } else if (isInserting) {
      context.missing(_turnoMeta);
    }
    if (data.containsKey('data_eleicao')) {
      context.handle(
        _dataEleicaoMeta,
        dataEleicao.isAcceptableOrUnknown(data['data_eleicao']!, _dataEleicaoMeta),
      );
    } else if (isInserting) {
      context.missing(_dataEleicaoMeta);
    }
    if (data.containsKey('situacao')) {
      context.handle(
        _situacaoMeta,
        situacao.isAcceptableOrUnknown(data['situacao']!, _situacaoMeta),
      );
    } else if (isInserting) {
      context.missing(_situacaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ElectionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ElectionData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ano: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}ano'])!,
      nome: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      tipo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      abrangencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abrangencia'],
      )!,
      turno: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}turno'])!,
      dataEleicao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_eleicao'],
      )!,
      situacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}situacao'],
      )!,
    );
  }

  @override
  $ElectionsTableTable createAlias(String alias) {
    return $ElectionsTableTable(attachedDatabase, alias);
  }
}

class ElectionData extends DataClass implements Insertable<ElectionData> {
  /// Identificador unico do pleito no sistema DivulgaCandContas do TSE.
  final int id;

  /// Ano eleitoral de realizacao do pleito (ex: 2026).
  final int ano;

  /// Nome oficial da eleicao (ex: 'Eleicao Geral Federal 2026').
  final String nome;

  /// Descricao detalhada divulgada pelo TSE.
  final String descricao;

  /// Classificacao do pleito: 'Ordinaria' ou 'Suplementar'.
  final String tipo;

  /// Abrangencia territorial: 'F' (Federal), 'E' (Estadual) ou 'M' (Municipal).
  final String abrangencia;

  /// Turno de votacao (1 ou 2).
  final int turno;

  /// Data oficial da votacao no formato dd/MM/yyyy.
  final String dataEleicao;

  /// Situacao do pleito registrada na Justica Eleitoral.
  final String situacao;
  const ElectionData({
    required this.id,
    required this.ano,
    required this.nome,
    required this.descricao,
    required this.tipo,
    required this.abrangencia,
    required this.turno,
    required this.dataEleicao,
    required this.situacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ano'] = Variable<int>(ano);
    map['nome'] = Variable<String>(nome);
    map['descricao'] = Variable<String>(descricao);
    map['tipo'] = Variable<String>(tipo);
    map['abrangencia'] = Variable<String>(abrangencia);
    map['turno'] = Variable<int>(turno);
    map['data_eleicao'] = Variable<String>(dataEleicao);
    map['situacao'] = Variable<String>(situacao);
    return map;
  }

  ElectionsTableCompanion toCompanion(bool nullToAbsent) {
    return ElectionsTableCompanion(
      id: Value(id),
      ano: Value(ano),
      nome: Value(nome),
      descricao: Value(descricao),
      tipo: Value(tipo),
      abrangencia: Value(abrangencia),
      turno: Value(turno),
      dataEleicao: Value(dataEleicao),
      situacao: Value(situacao),
    );
  }

  factory ElectionData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ElectionData(
      id: serializer.fromJson<int>(json['id']),
      ano: serializer.fromJson<int>(json['ano']),
      nome: serializer.fromJson<String>(json['nome']),
      descricao: serializer.fromJson<String>(json['descricao']),
      tipo: serializer.fromJson<String>(json['tipo']),
      abrangencia: serializer.fromJson<String>(json['abrangencia']),
      turno: serializer.fromJson<int>(json['turno']),
      dataEleicao: serializer.fromJson<String>(json['dataEleicao']),
      situacao: serializer.fromJson<String>(json['situacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ano': serializer.toJson<int>(ano),
      'nome': serializer.toJson<String>(nome),
      'descricao': serializer.toJson<String>(descricao),
      'tipo': serializer.toJson<String>(tipo),
      'abrangencia': serializer.toJson<String>(abrangencia),
      'turno': serializer.toJson<int>(turno),
      'dataEleicao': serializer.toJson<String>(dataEleicao),
      'situacao': serializer.toJson<String>(situacao),
    };
  }

  ElectionData copyWith({
    int? id,
    int? ano,
    String? nome,
    String? descricao,
    String? tipo,
    String? abrangencia,
    int? turno,
    String? dataEleicao,
    String? situacao,
  }) => ElectionData(
    id: id ?? this.id,
    ano: ano ?? this.ano,
    nome: nome ?? this.nome,
    descricao: descricao ?? this.descricao,
    tipo: tipo ?? this.tipo,
    abrangencia: abrangencia ?? this.abrangencia,
    turno: turno ?? this.turno,
    dataEleicao: dataEleicao ?? this.dataEleicao,
    situacao: situacao ?? this.situacao,
  );
  ElectionData copyWithCompanion(ElectionsTableCompanion data) {
    return ElectionData(
      id: data.id.present ? data.id.value : this.id,
      ano: data.ano.present ? data.ano.value : this.ano,
      nome: data.nome.present ? data.nome.value : this.nome,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      abrangencia: data.abrangencia.present ? data.abrangencia.value : this.abrangencia,
      turno: data.turno.present ? data.turno.value : this.turno,
      dataEleicao: data.dataEleicao.present ? data.dataEleicao.value : this.dataEleicao,
      situacao: data.situacao.present ? data.situacao.value : this.situacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ElectionData(')
          ..write('id: $id, ')
          ..write('ano: $ano, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('tipo: $tipo, ')
          ..write('abrangencia: $abrangencia, ')
          ..write('turno: $turno, ')
          ..write('dataEleicao: $dataEleicao, ')
          ..write('situacao: $situacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ano, nome, descricao, tipo, abrangencia, turno, dataEleicao, situacao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ElectionData &&
          other.id == this.id &&
          other.ano == this.ano &&
          other.nome == this.nome &&
          other.descricao == this.descricao &&
          other.tipo == this.tipo &&
          other.abrangencia == this.abrangencia &&
          other.turno == this.turno &&
          other.dataEleicao == this.dataEleicao &&
          other.situacao == this.situacao);
}

class ElectionsTableCompanion extends UpdateCompanion<ElectionData> {
  final Value<int> id;
  final Value<int> ano;
  final Value<String> nome;
  final Value<String> descricao;
  final Value<String> tipo;
  final Value<String> abrangencia;
  final Value<int> turno;
  final Value<String> dataEleicao;
  final Value<String> situacao;
  const ElectionsTableCompanion({
    this.id = const Value.absent(),
    this.ano = const Value.absent(),
    this.nome = const Value.absent(),
    this.descricao = const Value.absent(),
    this.tipo = const Value.absent(),
    this.abrangencia = const Value.absent(),
    this.turno = const Value.absent(),
    this.dataEleicao = const Value.absent(),
    this.situacao = const Value.absent(),
  });
  ElectionsTableCompanion.insert({
    this.id = const Value.absent(),
    required int ano,
    required String nome,
    required String descricao,
    required String tipo,
    required String abrangencia,
    required int turno,
    required String dataEleicao,
    required String situacao,
  }) : ano = Value(ano),
       nome = Value(nome),
       descricao = Value(descricao),
       tipo = Value(tipo),
       abrangencia = Value(abrangencia),
       turno = Value(turno),
       dataEleicao = Value(dataEleicao),
       situacao = Value(situacao);
  static Insertable<ElectionData> custom({
    Expression<int>? id,
    Expression<int>? ano,
    Expression<String>? nome,
    Expression<String>? descricao,
    Expression<String>? tipo,
    Expression<String>? abrangencia,
    Expression<int>? turno,
    Expression<String>? dataEleicao,
    Expression<String>? situacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ano != null) 'ano': ano,
      if (nome != null) 'nome': nome,
      if (descricao != null) 'descricao': descricao,
      if (tipo != null) 'tipo': tipo,
      if (abrangencia != null) 'abrangencia': abrangencia,
      if (turno != null) 'turno': turno,
      if (dataEleicao != null) 'data_eleicao': dataEleicao,
      if (situacao != null) 'situacao': situacao,
    });
  }

  ElectionsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? ano,
    Value<String>? nome,
    Value<String>? descricao,
    Value<String>? tipo,
    Value<String>? abrangencia,
    Value<int>? turno,
    Value<String>? dataEleicao,
    Value<String>? situacao,
  }) {
    return ElectionsTableCompanion(
      id: id ?? this.id,
      ano: ano ?? this.ano,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      tipo: tipo ?? this.tipo,
      abrangencia: abrangencia ?? this.abrangencia,
      turno: turno ?? this.turno,
      dataEleicao: dataEleicao ?? this.dataEleicao,
      situacao: situacao ?? this.situacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ano.present) {
      map['ano'] = Variable<int>(ano.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (abrangencia.present) {
      map['abrangencia'] = Variable<String>(abrangencia.value);
    }
    if (turno.present) {
      map['turno'] = Variable<int>(turno.value);
    }
    if (dataEleicao.present) {
      map['data_eleicao'] = Variable<String>(dataEleicao.value);
    }
    if (situacao.present) {
      map['situacao'] = Variable<String>(situacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ElectionsTableCompanion(')
          ..write('id: $id, ')
          ..write('ano: $ano, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('tipo: $tipo, ')
          ..write('abrangencia: $abrangencia, ')
          ..write('turno: $turno, ')
          ..write('dataEleicao: $dataEleicao, ')
          ..write('situacao: $situacao')
          ..write(')'))
        .toString();
  }
}

class $ElectionsCargosTableTable extends ElectionsCargosTable
    with TableInfo<$ElectionsCargosTableTable, ElectionCargoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ElectionsCargosTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _electionIdMeta = const VerificationMeta('electionId');
  @override
  late final GeneratedColumn<int> electionId = GeneratedColumn<int>(
    'election_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES elections (id)'),
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta('stateCode');
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cargoCodeMeta = const VerificationMeta('cargoCode');
  @override
  late final GeneratedColumn<int> cargoCode = GeneratedColumn<int>(
    'cargo_code',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cargoSiglaMeta = const VerificationMeta('cargoSigla');
  @override
  late final GeneratedColumn<String> cargoSigla = GeneratedColumn<String>(
    'cargo_sigla',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cargoNomeMeta = const VerificationMeta('cargoNome');
  @override
  late final GeneratedColumn<String> cargoNome = GeneratedColumn<String>(
    'cargo_nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titularMeta = const VerificationMeta('titular');
  @override
  late final GeneratedColumn<bool> titular = GeneratedColumn<bool>(
    'titular',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("titular" IN (0, 1))'),
  );
  static const VerificationMeta _contagemMeta = const VerificationMeta('contagem');
  @override
  late final GeneratedColumn<int> contagem = GeneratedColumn<int>(
    'contagem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    electionId,
    stateCode,
    cargoCode,
    cargoSigla,
    cargoNome,
    titular,
    contagem,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'elections_cargos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ElectionCargoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('election_id')) {
      context.handle(
        _electionIdMeta,
        electionId.isAcceptableOrUnknown(data['election_id']!, _electionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_electionIdMeta);
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_stateCodeMeta);
    }
    if (data.containsKey('cargo_code')) {
      context.handle(
        _cargoCodeMeta,
        cargoCode.isAcceptableOrUnknown(data['cargo_code']!, _cargoCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_cargoCodeMeta);
    }
    if (data.containsKey('cargo_sigla')) {
      context.handle(
        _cargoSiglaMeta,
        cargoSigla.isAcceptableOrUnknown(data['cargo_sigla']!, _cargoSiglaMeta),
      );
    } else if (isInserting) {
      context.missing(_cargoSiglaMeta);
    }
    if (data.containsKey('cargo_nome')) {
      context.handle(
        _cargoNomeMeta,
        cargoNome.isAcceptableOrUnknown(data['cargo_nome']!, _cargoNomeMeta),
      );
    } else if (isInserting) {
      context.missing(_cargoNomeMeta);
    }
    if (data.containsKey('titular')) {
      context.handle(_titularMeta, titular.isAcceptableOrUnknown(data['titular']!, _titularMeta));
    } else if (isInserting) {
      context.missing(_titularMeta);
    }
    if (data.containsKey('contagem')) {
      context.handle(
        _contagemMeta,
        contagem.isAcceptableOrUnknown(data['contagem']!, _contagemMeta),
      );
    } else if (isInserting) {
      context.missing(_contagemMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ElectionCargoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ElectionCargoData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      electionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}election_id'],
      )!,
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      )!,
      cargoCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cargo_code'],
      )!,
      cargoSigla: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cargo_sigla'],
      )!,
      cargoNome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cargo_nome'],
      )!,
      titular: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}titular'],
      )!,
      contagem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contagem'],
      )!,
    );
  }

  @override
  $ElectionsCargosTableTable createAlias(String alias) {
    return $ElectionsCargosTableTable(attachedDatabase, alias);
  }
}

class ElectionCargoData extends DataClass implements Insertable<ElectionCargoData> {
  /// Identificador sintetico local autoincrementavel.
  final int id;

  /// Chave estrangeira vinculando o cargo ao pleito oficial.
  final int electionId;

  /// Sigla da Unidade Federativa ('SP', 'BA', etc.) ou 'BR' para cargos federais.
  final String stateCode;

  /// Codigo oficial do cargo no TSE (1 a 13).
  final int cargoCode;

  /// Sigla padronizada do cargo (ex: 'P', 'VP', 'GE', 'S').
  final String cargoSigla;

  /// Denominacao completa do cargo.
  final String cargoNome;

  /// Indicador booleano de cargo titular (verdadeiro para titular, falso para vice/suplente).
  final bool titular;

  /// Quantidade total de candidaturas registradas para este cargo e jurisdicao.
  final int contagem;
  const ElectionCargoData({
    required this.id,
    required this.electionId,
    required this.stateCode,
    required this.cargoCode,
    required this.cargoSigla,
    required this.cargoNome,
    required this.titular,
    required this.contagem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['election_id'] = Variable<int>(electionId);
    map['state_code'] = Variable<String>(stateCode);
    map['cargo_code'] = Variable<int>(cargoCode);
    map['cargo_sigla'] = Variable<String>(cargoSigla);
    map['cargo_nome'] = Variable<String>(cargoNome);
    map['titular'] = Variable<bool>(titular);
    map['contagem'] = Variable<int>(contagem);
    return map;
  }

  ElectionsCargosTableCompanion toCompanion(bool nullToAbsent) {
    return ElectionsCargosTableCompanion(
      id: Value(id),
      electionId: Value(electionId),
      stateCode: Value(stateCode),
      cargoCode: Value(cargoCode),
      cargoSigla: Value(cargoSigla),
      cargoNome: Value(cargoNome),
      titular: Value(titular),
      contagem: Value(contagem),
    );
  }

  factory ElectionCargoData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ElectionCargoData(
      id: serializer.fromJson<int>(json['id']),
      electionId: serializer.fromJson<int>(json['electionId']),
      stateCode: serializer.fromJson<String>(json['stateCode']),
      cargoCode: serializer.fromJson<int>(json['cargoCode']),
      cargoSigla: serializer.fromJson<String>(json['cargoSigla']),
      cargoNome: serializer.fromJson<String>(json['cargoNome']),
      titular: serializer.fromJson<bool>(json['titular']),
      contagem: serializer.fromJson<int>(json['contagem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'electionId': serializer.toJson<int>(electionId),
      'stateCode': serializer.toJson<String>(stateCode),
      'cargoCode': serializer.toJson<int>(cargoCode),
      'cargoSigla': serializer.toJson<String>(cargoSigla),
      'cargoNome': serializer.toJson<String>(cargoNome),
      'titular': serializer.toJson<bool>(titular),
      'contagem': serializer.toJson<int>(contagem),
    };
  }

  ElectionCargoData copyWith({
    int? id,
    int? electionId,
    String? stateCode,
    int? cargoCode,
    String? cargoSigla,
    String? cargoNome,
    bool? titular,
    int? contagem,
  }) => ElectionCargoData(
    id: id ?? this.id,
    electionId: electionId ?? this.electionId,
    stateCode: stateCode ?? this.stateCode,
    cargoCode: cargoCode ?? this.cargoCode,
    cargoSigla: cargoSigla ?? this.cargoSigla,
    cargoNome: cargoNome ?? this.cargoNome,
    titular: titular ?? this.titular,
    contagem: contagem ?? this.contagem,
  );
  ElectionCargoData copyWithCompanion(ElectionsCargosTableCompanion data) {
    return ElectionCargoData(
      id: data.id.present ? data.id.value : this.id,
      electionId: data.electionId.present ? data.electionId.value : this.electionId,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      cargoCode: data.cargoCode.present ? data.cargoCode.value : this.cargoCode,
      cargoSigla: data.cargoSigla.present ? data.cargoSigla.value : this.cargoSigla,
      cargoNome: data.cargoNome.present ? data.cargoNome.value : this.cargoNome,
      titular: data.titular.present ? data.titular.value : this.titular,
      contagem: data.contagem.present ? data.contagem.value : this.contagem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ElectionCargoData(')
          ..write('id: $id, ')
          ..write('electionId: $electionId, ')
          ..write('stateCode: $stateCode, ')
          ..write('cargoCode: $cargoCode, ')
          ..write('cargoSigla: $cargoSigla, ')
          ..write('cargoNome: $cargoNome, ')
          ..write('titular: $titular, ')
          ..write('contagem: $contagem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, electionId, stateCode, cargoCode, cargoSigla, cargoNome, titular, contagem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ElectionCargoData &&
          other.id == this.id &&
          other.electionId == this.electionId &&
          other.stateCode == this.stateCode &&
          other.cargoCode == this.cargoCode &&
          other.cargoSigla == this.cargoSigla &&
          other.cargoNome == this.cargoNome &&
          other.titular == this.titular &&
          other.contagem == this.contagem);
}

class ElectionsCargosTableCompanion extends UpdateCompanion<ElectionCargoData> {
  final Value<int> id;
  final Value<int> electionId;
  final Value<String> stateCode;
  final Value<int> cargoCode;
  final Value<String> cargoSigla;
  final Value<String> cargoNome;
  final Value<bool> titular;
  final Value<int> contagem;
  const ElectionsCargosTableCompanion({
    this.id = const Value.absent(),
    this.electionId = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.cargoCode = const Value.absent(),
    this.cargoSigla = const Value.absent(),
    this.cargoNome = const Value.absent(),
    this.titular = const Value.absent(),
    this.contagem = const Value.absent(),
  });
  ElectionsCargosTableCompanion.insert({
    this.id = const Value.absent(),
    required int electionId,
    required String stateCode,
    required int cargoCode,
    required String cargoSigla,
    required String cargoNome,
    required bool titular,
    required int contagem,
  }) : electionId = Value(electionId),
       stateCode = Value(stateCode),
       cargoCode = Value(cargoCode),
       cargoSigla = Value(cargoSigla),
       cargoNome = Value(cargoNome),
       titular = Value(titular),
       contagem = Value(contagem);
  static Insertable<ElectionCargoData> custom({
    Expression<int>? id,
    Expression<int>? electionId,
    Expression<String>? stateCode,
    Expression<int>? cargoCode,
    Expression<String>? cargoSigla,
    Expression<String>? cargoNome,
    Expression<bool>? titular,
    Expression<int>? contagem,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (electionId != null) 'election_id': electionId,
      if (stateCode != null) 'state_code': stateCode,
      if (cargoCode != null) 'cargo_code': cargoCode,
      if (cargoSigla != null) 'cargo_sigla': cargoSigla,
      if (cargoNome != null) 'cargo_nome': cargoNome,
      if (titular != null) 'titular': titular,
      if (contagem != null) 'contagem': contagem,
    });
  }

  ElectionsCargosTableCompanion copyWith({
    Value<int>? id,
    Value<int>? electionId,
    Value<String>? stateCode,
    Value<int>? cargoCode,
    Value<String>? cargoSigla,
    Value<String>? cargoNome,
    Value<bool>? titular,
    Value<int>? contagem,
  }) {
    return ElectionsCargosTableCompanion(
      id: id ?? this.id,
      electionId: electionId ?? this.electionId,
      stateCode: stateCode ?? this.stateCode,
      cargoCode: cargoCode ?? this.cargoCode,
      cargoSigla: cargoSigla ?? this.cargoSigla,
      cargoNome: cargoNome ?? this.cargoNome,
      titular: titular ?? this.titular,
      contagem: contagem ?? this.contagem,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (electionId.present) {
      map['election_id'] = Variable<int>(electionId.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (cargoCode.present) {
      map['cargo_code'] = Variable<int>(cargoCode.value);
    }
    if (cargoSigla.present) {
      map['cargo_sigla'] = Variable<String>(cargoSigla.value);
    }
    if (cargoNome.present) {
      map['cargo_nome'] = Variable<String>(cargoNome.value);
    }
    if (titular.present) {
      map['titular'] = Variable<bool>(titular.value);
    }
    if (contagem.present) {
      map['contagem'] = Variable<int>(contagem.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ElectionsCargosTableCompanion(')
          ..write('id: $id, ')
          ..write('electionId: $electionId, ')
          ..write('stateCode: $stateCode, ')
          ..write('cargoCode: $cargoCode, ')
          ..write('cargoSigla: $cargoSigla, ')
          ..write('cargoNome: $cargoNome, ')
          ..write('titular: $titular, ')
          ..write('contagem: $contagem')
          ..write(')'))
        .toString();
  }
}

class $CandidatesTableTable extends CandidatesTable
    with TableInfo<$CandidatesTableTable, CandidateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CandidatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _electionIdMeta = const VerificationMeta('electionId');
  @override
  late final GeneratedColumn<int> electionId = GeneratedColumn<int>(
    'election_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES elections (id)'),
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta('stateCode');
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityCodeMeta = const VerificationMeta('cityCode');
  @override
  late final GeneratedColumn<int> cityCode = GeneratedColumn<int>(
    'city_code',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleCodeMeta = const VerificationMeta('roleCode');
  @override
  late final GeneratedColumn<int> roleCode = GeneratedColumn<int>(
    'role_code',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleDescriptionMeta = const VerificationMeta('roleDescription');
  @override
  late final GeneratedColumn<String> roleDescription = GeneratedColumn<String>(
    'role_description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ballotNumberMeta = const VerificationMeta('ballotNumber');
  @override
  late final GeneratedColumn<int> ballotNumber = GeneratedColumn<int>(
    'ballot_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ballotNameMeta = const VerificationMeta('ballotName');
  @override
  late final GeneratedColumn<String> ballotName = GeneratedColumn<String>(
    'ballot_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyNumberMeta = const VerificationMeta('partyNumber');
  @override
  late final GeneratedColumn<int> partyNumber = GeneratedColumn<int>(
    'party_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyAcronymMeta = const VerificationMeta('partyAcronym');
  @override
  late final GeneratedColumn<String> partyAcronym = GeneratedColumn<String>(
    'party_acronym',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyNameMeta = const VerificationMeta('partyName');
  @override
  late final GeneratedColumn<String> partyName = GeneratedColumn<String>(
    'party_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coalitionNameMeta = const VerificationMeta('coalitionName');
  @override
  late final GeneratedColumn<String> coalitionName = GeneratedColumn<String>(
    'coalition_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coalitionCompMeta = const VerificationMeta('coalitionComp');
  @override
  late final GeneratedColumn<String> coalitionComp = GeneratedColumn<String>(
    'coalition_comp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawStatusMeta = const VerificationMeta('rawStatus');
  @override
  late final GeneratedColumn<String> rawStatus = GeneratedColumn<String>(
    'raw_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAssetsMeta = const VerificationMeta('totalAssets');
  @override
  late final GeneratedColumn<double> totalAssets = GeneratedColumn<double>(
    'total_assets',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta('photoUrl');
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPhotoPathMeta = const VerificationMeta('localPhotoPath');
  @override
  late final GeneratedColumn<String> localPhotoPath = GeneratedColumn<String>(
    'local_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentCandidateIdMeta = const VerificationMeta(
    'parentCandidateId',
  );
  @override
  late final GeneratedColumn<int> parentCandidateId = GeneratedColumn<int>(
    'parent_candidate_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES candidates (id)'),
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta('birthDate');
  @override
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorRaceMeta = const VerificationMeta('colorRace');
  @override
  late final GeneratedColumn<String> colorRace = GeneratedColumn<String>(
    'color_race',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maritalStatusMeta = const VerificationMeta('maritalStatus');
  @override
  late final GeneratedColumn<String> maritalStatus = GeneratedColumn<String>(
    'marital_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _educationLevelMeta = const VerificationMeta('educationLevel');
  @override
  late final GeneratedColumn<String> educationLevel = GeneratedColumn<String>(
    'education_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta('occupation');
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nationalityMeta = const VerificationMeta('nationality');
  @override
  late final GeneratedColumn<String> nationality = GeneratedColumn<String>(
    'nationality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthCityMeta = const VerificationMeta('birthCity');
  @override
  late final GeneratedColumn<String> birthCity = GeneratedColumn<String>(
    'birth_city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthStateMeta = const VerificationMeta('birthState');
  @override
  late final GeneratedColumn<String> birthState = GeneratedColumn<String>(
    'birth_state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxExpense1tMeta = const VerificationMeta('maxExpense1t');
  @override
  late final GeneratedColumn<double> maxExpense1t = GeneratedColumn<double>(
    'max_expense_1t',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxExpense2tMeta = const VerificationMeta('maxExpense2t');
  @override
  late final GeneratedColumn<double> maxExpense2t = GeneratedColumn<double>(
    'max_expense_2t',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proposalDocUrlMeta = const VerificationMeta('proposalDocUrl');
  @override
  late final GeneratedColumn<String> proposalDocUrl = GeneratedColumn<String>(
    'proposal_doc_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _campaignCnpjMeta = const VerificationMeta('campaignCnpj');
  @override
  late final GeneratedColumn<String> campaignCnpj = GeneratedColumn<String>(
    'campaign_cnpj',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailFetchedMeta = const VerificationMeta('detailFetched');
  @override
  late final GeneratedColumn<bool> detailFetched = GeneratedColumn<bool>(
    'detail_fetched',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("detail_fetched" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    electionId,
    stateCode,
    cityCode,
    roleCode,
    roleDescription,
    ballotNumber,
    ballotName,
    fullName,
    partyNumber,
    partyAcronym,
    partyName,
    coalitionName,
    coalitionComp,
    status,
    rawStatus,
    totalAssets,
    photoUrl,
    localPhotoPath,
    parentCandidateId,
    birthDate,
    gender,
    colorRace,
    maritalStatus,
    educationLevel,
    occupation,
    nationality,
    birthCity,
    birthState,
    maxExpense1t,
    maxExpense2t,
    proposalDocUrl,
    campaignCnpj,
    detailFetched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'candidates';
  @override
  VerificationContext validateIntegrity(
    Insertable<CandidateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('election_id')) {
      context.handle(
        _electionIdMeta,
        electionId.isAcceptableOrUnknown(data['election_id']!, _electionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_electionIdMeta);
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_stateCodeMeta);
    }
    if (data.containsKey('city_code')) {
      context.handle(
        _cityCodeMeta,
        cityCode.isAcceptableOrUnknown(data['city_code']!, _cityCodeMeta),
      );
    }
    if (data.containsKey('role_code')) {
      context.handle(
        _roleCodeMeta,
        roleCode.isAcceptableOrUnknown(data['role_code']!, _roleCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_roleCodeMeta);
    }
    if (data.containsKey('role_description')) {
      context.handle(
        _roleDescriptionMeta,
        roleDescription.isAcceptableOrUnknown(data['role_description']!, _roleDescriptionMeta),
      );
    } else if (isInserting) {
      context.missing(_roleDescriptionMeta);
    }
    if (data.containsKey('ballot_number')) {
      context.handle(
        _ballotNumberMeta,
        ballotNumber.isAcceptableOrUnknown(data['ballot_number']!, _ballotNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ballotNumberMeta);
    }
    if (data.containsKey('ballot_name')) {
      context.handle(
        _ballotNameMeta,
        ballotName.isAcceptableOrUnknown(data['ballot_name']!, _ballotNameMeta),
      );
    } else if (isInserting) {
      context.missing(_ballotNameMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('party_number')) {
      context.handle(
        _partyNumberMeta,
        partyNumber.isAcceptableOrUnknown(data['party_number']!, _partyNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_partyNumberMeta);
    }
    if (data.containsKey('party_acronym')) {
      context.handle(
        _partyAcronymMeta,
        partyAcronym.isAcceptableOrUnknown(data['party_acronym']!, _partyAcronymMeta),
      );
    } else if (isInserting) {
      context.missing(_partyAcronymMeta);
    }
    if (data.containsKey('party_name')) {
      context.handle(
        _partyNameMeta,
        partyName.isAcceptableOrUnknown(data['party_name']!, _partyNameMeta),
      );
    } else if (isInserting) {
      context.missing(_partyNameMeta);
    }
    if (data.containsKey('coalition_name')) {
      context.handle(
        _coalitionNameMeta,
        coalitionName.isAcceptableOrUnknown(data['coalition_name']!, _coalitionNameMeta),
      );
    } else if (isInserting) {
      context.missing(_coalitionNameMeta);
    }
    if (data.containsKey('coalition_comp')) {
      context.handle(
        _coalitionCompMeta,
        coalitionComp.isAcceptableOrUnknown(data['coalition_comp']!, _coalitionCompMeta),
      );
    } else if (isInserting) {
      context.missing(_coalitionCompMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('raw_status')) {
      context.handle(
        _rawStatusMeta,
        rawStatus.isAcceptableOrUnknown(data['raw_status']!, _rawStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_rawStatusMeta);
    }
    if (data.containsKey('total_assets')) {
      context.handle(
        _totalAssetsMeta,
        totalAssets.isAcceptableOrUnknown(data['total_assets']!, _totalAssetsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalAssetsMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_photoUrlMeta);
    }
    if (data.containsKey('local_photo_path')) {
      context.handle(
        _localPhotoPathMeta,
        localPhotoPath.isAcceptableOrUnknown(data['local_photo_path']!, _localPhotoPathMeta),
      );
    }
    if (data.containsKey('parent_candidate_id')) {
      context.handle(
        _parentCandidateIdMeta,
        parentCandidateId.isAcceptableOrUnknown(
          data['parent_candidate_id']!,
          _parentCandidateIdMeta,
        ),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta, gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('color_race')) {
      context.handle(
        _colorRaceMeta,
        colorRace.isAcceptableOrUnknown(data['color_race']!, _colorRaceMeta),
      );
    }
    if (data.containsKey('marital_status')) {
      context.handle(
        _maritalStatusMeta,
        maritalStatus.isAcceptableOrUnknown(data['marital_status']!, _maritalStatusMeta),
      );
    }
    if (data.containsKey('education_level')) {
      context.handle(
        _educationLevelMeta,
        educationLevel.isAcceptableOrUnknown(data['education_level']!, _educationLevelMeta),
      );
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    }
    if (data.containsKey('nationality')) {
      context.handle(
        _nationalityMeta,
        nationality.isAcceptableOrUnknown(data['nationality']!, _nationalityMeta),
      );
    }
    if (data.containsKey('birth_city')) {
      context.handle(
        _birthCityMeta,
        birthCity.isAcceptableOrUnknown(data['birth_city']!, _birthCityMeta),
      );
    }
    if (data.containsKey('birth_state')) {
      context.handle(
        _birthStateMeta,
        birthState.isAcceptableOrUnknown(data['birth_state']!, _birthStateMeta),
      );
    }
    if (data.containsKey('max_expense_1t')) {
      context.handle(
        _maxExpense1tMeta,
        maxExpense1t.isAcceptableOrUnknown(data['max_expense_1t']!, _maxExpense1tMeta),
      );
    }
    if (data.containsKey('max_expense_2t')) {
      context.handle(
        _maxExpense2tMeta,
        maxExpense2t.isAcceptableOrUnknown(data['max_expense_2t']!, _maxExpense2tMeta),
      );
    }
    if (data.containsKey('proposal_doc_url')) {
      context.handle(
        _proposalDocUrlMeta,
        proposalDocUrl.isAcceptableOrUnknown(data['proposal_doc_url']!, _proposalDocUrlMeta),
      );
    }
    if (data.containsKey('campaign_cnpj')) {
      context.handle(
        _campaignCnpjMeta,
        campaignCnpj.isAcceptableOrUnknown(data['campaign_cnpj']!, _campaignCnpjMeta),
      );
    }
    if (data.containsKey('detail_fetched')) {
      context.handle(
        _detailFetchedMeta,
        detailFetched.isAcceptableOrUnknown(data['detail_fetched']!, _detailFetchedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CandidateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CandidateData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      electionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}election_id'],
      )!,
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      )!,
      cityCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}city_code'],
      ),
      roleCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}role_code'],
      )!,
      roleDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_description'],
      )!,
      ballotNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ballot_number'],
      )!,
      ballotName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ballot_name'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      partyNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}party_number'],
      )!,
      partyAcronym: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party_acronym'],
      )!,
      partyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party_name'],
      )!,
      coalitionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coalition_name'],
      )!,
      coalitionComp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coalition_comp'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      rawStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_status'],
      )!,
      totalAssets: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_assets'],
      )!,
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      )!,
      localPhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_photo_path'],
      ),
      parentCandidateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_candidate_id'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_date'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      colorRace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_race'],
      ),
      maritalStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marital_status'],
      ),
      educationLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}education_level'],
      ),
      occupation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupation'],
      ),
      nationality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nationality'],
      ),
      birthCity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_city'],
      ),
      birthState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_state'],
      ),
      maxExpense1t: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_expense_1t'],
      ),
      maxExpense2t: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_expense_2t'],
      ),
      proposalDocUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proposal_doc_url'],
      ),
      campaignCnpj: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}campaign_cnpj'],
      ),
      detailFetched: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}detail_fetched'],
      )!,
    );
  }

  @override
  $CandidatesTableTable createAlias(String alias) {
    return $CandidatesTableTable(attachedDatabase, alias);
  }
}

class CandidateData extends DataClass implements Insertable<CandidateData> {
  /// Identificador sequencial unico do candidato no TSE (chave primaria oficial).
  final int id;

  /// Chave estrangeira referenciando o pleito eleitoral correspondente.
  final int electionId;

  /// Sigla da Unidade Federativa da candidatura ou 'BR' para pleito nacional.
  final String stateCode;

  /// Codigo do municipio no TSE (nulo para cargos federais ou estaduais).
  final int? cityCode;

  /// Codigo oficial do cargo pleiteado no TSE (1 a 13).
  final int roleCode;

  /// Descricao oficial do cargo no TSE.
  final String roleDescription;

  /// Numero do candidato na urna eleitoral.
  final int ballotNumber;

  /// Nome do candidato registrado para exibicao em tela de votacao.
  final String ballotName;

  /// Nome completo de registro civil.
  final String fullName;

  /// Numero da legenda partidaria oficial.
  final int partyNumber;

  /// Sigla oficial da agremiacao partidaria.
  final String partyAcronym;

  /// Denominacao completa do partido politico.
  final String partyName;

  /// Nome da coligacao ou federacao partidaria registrada.
  final String coalitionName;

  /// Composicao detalhada das siglas participantes da coligacao.
  final String coalitionComp;

  /// Status normalizado de registro de candidatura (ex: 'DEFERRED', 'CANCELED').
  final String status;

  /// Status literal bruto retornado pela API do TSE (ex: 'DEFERIDO COM RECURSO').
  final String rawStatus;

  /// Valor venal total declarado de bens em moeda corrente nacional.
  final double totalAssets;

  /// Endereco URL oficial da imagem fotografica no servidor do TSE.
  final String photoUrl;

  /// Caminho relativo ou absoluto do arquivo de fotografia persistido em cache local.
  final String? localPhotoPath;

  /// Chave auto-referencial indicando vinculo com titular (para vices ou suplentes).
  final int? parentCandidateId;

  /// Data de nascimento informada a Justica Eleitoral no formato dd/MM/yyyy.
  final String? birthDate;

  /// Genero declarado pelo candidato.
  final String? gender;

  /// Autodeclaracao etnico-racial registrada no TSE.
  final String? colorRace;

  /// Estado civil informado no registro de candidatura.
  final String? maritalStatus;

  /// Grau de instrucao formal declarado.
  final String? educationLevel;

  /// Ocupacao profissional principal declarada.
  final String? occupation;

  /// Nacionalidade informada no registro.
  final String? nationality;

  /// Municipio de naturalidade do candidato.
  final String? birthCity;

  /// Unidade Federativa de nascimento.
  final String? birthState;

  /// Teto legal autorizado de gastos de campanha para o primeiro turno.
  final double? maxExpense1t;

  /// Teto legal autorizado de gastos de campanha para o segundo turno.
  final double? maxExpense2t;

  /// Endereco URL de download do plano/proposta de governo protocolado.
  final String? proposalDocUrl;

  /// Cadastro Nacional da Pessoa Juridica (CNPJ) oficial da conta de campanha.
  final String? campaignCnpj;

  /// Flag indicadora de captura previa dos metadados aprofundados de detalhe.
  final bool detailFetched;
  const CandidateData({
    required this.id,
    required this.electionId,
    required this.stateCode,
    this.cityCode,
    required this.roleCode,
    required this.roleDescription,
    required this.ballotNumber,
    required this.ballotName,
    required this.fullName,
    required this.partyNumber,
    required this.partyAcronym,
    required this.partyName,
    required this.coalitionName,
    required this.coalitionComp,
    required this.status,
    required this.rawStatus,
    required this.totalAssets,
    required this.photoUrl,
    this.localPhotoPath,
    this.parentCandidateId,
    this.birthDate,
    this.gender,
    this.colorRace,
    this.maritalStatus,
    this.educationLevel,
    this.occupation,
    this.nationality,
    this.birthCity,
    this.birthState,
    this.maxExpense1t,
    this.maxExpense2t,
    this.proposalDocUrl,
    this.campaignCnpj,
    required this.detailFetched,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['election_id'] = Variable<int>(electionId);
    map['state_code'] = Variable<String>(stateCode);
    if (!nullToAbsent || cityCode != null) {
      map['city_code'] = Variable<int>(cityCode);
    }
    map['role_code'] = Variable<int>(roleCode);
    map['role_description'] = Variable<String>(roleDescription);
    map['ballot_number'] = Variable<int>(ballotNumber);
    map['ballot_name'] = Variable<String>(ballotName);
    map['full_name'] = Variable<String>(fullName);
    map['party_number'] = Variable<int>(partyNumber);
    map['party_acronym'] = Variable<String>(partyAcronym);
    map['party_name'] = Variable<String>(partyName);
    map['coalition_name'] = Variable<String>(coalitionName);
    map['coalition_comp'] = Variable<String>(coalitionComp);
    map['status'] = Variable<String>(status);
    map['raw_status'] = Variable<String>(rawStatus);
    map['total_assets'] = Variable<double>(totalAssets);
    map['photo_url'] = Variable<String>(photoUrl);
    if (!nullToAbsent || localPhotoPath != null) {
      map['local_photo_path'] = Variable<String>(localPhotoPath);
    }
    if (!nullToAbsent || parentCandidateId != null) {
      map['parent_candidate_id'] = Variable<int>(parentCandidateId);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<String>(birthDate);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || colorRace != null) {
      map['color_race'] = Variable<String>(colorRace);
    }
    if (!nullToAbsent || maritalStatus != null) {
      map['marital_status'] = Variable<String>(maritalStatus);
    }
    if (!nullToAbsent || educationLevel != null) {
      map['education_level'] = Variable<String>(educationLevel);
    }
    if (!nullToAbsent || occupation != null) {
      map['occupation'] = Variable<String>(occupation);
    }
    if (!nullToAbsent || nationality != null) {
      map['nationality'] = Variable<String>(nationality);
    }
    if (!nullToAbsent || birthCity != null) {
      map['birth_city'] = Variable<String>(birthCity);
    }
    if (!nullToAbsent || birthState != null) {
      map['birth_state'] = Variable<String>(birthState);
    }
    if (!nullToAbsent || maxExpense1t != null) {
      map['max_expense_1t'] = Variable<double>(maxExpense1t);
    }
    if (!nullToAbsent || maxExpense2t != null) {
      map['max_expense_2t'] = Variable<double>(maxExpense2t);
    }
    if (!nullToAbsent || proposalDocUrl != null) {
      map['proposal_doc_url'] = Variable<String>(proposalDocUrl);
    }
    if (!nullToAbsent || campaignCnpj != null) {
      map['campaign_cnpj'] = Variable<String>(campaignCnpj);
    }
    map['detail_fetched'] = Variable<bool>(detailFetched);
    return map;
  }

  CandidatesTableCompanion toCompanion(bool nullToAbsent) {
    return CandidatesTableCompanion(
      id: Value(id),
      electionId: Value(electionId),
      stateCode: Value(stateCode),
      cityCode: cityCode == null && nullToAbsent ? const Value.absent() : Value(cityCode),
      roleCode: Value(roleCode),
      roleDescription: Value(roleDescription),
      ballotNumber: Value(ballotNumber),
      ballotName: Value(ballotName),
      fullName: Value(fullName),
      partyNumber: Value(partyNumber),
      partyAcronym: Value(partyAcronym),
      partyName: Value(partyName),
      coalitionName: Value(coalitionName),
      coalitionComp: Value(coalitionComp),
      status: Value(status),
      rawStatus: Value(rawStatus),
      totalAssets: Value(totalAssets),
      photoUrl: Value(photoUrl),
      localPhotoPath: localPhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPhotoPath),
      parentCandidateId: parentCandidateId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentCandidateId),
      birthDate: birthDate == null && nullToAbsent ? const Value.absent() : Value(birthDate),
      gender: gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      colorRace: colorRace == null && nullToAbsent ? const Value.absent() : Value(colorRace),
      maritalStatus: maritalStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(maritalStatus),
      educationLevel: educationLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(educationLevel),
      occupation: occupation == null && nullToAbsent ? const Value.absent() : Value(occupation),
      nationality: nationality == null && nullToAbsent ? const Value.absent() : Value(nationality),
      birthCity: birthCity == null && nullToAbsent ? const Value.absent() : Value(birthCity),
      birthState: birthState == null && nullToAbsent ? const Value.absent() : Value(birthState),
      maxExpense1t: maxExpense1t == null && nullToAbsent
          ? const Value.absent()
          : Value(maxExpense1t),
      maxExpense2t: maxExpense2t == null && nullToAbsent
          ? const Value.absent()
          : Value(maxExpense2t),
      proposalDocUrl: proposalDocUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(proposalDocUrl),
      campaignCnpj: campaignCnpj == null && nullToAbsent
          ? const Value.absent()
          : Value(campaignCnpj),
      detailFetched: Value(detailFetched),
    );
  }

  factory CandidateData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CandidateData(
      id: serializer.fromJson<int>(json['id']),
      electionId: serializer.fromJson<int>(json['electionId']),
      stateCode: serializer.fromJson<String>(json['stateCode']),
      cityCode: serializer.fromJson<int?>(json['cityCode']),
      roleCode: serializer.fromJson<int>(json['roleCode']),
      roleDescription: serializer.fromJson<String>(json['roleDescription']),
      ballotNumber: serializer.fromJson<int>(json['ballotNumber']),
      ballotName: serializer.fromJson<String>(json['ballotName']),
      fullName: serializer.fromJson<String>(json['fullName']),
      partyNumber: serializer.fromJson<int>(json['partyNumber']),
      partyAcronym: serializer.fromJson<String>(json['partyAcronym']),
      partyName: serializer.fromJson<String>(json['partyName']),
      coalitionName: serializer.fromJson<String>(json['coalitionName']),
      coalitionComp: serializer.fromJson<String>(json['coalitionComp']),
      status: serializer.fromJson<String>(json['status']),
      rawStatus: serializer.fromJson<String>(json['rawStatus']),
      totalAssets: serializer.fromJson<double>(json['totalAssets']),
      photoUrl: serializer.fromJson<String>(json['photoUrl']),
      localPhotoPath: serializer.fromJson<String?>(json['localPhotoPath']),
      parentCandidateId: serializer.fromJson<int?>(json['parentCandidateId']),
      birthDate: serializer.fromJson<String?>(json['birthDate']),
      gender: serializer.fromJson<String?>(json['gender']),
      colorRace: serializer.fromJson<String?>(json['colorRace']),
      maritalStatus: serializer.fromJson<String?>(json['maritalStatus']),
      educationLevel: serializer.fromJson<String?>(json['educationLevel']),
      occupation: serializer.fromJson<String?>(json['occupation']),
      nationality: serializer.fromJson<String?>(json['nationality']),
      birthCity: serializer.fromJson<String?>(json['birthCity']),
      birthState: serializer.fromJson<String?>(json['birthState']),
      maxExpense1t: serializer.fromJson<double?>(json['maxExpense1t']),
      maxExpense2t: serializer.fromJson<double?>(json['maxExpense2t']),
      proposalDocUrl: serializer.fromJson<String?>(json['proposalDocUrl']),
      campaignCnpj: serializer.fromJson<String?>(json['campaignCnpj']),
      detailFetched: serializer.fromJson<bool>(json['detailFetched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'electionId': serializer.toJson<int>(electionId),
      'stateCode': serializer.toJson<String>(stateCode),
      'cityCode': serializer.toJson<int?>(cityCode),
      'roleCode': serializer.toJson<int>(roleCode),
      'roleDescription': serializer.toJson<String>(roleDescription),
      'ballotNumber': serializer.toJson<int>(ballotNumber),
      'ballotName': serializer.toJson<String>(ballotName),
      'fullName': serializer.toJson<String>(fullName),
      'partyNumber': serializer.toJson<int>(partyNumber),
      'partyAcronym': serializer.toJson<String>(partyAcronym),
      'partyName': serializer.toJson<String>(partyName),
      'coalitionName': serializer.toJson<String>(coalitionName),
      'coalitionComp': serializer.toJson<String>(coalitionComp),
      'status': serializer.toJson<String>(status),
      'rawStatus': serializer.toJson<String>(rawStatus),
      'totalAssets': serializer.toJson<double>(totalAssets),
      'photoUrl': serializer.toJson<String>(photoUrl),
      'localPhotoPath': serializer.toJson<String?>(localPhotoPath),
      'parentCandidateId': serializer.toJson<int?>(parentCandidateId),
      'birthDate': serializer.toJson<String?>(birthDate),
      'gender': serializer.toJson<String?>(gender),
      'colorRace': serializer.toJson<String?>(colorRace),
      'maritalStatus': serializer.toJson<String?>(maritalStatus),
      'educationLevel': serializer.toJson<String?>(educationLevel),
      'occupation': serializer.toJson<String?>(occupation),
      'nationality': serializer.toJson<String?>(nationality),
      'birthCity': serializer.toJson<String?>(birthCity),
      'birthState': serializer.toJson<String?>(birthState),
      'maxExpense1t': serializer.toJson<double?>(maxExpense1t),
      'maxExpense2t': serializer.toJson<double?>(maxExpense2t),
      'proposalDocUrl': serializer.toJson<String?>(proposalDocUrl),
      'campaignCnpj': serializer.toJson<String?>(campaignCnpj),
      'detailFetched': serializer.toJson<bool>(detailFetched),
    };
  }

  CandidateData copyWith({
    int? id,
    int? electionId,
    String? stateCode,
    Value<int?> cityCode = const Value.absent(),
    int? roleCode,
    String? roleDescription,
    int? ballotNumber,
    String? ballotName,
    String? fullName,
    int? partyNumber,
    String? partyAcronym,
    String? partyName,
    String? coalitionName,
    String? coalitionComp,
    String? status,
    String? rawStatus,
    double? totalAssets,
    String? photoUrl,
    Value<String?> localPhotoPath = const Value.absent(),
    Value<int?> parentCandidateId = const Value.absent(),
    Value<String?> birthDate = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> colorRace = const Value.absent(),
    Value<String?> maritalStatus = const Value.absent(),
    Value<String?> educationLevel = const Value.absent(),
    Value<String?> occupation = const Value.absent(),
    Value<String?> nationality = const Value.absent(),
    Value<String?> birthCity = const Value.absent(),
    Value<String?> birthState = const Value.absent(),
    Value<double?> maxExpense1t = const Value.absent(),
    Value<double?> maxExpense2t = const Value.absent(),
    Value<String?> proposalDocUrl = const Value.absent(),
    Value<String?> campaignCnpj = const Value.absent(),
    bool? detailFetched,
  }) => CandidateData(
    id: id ?? this.id,
    electionId: electionId ?? this.electionId,
    stateCode: stateCode ?? this.stateCode,
    cityCode: cityCode.present ? cityCode.value : this.cityCode,
    roleCode: roleCode ?? this.roleCode,
    roleDescription: roleDescription ?? this.roleDescription,
    ballotNumber: ballotNumber ?? this.ballotNumber,
    ballotName: ballotName ?? this.ballotName,
    fullName: fullName ?? this.fullName,
    partyNumber: partyNumber ?? this.partyNumber,
    partyAcronym: partyAcronym ?? this.partyAcronym,
    partyName: partyName ?? this.partyName,
    coalitionName: coalitionName ?? this.coalitionName,
    coalitionComp: coalitionComp ?? this.coalitionComp,
    status: status ?? this.status,
    rawStatus: rawStatus ?? this.rawStatus,
    totalAssets: totalAssets ?? this.totalAssets,
    photoUrl: photoUrl ?? this.photoUrl,
    localPhotoPath: localPhotoPath.present ? localPhotoPath.value : this.localPhotoPath,
    parentCandidateId: parentCandidateId.present ? parentCandidateId.value : this.parentCandidateId,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    gender: gender.present ? gender.value : this.gender,
    colorRace: colorRace.present ? colorRace.value : this.colorRace,
    maritalStatus: maritalStatus.present ? maritalStatus.value : this.maritalStatus,
    educationLevel: educationLevel.present ? educationLevel.value : this.educationLevel,
    occupation: occupation.present ? occupation.value : this.occupation,
    nationality: nationality.present ? nationality.value : this.nationality,
    birthCity: birthCity.present ? birthCity.value : this.birthCity,
    birthState: birthState.present ? birthState.value : this.birthState,
    maxExpense1t: maxExpense1t.present ? maxExpense1t.value : this.maxExpense1t,
    maxExpense2t: maxExpense2t.present ? maxExpense2t.value : this.maxExpense2t,
    proposalDocUrl: proposalDocUrl.present ? proposalDocUrl.value : this.proposalDocUrl,
    campaignCnpj: campaignCnpj.present ? campaignCnpj.value : this.campaignCnpj,
    detailFetched: detailFetched ?? this.detailFetched,
  );
  CandidateData copyWithCompanion(CandidatesTableCompanion data) {
    return CandidateData(
      id: data.id.present ? data.id.value : this.id,
      electionId: data.electionId.present ? data.electionId.value : this.electionId,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      cityCode: data.cityCode.present ? data.cityCode.value : this.cityCode,
      roleCode: data.roleCode.present ? data.roleCode.value : this.roleCode,
      roleDescription: data.roleDescription.present
          ? data.roleDescription.value
          : this.roleDescription,
      ballotNumber: data.ballotNumber.present ? data.ballotNumber.value : this.ballotNumber,
      ballotName: data.ballotName.present ? data.ballotName.value : this.ballotName,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      partyNumber: data.partyNumber.present ? data.partyNumber.value : this.partyNumber,
      partyAcronym: data.partyAcronym.present ? data.partyAcronym.value : this.partyAcronym,
      partyName: data.partyName.present ? data.partyName.value : this.partyName,
      coalitionName: data.coalitionName.present ? data.coalitionName.value : this.coalitionName,
      coalitionComp: data.coalitionComp.present ? data.coalitionComp.value : this.coalitionComp,
      status: data.status.present ? data.status.value : this.status,
      rawStatus: data.rawStatus.present ? data.rawStatus.value : this.rawStatus,
      totalAssets: data.totalAssets.present ? data.totalAssets.value : this.totalAssets,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      localPhotoPath: data.localPhotoPath.present ? data.localPhotoPath.value : this.localPhotoPath,
      parentCandidateId: data.parentCandidateId.present
          ? data.parentCandidateId.value
          : this.parentCandidateId,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      gender: data.gender.present ? data.gender.value : this.gender,
      colorRace: data.colorRace.present ? data.colorRace.value : this.colorRace,
      maritalStatus: data.maritalStatus.present ? data.maritalStatus.value : this.maritalStatus,
      educationLevel: data.educationLevel.present ? data.educationLevel.value : this.educationLevel,
      occupation: data.occupation.present ? data.occupation.value : this.occupation,
      nationality: data.nationality.present ? data.nationality.value : this.nationality,
      birthCity: data.birthCity.present ? data.birthCity.value : this.birthCity,
      birthState: data.birthState.present ? data.birthState.value : this.birthState,
      maxExpense1t: data.maxExpense1t.present ? data.maxExpense1t.value : this.maxExpense1t,
      maxExpense2t: data.maxExpense2t.present ? data.maxExpense2t.value : this.maxExpense2t,
      proposalDocUrl: data.proposalDocUrl.present ? data.proposalDocUrl.value : this.proposalDocUrl,
      campaignCnpj: data.campaignCnpj.present ? data.campaignCnpj.value : this.campaignCnpj,
      detailFetched: data.detailFetched.present ? data.detailFetched.value : this.detailFetched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CandidateData(')
          ..write('id: $id, ')
          ..write('electionId: $electionId, ')
          ..write('stateCode: $stateCode, ')
          ..write('cityCode: $cityCode, ')
          ..write('roleCode: $roleCode, ')
          ..write('roleDescription: $roleDescription, ')
          ..write('ballotNumber: $ballotNumber, ')
          ..write('ballotName: $ballotName, ')
          ..write('fullName: $fullName, ')
          ..write('partyNumber: $partyNumber, ')
          ..write('partyAcronym: $partyAcronym, ')
          ..write('partyName: $partyName, ')
          ..write('coalitionName: $coalitionName, ')
          ..write('coalitionComp: $coalitionComp, ')
          ..write('status: $status, ')
          ..write('rawStatus: $rawStatus, ')
          ..write('totalAssets: $totalAssets, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('localPhotoPath: $localPhotoPath, ')
          ..write('parentCandidateId: $parentCandidateId, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('colorRace: $colorRace, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('educationLevel: $educationLevel, ')
          ..write('occupation: $occupation, ')
          ..write('nationality: $nationality, ')
          ..write('birthCity: $birthCity, ')
          ..write('birthState: $birthState, ')
          ..write('maxExpense1t: $maxExpense1t, ')
          ..write('maxExpense2t: $maxExpense2t, ')
          ..write('proposalDocUrl: $proposalDocUrl, ')
          ..write('campaignCnpj: $campaignCnpj, ')
          ..write('detailFetched: $detailFetched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    electionId,
    stateCode,
    cityCode,
    roleCode,
    roleDescription,
    ballotNumber,
    ballotName,
    fullName,
    partyNumber,
    partyAcronym,
    partyName,
    coalitionName,
    coalitionComp,
    status,
    rawStatus,
    totalAssets,
    photoUrl,
    localPhotoPath,
    parentCandidateId,
    birthDate,
    gender,
    colorRace,
    maritalStatus,
    educationLevel,
    occupation,
    nationality,
    birthCity,
    birthState,
    maxExpense1t,
    maxExpense2t,
    proposalDocUrl,
    campaignCnpj,
    detailFetched,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CandidateData &&
          other.id == this.id &&
          other.electionId == this.electionId &&
          other.stateCode == this.stateCode &&
          other.cityCode == this.cityCode &&
          other.roleCode == this.roleCode &&
          other.roleDescription == this.roleDescription &&
          other.ballotNumber == this.ballotNumber &&
          other.ballotName == this.ballotName &&
          other.fullName == this.fullName &&
          other.partyNumber == this.partyNumber &&
          other.partyAcronym == this.partyAcronym &&
          other.partyName == this.partyName &&
          other.coalitionName == this.coalitionName &&
          other.coalitionComp == this.coalitionComp &&
          other.status == this.status &&
          other.rawStatus == this.rawStatus &&
          other.totalAssets == this.totalAssets &&
          other.photoUrl == this.photoUrl &&
          other.localPhotoPath == this.localPhotoPath &&
          other.parentCandidateId == this.parentCandidateId &&
          other.birthDate == this.birthDate &&
          other.gender == this.gender &&
          other.colorRace == this.colorRace &&
          other.maritalStatus == this.maritalStatus &&
          other.educationLevel == this.educationLevel &&
          other.occupation == this.occupation &&
          other.nationality == this.nationality &&
          other.birthCity == this.birthCity &&
          other.birthState == this.birthState &&
          other.maxExpense1t == this.maxExpense1t &&
          other.maxExpense2t == this.maxExpense2t &&
          other.proposalDocUrl == this.proposalDocUrl &&
          other.campaignCnpj == this.campaignCnpj &&
          other.detailFetched == this.detailFetched);
}

class CandidatesTableCompanion extends UpdateCompanion<CandidateData> {
  final Value<int> id;
  final Value<int> electionId;
  final Value<String> stateCode;
  final Value<int?> cityCode;
  final Value<int> roleCode;
  final Value<String> roleDescription;
  final Value<int> ballotNumber;
  final Value<String> ballotName;
  final Value<String> fullName;
  final Value<int> partyNumber;
  final Value<String> partyAcronym;
  final Value<String> partyName;
  final Value<String> coalitionName;
  final Value<String> coalitionComp;
  final Value<String> status;
  final Value<String> rawStatus;
  final Value<double> totalAssets;
  final Value<String> photoUrl;
  final Value<String?> localPhotoPath;
  final Value<int?> parentCandidateId;
  final Value<String?> birthDate;
  final Value<String?> gender;
  final Value<String?> colorRace;
  final Value<String?> maritalStatus;
  final Value<String?> educationLevel;
  final Value<String?> occupation;
  final Value<String?> nationality;
  final Value<String?> birthCity;
  final Value<String?> birthState;
  final Value<double?> maxExpense1t;
  final Value<double?> maxExpense2t;
  final Value<String?> proposalDocUrl;
  final Value<String?> campaignCnpj;
  final Value<bool> detailFetched;
  const CandidatesTableCompanion({
    this.id = const Value.absent(),
    this.electionId = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.cityCode = const Value.absent(),
    this.roleCode = const Value.absent(),
    this.roleDescription = const Value.absent(),
    this.ballotNumber = const Value.absent(),
    this.ballotName = const Value.absent(),
    this.fullName = const Value.absent(),
    this.partyNumber = const Value.absent(),
    this.partyAcronym = const Value.absent(),
    this.partyName = const Value.absent(),
    this.coalitionName = const Value.absent(),
    this.coalitionComp = const Value.absent(),
    this.status = const Value.absent(),
    this.rawStatus = const Value.absent(),
    this.totalAssets = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.localPhotoPath = const Value.absent(),
    this.parentCandidateId = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.colorRace = const Value.absent(),
    this.maritalStatus = const Value.absent(),
    this.educationLevel = const Value.absent(),
    this.occupation = const Value.absent(),
    this.nationality = const Value.absent(),
    this.birthCity = const Value.absent(),
    this.birthState = const Value.absent(),
    this.maxExpense1t = const Value.absent(),
    this.maxExpense2t = const Value.absent(),
    this.proposalDocUrl = const Value.absent(),
    this.campaignCnpj = const Value.absent(),
    this.detailFetched = const Value.absent(),
  });
  CandidatesTableCompanion.insert({
    this.id = const Value.absent(),
    required int electionId,
    required String stateCode,
    this.cityCode = const Value.absent(),
    required int roleCode,
    required String roleDescription,
    required int ballotNumber,
    required String ballotName,
    required String fullName,
    required int partyNumber,
    required String partyAcronym,
    required String partyName,
    required String coalitionName,
    required String coalitionComp,
    required String status,
    required String rawStatus,
    required double totalAssets,
    required String photoUrl,
    this.localPhotoPath = const Value.absent(),
    this.parentCandidateId = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.colorRace = const Value.absent(),
    this.maritalStatus = const Value.absent(),
    this.educationLevel = const Value.absent(),
    this.occupation = const Value.absent(),
    this.nationality = const Value.absent(),
    this.birthCity = const Value.absent(),
    this.birthState = const Value.absent(),
    this.maxExpense1t = const Value.absent(),
    this.maxExpense2t = const Value.absent(),
    this.proposalDocUrl = const Value.absent(),
    this.campaignCnpj = const Value.absent(),
    this.detailFetched = const Value.absent(),
  }) : electionId = Value(electionId),
       stateCode = Value(stateCode),
       roleCode = Value(roleCode),
       roleDescription = Value(roleDescription),
       ballotNumber = Value(ballotNumber),
       ballotName = Value(ballotName),
       fullName = Value(fullName),
       partyNumber = Value(partyNumber),
       partyAcronym = Value(partyAcronym),
       partyName = Value(partyName),
       coalitionName = Value(coalitionName),
       coalitionComp = Value(coalitionComp),
       status = Value(status),
       rawStatus = Value(rawStatus),
       totalAssets = Value(totalAssets),
       photoUrl = Value(photoUrl);
  static Insertable<CandidateData> custom({
    Expression<int>? id,
    Expression<int>? electionId,
    Expression<String>? stateCode,
    Expression<int>? cityCode,
    Expression<int>? roleCode,
    Expression<String>? roleDescription,
    Expression<int>? ballotNumber,
    Expression<String>? ballotName,
    Expression<String>? fullName,
    Expression<int>? partyNumber,
    Expression<String>? partyAcronym,
    Expression<String>? partyName,
    Expression<String>? coalitionName,
    Expression<String>? coalitionComp,
    Expression<String>? status,
    Expression<String>? rawStatus,
    Expression<double>? totalAssets,
    Expression<String>? photoUrl,
    Expression<String>? localPhotoPath,
    Expression<int>? parentCandidateId,
    Expression<String>? birthDate,
    Expression<String>? gender,
    Expression<String>? colorRace,
    Expression<String>? maritalStatus,
    Expression<String>? educationLevel,
    Expression<String>? occupation,
    Expression<String>? nationality,
    Expression<String>? birthCity,
    Expression<String>? birthState,
    Expression<double>? maxExpense1t,
    Expression<double>? maxExpense2t,
    Expression<String>? proposalDocUrl,
    Expression<String>? campaignCnpj,
    Expression<bool>? detailFetched,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (electionId != null) 'election_id': electionId,
      if (stateCode != null) 'state_code': stateCode,
      if (cityCode != null) 'city_code': cityCode,
      if (roleCode != null) 'role_code': roleCode,
      if (roleDescription != null) 'role_description': roleDescription,
      if (ballotNumber != null) 'ballot_number': ballotNumber,
      if (ballotName != null) 'ballot_name': ballotName,
      if (fullName != null) 'full_name': fullName,
      if (partyNumber != null) 'party_number': partyNumber,
      if (partyAcronym != null) 'party_acronym': partyAcronym,
      if (partyName != null) 'party_name': partyName,
      if (coalitionName != null) 'coalition_name': coalitionName,
      if (coalitionComp != null) 'coalition_comp': coalitionComp,
      if (status != null) 'status': status,
      if (rawStatus != null) 'raw_status': rawStatus,
      if (totalAssets != null) 'total_assets': totalAssets,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (localPhotoPath != null) 'local_photo_path': localPhotoPath,
      if (parentCandidateId != null) 'parent_candidate_id': parentCandidateId,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender,
      if (colorRace != null) 'color_race': colorRace,
      if (maritalStatus != null) 'marital_status': maritalStatus,
      if (educationLevel != null) 'education_level': educationLevel,
      if (occupation != null) 'occupation': occupation,
      if (nationality != null) 'nationality': nationality,
      if (birthCity != null) 'birth_city': birthCity,
      if (birthState != null) 'birth_state': birthState,
      if (maxExpense1t != null) 'max_expense_1t': maxExpense1t,
      if (maxExpense2t != null) 'max_expense_2t': maxExpense2t,
      if (proposalDocUrl != null) 'proposal_doc_url': proposalDocUrl,
      if (campaignCnpj != null) 'campaign_cnpj': campaignCnpj,
      if (detailFetched != null) 'detail_fetched': detailFetched,
    });
  }

  CandidatesTableCompanion copyWith({
    Value<int>? id,
    Value<int>? electionId,
    Value<String>? stateCode,
    Value<int?>? cityCode,
    Value<int>? roleCode,
    Value<String>? roleDescription,
    Value<int>? ballotNumber,
    Value<String>? ballotName,
    Value<String>? fullName,
    Value<int>? partyNumber,
    Value<String>? partyAcronym,
    Value<String>? partyName,
    Value<String>? coalitionName,
    Value<String>? coalitionComp,
    Value<String>? status,
    Value<String>? rawStatus,
    Value<double>? totalAssets,
    Value<String>? photoUrl,
    Value<String?>? localPhotoPath,
    Value<int?>? parentCandidateId,
    Value<String?>? birthDate,
    Value<String?>? gender,
    Value<String?>? colorRace,
    Value<String?>? maritalStatus,
    Value<String?>? educationLevel,
    Value<String?>? occupation,
    Value<String?>? nationality,
    Value<String?>? birthCity,
    Value<String?>? birthState,
    Value<double?>? maxExpense1t,
    Value<double?>? maxExpense2t,
    Value<String?>? proposalDocUrl,
    Value<String?>? campaignCnpj,
    Value<bool>? detailFetched,
  }) {
    return CandidatesTableCompanion(
      id: id ?? this.id,
      electionId: electionId ?? this.electionId,
      stateCode: stateCode ?? this.stateCode,
      cityCode: cityCode ?? this.cityCode,
      roleCode: roleCode ?? this.roleCode,
      roleDescription: roleDescription ?? this.roleDescription,
      ballotNumber: ballotNumber ?? this.ballotNumber,
      ballotName: ballotName ?? this.ballotName,
      fullName: fullName ?? this.fullName,
      partyNumber: partyNumber ?? this.partyNumber,
      partyAcronym: partyAcronym ?? this.partyAcronym,
      partyName: partyName ?? this.partyName,
      coalitionName: coalitionName ?? this.coalitionName,
      coalitionComp: coalitionComp ?? this.coalitionComp,
      status: status ?? this.status,
      rawStatus: rawStatus ?? this.rawStatus,
      totalAssets: totalAssets ?? this.totalAssets,
      photoUrl: photoUrl ?? this.photoUrl,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
      parentCandidateId: parentCandidateId ?? this.parentCandidateId,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      colorRace: colorRace ?? this.colorRace,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      educationLevel: educationLevel ?? this.educationLevel,
      occupation: occupation ?? this.occupation,
      nationality: nationality ?? this.nationality,
      birthCity: birthCity ?? this.birthCity,
      birthState: birthState ?? this.birthState,
      maxExpense1t: maxExpense1t ?? this.maxExpense1t,
      maxExpense2t: maxExpense2t ?? this.maxExpense2t,
      proposalDocUrl: proposalDocUrl ?? this.proposalDocUrl,
      campaignCnpj: campaignCnpj ?? this.campaignCnpj,
      detailFetched: detailFetched ?? this.detailFetched,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (electionId.present) {
      map['election_id'] = Variable<int>(electionId.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (cityCode.present) {
      map['city_code'] = Variable<int>(cityCode.value);
    }
    if (roleCode.present) {
      map['role_code'] = Variable<int>(roleCode.value);
    }
    if (roleDescription.present) {
      map['role_description'] = Variable<String>(roleDescription.value);
    }
    if (ballotNumber.present) {
      map['ballot_number'] = Variable<int>(ballotNumber.value);
    }
    if (ballotName.present) {
      map['ballot_name'] = Variable<String>(ballotName.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (partyNumber.present) {
      map['party_number'] = Variable<int>(partyNumber.value);
    }
    if (partyAcronym.present) {
      map['party_acronym'] = Variable<String>(partyAcronym.value);
    }
    if (partyName.present) {
      map['party_name'] = Variable<String>(partyName.value);
    }
    if (coalitionName.present) {
      map['coalition_name'] = Variable<String>(coalitionName.value);
    }
    if (coalitionComp.present) {
      map['coalition_comp'] = Variable<String>(coalitionComp.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rawStatus.present) {
      map['raw_status'] = Variable<String>(rawStatus.value);
    }
    if (totalAssets.present) {
      map['total_assets'] = Variable<double>(totalAssets.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (localPhotoPath.present) {
      map['local_photo_path'] = Variable<String>(localPhotoPath.value);
    }
    if (parentCandidateId.present) {
      map['parent_candidate_id'] = Variable<int>(parentCandidateId.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (colorRace.present) {
      map['color_race'] = Variable<String>(colorRace.value);
    }
    if (maritalStatus.present) {
      map['marital_status'] = Variable<String>(maritalStatus.value);
    }
    if (educationLevel.present) {
      map['education_level'] = Variable<String>(educationLevel.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (nationality.present) {
      map['nationality'] = Variable<String>(nationality.value);
    }
    if (birthCity.present) {
      map['birth_city'] = Variable<String>(birthCity.value);
    }
    if (birthState.present) {
      map['birth_state'] = Variable<String>(birthState.value);
    }
    if (maxExpense1t.present) {
      map['max_expense_1t'] = Variable<double>(maxExpense1t.value);
    }
    if (maxExpense2t.present) {
      map['max_expense_2t'] = Variable<double>(maxExpense2t.value);
    }
    if (proposalDocUrl.present) {
      map['proposal_doc_url'] = Variable<String>(proposalDocUrl.value);
    }
    if (campaignCnpj.present) {
      map['campaign_cnpj'] = Variable<String>(campaignCnpj.value);
    }
    if (detailFetched.present) {
      map['detail_fetched'] = Variable<bool>(detailFetched.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CandidatesTableCompanion(')
          ..write('id: $id, ')
          ..write('electionId: $electionId, ')
          ..write('stateCode: $stateCode, ')
          ..write('cityCode: $cityCode, ')
          ..write('roleCode: $roleCode, ')
          ..write('roleDescription: $roleDescription, ')
          ..write('ballotNumber: $ballotNumber, ')
          ..write('ballotName: $ballotName, ')
          ..write('fullName: $fullName, ')
          ..write('partyNumber: $partyNumber, ')
          ..write('partyAcronym: $partyAcronym, ')
          ..write('partyName: $partyName, ')
          ..write('coalitionName: $coalitionName, ')
          ..write('coalitionComp: $coalitionComp, ')
          ..write('status: $status, ')
          ..write('rawStatus: $rawStatus, ')
          ..write('totalAssets: $totalAssets, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('localPhotoPath: $localPhotoPath, ')
          ..write('parentCandidateId: $parentCandidateId, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('colorRace: $colorRace, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('educationLevel: $educationLevel, ')
          ..write('occupation: $occupation, ')
          ..write('nationality: $nationality, ')
          ..write('birthCity: $birthCity, ')
          ..write('birthState: $birthState, ')
          ..write('maxExpense1t: $maxExpense1t, ')
          ..write('maxExpense2t: $maxExpense2t, ')
          ..write('proposalDocUrl: $proposalDocUrl, ')
          ..write('campaignCnpj: $campaignCnpj, ')
          ..write('detailFetched: $detailFetched')
          ..write(')'))
        .toString();
  }
}

class $CandidateAssetsTableTable extends CandidateAssetsTable
    with TableInfo<$CandidateAssetsTableTable, CandidateAssetData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CandidateAssetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _candidateIdMeta = const VerificationMeta('candidateId');
  @override
  late final GeneratedColumn<int> candidateId = GeneratedColumn<int>(
    'candidate_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES candidates (id)'),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    candidateId,
    orderIndex,
    category,
    description,
    amount,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'candidate_assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<CandidateAssetData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('candidate_id')) {
      context.handle(
        _candidateIdMeta,
        candidateId.isAcceptableOrUnknown(data['candidate_id']!, _candidateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_candidateIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(data['description']!, _descriptionMeta),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta, amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CandidateAssetData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CandidateAssetData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      candidateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}candidate_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CandidateAssetsTableTable createAlias(String alias) {
    return $CandidateAssetsTableTable(attachedDatabase, alias);
  }
}

class CandidateAssetData extends DataClass implements Insertable<CandidateAssetData> {
  /// Identificador sintetico local autoincrementavel.
  final int id;

  /// Chave estrangeira vinculando o bem ao candidato titular.
  final int candidateId;

  /// Indice sequencial de apresentacao fornecido originalmente pelo TSE.
  final int orderIndex;

  /// Categoria ou tipo padronizado do bem (ex: 'VEICULO AUTOMOTOR', 'APARTAMENTO').
  final String category;

  /// Descricao detalhada do bem prestada pelo candidato a Justica Eleitoral.
  final String description;

  /// Valor venal em moeda corrente nacional com precisao centesimal.
  final double amount;

  /// Carimbo temporal da ultima atualizacao do registro patrimonial.
  final String updatedAt;
  const CandidateAssetData({
    required this.id,
    required this.candidateId,
    required this.orderIndex,
    required this.category,
    required this.description,
    required this.amount,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['candidate_id'] = Variable<int>(candidateId);
    map['order_index'] = Variable<int>(orderIndex);
    map['category'] = Variable<String>(category);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  CandidateAssetsTableCompanion toCompanion(bool nullToAbsent) {
    return CandidateAssetsTableCompanion(
      id: Value(id),
      candidateId: Value(candidateId),
      orderIndex: Value(orderIndex),
      category: Value(category),
      description: Value(description),
      amount: Value(amount),
      updatedAt: Value(updatedAt),
    );
  }

  factory CandidateAssetData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CandidateAssetData(
      id: serializer.fromJson<int>(json['id']),
      candidateId: serializer.fromJson<int>(json['candidateId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'candidateId': serializer.toJson<int>(candidateId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  CandidateAssetData copyWith({
    int? id,
    int? candidateId,
    int? orderIndex,
    String? category,
    String? description,
    double? amount,
    String? updatedAt,
  }) => CandidateAssetData(
    id: id ?? this.id,
    candidateId: candidateId ?? this.candidateId,
    orderIndex: orderIndex ?? this.orderIndex,
    category: category ?? this.category,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CandidateAssetData copyWithCompanion(CandidateAssetsTableCompanion data) {
    return CandidateAssetData(
      id: data.id.present ? data.id.value : this.id,
      candidateId: data.candidateId.present ? data.candidateId.value : this.candidateId,
      orderIndex: data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present ? data.description.value : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CandidateAssetData(')
          ..write('id: $id, ')
          ..write('candidateId: $candidateId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, candidateId, orderIndex, category, description, amount, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CandidateAssetData &&
          other.id == this.id &&
          other.candidateId == this.candidateId &&
          other.orderIndex == this.orderIndex &&
          other.category == this.category &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.updatedAt == this.updatedAt);
}

class CandidateAssetsTableCompanion extends UpdateCompanion<CandidateAssetData> {
  final Value<int> id;
  final Value<int> candidateId;
  final Value<int> orderIndex;
  final Value<String> category;
  final Value<String> description;
  final Value<double> amount;
  final Value<String> updatedAt;
  const CandidateAssetsTableCompanion({
    this.id = const Value.absent(),
    this.candidateId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CandidateAssetsTableCompanion.insert({
    this.id = const Value.absent(),
    required int candidateId,
    required int orderIndex,
    required String category,
    required String description,
    required double amount,
    required String updatedAt,
  }) : candidateId = Value(candidateId),
       orderIndex = Value(orderIndex),
       category = Value(category),
       description = Value(description),
       amount = Value(amount),
       updatedAt = Value(updatedAt);
  static Insertable<CandidateAssetData> custom({
    Expression<int>? id,
    Expression<int>? candidateId,
    Expression<int>? orderIndex,
    Expression<String>? category,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (candidateId != null) 'candidate_id': candidateId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CandidateAssetsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? candidateId,
    Value<int>? orderIndex,
    Value<String>? category,
    Value<String>? description,
    Value<double>? amount,
    Value<String>? updatedAt,
  }) {
    return CandidateAssetsTableCompanion(
      id: id ?? this.id,
      candidateId: candidateId ?? this.candidateId,
      orderIndex: orderIndex ?? this.orderIndex,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (candidateId.present) {
      map['candidate_id'] = Variable<int>(candidateId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CandidateAssetsTableCompanion(')
          ..write('id: $id, ')
          ..write('candidateId: $candidateId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CacheMetadataTableTable extends CacheMetadataTable
    with TableInfo<$CacheMetadataTableTable, CacheMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheMetadataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cacheKeyMeta = const VerificationMeta('cacheKey');
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
    'cache_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastFetchedAtMeta = const VerificationMeta('lastFetchedAt');
  @override
  late final GeneratedColumn<String> lastFetchedAt = GeneratedColumn<String>(
    'last_fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadHashMeta = const VerificationMeta('payloadHash');
  @override
  late final GeneratedColumn<String> payloadHash = GeneratedColumn<String>(
    'payload_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemCountMeta = const VerificationMeta('itemCount');
  @override
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
    'item_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [cacheKey, lastFetchedAt, payloadHash, etag, itemCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cache_key')) {
      context.handle(
        _cacheKeyMeta,
        cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('last_fetched_at')) {
      context.handle(
        _lastFetchedAtMeta,
        lastFetchedAt.isAcceptableOrUnknown(data['last_fetched_at']!, _lastFetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_lastFetchedAtMeta);
    }
    if (data.containsKey('payload_hash')) {
      context.handle(
        _payloadHashMeta,
        payloadHash.isAcceptableOrUnknown(data['payload_hash']!, _payloadHashMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadHashMeta);
    }
    if (data.containsKey('etag')) {
      context.handle(_etagMeta, etag.isAcceptableOrUnknown(data['etag']!, _etagMeta));
    }
    if (data.containsKey('item_count')) {
      context.handle(
        _itemCountMeta,
        itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta),
      );
    } else if (isInserting) {
      context.missing(_itemCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cacheKey};
  @override
  CacheMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheMetadataData(
      cacheKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cache_key'],
      )!,
      lastFetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_fetched_at'],
      )!,
      payloadHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_hash'],
      )!,
      etag: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}etag']),
      itemCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_count'],
      )!,
    );
  }

  @override
  $CacheMetadataTableTable createAlias(String alias) {
    return $CacheMetadataTableTable(attachedDatabase, alias);
  }
}

class CacheMetadataData extends DataClass implements Insertable<CacheMetadataData> {
  /// Chave composta de consulta no formato {ano}_{uf}_{idEleicao}_{codigoCargo}.
  final String cacheKey;

  /// Carimbo ISO-8601 correspondente a ultima captura remota bem-sucedida.
  final String lastFetchedAt;

  /// Hash criptografico SHA-256 calculado sobre o payload bruto recebido da API.
  final String payloadHash;

  /// Cabecalho ETag HTTP emitido pelo servidor perimetral governamental.
  final String? etag;

  /// Total de registros consolidados obtidos na resposta oficial correspondente.
  final int itemCount;
  const CacheMetadataData({
    required this.cacheKey,
    required this.lastFetchedAt,
    required this.payloadHash,
    this.etag,
    required this.itemCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cache_key'] = Variable<String>(cacheKey);
    map['last_fetched_at'] = Variable<String>(lastFetchedAt);
    map['payload_hash'] = Variable<String>(payloadHash);
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    map['item_count'] = Variable<int>(itemCount);
    return map;
  }

  CacheMetadataTableCompanion toCompanion(bool nullToAbsent) {
    return CacheMetadataTableCompanion(
      cacheKey: Value(cacheKey),
      lastFetchedAt: Value(lastFetchedAt),
      payloadHash: Value(payloadHash),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      itemCount: Value(itemCount),
    );
  }

  factory CacheMetadataData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheMetadataData(
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      lastFetchedAt: serializer.fromJson<String>(json['lastFetchedAt']),
      payloadHash: serializer.fromJson<String>(json['payloadHash']),
      etag: serializer.fromJson<String?>(json['etag']),
      itemCount: serializer.fromJson<int>(json['itemCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cacheKey': serializer.toJson<String>(cacheKey),
      'lastFetchedAt': serializer.toJson<String>(lastFetchedAt),
      'payloadHash': serializer.toJson<String>(payloadHash),
      'etag': serializer.toJson<String?>(etag),
      'itemCount': serializer.toJson<int>(itemCount),
    };
  }

  CacheMetadataData copyWith({
    String? cacheKey,
    String? lastFetchedAt,
    String? payloadHash,
    Value<String?> etag = const Value.absent(),
    int? itemCount,
  }) => CacheMetadataData(
    cacheKey: cacheKey ?? this.cacheKey,
    lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
    payloadHash: payloadHash ?? this.payloadHash,
    etag: etag.present ? etag.value : this.etag,
    itemCount: itemCount ?? this.itemCount,
  );
  CacheMetadataData copyWithCompanion(CacheMetadataTableCompanion data) {
    return CacheMetadataData(
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      lastFetchedAt: data.lastFetchedAt.present ? data.lastFetchedAt.value : this.lastFetchedAt,
      payloadHash: data.payloadHash.present ? data.payloadHash.value : this.payloadHash,
      etag: data.etag.present ? data.etag.value : this.etag,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetadataData(')
          ..write('cacheKey: $cacheKey, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('etag: $etag, ')
          ..write('itemCount: $itemCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cacheKey, lastFetchedAt, payloadHash, etag, itemCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheMetadataData &&
          other.cacheKey == this.cacheKey &&
          other.lastFetchedAt == this.lastFetchedAt &&
          other.payloadHash == this.payloadHash &&
          other.etag == this.etag &&
          other.itemCount == this.itemCount);
}

class CacheMetadataTableCompanion extends UpdateCompanion<CacheMetadataData> {
  final Value<String> cacheKey;
  final Value<String> lastFetchedAt;
  final Value<String> payloadHash;
  final Value<String?> etag;
  final Value<int> itemCount;
  final Value<int> rowid;
  const CacheMetadataTableCompanion({
    this.cacheKey = const Value.absent(),
    this.lastFetchedAt = const Value.absent(),
    this.payloadHash = const Value.absent(),
    this.etag = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheMetadataTableCompanion.insert({
    required String cacheKey,
    required String lastFetchedAt,
    required String payloadHash,
    this.etag = const Value.absent(),
    required int itemCount,
    this.rowid = const Value.absent(),
  }) : cacheKey = Value(cacheKey),
       lastFetchedAt = Value(lastFetchedAt),
       payloadHash = Value(payloadHash),
       itemCount = Value(itemCount);
  static Insertable<CacheMetadataData> custom({
    Expression<String>? cacheKey,
    Expression<String>? lastFetchedAt,
    Expression<String>? payloadHash,
    Expression<String>? etag,
    Expression<int>? itemCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cacheKey != null) 'cache_key': cacheKey,
      if (lastFetchedAt != null) 'last_fetched_at': lastFetchedAt,
      if (payloadHash != null) 'payload_hash': payloadHash,
      if (etag != null) 'etag': etag,
      if (itemCount != null) 'item_count': itemCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheMetadataTableCompanion copyWith({
    Value<String>? cacheKey,
    Value<String>? lastFetchedAt,
    Value<String>? payloadHash,
    Value<String?>? etag,
    Value<int>? itemCount,
    Value<int>? rowid,
  }) {
    return CacheMetadataTableCompanion(
      cacheKey: cacheKey ?? this.cacheKey,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
      payloadHash: payloadHash ?? this.payloadHash,
      etag: etag ?? this.etag,
      itemCount: itemCount ?? this.itemCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (lastFetchedAt.present) {
      map['last_fetched_at'] = Variable<String>(lastFetchedAt.value);
    }
    if (payloadHash.present) {
      map['payload_hash'] = Variable<String>(payloadHash.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<int>(itemCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetadataTableCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('etag: $etag, ')
          ..write('itemCount: $itemCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ElectionsTableTable electionsTable = $ElectionsTableTable(this);
  late final $ElectionsCargosTableTable electionsCargosTable = $ElectionsCargosTableTable(this);
  late final $CandidatesTableTable candidatesTable = $CandidatesTableTable(this);
  late final $CandidateAssetsTableTable candidateAssetsTable = $CandidateAssetsTableTable(this);
  late final $CacheMetadataTableTable cacheMetadataTable = $CacheMetadataTableTable(this);
  late final Index idxCargosQuery = Index(
    'idx_cargos_query',
    'CREATE INDEX idx_cargos_query ON elections_cargos (election_id, state_code)',
  );
  late final Index idxCandidatesQuery = Index(
    'idx_candidates_query',
    'CREATE INDEX idx_candidates_query ON candidates (election_id, state_code, role_code)',
  );
  late final Index idxCandidatesParty = Index(
    'idx_candidates_party',
    'CREATE INDEX idx_candidates_party ON candidates (election_id, party_number)',
  );
  late final Index idxCandidatesSearch = Index(
    'idx_candidates_search',
    'CREATE INDEX idx_candidates_search ON candidates (ballot_name, full_name, ballot_number)',
  );
  late final Index idxCandidatesParent = Index(
    'idx_candidates_parent',
    'CREATE INDEX idx_candidates_parent ON candidates (parent_candidate_id)',
  );
  late final Index idxAssetsCandidate = Index(
    'idx_assets_candidate',
    'CREATE INDEX idx_assets_candidate ON candidate_assets (candidate_id, amount DESC)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    electionsTable,
    electionsCargosTable,
    candidatesTable,
    candidateAssetsTable,
    cacheMetadataTable,
    idxCargosQuery,
    idxCandidatesQuery,
    idxCandidatesParty,
    idxCandidatesSearch,
    idxCandidatesParent,
    idxAssetsCandidate,
  ];
}

typedef $$ElectionsTableTableCreateCompanionBuilder =
    ElectionsTableCompanion Function({
      Value<int> id,
      required int ano,
      required String nome,
      required String descricao,
      required String tipo,
      required String abrangencia,
      required int turno,
      required String dataEleicao,
      required String situacao,
    });
typedef $$ElectionsTableTableUpdateCompanionBuilder =
    ElectionsTableCompanion Function({
      Value<int> id,
      Value<int> ano,
      Value<String> nome,
      Value<String> descricao,
      Value<String> tipo,
      Value<String> abrangencia,
      Value<int> turno,
      Value<String> dataEleicao,
      Value<String> situacao,
    });

final class $$ElectionsTableTableReferences
    extends BaseReferences<_$AppDatabase, $ElectionsTableTable, ElectionData> {
  $$ElectionsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ElectionsCargosTableTable, List<ElectionCargoData>>
  _electionsCargosTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.electionsCargosTable,
    aliasName: 'elections__id__elections_cargos__election_id',
  );

  $$ElectionsCargosTableTableProcessedTableManager get electionsCargosTableRefs {
    final manager = $$ElectionsCargosTableTableTableManager(
      $_db,
      $_db.electionsCargosTable,
    ).filter((f) => f.electionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_electionsCargosTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CandidatesTableTable, List<CandidateData>> _candidatesTableRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.candidatesTable,
    aliasName: 'elections__id__candidates__election_id',
  );

  $$CandidatesTableTableProcessedTableManager get candidatesTableRefs {
    final manager = $$CandidatesTableTableTableManager(
      $_db,
      $_db.candidatesTable,
    ).filter((f) => f.electionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_candidatesTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ElectionsTableTableFilterComposer extends Composer<_$AppDatabase, $ElectionsTableTable> {
  $$ElectionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ano =>
      $composableBuilder(column: $table.ano, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get abrangencia =>
      $composableBuilder(column: $table.abrangencia, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get turno =>
      $composableBuilder(column: $table.turno, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dataEleicao =>
      $composableBuilder(column: $table.dataEleicao, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get situacao =>
      $composableBuilder(column: $table.situacao, builder: (column) => ColumnFilters(column));

  Expression<bool> electionsCargosTableRefs(
    Expression<bool> Function($$ElectionsCargosTableTableFilterComposer f) f,
  ) {
    final $$ElectionsCargosTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.electionsCargosTable,
      getReferencedColumn: (t) => t.electionId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ElectionsCargosTableTableFilterComposer(
            $db: $db,
            $table: $db.electionsCargosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> candidatesTableRefs(
    Expression<bool> Function($$CandidatesTableTableFilterComposer f) f,
  ) {
    final $$CandidatesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.candidatesTable,
      getReferencedColumn: (t) => t.electionId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CandidatesTableTableFilterComposer(
            $db: $db,
            $table: $db.candidatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ElectionsTableTableOrderingComposer extends Composer<_$AppDatabase, $ElectionsTableTable> {
  $$ElectionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ano =>
      $composableBuilder(column: $table.ano, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get abrangencia =>
      $composableBuilder(column: $table.abrangencia, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get turno =>
      $composableBuilder(column: $table.turno, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dataEleicao =>
      $composableBuilder(column: $table.dataEleicao, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get situacao =>
      $composableBuilder(column: $table.situacao, builder: (column) => ColumnOrderings(column));
}

class $$ElectionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ElectionsTableTable> {
  $$ElectionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ano =>
      $composableBuilder(column: $table.ano, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get abrangencia =>
      $composableBuilder(column: $table.abrangencia, builder: (column) => column);

  GeneratedColumn<int> get turno =>
      $composableBuilder(column: $table.turno, builder: (column) => column);

  GeneratedColumn<String> get dataEleicao =>
      $composableBuilder(column: $table.dataEleicao, builder: (column) => column);

  GeneratedColumn<String> get situacao =>
      $composableBuilder(column: $table.situacao, builder: (column) => column);

  Expression<T> electionsCargosTableRefs<T extends Object>(
    Expression<T> Function($$ElectionsCargosTableTableAnnotationComposer a) f,
  ) {
    final $$ElectionsCargosTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.electionsCargosTable,
      getReferencedColumn: (t) => t.electionId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ElectionsCargosTableTableAnnotationComposer(
            $db: $db,
            $table: $db.electionsCargosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> candidatesTableRefs<T extends Object>(
    Expression<T> Function($$CandidatesTableTableAnnotationComposer a) f,
  ) {
    final $$CandidatesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.candidatesTable,
      getReferencedColumn: (t) => t.electionId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CandidatesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.candidatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ElectionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ElectionsTableTable,
          ElectionData,
          $$ElectionsTableTableFilterComposer,
          $$ElectionsTableTableOrderingComposer,
          $$ElectionsTableTableAnnotationComposer,
          $$ElectionsTableTableCreateCompanionBuilder,
          $$ElectionsTableTableUpdateCompanionBuilder,
          (ElectionData, $$ElectionsTableTableReferences),
          ElectionData,
          PrefetchHooks Function({bool electionsCargosTableRefs, bool candidatesTableRefs})
        > {
  $$ElectionsTableTableTableManager(_$AppDatabase db, $ElectionsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ElectionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ElectionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ElectionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ano = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> abrangencia = const Value.absent(),
                Value<int> turno = const Value.absent(),
                Value<String> dataEleicao = const Value.absent(),
                Value<String> situacao = const Value.absent(),
              }) => ElectionsTableCompanion(
                id: id,
                ano: ano,
                nome: nome,
                descricao: descricao,
                tipo: tipo,
                abrangencia: abrangencia,
                turno: turno,
                dataEleicao: dataEleicao,
                situacao: situacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ano,
                required String nome,
                required String descricao,
                required String tipo,
                required String abrangencia,
                required int turno,
                required String dataEleicao,
                required String situacao,
              }) => ElectionsTableCompanion.insert(
                id: id,
                ano: ano,
                nome: nome,
                descricao: descricao,
                tipo: tipo,
                abrangencia: abrangencia,
                turno: turno,
                dataEleicao: dataEleicao,
                situacao: situacao,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $$ElectionsTableTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({electionsCargosTableRefs = false, candidatesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (electionsCargosTableRefs) db.electionsCargosTable,
                if (candidatesTableRefs) db.candidatesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (electionsCargosTableRefs)
                    await $_getPrefetchedData<
                      ElectionData,
                      $ElectionsTableTable,
                      ElectionCargoData
                    >(
                      currentTable: table,
                      referencedTable: $$ElectionsTableTableReferences
                          ._electionsCargosTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ElectionsTableTableReferences(db, table, p0).electionsCargosTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.electionId == item.id),
                      typedResults: items,
                    ),
                  if (candidatesTableRefs)
                    await $_getPrefetchedData<ElectionData, $ElectionsTableTable, CandidateData>(
                      currentTable: table,
                      referencedTable: $$ElectionsTableTableReferences._candidatesTableRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$ElectionsTableTableReferences(db, table, p0).candidatesTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.electionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ElectionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ElectionsTableTable,
      ElectionData,
      $$ElectionsTableTableFilterComposer,
      $$ElectionsTableTableOrderingComposer,
      $$ElectionsTableTableAnnotationComposer,
      $$ElectionsTableTableCreateCompanionBuilder,
      $$ElectionsTableTableUpdateCompanionBuilder,
      (ElectionData, $$ElectionsTableTableReferences),
      ElectionData,
      PrefetchHooks Function({bool electionsCargosTableRefs, bool candidatesTableRefs})
    >;
typedef $$ElectionsCargosTableTableCreateCompanionBuilder =
    ElectionsCargosTableCompanion Function({
      Value<int> id,
      required int electionId,
      required String stateCode,
      required int cargoCode,
      required String cargoSigla,
      required String cargoNome,
      required bool titular,
      required int contagem,
    });
typedef $$ElectionsCargosTableTableUpdateCompanionBuilder =
    ElectionsCargosTableCompanion Function({
      Value<int> id,
      Value<int> electionId,
      Value<String> stateCode,
      Value<int> cargoCode,
      Value<String> cargoSigla,
      Value<String> cargoNome,
      Value<bool> titular,
      Value<int> contagem,
    });

final class $$ElectionsCargosTableTableReferences
    extends BaseReferences<_$AppDatabase, $ElectionsCargosTableTable, ElectionCargoData> {
  $$ElectionsCargosTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ElectionsTableTable _electionIdTable(_$AppDatabase db) =>
      db.electionsTable.createAlias('elections_cargos__election_id__elections__id');

  $$ElectionsTableTableProcessedTableManager get electionId {
    final $_column = $_itemColumn<int>('election_id')!;

    final manager = $$ElectionsTableTableTableManager(
      $_db,
      $_db.electionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_electionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ElectionsCargosTableTableFilterComposer
    extends Composer<_$AppDatabase, $ElectionsCargosTableTable> {
  $$ElectionsCargosTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cargoCode =>
      $composableBuilder(column: $table.cargoCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cargoSigla =>
      $composableBuilder(column: $table.cargoSigla, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cargoNome =>
      $composableBuilder(column: $table.cargoNome, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get titular =>
      $composableBuilder(column: $table.titular, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get contagem =>
      $composableBuilder(column: $table.contagem, builder: (column) => ColumnFilters(column));

  $$ElectionsTableTableFilterComposer get electionId {
    final $$ElectionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.electionsTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ElectionsTableTableFilterComposer(
            $db: $db,
            $table: $db.electionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ElectionsCargosTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ElectionsCargosTableTable> {
  $$ElectionsCargosTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cargoCode =>
      $composableBuilder(column: $table.cargoCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cargoSigla =>
      $composableBuilder(column: $table.cargoSigla, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cargoNome =>
      $composableBuilder(column: $table.cargoNome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get titular =>
      $composableBuilder(column: $table.titular, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get contagem =>
      $composableBuilder(column: $table.contagem, builder: (column) => ColumnOrderings(column));

  $$ElectionsTableTableOrderingComposer get electionId {
    final $$ElectionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.electionsTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ElectionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.electionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ElectionsCargosTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ElectionsCargosTableTable> {
  $$ElectionsCargosTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<int> get cargoCode =>
      $composableBuilder(column: $table.cargoCode, builder: (column) => column);

  GeneratedColumn<String> get cargoSigla =>
      $composableBuilder(column: $table.cargoSigla, builder: (column) => column);

  GeneratedColumn<String> get cargoNome =>
      $composableBuilder(column: $table.cargoNome, builder: (column) => column);

  GeneratedColumn<bool> get titular =>
      $composableBuilder(column: $table.titular, builder: (column) => column);

  GeneratedColumn<int> get contagem =>
      $composableBuilder(column: $table.contagem, builder: (column) => column);

  $$ElectionsTableTableAnnotationComposer get electionId {
    final $$ElectionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.electionsTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ElectionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.electionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ElectionsCargosTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ElectionsCargosTableTable,
          ElectionCargoData,
          $$ElectionsCargosTableTableFilterComposer,
          $$ElectionsCargosTableTableOrderingComposer,
          $$ElectionsCargosTableTableAnnotationComposer,
          $$ElectionsCargosTableTableCreateCompanionBuilder,
          $$ElectionsCargosTableTableUpdateCompanionBuilder,
          (ElectionCargoData, $$ElectionsCargosTableTableReferences),
          ElectionCargoData,
          PrefetchHooks Function({bool electionId})
        > {
  $$ElectionsCargosTableTableTableManager(_$AppDatabase db, $ElectionsCargosTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ElectionsCargosTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ElectionsCargosTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ElectionsCargosTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> electionId = const Value.absent(),
                Value<String> stateCode = const Value.absent(),
                Value<int> cargoCode = const Value.absent(),
                Value<String> cargoSigla = const Value.absent(),
                Value<String> cargoNome = const Value.absent(),
                Value<bool> titular = const Value.absent(),
                Value<int> contagem = const Value.absent(),
              }) => ElectionsCargosTableCompanion(
                id: id,
                electionId: electionId,
                stateCode: stateCode,
                cargoCode: cargoCode,
                cargoSigla: cargoSigla,
                cargoNome: cargoNome,
                titular: titular,
                contagem: contagem,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int electionId,
                required String stateCode,
                required int cargoCode,
                required String cargoSigla,
                required String cargoNome,
                required bool titular,
                required int contagem,
              }) => ElectionsCargosTableCompanion.insert(
                id: id,
                electionId: electionId,
                stateCode: stateCode,
                cargoCode: cargoCode,
                cargoSigla: cargoSigla,
                cargoNome: cargoNome,
                titular: titular,
                contagem: contagem,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $$ElectionsCargosTableTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({electionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (electionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.electionId,
                                referencedTable: $$ElectionsCargosTableTableReferences
                                    ._electionIdTable(db),
                                referencedColumn: $$ElectionsCargosTableTableReferences
                                    ._electionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ElectionsCargosTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ElectionsCargosTableTable,
      ElectionCargoData,
      $$ElectionsCargosTableTableFilterComposer,
      $$ElectionsCargosTableTableOrderingComposer,
      $$ElectionsCargosTableTableAnnotationComposer,
      $$ElectionsCargosTableTableCreateCompanionBuilder,
      $$ElectionsCargosTableTableUpdateCompanionBuilder,
      (ElectionCargoData, $$ElectionsCargosTableTableReferences),
      ElectionCargoData,
      PrefetchHooks Function({bool electionId})
    >;
typedef $$CandidatesTableTableCreateCompanionBuilder =
    CandidatesTableCompanion Function({
      Value<int> id,
      required int electionId,
      required String stateCode,
      Value<int?> cityCode,
      required int roleCode,
      required String roleDescription,
      required int ballotNumber,
      required String ballotName,
      required String fullName,
      required int partyNumber,
      required String partyAcronym,
      required String partyName,
      required String coalitionName,
      required String coalitionComp,
      required String status,
      required String rawStatus,
      required double totalAssets,
      required String photoUrl,
      Value<String?> localPhotoPath,
      Value<int?> parentCandidateId,
      Value<String?> birthDate,
      Value<String?> gender,
      Value<String?> colorRace,
      Value<String?> maritalStatus,
      Value<String?> educationLevel,
      Value<String?> occupation,
      Value<String?> nationality,
      Value<String?> birthCity,
      Value<String?> birthState,
      Value<double?> maxExpense1t,
      Value<double?> maxExpense2t,
      Value<String?> proposalDocUrl,
      Value<String?> campaignCnpj,
      Value<bool> detailFetched,
    });
typedef $$CandidatesTableTableUpdateCompanionBuilder =
    CandidatesTableCompanion Function({
      Value<int> id,
      Value<int> electionId,
      Value<String> stateCode,
      Value<int?> cityCode,
      Value<int> roleCode,
      Value<String> roleDescription,
      Value<int> ballotNumber,
      Value<String> ballotName,
      Value<String> fullName,
      Value<int> partyNumber,
      Value<String> partyAcronym,
      Value<String> partyName,
      Value<String> coalitionName,
      Value<String> coalitionComp,
      Value<String> status,
      Value<String> rawStatus,
      Value<double> totalAssets,
      Value<String> photoUrl,
      Value<String?> localPhotoPath,
      Value<int?> parentCandidateId,
      Value<String?> birthDate,
      Value<String?> gender,
      Value<String?> colorRace,
      Value<String?> maritalStatus,
      Value<String?> educationLevel,
      Value<String?> occupation,
      Value<String?> nationality,
      Value<String?> birthCity,
      Value<String?> birthState,
      Value<double?> maxExpense1t,
      Value<double?> maxExpense2t,
      Value<String?> proposalDocUrl,
      Value<String?> campaignCnpj,
      Value<bool> detailFetched,
    });

final class $$CandidatesTableTableReferences
    extends BaseReferences<_$AppDatabase, $CandidatesTableTable, CandidateData> {
  $$CandidatesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ElectionsTableTable _electionIdTable(_$AppDatabase db) =>
      db.electionsTable.createAlias('candidates__election_id__elections__id');

  $$ElectionsTableTableProcessedTableManager get electionId {
    final $_column = $_itemColumn<int>('election_id')!;

    final manager = $$ElectionsTableTableTableManager(
      $_db,
      $_db.electionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_electionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CandidatesTableTable _parentCandidateIdTable(_$AppDatabase db) =>
      db.candidatesTable.createAlias('candidates__parent_candidate_id__candidates__id');

  $$CandidatesTableTableProcessedTableManager? get parentCandidateId {
    final $_column = $_itemColumn<int>('parent_candidate_id');
    if ($_column == null) return null;
    final manager = $$CandidatesTableTableTableManager(
      $_db,
      $_db.candidatesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentCandidateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$CandidateAssetsTableTable, List<CandidateAssetData>>
  _candidateAssetsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.candidateAssetsTable,
    aliasName: 'candidates__id__candidate_assets__candidate_id',
  );

  $$CandidateAssetsTableTableProcessedTableManager get candidateAssetsTableRefs {
    final manager = $$CandidateAssetsTableTableTableManager(
      $_db,
      $_db.candidateAssetsTable,
    ).filter((f) => f.candidateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_candidateAssetsTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CandidatesTableTableFilterComposer extends Composer<_$AppDatabase, $CandidatesTableTable> {
  $$CandidatesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cityCode =>
      $composableBuilder(column: $table.cityCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get roleCode =>
      $composableBuilder(column: $table.roleCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get roleDescription => $composableBuilder(
    column: $table.roleDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ballotNumber =>
      $composableBuilder(column: $table.ballotNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ballotName =>
      $composableBuilder(column: $table.ballotName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get partyNumber =>
      $composableBuilder(column: $table.partyNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partyAcronym =>
      $composableBuilder(column: $table.partyAcronym, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partyName =>
      $composableBuilder(column: $table.partyName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coalitionName =>
      $composableBuilder(column: $table.coalitionName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coalitionComp =>
      $composableBuilder(column: $table.coalitionComp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawStatus =>
      $composableBuilder(column: $table.rawStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAssets =>
      $composableBuilder(column: $table.totalAssets, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPhotoPath =>
      $composableBuilder(column: $table.localPhotoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorRace =>
      $composableBuilder(column: $table.colorRace, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get maritalStatus =>
      $composableBuilder(column: $table.maritalStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get educationLevel =>
      $composableBuilder(column: $table.educationLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get occupation =>
      $composableBuilder(column: $table.occupation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nationality =>
      $composableBuilder(column: $table.nationality, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get birthCity =>
      $composableBuilder(column: $table.birthCity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get birthState =>
      $composableBuilder(column: $table.birthState, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxExpense1t =>
      $composableBuilder(column: $table.maxExpense1t, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxExpense2t =>
      $composableBuilder(column: $table.maxExpense2t, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get proposalDocUrl =>
      $composableBuilder(column: $table.proposalDocUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get campaignCnpj =>
      $composableBuilder(column: $table.campaignCnpj, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get detailFetched =>
      $composableBuilder(column: $table.detailFetched, builder: (column) => ColumnFilters(column));

  $$ElectionsTableTableFilterComposer get electionId {
    final $$ElectionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.electionsTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ElectionsTableTableFilterComposer(
            $db: $db,
            $table: $db.electionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CandidatesTableTableFilterComposer get parentCandidateId {
    final $$CandidatesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentCandidateId,
      referencedTable: $db.candidatesTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CandidatesTableTableFilterComposer(
            $db: $db,
            $table: $db.candidatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> candidateAssetsTableRefs(
    Expression<bool> Function($$CandidateAssetsTableTableFilterComposer f) f,
  ) {
    final $$CandidateAssetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.candidateAssetsTable,
      getReferencedColumn: (t) => t.candidateId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CandidateAssetsTableTableFilterComposer(
            $db: $db,
            $table: $db.candidateAssetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CandidatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CandidatesTableTable> {
  $$CandidatesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cityCode =>
      $composableBuilder(column: $table.cityCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get roleCode =>
      $composableBuilder(column: $table.roleCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get roleDescription => $composableBuilder(
    column: $table.roleDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ballotNumber =>
      $composableBuilder(column: $table.ballotNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ballotName =>
      $composableBuilder(column: $table.ballotName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get partyNumber =>
      $composableBuilder(column: $table.partyNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partyAcronym =>
      $composableBuilder(column: $table.partyAcronym, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partyName =>
      $composableBuilder(column: $table.partyName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coalitionName => $composableBuilder(
    column: $table.coalitionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coalitionComp => $composableBuilder(
    column: $table.coalitionComp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawStatus =>
      $composableBuilder(column: $table.rawStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAssets =>
      $composableBuilder(column: $table.totalAssets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPhotoPath => $composableBuilder(
    column: $table.localPhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorRace =>
      $composableBuilder(column: $table.colorRace, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get maritalStatus => $composableBuilder(
    column: $table.maritalStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get educationLevel => $composableBuilder(
    column: $table.educationLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation =>
      $composableBuilder(column: $table.occupation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nationality =>
      $composableBuilder(column: $table.nationality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get birthCity =>
      $composableBuilder(column: $table.birthCity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get birthState =>
      $composableBuilder(column: $table.birthState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxExpense1t =>
      $composableBuilder(column: $table.maxExpense1t, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxExpense2t =>
      $composableBuilder(column: $table.maxExpense2t, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get proposalDocUrl => $composableBuilder(
    column: $table.proposalDocUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get campaignCnpj =>
      $composableBuilder(column: $table.campaignCnpj, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get detailFetched => $composableBuilder(
    column: $table.detailFetched,
    builder: (column) => ColumnOrderings(column),
  );

  $$ElectionsTableTableOrderingComposer get electionId {
    final $$ElectionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.electionsTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ElectionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.electionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CandidatesTableTableOrderingComposer get parentCandidateId {
    final $$CandidatesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentCandidateId,
      referencedTable: $db.candidatesTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CandidatesTableTableOrderingComposer(
            $db: $db,
            $table: $db.candidatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CandidatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CandidatesTableTable> {
  $$CandidatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<int> get cityCode =>
      $composableBuilder(column: $table.cityCode, builder: (column) => column);

  GeneratedColumn<int> get roleCode =>
      $composableBuilder(column: $table.roleCode, builder: (column) => column);

  GeneratedColumn<String> get roleDescription =>
      $composableBuilder(column: $table.roleDescription, builder: (column) => column);

  GeneratedColumn<int> get ballotNumber =>
      $composableBuilder(column: $table.ballotNumber, builder: (column) => column);

  GeneratedColumn<String> get ballotName =>
      $composableBuilder(column: $table.ballotName, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<int> get partyNumber =>
      $composableBuilder(column: $table.partyNumber, builder: (column) => column);

  GeneratedColumn<String> get partyAcronym =>
      $composableBuilder(column: $table.partyAcronym, builder: (column) => column);

  GeneratedColumn<String> get partyName =>
      $composableBuilder(column: $table.partyName, builder: (column) => column);

  GeneratedColumn<String> get coalitionName =>
      $composableBuilder(column: $table.coalitionName, builder: (column) => column);

  GeneratedColumn<String> get coalitionComp =>
      $composableBuilder(column: $table.coalitionComp, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get rawStatus =>
      $composableBuilder(column: $table.rawStatus, builder: (column) => column);

  GeneratedColumn<double> get totalAssets =>
      $composableBuilder(column: $table.totalAssets, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get localPhotoPath =>
      $composableBuilder(column: $table.localPhotoPath, builder: (column) => column);

  GeneratedColumn<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get colorRace =>
      $composableBuilder(column: $table.colorRace, builder: (column) => column);

  GeneratedColumn<String> get maritalStatus =>
      $composableBuilder(column: $table.maritalStatus, builder: (column) => column);

  GeneratedColumn<String> get educationLevel =>
      $composableBuilder(column: $table.educationLevel, builder: (column) => column);

  GeneratedColumn<String> get occupation =>
      $composableBuilder(column: $table.occupation, builder: (column) => column);

  GeneratedColumn<String> get nationality =>
      $composableBuilder(column: $table.nationality, builder: (column) => column);

  GeneratedColumn<String> get birthCity =>
      $composableBuilder(column: $table.birthCity, builder: (column) => column);

  GeneratedColumn<String> get birthState =>
      $composableBuilder(column: $table.birthState, builder: (column) => column);

  GeneratedColumn<double> get maxExpense1t =>
      $composableBuilder(column: $table.maxExpense1t, builder: (column) => column);

  GeneratedColumn<double> get maxExpense2t =>
      $composableBuilder(column: $table.maxExpense2t, builder: (column) => column);

  GeneratedColumn<String> get proposalDocUrl =>
      $composableBuilder(column: $table.proposalDocUrl, builder: (column) => column);

  GeneratedColumn<String> get campaignCnpj =>
      $composableBuilder(column: $table.campaignCnpj, builder: (column) => column);

  GeneratedColumn<bool> get detailFetched =>
      $composableBuilder(column: $table.detailFetched, builder: (column) => column);

  $$ElectionsTableTableAnnotationComposer get electionId {
    final $$ElectionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.electionsTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ElectionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.electionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CandidatesTableTableAnnotationComposer get parentCandidateId {
    final $$CandidatesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentCandidateId,
      referencedTable: $db.candidatesTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CandidatesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.candidatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> candidateAssetsTableRefs<T extends Object>(
    Expression<T> Function($$CandidateAssetsTableTableAnnotationComposer a) f,
  ) {
    final $$CandidateAssetsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.candidateAssetsTable,
      getReferencedColumn: (t) => t.candidateId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CandidateAssetsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.candidateAssetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CandidatesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CandidatesTableTable,
          CandidateData,
          $$CandidatesTableTableFilterComposer,
          $$CandidatesTableTableOrderingComposer,
          $$CandidatesTableTableAnnotationComposer,
          $$CandidatesTableTableCreateCompanionBuilder,
          $$CandidatesTableTableUpdateCompanionBuilder,
          (CandidateData, $$CandidatesTableTableReferences),
          CandidateData,
          PrefetchHooks Function({
            bool electionId,
            bool parentCandidateId,
            bool candidateAssetsTableRefs,
          })
        > {
  $$CandidatesTableTableTableManager(_$AppDatabase db, $CandidatesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CandidatesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CandidatesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CandidatesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> electionId = const Value.absent(),
                Value<String> stateCode = const Value.absent(),
                Value<int?> cityCode = const Value.absent(),
                Value<int> roleCode = const Value.absent(),
                Value<String> roleDescription = const Value.absent(),
                Value<int> ballotNumber = const Value.absent(),
                Value<String> ballotName = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<int> partyNumber = const Value.absent(),
                Value<String> partyAcronym = const Value.absent(),
                Value<String> partyName = const Value.absent(),
                Value<String> coalitionName = const Value.absent(),
                Value<String> coalitionComp = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> rawStatus = const Value.absent(),
                Value<double> totalAssets = const Value.absent(),
                Value<String> photoUrl = const Value.absent(),
                Value<String?> localPhotoPath = const Value.absent(),
                Value<int?> parentCandidateId = const Value.absent(),
                Value<String?> birthDate = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> colorRace = const Value.absent(),
                Value<String?> maritalStatus = const Value.absent(),
                Value<String?> educationLevel = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> nationality = const Value.absent(),
                Value<String?> birthCity = const Value.absent(),
                Value<String?> birthState = const Value.absent(),
                Value<double?> maxExpense1t = const Value.absent(),
                Value<double?> maxExpense2t = const Value.absent(),
                Value<String?> proposalDocUrl = const Value.absent(),
                Value<String?> campaignCnpj = const Value.absent(),
                Value<bool> detailFetched = const Value.absent(),
              }) => CandidatesTableCompanion(
                id: id,
                electionId: electionId,
                stateCode: stateCode,
                cityCode: cityCode,
                roleCode: roleCode,
                roleDescription: roleDescription,
                ballotNumber: ballotNumber,
                ballotName: ballotName,
                fullName: fullName,
                partyNumber: partyNumber,
                partyAcronym: partyAcronym,
                partyName: partyName,
                coalitionName: coalitionName,
                coalitionComp: coalitionComp,
                status: status,
                rawStatus: rawStatus,
                totalAssets: totalAssets,
                photoUrl: photoUrl,
                localPhotoPath: localPhotoPath,
                parentCandidateId: parentCandidateId,
                birthDate: birthDate,
                gender: gender,
                colorRace: colorRace,
                maritalStatus: maritalStatus,
                educationLevel: educationLevel,
                occupation: occupation,
                nationality: nationality,
                birthCity: birthCity,
                birthState: birthState,
                maxExpense1t: maxExpense1t,
                maxExpense2t: maxExpense2t,
                proposalDocUrl: proposalDocUrl,
                campaignCnpj: campaignCnpj,
                detailFetched: detailFetched,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int electionId,
                required String stateCode,
                Value<int?> cityCode = const Value.absent(),
                required int roleCode,
                required String roleDescription,
                required int ballotNumber,
                required String ballotName,
                required String fullName,
                required int partyNumber,
                required String partyAcronym,
                required String partyName,
                required String coalitionName,
                required String coalitionComp,
                required String status,
                required String rawStatus,
                required double totalAssets,
                required String photoUrl,
                Value<String?> localPhotoPath = const Value.absent(),
                Value<int?> parentCandidateId = const Value.absent(),
                Value<String?> birthDate = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> colorRace = const Value.absent(),
                Value<String?> maritalStatus = const Value.absent(),
                Value<String?> educationLevel = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> nationality = const Value.absent(),
                Value<String?> birthCity = const Value.absent(),
                Value<String?> birthState = const Value.absent(),
                Value<double?> maxExpense1t = const Value.absent(),
                Value<double?> maxExpense2t = const Value.absent(),
                Value<String?> proposalDocUrl = const Value.absent(),
                Value<String?> campaignCnpj = const Value.absent(),
                Value<bool> detailFetched = const Value.absent(),
              }) => CandidatesTableCompanion.insert(
                id: id,
                electionId: electionId,
                stateCode: stateCode,
                cityCode: cityCode,
                roleCode: roleCode,
                roleDescription: roleDescription,
                ballotNumber: ballotNumber,
                ballotName: ballotName,
                fullName: fullName,
                partyNumber: partyNumber,
                partyAcronym: partyAcronym,
                partyName: partyName,
                coalitionName: coalitionName,
                coalitionComp: coalitionComp,
                status: status,
                rawStatus: rawStatus,
                totalAssets: totalAssets,
                photoUrl: photoUrl,
                localPhotoPath: localPhotoPath,
                parentCandidateId: parentCandidateId,
                birthDate: birthDate,
                gender: gender,
                colorRace: colorRace,
                maritalStatus: maritalStatus,
                educationLevel: educationLevel,
                occupation: occupation,
                nationality: nationality,
                birthCity: birthCity,
                birthState: birthState,
                maxExpense1t: maxExpense1t,
                maxExpense2t: maxExpense2t,
                proposalDocUrl: proposalDocUrl,
                campaignCnpj: campaignCnpj,
                detailFetched: detailFetched,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $$CandidatesTableTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback:
              ({electionId = false, parentCandidateId = false, candidateAssetsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (candidateAssetsTableRefs) db.candidateAssetsTable],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (electionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.electionId,
                                    referencedTable: $$CandidatesTableTableReferences
                                        ._electionIdTable(db),
                                    referencedColumn: $$CandidatesTableTableReferences
                                        ._electionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (parentCandidateId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentCandidateId,
                                    referencedTable: $$CandidatesTableTableReferences
                                        ._parentCandidateIdTable(db),
                                    referencedColumn: $$CandidatesTableTableReferences
                                        ._parentCandidateIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (candidateAssetsTableRefs)
                        await $_getPrefetchedData<
                          CandidateData,
                          $CandidatesTableTable,
                          CandidateAssetData
                        >(
                          currentTable: table,
                          referencedTable: $$CandidatesTableTableReferences
                              ._candidateAssetsTableRefsTable(db),
                          managerFromTypedResult: (p0) => $$CandidatesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).candidateAssetsTableRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.candidateId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CandidatesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CandidatesTableTable,
      CandidateData,
      $$CandidatesTableTableFilterComposer,
      $$CandidatesTableTableOrderingComposer,
      $$CandidatesTableTableAnnotationComposer,
      $$CandidatesTableTableCreateCompanionBuilder,
      $$CandidatesTableTableUpdateCompanionBuilder,
      (CandidateData, $$CandidatesTableTableReferences),
      CandidateData,
      PrefetchHooks Function({
        bool electionId,
        bool parentCandidateId,
        bool candidateAssetsTableRefs,
      })
    >;
typedef $$CandidateAssetsTableTableCreateCompanionBuilder =
    CandidateAssetsTableCompanion Function({
      Value<int> id,
      required int candidateId,
      required int orderIndex,
      required String category,
      required String description,
      required double amount,
      required String updatedAt,
    });
typedef $$CandidateAssetsTableTableUpdateCompanionBuilder =
    CandidateAssetsTableCompanion Function({
      Value<int> id,
      Value<int> candidateId,
      Value<int> orderIndex,
      Value<String> category,
      Value<String> description,
      Value<double> amount,
      Value<String> updatedAt,
    });

final class $$CandidateAssetsTableTableReferences
    extends BaseReferences<_$AppDatabase, $CandidateAssetsTableTable, CandidateAssetData> {
  $$CandidateAssetsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CandidatesTableTable _candidateIdTable(_$AppDatabase db) =>
      db.candidatesTable.createAlias('candidate_assets__candidate_id__candidates__id');

  $$CandidatesTableTableProcessedTableManager get candidateId {
    final $_column = $_itemColumn<int>('candidate_id')!;

    final manager = $$CandidatesTableTableTableManager(
      $_db,
      $_db.candidatesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_candidateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CandidateAssetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CandidateAssetsTableTable> {
  $$CandidateAssetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex =>
      $composableBuilder(column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CandidatesTableTableFilterComposer get candidateId {
    final $$CandidatesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.candidateId,
      referencedTable: $db.candidatesTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CandidatesTableTableFilterComposer(
            $db: $db,
            $table: $db.candidatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CandidateAssetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CandidateAssetsTableTable> {
  $$CandidateAssetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex =>
      $composableBuilder(column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CandidatesTableTableOrderingComposer get candidateId {
    final $$CandidatesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.candidateId,
      referencedTable: $db.candidatesTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CandidatesTableTableOrderingComposer(
            $db: $db,
            $table: $db.candidatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CandidateAssetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CandidateAssetsTableTable> {
  $$CandidateAssetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex =>
      $composableBuilder(column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CandidatesTableTableAnnotationComposer get candidateId {
    final $$CandidatesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.candidateId,
      referencedTable: $db.candidatesTable,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CandidatesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.candidatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CandidateAssetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CandidateAssetsTableTable,
          CandidateAssetData,
          $$CandidateAssetsTableTableFilterComposer,
          $$CandidateAssetsTableTableOrderingComposer,
          $$CandidateAssetsTableTableAnnotationComposer,
          $$CandidateAssetsTableTableCreateCompanionBuilder,
          $$CandidateAssetsTableTableUpdateCompanionBuilder,
          (CandidateAssetData, $$CandidateAssetsTableTableReferences),
          CandidateAssetData,
          PrefetchHooks Function({bool candidateId})
        > {
  $$CandidateAssetsTableTableTableManager(_$AppDatabase db, $CandidateAssetsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CandidateAssetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CandidateAssetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CandidateAssetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> candidateId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
              }) => CandidateAssetsTableCompanion(
                id: id,
                candidateId: candidateId,
                orderIndex: orderIndex,
                category: category,
                description: description,
                amount: amount,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int candidateId,
                required int orderIndex,
                required String category,
                required String description,
                required double amount,
                required String updatedAt,
              }) => CandidateAssetsTableCompanion.insert(
                id: id,
                candidateId: candidateId,
                orderIndex: orderIndex,
                category: category,
                description: description,
                amount: amount,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $$CandidateAssetsTableTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({candidateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (candidateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.candidateId,
                                referencedTable: $$CandidateAssetsTableTableReferences
                                    ._candidateIdTable(db),
                                referencedColumn: $$CandidateAssetsTableTableReferences
                                    ._candidateIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CandidateAssetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CandidateAssetsTableTable,
      CandidateAssetData,
      $$CandidateAssetsTableTableFilterComposer,
      $$CandidateAssetsTableTableOrderingComposer,
      $$CandidateAssetsTableTableAnnotationComposer,
      $$CandidateAssetsTableTableCreateCompanionBuilder,
      $$CandidateAssetsTableTableUpdateCompanionBuilder,
      (CandidateAssetData, $$CandidateAssetsTableTableReferences),
      CandidateAssetData,
      PrefetchHooks Function({bool candidateId})
    >;
typedef $$CacheMetadataTableTableCreateCompanionBuilder =
    CacheMetadataTableCompanion Function({
      required String cacheKey,
      required String lastFetchedAt,
      required String payloadHash,
      Value<String?> etag,
      required int itemCount,
      Value<int> rowid,
    });
typedef $$CacheMetadataTableTableUpdateCompanionBuilder =
    CacheMetadataTableCompanion Function({
      Value<String> cacheKey,
      Value<String> lastFetchedAt,
      Value<String> payloadHash,
      Value<String?> etag,
      Value<int> itemCount,
      Value<int> rowid,
    });

class $$CacheMetadataTableTableFilterComposer
    extends Composer<_$AppDatabase, $CacheMetadataTableTable> {
  $$CacheMetadataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastFetchedAt =>
      $composableBuilder(column: $table.lastFetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadHash =>
      $composableBuilder(column: $table.payloadHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => ColumnFilters(column));
}

class $$CacheMetadataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheMetadataTableTable> {
  $$CacheMetadataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastFetchedAt => $composableBuilder(
    column: $table.lastFetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadHash =>
      $composableBuilder(column: $table.payloadHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => ColumnOrderings(column));
}

class $$CacheMetadataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheMetadataTableTable> {
  $$CacheMetadataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get lastFetchedAt =>
      $composableBuilder(column: $table.lastFetchedAt, builder: (column) => column);

  GeneratedColumn<String> get payloadHash =>
      $composableBuilder(column: $table.payloadHash, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);
}

class $$CacheMetadataTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CacheMetadataTableTable,
          CacheMetadataData,
          $$CacheMetadataTableTableFilterComposer,
          $$CacheMetadataTableTableOrderingComposer,
          $$CacheMetadataTableTableAnnotationComposer,
          $$CacheMetadataTableTableCreateCompanionBuilder,
          $$CacheMetadataTableTableUpdateCompanionBuilder,
          (
            CacheMetadataData,
            BaseReferences<_$AppDatabase, $CacheMetadataTableTable, CacheMetadataData>,
          ),
          CacheMetadataData,
          PrefetchHooks Function()
        > {
  $$CacheMetadataTableTableTableManager(_$AppDatabase db, $CacheMetadataTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheMetadataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheMetadataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheMetadataTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cacheKey = const Value.absent(),
                Value<String> lastFetchedAt = const Value.absent(),
                Value<String> payloadHash = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<int> itemCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheMetadataTableCompanion(
                cacheKey: cacheKey,
                lastFetchedAt: lastFetchedAt,
                payloadHash: payloadHash,
                etag: etag,
                itemCount: itemCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cacheKey,
                required String lastFetchedAt,
                required String payloadHash,
                Value<String?> etag = const Value.absent(),
                required int itemCount,
                Value<int> rowid = const Value.absent(),
              }) => CacheMetadataTableCompanion.insert(
                cacheKey: cacheKey,
                lastFetchedAt: lastFetchedAt,
                payloadHash: payloadHash,
                etag: etag,
                itemCount: itemCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheMetadataTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CacheMetadataTableTable,
      CacheMetadataData,
      $$CacheMetadataTableTableFilterComposer,
      $$CacheMetadataTableTableOrderingComposer,
      $$CacheMetadataTableTableAnnotationComposer,
      $$CacheMetadataTableTableCreateCompanionBuilder,
      $$CacheMetadataTableTableUpdateCompanionBuilder,
      (
        CacheMetadataData,
        BaseReferences<_$AppDatabase, $CacheMetadataTableTable, CacheMetadataData>,
      ),
      CacheMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ElectionsTableTableTableManager get electionsTable =>
      $$ElectionsTableTableTableManager(_db, _db.electionsTable);
  $$ElectionsCargosTableTableTableManager get electionsCargosTable =>
      $$ElectionsCargosTableTableTableManager(_db, _db.electionsCargosTable);
  $$CandidatesTableTableTableManager get candidatesTable =>
      $$CandidatesTableTableTableManager(_db, _db.candidatesTable);
  $$CandidateAssetsTableTableTableManager get candidateAssetsTable =>
      $$CandidateAssetsTableTableTableManager(_db, _db.candidateAssetsTable);
  $$CacheMetadataTableTableTableManager get cacheMetadataTable =>
      $$CacheMetadataTableTableTableManager(_db, _db.cacheMetadataTable);
}
