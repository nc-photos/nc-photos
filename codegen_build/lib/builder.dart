import 'package:build/build.dart';
import 'package:np_codegen_build/src/drift_table_sort_generator.dart';
import 'package:np_codegen_build/src/np_subject_accessor_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder driftTableSortBuilder(BuilderOptions options) =>
    SharedPartBuilder([const DriftTableSortGenerator()], "drift_table_sort");

Builder npSubjectAccessorBuilder(BuilderOptions options) => SharedPartBuilder([
  const NpSubjectAccessorGenerator(),
], "np_subject_accessor");
