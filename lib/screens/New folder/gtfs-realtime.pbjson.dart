//
//  Generated code. Do not modify.
//  source: gtfs-realtime.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use feedMessageDescriptor instead')
const FeedMessage$json = {
  '1': 'FeedMessage',
  '2': [
    {'1': 'header', '3': 1, '4': 1, '5': 11, '6': '.transit_realtime.FeedHeader', '10': 'header'},
    {'1': 'entity', '3': 2, '4': 3, '5': 11, '6': '.transit_realtime.FeedEntity', '10': 'entity'},
  ],
};

/// Descriptor for `FeedMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedMessageDescriptor = $convert.base64Decode(
    'CgtGZWVkTWVzc2FnZRI0CgZoZWFkZXIYASABKAsyHC50cmFuc2l0X3JlYWx0aW1lLkZlZWRIZW'
    'FkZXJSBmhlYWRlchI0CgZlbnRpdHkYAiADKAsyHC50cmFuc2l0X3JlYWx0aW1lLkZlZWRFbnRp'
    'dHlSBmVudGl0eQ==');

@$core.Deprecated('Use feedHeaderDescriptor instead')
const FeedHeader$json = {
  '1': 'FeedHeader',
  '2': [
    {'1': 'gtfs_realtime_version', '3': 1, '4': 1, '5': 9, '10': 'gtfsRealtimeVersion'},
    {'1': 'incrementality', '3': 2, '4': 1, '5': 14, '6': '.transit_realtime.FeedHeader.Incrementality', '10': 'incrementality'},
    {'1': 'timestamp', '3': 3, '4': 1, '5': 4, '10': 'timestamp'},
  ],
  '4': [FeedHeader_Incrementality$json],
};

@$core.Deprecated('Use feedHeaderDescriptor instead')
const FeedHeader_Incrementality$json = {
  '1': 'Incrementality',
  '2': [
    {'1': 'FULL_DATASET', '2': 0},
    {'1': 'DIFFERENTIAL', '2': 1},
  ],
};

/// Descriptor for `FeedHeader`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedHeaderDescriptor = $convert.base64Decode(
    'CgpGZWVkSGVhZGVyEjIKFWd0ZnNfcmVhbHRpbWVfdmVyc2lvbhgBIAEoCVITZ3Rmc1JlYWx0aW'
    '1lVmVyc2lvbhJTCg5pbmNyZW1lbnRhbGl0eRgCIAEoDjIrLnRyYW5zaXRfcmVhbHRpbWUuRmVl'
    'ZEhlYWRlci5JbmNyZW1lbnRhbGl0eVIOaW5jcmVtZW50YWxpdHkSHAoJdGltZXN0YW1wGAMgAS'
    'gEUgl0aW1lc3RhbXAiNAoOSW5jcmVtZW50YWxpdHkSEAoMRlVMTF9EQVRBU0VUEAASEAoMRElG'
    'RkVSRU5USUFMEAE=');

@$core.Deprecated('Use feedEntityDescriptor instead')
const FeedEntity$json = {
  '1': 'FeedEntity',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'is_deleted', '3': 2, '4': 1, '5': 8, '10': 'isDeleted'},
    {'1': 'trip_update', '3': 3, '4': 1, '5': 11, '6': '.transit_realtime.TripUpdate', '10': 'tripUpdate'},
    {'1': 'vehicle', '3': 4, '4': 1, '5': 11, '6': '.transit_realtime.VehiclePosition', '10': 'vehicle'},
    {'1': 'alert', '3': 5, '4': 1, '5': 11, '6': '.transit_realtime.Alert', '10': 'alert'},
  ],
};

/// Descriptor for `FeedEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedEntityDescriptor = $convert.base64Decode(
    'CgpGZWVkRW50aXR5Eg4KAmlkGAEgASgJUgJpZBIdCgppc19kZWxldGVkGAIgASgIUglpc0RlbG'
    'V0ZWQSPQoLdHJpcF91cGRhdGUYAyABKAsyHC50cmFuc2l0X3JlYWx0aW1lLlRyaXBVcGRhdGVS'
    'CnRyaXBVcGRhdGUSOwoHdmVoaWNsZRgEIAEoCzIhLnRyYW5zaXRfcmVhbHRpbWUuVmVoaWNsZV'
    'Bvc2l0aW9uUgd2ZWhpY2xlEi0KBWFsZXJ0GAUgASgLMhcudHJhbnNpdF9yZWFsdGltZS5BbGVy'
    'dFIFYWxlcnQ=');

@$core.Deprecated('Use tripUpdateDescriptor instead')
const TripUpdate$json = {
  '1': 'TripUpdate',
  '2': [
    {'1': 'trip', '3': 1, '4': 1, '5': 11, '6': '.transit_realtime.TripDescriptor', '10': 'trip'},
    {'1': 'vehicle', '3': 3, '4': 1, '5': 11, '6': '.transit_realtime.VehicleDescriptor', '10': 'vehicle'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 4, '10': 'timestamp'},
    {'1': 'stop_time_update', '3': 5, '4': 3, '5': 11, '6': '.transit_realtime.TripUpdate.StopTimeUpdate', '10': 'stopTimeUpdate'},
  ],
  '3': [TripUpdate_StopTimeEvent$json, TripUpdate_StopTimeUpdate$json],
};

@$core.Deprecated('Use tripUpdateDescriptor instead')
const TripUpdate_StopTimeEvent$json = {
  '1': 'StopTimeEvent',
  '2': [
    {'1': 'delay', '3': 1, '4': 1, '5': 5, '10': 'delay'},
    {'1': 'time', '3': 2, '4': 1, '5': 3, '10': 'time'},
    {'1': 'uncertainty', '3': 3, '4': 1, '5': 5, '10': 'uncertainty'},
  ],
};

@$core.Deprecated('Use tripUpdateDescriptor instead')
const TripUpdate_StopTimeUpdate$json = {
  '1': 'StopTimeUpdate',
  '2': [
    {'1': 'stop_id', '3': 1, '4': 1, '5': 9, '10': 'stopId'},
    {'1': 'arrival', '3': 2, '4': 1, '5': 11, '6': '.transit_realtime.TripUpdate.StopTimeEvent', '10': 'arrival'},
    {'1': 'departure', '3': 3, '4': 1, '5': 11, '6': '.transit_realtime.TripUpdate.StopTimeEvent', '10': 'departure'},
    {'1': 'schedule_relationship', '3': 4, '4': 1, '5': 14, '6': '.transit_realtime.TripUpdate.StopTimeUpdate.ScheduleRelationship', '10': 'scheduleRelationship'},
  ],
  '4': [TripUpdate_StopTimeUpdate_ScheduleRelationship$json],
};

@$core.Deprecated('Use tripUpdateDescriptor instead')
const TripUpdate_StopTimeUpdate_ScheduleRelationship$json = {
  '1': 'ScheduleRelationship',
  '2': [
    {'1': 'SCHEDULED', '2': 0},
    {'1': 'SKIPPED', '2': 1},
    {'1': 'NO_DATA', '2': 2},
  ],
};

/// Descriptor for `TripUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tripUpdateDescriptor = $convert.base64Decode(
    'CgpUcmlwVXBkYXRlEjQKBHRyaXAYASABKAsyIC50cmFuc2l0X3JlYWx0aW1lLlRyaXBEZXNjcm'
    'lwdG9yUgR0cmlwEj0KB3ZlaGljbGUYAyABKAsyIy50cmFuc2l0X3JlYWx0aW1lLlZlaGljbGVE'
    'ZXNjcmlwdG9yUgd2ZWhpY2xlEhwKCXRpbWVzdGFtcBgEIAEoBFIJdGltZXN0YW1wElUKEHN0b3'
    'BfdGltZV91cGRhdGUYBSADKAsyKy50cmFuc2l0X3JlYWx0aW1lLlRyaXBVcGRhdGUuU3RvcFRp'
    'bWVVcGRhdGVSDnN0b3BUaW1lVXBkYXRlGlsKDVN0b3BUaW1lRXZlbnQSFAoFZGVsYXkYASABKA'
    'VSBWRlbGF5EhIKBHRpbWUYAiABKANSBHRpbWUSIAoLdW5jZXJ0YWludHkYAyABKAVSC3VuY2Vy'
    'dGFpbnR5GvECCg5TdG9wVGltZVVwZGF0ZRIXCgdzdG9wX2lkGAEgASgJUgZzdG9wSWQSRAoHYX'
    'JyaXZhbBgCIAEoCzIqLnRyYW5zaXRfcmVhbHRpbWUuVHJpcFVwZGF0ZS5TdG9wVGltZUV2ZW50'
    'UgdhcnJpdmFsEkgKCWRlcGFydHVyZRgDIAEoCzIqLnRyYW5zaXRfcmVhbHRpbWUuVHJpcFVwZG'
    'F0ZS5TdG9wVGltZUV2ZW50UglkZXBhcnR1cmUSdQoVc2NoZWR1bGVfcmVsYXRpb25zaGlwGAQg'
    'ASgOMkAudHJhbnNpdF9yZWFsdGltZS5UcmlwVXBkYXRlLlN0b3BUaW1lVXBkYXRlLlNjaGVkdW'
    'xlUmVsYXRpb25zaGlwUhRzY2hlZHVsZVJlbGF0aW9uc2hpcCI/ChRTY2hlZHVsZVJlbGF0aW9u'
    'c2hpcBINCglTQ0hFRFVMRUQQABILCgdTS0lQUEVEEAESCwoHTk9fREFUQRAC');

@$core.Deprecated('Use vehiclePositionDescriptor instead')
const VehiclePosition$json = {
  '1': 'VehiclePosition',
  '2': [
    {'1': 'trip', '3': 1, '4': 1, '5': 11, '6': '.transit_realtime.TripDescriptor', '10': 'trip'},
    {'1': 'vehicle', '3': 2, '4': 1, '5': 11, '6': '.transit_realtime.VehicleDescriptor', '10': 'vehicle'},
    {'1': 'position', '3': 3, '4': 1, '5': 11, '6': '.transit_realtime.Position', '10': 'position'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 4, '10': 'timestamp'},
    {'1': 'congestion_level', '3': 5, '4': 1, '5': 14, '6': '.transit_realtime.VehiclePosition.CongestionLevel', '10': 'congestionLevel'},
    {'1': 'current_status', '3': 6, '4': 1, '5': 14, '6': '.transit_realtime.VehiclePosition.VehicleStopStatus', '10': 'currentStatus'},
    {'1': 'stop_id', '3': 7, '4': 1, '5': 9, '10': 'stopId'},
  ],
  '4': [VehiclePosition_VehicleStopStatus$json, VehiclePosition_CongestionLevel$json],
};

@$core.Deprecated('Use vehiclePositionDescriptor instead')
const VehiclePosition_VehicleStopStatus$json = {
  '1': 'VehicleStopStatus',
  '2': [
    {'1': 'INCOMING_AT', '2': 0},
    {'1': 'STOPPED_AT', '2': 1},
    {'1': 'IN_TRANSIT_TO', '2': 2},
  ],
};

@$core.Deprecated('Use vehiclePositionDescriptor instead')
const VehiclePosition_CongestionLevel$json = {
  '1': 'CongestionLevel',
  '2': [
    {'1': 'UNKNOWN_CONGESTION_LEVEL', '2': 0},
    {'1': 'RUNNING_SMOOTHLY', '2': 1},
    {'1': 'STOP_AND_GO', '2': 2},
    {'1': 'CONGESTION', '2': 3},
    {'1': 'SEVERE_CONGESTION', '2': 4},
  ],
};

/// Descriptor for `VehiclePosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehiclePositionDescriptor = $convert.base64Decode(
    'Cg9WZWhpY2xlUG9zaXRpb24SNAoEdHJpcBgBIAEoCzIgLnRyYW5zaXRfcmVhbHRpbWUuVHJpcE'
    'Rlc2NyaXB0b3JSBHRyaXASPQoHdmVoaWNsZRgCIAEoCzIjLnRyYW5zaXRfcmVhbHRpbWUuVmVo'
    'aWNsZURlc2NyaXB0b3JSB3ZlaGljbGUSNgoIcG9zaXRpb24YAyABKAsyGi50cmFuc2l0X3JlYW'
    'x0aW1lLlBvc2l0aW9uUghwb3NpdGlvbhIcCgl0aW1lc3RhbXAYBCABKARSCXRpbWVzdGFtcBJc'
    'ChBjb25nZXN0aW9uX2xldmVsGAUgASgOMjEudHJhbnNpdF9yZWFsdGltZS5WZWhpY2xlUG9zaX'
    'Rpb24uQ29uZ2VzdGlvbkxldmVsUg9jb25nZXN0aW9uTGV2ZWwSWgoOY3VycmVudF9zdGF0dXMY'
    'BiABKA4yMy50cmFuc2l0X3JlYWx0aW1lLlZlaGljbGVQb3NpdGlvbi5WZWhpY2xlU3RvcFN0YX'
    'R1c1INY3VycmVudFN0YXR1cxIXCgdzdG9wX2lkGAcgASgJUgZzdG9wSWQiRwoRVmVoaWNsZVN0'
    'b3BTdGF0dXMSDwoLSU5DT01JTkdfQVQQABIOCgpTVE9QUEVEX0FUEAESEQoNSU5fVFJBTlNJVF'
    '9UTxACIn0KD0Nvbmdlc3Rpb25MZXZlbBIcChhVTktOT1dOX0NPTkdFU1RJT05fTEVWRUwQABIU'
    'ChBSVU5OSU5HX1NNT09USExZEAESDwoLU1RPUF9BTkRfR08QAhIOCgpDT05HRVNUSU9OEAMSFQ'
    'oRU0VWRVJFX0NPTkdFU1RJT04QBA==');

@$core.Deprecated('Use positionDescriptor instead')
const Position$json = {
  '1': 'Position',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 2, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 2, '10': 'longitude'},
    {'1': 'bearing', '3': 3, '4': 1, '5': 2, '10': 'bearing'},
    {'1': 'odometer', '3': 4, '4': 1, '5': 2, '10': 'odometer'},
    {'1': 'speed', '3': 5, '4': 1, '5': 2, '10': 'speed'},
  ],
};

/// Descriptor for `Position`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List positionDescriptor = $convert.base64Decode(
    'CghQb3NpdGlvbhIaCghsYXRpdHVkZRgBIAEoAlIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAIgAS'
    'gCUglsb25naXR1ZGUSGAoHYmVhcmluZxgDIAEoAlIHYmVhcmluZxIaCghvZG9tZXRlchgEIAEo'
    'AlIIb2RvbWV0ZXISFAoFc3BlZWQYBSABKAJSBXNwZWVk');

@$core.Deprecated('Use tripDescriptorDescriptor instead')
const TripDescriptor$json = {
  '1': 'TripDescriptor',
  '2': [
    {'1': 'trip_id', '3': 1, '4': 1, '5': 9, '10': 'tripId'},
    {'1': 'route_id', '3': 2, '4': 1, '5': 9, '10': 'routeId'},
    {'1': 'start_time', '3': 3, '4': 1, '5': 9, '10': 'startTime'},
    {'1': 'start_date', '3': 4, '4': 1, '5': 9, '10': 'startDate'},
    {'1': 'schedule_relationship', '3': 5, '4': 1, '5': 14, '6': '.transit_realtime.TripDescriptor.ScheduleRelationship', '10': 'scheduleRelationship'},
  ],
  '4': [TripDescriptor_ScheduleRelationship$json],
};

@$core.Deprecated('Use tripDescriptorDescriptor instead')
const TripDescriptor_ScheduleRelationship$json = {
  '1': 'ScheduleRelationship',
  '2': [
    {'1': 'SCHEDULED', '2': 0},
    {'1': 'ADDED', '2': 1},
    {'1': 'UNSCHEDULED', '2': 2},
    {'1': 'CANCELED', '2': 3},
  ],
};

/// Descriptor for `TripDescriptor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tripDescriptorDescriptor = $convert.base64Decode(
    'Cg5UcmlwRGVzY3JpcHRvchIXCgd0cmlwX2lkGAEgASgJUgZ0cmlwSWQSGQoIcm91dGVfaWQYAi'
    'ABKAlSB3JvdXRlSWQSHQoKc3RhcnRfdGltZRgDIAEoCVIJc3RhcnRUaW1lEh0KCnN0YXJ0X2Rh'
    'dGUYBCABKAlSCXN0YXJ0RGF0ZRJqChVzY2hlZHVsZV9yZWxhdGlvbnNoaXAYBSABKA4yNS50cm'
    'Fuc2l0X3JlYWx0aW1lLlRyaXBEZXNjcmlwdG9yLlNjaGVkdWxlUmVsYXRpb25zaGlwUhRzY2hl'
    'ZHVsZVJlbGF0aW9uc2hpcCJPChRTY2hlZHVsZVJlbGF0aW9uc2hpcBINCglTQ0hFRFVMRUQQAB'
    'IJCgVBRERFRBABEg8KC1VOU0NIRURVTEVEEAISDAoIQ0FOQ0VMRUQQAw==');

@$core.Deprecated('Use vehicleDescriptorDescriptor instead')
const VehicleDescriptor$json = {
  '1': 'VehicleDescriptor',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'license_plate', '3': 3, '4': 1, '5': 9, '10': 'licensePlate'},
  ],
};

/// Descriptor for `VehicleDescriptor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehicleDescriptorDescriptor = $convert.base64Decode(
    'ChFWZWhpY2xlRGVzY3JpcHRvchIOCgJpZBgBIAEoCVICaWQSFAoFbGFiZWwYAiABKAlSBWxhYm'
    'VsEiMKDWxpY2Vuc2VfcGxhdGUYAyABKAlSDGxpY2Vuc2VQbGF0ZQ==');

@$core.Deprecated('Use alertDescriptor instead')
const Alert$json = {
  '1': 'Alert',
  '2': [
    {'1': 'active_period', '3': 1, '4': 3, '5': 11, '6': '.transit_realtime.Alert.TimeRange', '10': 'activePeriod'},
    {'1': 'informed_entity', '3': 5, '4': 3, '5': 11, '6': '.transit_realtime.Alert.EntitySelector', '10': 'informedEntity'},
    {'1': 'cause', '3': 6, '4': 1, '5': 14, '6': '.transit_realtime.Alert.Cause', '10': 'cause'},
    {'1': 'effect', '3': 7, '4': 1, '5': 14, '6': '.transit_realtime.Alert.Effect', '10': 'effect'},
    {'1': 'header_text', '3': 8, '4': 1, '5': 11, '6': '.transit_realtime.TranslatedString', '10': 'headerText'},
    {'1': 'description_text', '3': 10, '4': 1, '5': 11, '6': '.transit_realtime.TranslatedString', '10': 'descriptionText'},
    {'1': 'url', '3': 11, '4': 1, '5': 11, '6': '.transit_realtime.TranslatedString', '10': 'url'},
  ],
  '3': [Alert_TimeRange$json, Alert_EntitySelector$json],
  '4': [Alert_Cause$json, Alert_Effect$json],
};

@$core.Deprecated('Use alertDescriptor instead')
const Alert_TimeRange$json = {
  '1': 'TimeRange',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 4, '10': 'start'},
    {'1': 'end', '3': 2, '4': 1, '5': 4, '10': 'end'},
  ],
};

@$core.Deprecated('Use alertDescriptor instead')
const Alert_EntitySelector$json = {
  '1': 'EntitySelector',
  '2': [
    {'1': 'agency_id', '3': 1, '4': 1, '5': 9, '10': 'agencyId'},
    {'1': 'route_id', '3': 2, '4': 1, '5': 9, '10': 'routeId'},
    {'1': 'trip', '3': 3, '4': 1, '5': 11, '6': '.transit_realtime.TripDescriptor', '10': 'trip'},
    {'1': 'stop_id', '3': 4, '4': 1, '5': 9, '10': 'stopId'},
  ],
};

@$core.Deprecated('Use alertDescriptor instead')
const Alert_Cause$json = {
  '1': 'Cause',
  '2': [
    {'1': 'UNKNOWN_CAUSE', '2': 0},
    {'1': 'OTHER_CAUSE', '2': 1},
    {'1': 'TECHNICAL_PROBLEM', '2': 2},
    {'1': 'STRIKE', '2': 3},
    {'1': 'WEATHER', '2': 4},
    {'1': 'MAINTENANCE', '2': 5},
    {'1': 'CONSTRUCTION', '2': 6},
    {'1': 'POLICE_ACTIVITY', '2': 7},
    {'1': 'MEDICAL_EMERGENCY', '2': 8},
  ],
};

@$core.Deprecated('Use alertDescriptor instead')
const Alert_Effect$json = {
  '1': 'Effect',
  '2': [
    {'1': 'NO_SERVICE', '2': 0},
    {'1': 'REDUCED_SERVICE', '2': 1},
    {'1': 'SIGNIFICANT_DELAYS', '2': 2},
    {'1': 'DETOUR', '2': 3},
    {'1': 'ADDITIONAL_SERVICE', '2': 4},
    {'1': 'MODIFIED_SERVICE', '2': 5},
    {'1': 'OTHER_EFFECT', '2': 6},
    {'1': 'UNKNOWN_EFFECT', '2': 7},
    {'1': 'STOP_MOVED', '2': 8},
  ],
};

/// Descriptor for `Alert`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alertDescriptor = $convert.base64Decode(
    'CgVBbGVydBJGCg1hY3RpdmVfcGVyaW9kGAEgAygLMiEudHJhbnNpdF9yZWFsdGltZS5BbGVydC'
    '5UaW1lUmFuZ2VSDGFjdGl2ZVBlcmlvZBJPCg9pbmZvcm1lZF9lbnRpdHkYBSADKAsyJi50cmFu'
    'c2l0X3JlYWx0aW1lLkFsZXJ0LkVudGl0eVNlbGVjdG9yUg5pbmZvcm1lZEVudGl0eRIzCgVjYX'
    'VzZRgGIAEoDjIdLnRyYW5zaXRfcmVhbHRpbWUuQWxlcnQuQ2F1c2VSBWNhdXNlEjYKBmVmZmVj'
    'dBgHIAEoDjIeLnRyYW5zaXRfcmVhbHRpbWUuQWxlcnQuRWZmZWN0UgZlZmZlY3QSQwoLaGVhZG'
    'VyX3RleHQYCCABKAsyIi50cmFuc2l0X3JlYWx0aW1lLlRyYW5zbGF0ZWRTdHJpbmdSCmhlYWRl'
    'clRleHQSTQoQZGVzY3JpcHRpb25fdGV4dBgKIAEoCzIiLnRyYW5zaXRfcmVhbHRpbWUuVHJhbn'
    'NsYXRlZFN0cmluZ1IPZGVzY3JpcHRpb25UZXh0EjQKA3VybBgLIAEoCzIiLnRyYW5zaXRfcmVh'
    'bHRpbWUuVHJhbnNsYXRlZFN0cmluZ1IDdXJsGjMKCVRpbWVSYW5nZRIUCgVzdGFydBgBIAEoBF'
    'IFc3RhcnQSEAoDZW5kGAIgASgEUgNlbmQalwEKDkVudGl0eVNlbGVjdG9yEhsKCWFnZW5jeV9p'
    'ZBgBIAEoCVIIYWdlbmN5SWQSGQoIcm91dGVfaWQYAiABKAlSB3JvdXRlSWQSNAoEdHJpcBgDIA'
    'EoCzIgLnRyYW5zaXRfcmVhbHRpbWUuVHJpcERlc2NyaXB0b3JSBHRyaXASFwoHc3RvcF9pZBgE'
    'IAEoCVIGc3RvcElkIqoBCgVDYXVzZRIRCg1VTktOT1dOX0NBVVNFEAASDwoLT1RIRVJfQ0FVU0'
    'UQARIVChFURUNITklDQUxfUFJPQkxFTRACEgoKBlNUUklLRRADEgsKB1dFQVRIRVIQBBIPCgtN'
    'QUlOVEVOQU5DRRAFEhAKDENPTlNUUlVDVElPThAGEhMKD1BPTElDRV9BQ1RJVklUWRAHEhUKEU'
    '1FRElDQUxfRU1FUkdFTkNZEAgitQEKBkVmZmVjdBIOCgpOT19TRVJWSUNFEAASEwoPUkVEVUNF'
    'RF9TRVJWSUNFEAESFgoSU0lHTklGSUNBTlRfREVMQVlTEAISCgoGREVUT1VSEAMSFgoSQURESV'
    'RJT05BTF9TRVJWSUNFEAQSFAoQTU9ESUZJRURfU0VSVklDRRAFEhAKDE9USEVSX0VGRkVDVBAG'
    'EhIKDlVOS05PV05fRUZGRUNUEAcSDgoKU1RPUF9NT1ZFRBAI');

@$core.Deprecated('Use translatedStringDescriptor instead')
const TranslatedString$json = {
  '1': 'TranslatedString',
  '2': [
    {'1': 'translation', '3': 1, '4': 3, '5': 11, '6': '.transit_realtime.TranslatedString.Translation', '10': 'translation'},
  ],
  '3': [TranslatedString_Translation$json],
};

@$core.Deprecated('Use translatedStringDescriptor instead')
const TranslatedString_Translation$json = {
  '1': 'Translation',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'language', '3': 2, '4': 1, '5': 9, '10': 'language'},
  ],
};

/// Descriptor for `TranslatedString`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translatedStringDescriptor = $convert.base64Decode(
    'ChBUcmFuc2xhdGVkU3RyaW5nElAKC3RyYW5zbGF0aW9uGAEgAygLMi4udHJhbnNpdF9yZWFsdG'
    'ltZS5UcmFuc2xhdGVkU3RyaW5nLlRyYW5zbGF0aW9uUgt0cmFuc2xhdGlvbho9CgtUcmFuc2xh'
    'dGlvbhISCgR0ZXh0GAEgASgJUgR0ZXh0EhoKCGxhbmd1YWdlGAIgASgJUghsYW5ndWFnZQ==');

