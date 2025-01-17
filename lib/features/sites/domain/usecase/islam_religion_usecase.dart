import 'package:dartz/dartz.dart';
import 'package:hiwayda_oracion_islamica/features/sites/domain/entities/media_entity.dart';
import '../../../../core/errors/failures.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../entities/islam_religion_entities.dart';
import '../repository/islam_religion_repository.dart';

class IslamReligionUseCase {
  final IslamReligionRepository islamReligionRepository;
  IslamReligionUseCase(
    this.islamReligionRepository,
  );

  Future<Either<Failure, List<IslamReligionEntities>>> call() async {
    Get.find<Logger>().i("Call IslamReligionUseCase");
    return islamReligionRepository.getContent();
  }
}
