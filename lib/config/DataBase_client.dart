import 'package:supabase/supabase.dart';
import 'package:dotenv/dotenv.dart';

final env = DotEnv()..load();

final supabase = SupabaseClient(
  env['Database_Url']!,
  env['Database_Key']!,
);