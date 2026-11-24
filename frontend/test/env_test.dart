import 'package:fitcheck/core/constants/env.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('apiBaseUrl always ends with a slash', () {
    dotenv.loadFromString(envString: 'API_BASE_URL=http://host:5232/api');
    expect(Env.apiBaseUrl, 'http://host:5232/api/');

    dotenv.loadFromString(envString: 'API_BASE_URL=http://host:5232/api/');
    expect(Env.apiBaseUrl, 'http://host:5232/api/');
  });

  test('default apiBaseUrl joins with relative paths', () {
    dotenv.loadFromString(isOptional: true);
    expect(
      Uri.parse(Env.apiBaseUrl).resolve('auth/login').toString(),
      'http://10.0.2.2:5232/api/auth/login',
    );
  });
}
