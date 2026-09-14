import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase - Inicializacao e Integridade Referencial', () {
    test('deve habilitar compulsoriamente PRAGMA foreign_keys = ON', () async {
      final result = await db.customSelect('PRAGMA foreign_keys;').getSingle();
      final foreignKeysStatus = result.data['foreign_keys'];
      expect(foreignKeysStatus, equals(1));
    });

    test('deve rejeitar insercao de candidato com election_id inexistente (FK)', () async {
      final candidateCompanion = CandidatesTableCompanion.insert(
        id: const Value(1001),
        electionId: 99999999999, // Inexistente na tabela elections
        stateCode: 'BR',
        roleCode: 1,
        roleDescription: 'PRESIDENTE',
        ballotNumber: 99,
        ballotName: 'CANDIDATO FANTASMA',
        fullName: 'CANDIDATO TESTE FANTASMA',
        partyNumber: 99,
        partyAcronym: 'PTST',
        partyName: 'PARTIDO TESTE',
        coalitionName: 'COLIGACAO TESTE',
        coalitionComp: 'PTST',
        status: 'DEFERRED',
        rawStatus: 'DEFERIDO',
        totalAssets: 0.0,
        photoUrl: 'https://exemplo.tse.jus.br/foto.jpg',
      );

      expect(
        () => db.into(db.candidatesTable).insert(candidateCompanion),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('AppDatabase - ElectionsTable (Pleitos Eleitorais)', () {
    test('deve inserir e recuperar registro de eleicao oficial', () async {
      const electionId = 20322002026;
      final electionCompanion = ElectionsTableCompanion.insert(
        id: const Value(electionId),
        ano: 2026,
        nome: 'Eleicao Geral Federal 2026',
        descricao: 'Eleicoes Gerais Ordinarias 2026',
        tipo: 'Ordinaria',
        abrangencia: 'F',
        turno: 1,
        dataEleicao: '04/10/2026',
        situacao: 'Aberta',
      );

      await db.into(db.electionsTable).insert(electionCompanion);

      final query = db.select(db.electionsTable)..where((tbl) => tbl.id.equals(electionId));
      final election = await query.getSingle();

      expect(election.id, equals(electionId));
      expect(election.ano, equals(2026));
      expect(election.nome, equals('Eleicao Geral Federal 2026'));
      expect(election.abrangencia, equals('F'));
      expect(election.turno, equals(1));
    });
  });

  group('AppDatabase - ElectionsCargosTable (Cargos Disponiveis)', () {
    test('deve inserir e consultar cargos vinculados a eleicao por UF', () async {
      const electionId = 20322002026;
      await _insertFakeElection(db, electionId);

      final cargoCompanion = ElectionsCargosTableCompanion.insert(
        electionId: electionId,
        stateCode: 'BR',
        cargoCode: 1,
        cargoSigla: 'P',
        cargoNome: 'Presidente',
        titular: true,
        contagem: 12,
      );

      await db.into(db.electionsCargosTable).insert(cargoCompanion);

      final query = db.select(db.electionsCargosTable)
        ..where((tbl) => tbl.electionId.equals(electionId) & tbl.stateCode.equals('BR'));
      final cargos = await query.get();

      expect(cargos.length, equals(1));
      expect(cargos.first.cargoCode, equals(1));
      expect(cargos.first.cargoNome, equals('Presidente'));
      expect(cargos.first.titular, isTrue);
      expect(cargos.first.contagem, equals(12));
    });
  });

  group('AppDatabase - CandidatesTable (Candidaturas e Detalhes)', () {
    const electionId = 20322002026;
    const candidateId = 280001607833;
    const viceId = 280001607834;

    setUp(() async {
      await _insertFakeElection(db, electionId);
    });

    test('deve inserir candidato titular e vice via chave auto-referencial', () async {
      final titularCompanion = CandidatesTableCompanion.insert(
        id: const Value(candidateId),
        electionId: electionId,
        stateCode: 'BR',
        roleCode: 1,
        roleDescription: 'PRESIDENTE',
        ballotNumber: 13,
        ballotName: 'LULA',
        fullName: 'LUIZ INACIO LULA DA SILVA',
        partyNumber: 13,
        partyAcronym: 'PT',
        partyName: 'PARTIDO DOS TRABALHADORES',
        coalitionName: 'BRASIL DA ESPERANCA',
        coalitionComp: 'FE BRASIL (PT/PC do B/PV) / SOLIDARIEDADE',
        status: 'DEFERRED',
        rawStatus: 'DEFERIDO',
        totalAssets: 7423625.38,
        photoUrl: 'https://exemplo.tse.jus.br/foto_lula.jpg',
      );
      await db.into(db.candidatesTable).insert(titularCompanion);

      final viceCompanion = CandidatesTableCompanion.insert(
        id: const Value(viceId),
        electionId: electionId,
        stateCode: 'BR',
        roleCode: 2,
        roleDescription: 'VICE-PRESIDENTE',
        ballotNumber: 13,
        ballotName: 'GERALDO ALCKMIN',
        fullName: 'GERALDO JOSE RODRIGUES ALCKMIN FILHO',
        partyNumber: 40,
        partyAcronym: 'PSB',
        partyName: 'PARTIDO SOCIALISTA BRASILEIRO',
        coalitionName: 'BRASIL DA ESPERANCA',
        coalitionComp: 'FE BRASIL (PT/PC do B/PV) / SOLIDARIEDADE',
        status: 'DEFERRED',
        rawStatus: 'DEFERIDO',
        totalAssets: 3000000.00,
        photoUrl: 'https://exemplo.tse.jus.br/foto_alckmin.jpg',
        parentCandidateId: const Value(candidateId),
      );
      await db.into(db.candidatesTable).insert(viceCompanion);

      final viceQuery = db.select(db.candidatesTable)
        ..where((tbl) => tbl.parentCandidateId.equals(candidateId));
      final vices = await viceQuery.get();

      expect(vices.length, equals(1));
      expect(vices.first.id, equals(viceId));
      expect(vices.first.ballotName, equals('GERALDO ALCKMIN'));
      expect(vices.first.parentCandidateId, equals(candidateId));
    });

    test('deve atualizar atributos detalhados sob demanda marcando detail_fetched', () async {
      await _insertTitularCandidate(db, candidateId, electionId);

      const updateCompanion = CandidatesTableCompanion(
        birthDate: Value('27/10/1945'),
        gender: Value('MASCULINO'),
        educationLevel: Value('ENSINO FUNDAMENTAL INCOMPLETO'),
        occupation: Value('APOSENTADO (EXCETO SERVIDOR PUBLICO)'),
        campaignCnpj: Value('47.584.288/0001-00'),
        detailFetched: Value(true),
      );

      final rowsAffected = await (db.update(
        db.candidatesTable,
      )..where((tbl) => tbl.id.equals(candidateId))).write(updateCompanion);

      expect(rowsAffected, equals(1));

      final updated = await (db.select(
        db.candidatesTable,
      )..where((tbl) => tbl.id.equals(candidateId))).getSingle();

      expect(updated.birthDate, equals('27/10/1945'));
      expect(updated.gender, equals('MASCULINO'));
      expect(updated.detailFetched, isTrue);
      expect(updated.campaignCnpj, equals('47.584.288/0001-00'));
    });
  });

  group('AppDatabase - CandidateAssetsTable (Bens Declarados)', () {
    const electionId = 20322002026;
    const candidateId = 280001607833;

    setUp(() async {
      await _insertFakeElection(db, electionId);
      await _insertTitularCandidate(db, candidateId, electionId);
    });

    test('deve persistir bens e recuperar ordenados decrescentemente por valor venal', () async {
      await db
          .into(db.candidateAssetsTable)
          .insert(
            CandidateAssetsTableCompanion.insert(
              candidateId: candidateId,
              orderIndex: 1,
              category: 'APARTAMENTO',
              description: 'Apartamento em Sao Bernardo do Campo',
              amount: 500000.0,
              updatedAt: '15/08/2026',
            ),
          );

      await db
          .into(db.candidateAssetsTable)
          .insert(
            CandidateAssetsTableCompanion.insert(
              candidateId: candidateId,
              orderIndex: 2,
              category: 'PLANO DE PREVIDENCIA PRIVADA',
              description: 'VGBL Bradesco Vida e Previdencia',
              amount: 5500000.0,
              updatedAt: '15/08/2026',
            ),
          );

      final query = db.select(db.candidateAssetsTable)
        ..where((tbl) => tbl.candidateId.equals(candidateId))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.amount)]);

      final assets = await query.get();

      expect(assets.length, equals(2));
      expect(assets.first.amount, equals(5500000.0));
      expect(assets.first.category, equals('PLANO DE PREVIDENCIA PRIVADA'));
      expect(assets.last.amount, equals(500000.0));
    });
  });

  group('AppDatabase - CacheMetadataTable (Politica SWR)', () {
    test('deve inserir, atualizar payloadHash e recuperar metadados de cache', () async {
      const cacheKey = '2026_BR_20322002026_1';
      final initialCompanion = CacheMetadataTableCompanion.insert(
        cacheKey: cacheKey,
        lastFetchedAt: '2026-09-13T10:00:00Z',
        payloadHash: 'hash_inicial_sha256',
        itemCount: 12,
        etag: const Value('W/"123456"'),
      );

      await db.into(db.cacheMetadataTable).insert(initialCompanion);

      final initial = await (db.select(
        db.cacheMetadataTable,
      )..where((tbl) => tbl.cacheKey.equals(cacheKey))).getSingle();

      expect(initial.payloadHash, equals('hash_inicial_sha256'));
      expect(initial.itemCount, equals(12));

      // Atualizacao apos novo fetch SWR
      await (db.update(db.cacheMetadataTable)..where((tbl) => tbl.cacheKey.equals(cacheKey))).write(
        const CacheMetadataTableCompanion(
          lastFetchedAt: Value('2026-09-13T11:00:00Z'),
          payloadHash: Value('hash_atualizado_sha256'),
        ),
      );

      final updated = await (db.select(
        db.cacheMetadataTable,
      )..where((tbl) => tbl.cacheKey.equals(cacheKey))).getSingle();

      expect(updated.payloadHash, equals('hash_atualizado_sha256'));
      expect(updated.lastFetchedAt, equals('2026-09-13T11:00:00Z'));
      expect(updated.itemCount, equals(12));
    });
  });
}

Future<void> _insertFakeElection(AppDatabase db, int electionId) async {
  await db
      .into(db.electionsTable)
      .insert(
        ElectionsTableCompanion.insert(
          id: Value(electionId),
          ano: 2026,
          nome: 'Eleicao Geral Federal 2026',
          descricao: 'Eleicoes Gerais Ordinarias 2026',
          tipo: 'Ordinaria',
          abrangencia: 'F',
          turno: 1,
          dataEleicao: '04/10/2026',
          situacao: 'Aberta',
        ),
      );
}

Future<void> _insertTitularCandidate(AppDatabase db, int candidateId, int electionId) async {
  await db
      .into(db.candidatesTable)
      .insert(
        CandidatesTableCompanion.insert(
          id: Value(candidateId),
          electionId: electionId,
          stateCode: 'BR',
          roleCode: 1,
          roleDescription: 'PRESIDENTE',
          ballotNumber: 13,
          ballotName: 'LULA',
          fullName: 'LUIZ INACIO LULA DA SILVA',
          partyNumber: 13,
          partyAcronym: 'PT',
          partyName: 'PARTIDO DOS TRABALHADORES',
          coalitionName: 'BRASIL DA ESPERANCA',
          coalitionComp: 'FE BRASIL (PT/PC do B/PV) / SOLIDARIEDADE',
          status: 'DEFERRED',
          rawStatus: 'DEFERIDO',
          totalAssets: 7423625.38,
          photoUrl: 'https://exemplo.tse.jus.br/foto_lula.jpg',
        ),
      );
}
