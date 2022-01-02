import 'package:algolia/algolia.dart';
import 'package:flutter/foundation.dart';

//import '../secret_keys.dart';

class AlgoliaService {
  static const Algolia algolia = Algolia.init(
    applicationId: 'JLQW3TQEKQ',
    apiKey: kReleaseMode ? '38473fb58ddbd02c9560cd95d5c7d35c' : '38473fb58ddbd02c9560cd95d5c7d35c',
  );
}
