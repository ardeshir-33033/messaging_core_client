const bool kIsProduction = String.fromEnvironment("BUILD_TYPE") == "PRODUCTION";
const bool kIsStage = String.fromEnvironment("BUILD_TYPE") == "STAGE";
const bool kIsDevelop = String.fromEnvironment("BUILD_TYPE") == "DEVELOP";
