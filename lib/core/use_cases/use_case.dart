import 'package:fpdart/fpdart.dart';
import 'package:journal_local_app/core/error/failure.dart';

abstract interface class UseCase<SuccessType,Params>{
  Future<Either<Failure,SuccessType>> call(Params params);
}

class NoParams{}