/// abstract usecase for whole app
abstract class UseCase<T , Params>{
  T call(Params params);
}