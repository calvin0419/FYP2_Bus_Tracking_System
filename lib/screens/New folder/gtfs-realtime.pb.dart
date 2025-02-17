//
//  Generated code. Do not modify.
//  source: gtfs-realtime.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'gtfs-realtime.pbenum.dart';

export 'gtfs-realtime.pbenum.dart';

/// Message representing the entire GTFS Realtime feed.
class FeedMessage extends $pb.GeneratedMessage {
  factory FeedMessage({
    FeedHeader? header,
    $core.Iterable<FeedEntity>? entity,
  }) {
    final $result = create();
    if (header != null) {
      $result.header = header;
    }
    if (entity != null) {
      $result.entity.addAll(entity);
    }
    return $result;
  }
  FeedMessage._() : super();
  factory FeedMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeedMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeedMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..aOM<FeedHeader>(1, _omitFieldNames ? '' : 'header', subBuilder: FeedHeader.create)
    ..pc<FeedEntity>(2, _omitFieldNames ? '' : 'entity', $pb.PbFieldType.PM, subBuilder: FeedEntity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeedMessage clone() => FeedMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeedMessage copyWith(void Function(FeedMessage) updates) => super.copyWith((message) => updates(message as FeedMessage)) as FeedMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeedMessage create() => FeedMessage._();
  FeedMessage createEmptyInstance() => create();
  static $pb.PbList<FeedMessage> createRepeated() => $pb.PbList<FeedMessage>();
  @$core.pragma('dart2js:noInline')
  static FeedMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeedMessage>(create);
  static FeedMessage? _defaultInstance;

  @$pb.TagNumber(1)
  FeedHeader get header => $_getN(0);
  @$pb.TagNumber(1)
  set header(FeedHeader v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHeader() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeader() => clearField(1);
  @$pb.TagNumber(1)
  FeedHeader ensureHeader() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<FeedEntity> get entity => $_getList(1);
}

/// Metadata about the GTFS Realtime feed.
class FeedHeader extends $pb.GeneratedMessage {
  factory FeedHeader({
    $core.String? gtfsRealtimeVersion,
    FeedHeader_Incrementality? incrementality,
    $fixnum.Int64? timestamp,
  }) {
    final $result = create();
    if (gtfsRealtimeVersion != null) {
      $result.gtfsRealtimeVersion = gtfsRealtimeVersion;
    }
    if (incrementality != null) {
      $result.incrementality = incrementality;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    return $result;
  }
  FeedHeader._() : super();
  factory FeedHeader.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeedHeader.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeedHeader', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gtfsRealtimeVersion')
    ..e<FeedHeader_Incrementality>(2, _omitFieldNames ? '' : 'incrementality', $pb.PbFieldType.OE, defaultOrMaker: FeedHeader_Incrementality.FULL_DATASET, valueOf: FeedHeader_Incrementality.valueOf, enumValues: FeedHeader_Incrementality.values)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeedHeader clone() => FeedHeader()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeedHeader copyWith(void Function(FeedHeader) updates) => super.copyWith((message) => updates(message as FeedHeader)) as FeedHeader;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeedHeader create() => FeedHeader._();
  FeedHeader createEmptyInstance() => create();
  static $pb.PbList<FeedHeader> createRepeated() => $pb.PbList<FeedHeader>();
  @$core.pragma('dart2js:noInline')
  static FeedHeader getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeedHeader>(create);
  static FeedHeader? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gtfsRealtimeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set gtfsRealtimeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGtfsRealtimeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearGtfsRealtimeVersion() => clearField(1);

  @$pb.TagNumber(2)
  FeedHeader_Incrementality get incrementality => $_getN(1);
  @$pb.TagNumber(2)
  set incrementality(FeedHeader_Incrementality v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasIncrementality() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncrementality() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => clearField(3);
}

/// A single update within the GTFS Realtime feed, such as a vehicle position or trip update.
class FeedEntity extends $pb.GeneratedMessage {
  factory FeedEntity({
    $core.String? id,
    $core.bool? isDeleted,
    TripUpdate? tripUpdate,
    VehiclePosition? vehicle,
    Alert? alert,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (isDeleted != null) {
      $result.isDeleted = isDeleted;
    }
    if (tripUpdate != null) {
      $result.tripUpdate = tripUpdate;
    }
    if (vehicle != null) {
      $result.vehicle = vehicle;
    }
    if (alert != null) {
      $result.alert = alert;
    }
    return $result;
  }
  FeedEntity._() : super();
  factory FeedEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeedEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeedEntity', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOB(2, _omitFieldNames ? '' : 'isDeleted')
    ..aOM<TripUpdate>(3, _omitFieldNames ? '' : 'tripUpdate', subBuilder: TripUpdate.create)
    ..aOM<VehiclePosition>(4, _omitFieldNames ? '' : 'vehicle', subBuilder: VehiclePosition.create)
    ..aOM<Alert>(5, _omitFieldNames ? '' : 'alert', subBuilder: Alert.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeedEntity clone() => FeedEntity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeedEntity copyWith(void Function(FeedEntity) updates) => super.copyWith((message) => updates(message as FeedEntity)) as FeedEntity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeedEntity create() => FeedEntity._();
  FeedEntity createEmptyInstance() => create();
  static $pb.PbList<FeedEntity> createRepeated() => $pb.PbList<FeedEntity>();
  @$core.pragma('dart2js:noInline')
  static FeedEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeedEntity>(create);
  static FeedEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isDeleted => $_getBF(1);
  @$pb.TagNumber(2)
  set isDeleted($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsDeleted() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsDeleted() => clearField(2);

  @$pb.TagNumber(3)
  TripUpdate get tripUpdate => $_getN(2);
  @$pb.TagNumber(3)
  set tripUpdate(TripUpdate v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTripUpdate() => $_has(2);
  @$pb.TagNumber(3)
  void clearTripUpdate() => clearField(3);
  @$pb.TagNumber(3)
  TripUpdate ensureTripUpdate() => $_ensure(2);

  @$pb.TagNumber(4)
  VehiclePosition get vehicle => $_getN(3);
  @$pb.TagNumber(4)
  set vehicle(VehiclePosition v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasVehicle() => $_has(3);
  @$pb.TagNumber(4)
  void clearVehicle() => clearField(4);
  @$pb.TagNumber(4)
  VehiclePosition ensureVehicle() => $_ensure(3);

  @$pb.TagNumber(5)
  Alert get alert => $_getN(4);
  @$pb.TagNumber(5)
  set alert(Alert v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasAlert() => $_has(4);
  @$pb.TagNumber(5)
  void clearAlert() => clearField(5);
  @$pb.TagNumber(5)
  Alert ensureAlert() => $_ensure(4);
}

/// Nested message describing scheduled stops for this trip.
class TripUpdate_StopTimeEvent extends $pb.GeneratedMessage {
  factory TripUpdate_StopTimeEvent({
    $core.int? delay,
    $fixnum.Int64? time,
    $core.int? uncertainty,
  }) {
    final $result = create();
    if (delay != null) {
      $result.delay = delay;
    }
    if (time != null) {
      $result.time = time;
    }
    if (uncertainty != null) {
      $result.uncertainty = uncertainty;
    }
    return $result;
  }
  TripUpdate_StopTimeEvent._() : super();
  factory TripUpdate_StopTimeEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TripUpdate_StopTimeEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TripUpdate.StopTimeEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'delay', $pb.PbFieldType.O3)
    ..aInt64(2, _omitFieldNames ? '' : 'time')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'uncertainty', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TripUpdate_StopTimeEvent clone() => TripUpdate_StopTimeEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TripUpdate_StopTimeEvent copyWith(void Function(TripUpdate_StopTimeEvent) updates) => super.copyWith((message) => updates(message as TripUpdate_StopTimeEvent)) as TripUpdate_StopTimeEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TripUpdate_StopTimeEvent create() => TripUpdate_StopTimeEvent._();
  TripUpdate_StopTimeEvent createEmptyInstance() => create();
  static $pb.PbList<TripUpdate_StopTimeEvent> createRepeated() => $pb.PbList<TripUpdate_StopTimeEvent>();
  @$core.pragma('dart2js:noInline')
  static TripUpdate_StopTimeEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TripUpdate_StopTimeEvent>(create);
  static TripUpdate_StopTimeEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get delay => $_getIZ(0);
  @$pb.TagNumber(1)
  set delay($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDelay() => $_has(0);
  @$pb.TagNumber(1)
  void clearDelay() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get time => $_getI64(1);
  @$pb.TagNumber(2)
  set time($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get uncertainty => $_getIZ(2);
  @$pb.TagNumber(3)
  set uncertainty($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUncertainty() => $_has(2);
  @$pb.TagNumber(3)
  void clearUncertainty() => clearField(3);
}

/// Update on the scheduled arrival/departure time for a specific stop.
class TripUpdate_StopTimeUpdate extends $pb.GeneratedMessage {
  factory TripUpdate_StopTimeUpdate({
    $core.String? stopId,
    TripUpdate_StopTimeEvent? arrival,
    TripUpdate_StopTimeEvent? departure,
    TripUpdate_StopTimeUpdate_ScheduleRelationship? scheduleRelationship,
  }) {
    final $result = create();
    if (stopId != null) {
      $result.stopId = stopId;
    }
    if (arrival != null) {
      $result.arrival = arrival;
    }
    if (departure != null) {
      $result.departure = departure;
    }
    if (scheduleRelationship != null) {
      $result.scheduleRelationship = scheduleRelationship;
    }
    return $result;
  }
  TripUpdate_StopTimeUpdate._() : super();
  factory TripUpdate_StopTimeUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TripUpdate_StopTimeUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TripUpdate.StopTimeUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'stopId')
    ..aOM<TripUpdate_StopTimeEvent>(2, _omitFieldNames ? '' : 'arrival', subBuilder: TripUpdate_StopTimeEvent.create)
    ..aOM<TripUpdate_StopTimeEvent>(3, _omitFieldNames ? '' : 'departure', subBuilder: TripUpdate_StopTimeEvent.create)
    ..e<TripUpdate_StopTimeUpdate_ScheduleRelationship>(4, _omitFieldNames ? '' : 'scheduleRelationship', $pb.PbFieldType.OE, defaultOrMaker: TripUpdate_StopTimeUpdate_ScheduleRelationship.SCHEDULED, valueOf: TripUpdate_StopTimeUpdate_ScheduleRelationship.valueOf, enumValues: TripUpdate_StopTimeUpdate_ScheduleRelationship.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TripUpdate_StopTimeUpdate clone() => TripUpdate_StopTimeUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TripUpdate_StopTimeUpdate copyWith(void Function(TripUpdate_StopTimeUpdate) updates) => super.copyWith((message) => updates(message as TripUpdate_StopTimeUpdate)) as TripUpdate_StopTimeUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TripUpdate_StopTimeUpdate create() => TripUpdate_StopTimeUpdate._();
  TripUpdate_StopTimeUpdate createEmptyInstance() => create();
  static $pb.PbList<TripUpdate_StopTimeUpdate> createRepeated() => $pb.PbList<TripUpdate_StopTimeUpdate>();
  @$core.pragma('dart2js:noInline')
  static TripUpdate_StopTimeUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TripUpdate_StopTimeUpdate>(create);
  static TripUpdate_StopTimeUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stopId => $_getSZ(0);
  @$pb.TagNumber(1)
  set stopId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStopId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStopId() => clearField(1);

  @$pb.TagNumber(2)
  TripUpdate_StopTimeEvent get arrival => $_getN(1);
  @$pb.TagNumber(2)
  set arrival(TripUpdate_StopTimeEvent v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasArrival() => $_has(1);
  @$pb.TagNumber(2)
  void clearArrival() => clearField(2);
  @$pb.TagNumber(2)
  TripUpdate_StopTimeEvent ensureArrival() => $_ensure(1);

  @$pb.TagNumber(3)
  TripUpdate_StopTimeEvent get departure => $_getN(2);
  @$pb.TagNumber(3)
  set departure(TripUpdate_StopTimeEvent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDeparture() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeparture() => clearField(3);
  @$pb.TagNumber(3)
  TripUpdate_StopTimeEvent ensureDeparture() => $_ensure(2);

  @$pb.TagNumber(4)
  TripUpdate_StopTimeUpdate_ScheduleRelationship get scheduleRelationship => $_getN(3);
  @$pb.TagNumber(4)
  set scheduleRelationship(TripUpdate_StopTimeUpdate_ScheduleRelationship v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasScheduleRelationship() => $_has(3);
  @$pb.TagNumber(4)
  void clearScheduleRelationship() => clearField(4);
}

/// Message representing a trip update, including delays or changes in schedule.
class TripUpdate extends $pb.GeneratedMessage {
  factory TripUpdate({
    TripDescriptor? trip,
    VehicleDescriptor? vehicle,
    $fixnum.Int64? timestamp,
    $core.Iterable<TripUpdate_StopTimeUpdate>? stopTimeUpdate,
  }) {
    final $result = create();
    if (trip != null) {
      $result.trip = trip;
    }
    if (vehicle != null) {
      $result.vehicle = vehicle;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (stopTimeUpdate != null) {
      $result.stopTimeUpdate.addAll(stopTimeUpdate);
    }
    return $result;
  }
  TripUpdate._() : super();
  factory TripUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TripUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TripUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..aOM<TripDescriptor>(1, _omitFieldNames ? '' : 'trip', subBuilder: TripDescriptor.create)
    ..aOM<VehicleDescriptor>(3, _omitFieldNames ? '' : 'vehicle', subBuilder: VehicleDescriptor.create)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<TripUpdate_StopTimeUpdate>(5, _omitFieldNames ? '' : 'stopTimeUpdate', $pb.PbFieldType.PM, subBuilder: TripUpdate_StopTimeUpdate.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TripUpdate clone() => TripUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TripUpdate copyWith(void Function(TripUpdate) updates) => super.copyWith((message) => updates(message as TripUpdate)) as TripUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TripUpdate create() => TripUpdate._();
  TripUpdate createEmptyInstance() => create();
  static $pb.PbList<TripUpdate> createRepeated() => $pb.PbList<TripUpdate>();
  @$core.pragma('dart2js:noInline')
  static TripUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TripUpdate>(create);
  static TripUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  TripDescriptor get trip => $_getN(0);
  @$pb.TagNumber(1)
  set trip(TripDescriptor v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrip() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrip() => clearField(1);
  @$pb.TagNumber(1)
  TripDescriptor ensureTrip() => $_ensure(0);

  @$pb.TagNumber(3)
  VehicleDescriptor get vehicle => $_getN(1);
  @$pb.TagNumber(3)
  set vehicle(VehicleDescriptor v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasVehicle() => $_has(1);
  @$pb.TagNumber(3)
  void clearVehicle() => clearField(3);
  @$pb.TagNumber(3)
  VehicleDescriptor ensureVehicle() => $_ensure(1);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<TripUpdate_StopTimeUpdate> get stopTimeUpdate => $_getList(3);
}

/// Message representing the position of a vehicle.
class VehiclePosition extends $pb.GeneratedMessage {
  factory VehiclePosition({
    TripDescriptor? trip,
    VehicleDescriptor? vehicle,
    Position? position,
    $fixnum.Int64? timestamp,
    VehiclePosition_CongestionLevel? congestionLevel,
    VehiclePosition_VehicleStopStatus? currentStatus,
    $core.String? stopId,
  }) {
    final $result = create();
    if (trip != null) {
      $result.trip = trip;
    }
    if (vehicle != null) {
      $result.vehicle = vehicle;
    }
    if (position != null) {
      $result.position = position;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (congestionLevel != null) {
      $result.congestionLevel = congestionLevel;
    }
    if (currentStatus != null) {
      $result.currentStatus = currentStatus;
    }
    if (stopId != null) {
      $result.stopId = stopId;
    }
    return $result;
  }
  VehiclePosition._() : super();
  factory VehiclePosition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VehiclePosition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VehiclePosition', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..aOM<TripDescriptor>(1, _omitFieldNames ? '' : 'trip', subBuilder: TripDescriptor.create)
    ..aOM<VehicleDescriptor>(2, _omitFieldNames ? '' : 'vehicle', subBuilder: VehicleDescriptor.create)
    ..aOM<Position>(3, _omitFieldNames ? '' : 'position', subBuilder: Position.create)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<VehiclePosition_CongestionLevel>(5, _omitFieldNames ? '' : 'congestionLevel', $pb.PbFieldType.OE, defaultOrMaker: VehiclePosition_CongestionLevel.UNKNOWN_CONGESTION_LEVEL, valueOf: VehiclePosition_CongestionLevel.valueOf, enumValues: VehiclePosition_CongestionLevel.values)
    ..e<VehiclePosition_VehicleStopStatus>(6, _omitFieldNames ? '' : 'currentStatus', $pb.PbFieldType.OE, defaultOrMaker: VehiclePosition_VehicleStopStatus.INCOMING_AT, valueOf: VehiclePosition_VehicleStopStatus.valueOf, enumValues: VehiclePosition_VehicleStopStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'stopId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VehiclePosition clone() => VehiclePosition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VehiclePosition copyWith(void Function(VehiclePosition) updates) => super.copyWith((message) => updates(message as VehiclePosition)) as VehiclePosition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VehiclePosition create() => VehiclePosition._();
  VehiclePosition createEmptyInstance() => create();
  static $pb.PbList<VehiclePosition> createRepeated() => $pb.PbList<VehiclePosition>();
  @$core.pragma('dart2js:noInline')
  static VehiclePosition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VehiclePosition>(create);
  static VehiclePosition? _defaultInstance;

  @$pb.TagNumber(1)
  TripDescriptor get trip => $_getN(0);
  @$pb.TagNumber(1)
  set trip(TripDescriptor v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrip() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrip() => clearField(1);
  @$pb.TagNumber(1)
  TripDescriptor ensureTrip() => $_ensure(0);

  @$pb.TagNumber(2)
  VehicleDescriptor get vehicle => $_getN(1);
  @$pb.TagNumber(2)
  set vehicle(VehicleDescriptor v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasVehicle() => $_has(1);
  @$pb.TagNumber(2)
  void clearVehicle() => clearField(2);
  @$pb.TagNumber(2)
  VehicleDescriptor ensureVehicle() => $_ensure(1);

  @$pb.TagNumber(3)
  Position get position => $_getN(2);
  @$pb.TagNumber(3)
  set position(Position v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => clearField(3);
  @$pb.TagNumber(3)
  Position ensurePosition() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);

  @$pb.TagNumber(5)
  VehiclePosition_CongestionLevel get congestionLevel => $_getN(4);
  @$pb.TagNumber(5)
  set congestionLevel(VehiclePosition_CongestionLevel v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCongestionLevel() => $_has(4);
  @$pb.TagNumber(5)
  void clearCongestionLevel() => clearField(5);

  @$pb.TagNumber(6)
  VehiclePosition_VehicleStopStatus get currentStatus => $_getN(5);
  @$pb.TagNumber(6)
  set currentStatus(VehiclePosition_VehicleStopStatus v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCurrentStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrentStatus() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get stopId => $_getSZ(6);
  @$pb.TagNumber(7)
  set stopId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStopId() => $_has(6);
  @$pb.TagNumber(7)
  void clearStopId() => clearField(7);
}

/// A geographical position, including latitude, longitude, and optional bearing.
class Position extends $pb.GeneratedMessage {
  factory Position({
    $core.double? latitude,
    $core.double? longitude,
    $core.double? bearing,
    $core.double? odometer,
    $core.double? speed,
  }) {
    final $result = create();
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (bearing != null) {
      $result.bearing = bearing;
    }
    if (odometer != null) {
      $result.odometer = odometer;
    }
    if (speed != null) {
      $result.speed = speed;
    }
    return $result;
  }
  Position._() : super();
  factory Position.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Position.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Position', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OF)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'bearing', $pb.PbFieldType.OF)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'odometer', $pb.PbFieldType.OF)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'speed', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Position clone() => Position()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Position copyWith(void Function(Position) updates) => super.copyWith((message) => updates(message as Position)) as Position;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Position create() => Position._();
  Position createEmptyInstance() => create();
  static $pb.PbList<Position> createRepeated() => $pb.PbList<Position>();
  @$core.pragma('dart2js:noInline')
  static Position getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Position>(create);
  static Position? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(1)
  set latitude($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatitude() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get bearing => $_getN(2);
  @$pb.TagNumber(3)
  set bearing($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBearing() => $_has(2);
  @$pb.TagNumber(3)
  void clearBearing() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get odometer => $_getN(3);
  @$pb.TagNumber(4)
  set odometer($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOdometer() => $_has(3);
  @$pb.TagNumber(4)
  void clearOdometer() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get speed => $_getN(4);
  @$pb.TagNumber(5)
  set speed($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSpeed() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpeed() => clearField(5);
}

/// A descriptor for a trip, including route and start information.
class TripDescriptor extends $pb.GeneratedMessage {
  factory TripDescriptor({
    $core.String? tripId,
    $core.String? routeId,
    $core.String? startTime,
    $core.String? startDate,
    TripDescriptor_ScheduleRelationship? scheduleRelationship,
  }) {
    final $result = create();
    if (tripId != null) {
      $result.tripId = tripId;
    }
    if (routeId != null) {
      $result.routeId = routeId;
    }
    if (startTime != null) {
      $result.startTime = startTime;
    }
    if (startDate != null) {
      $result.startDate = startDate;
    }
    if (scheduleRelationship != null) {
      $result.scheduleRelationship = scheduleRelationship;
    }
    return $result;
  }
  TripDescriptor._() : super();
  factory TripDescriptor.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TripDescriptor.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TripDescriptor', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tripId')
    ..aOS(2, _omitFieldNames ? '' : 'routeId')
    ..aOS(3, _omitFieldNames ? '' : 'startTime')
    ..aOS(4, _omitFieldNames ? '' : 'startDate')
    ..e<TripDescriptor_ScheduleRelationship>(5, _omitFieldNames ? '' : 'scheduleRelationship', $pb.PbFieldType.OE, defaultOrMaker: TripDescriptor_ScheduleRelationship.SCHEDULED, valueOf: TripDescriptor_ScheduleRelationship.valueOf, enumValues: TripDescriptor_ScheduleRelationship.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TripDescriptor clone() => TripDescriptor()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TripDescriptor copyWith(void Function(TripDescriptor) updates) => super.copyWith((message) => updates(message as TripDescriptor)) as TripDescriptor;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TripDescriptor create() => TripDescriptor._();
  TripDescriptor createEmptyInstance() => create();
  static $pb.PbList<TripDescriptor> createRepeated() => $pb.PbList<TripDescriptor>();
  @$core.pragma('dart2js:noInline')
  static TripDescriptor getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TripDescriptor>(create);
  static TripDescriptor? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tripId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tripId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTripId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get routeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set routeId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRouteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRouteId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get startTime => $_getSZ(2);
  @$pb.TagNumber(3)
  set startTime($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStartTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartTime() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get startDate => $_getSZ(3);
  @$pb.TagNumber(4)
  set startDate($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStartDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartDate() => clearField(4);

  @$pb.TagNumber(5)
  TripDescriptor_ScheduleRelationship get scheduleRelationship => $_getN(4);
  @$pb.TagNumber(5)
  set scheduleRelationship(TripDescriptor_ScheduleRelationship v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasScheduleRelationship() => $_has(4);
  @$pb.TagNumber(5)
  void clearScheduleRelationship() => clearField(5);
}

/// A descriptor for a specific vehicle, including an ID and label.
class VehicleDescriptor extends $pb.GeneratedMessage {
  factory VehicleDescriptor({
    $core.String? id,
    $core.String? label,
    $core.String? licensePlate,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (label != null) {
      $result.label = label;
    }
    if (licensePlate != null) {
      $result.licensePlate = licensePlate;
    }
    return $result;
  }
  VehicleDescriptor._() : super();
  factory VehicleDescriptor.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VehicleDescriptor.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VehicleDescriptor', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOS(3, _omitFieldNames ? '' : 'licensePlate')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VehicleDescriptor clone() => VehicleDescriptor()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VehicleDescriptor copyWith(void Function(VehicleDescriptor) updates) => super.copyWith((message) => updates(message as VehicleDescriptor)) as VehicleDescriptor;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VehicleDescriptor create() => VehicleDescriptor._();
  VehicleDescriptor createEmptyInstance() => create();
  static $pb.PbList<VehicleDescriptor> createRepeated() => $pb.PbList<VehicleDescriptor>();
  @$core.pragma('dart2js:noInline')
  static VehicleDescriptor getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VehicleDescriptor>(create);
  static VehicleDescriptor? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get licensePlate => $_getSZ(2);
  @$pb.TagNumber(3)
  set licensePlate($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLicensePlate() => $_has(2);
  @$pb.TagNumber(3)
  void clearLicensePlate() => clearField(3);
}

class Alert_TimeRange extends $pb.GeneratedMessage {
  factory Alert_TimeRange({
    $fixnum.Int64? start,
    $fixnum.Int64? end,
  }) {
    final $result = create();
    if (start != null) {
      $result.start = start;
    }
    if (end != null) {
      $result.end = end;
    }
    return $result;
  }
  Alert_TimeRange._() : super();
  factory Alert_TimeRange.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Alert_TimeRange.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Alert.TimeRange', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'start', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'end', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Alert_TimeRange clone() => Alert_TimeRange()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Alert_TimeRange copyWith(void Function(Alert_TimeRange) updates) => super.copyWith((message) => updates(message as Alert_TimeRange)) as Alert_TimeRange;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Alert_TimeRange create() => Alert_TimeRange._();
  Alert_TimeRange createEmptyInstance() => create();
  static $pb.PbList<Alert_TimeRange> createRepeated() => $pb.PbList<Alert_TimeRange>();
  @$core.pragma('dart2js:noInline')
  static Alert_TimeRange getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Alert_TimeRange>(create);
  static Alert_TimeRange? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get end => $_getI64(1);
  @$pb.TagNumber(2)
  set end($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => clearField(2);
}

class Alert_EntitySelector extends $pb.GeneratedMessage {
  factory Alert_EntitySelector({
    $core.String? agencyId,
    $core.String? routeId,
    TripDescriptor? trip,
    $core.String? stopId,
  }) {
    final $result = create();
    if (agencyId != null) {
      $result.agencyId = agencyId;
    }
    if (routeId != null) {
      $result.routeId = routeId;
    }
    if (trip != null) {
      $result.trip = trip;
    }
    if (stopId != null) {
      $result.stopId = stopId;
    }
    return $result;
  }
  Alert_EntitySelector._() : super();
  factory Alert_EntitySelector.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Alert_EntitySelector.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Alert.EntitySelector', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'agencyId')
    ..aOS(2, _omitFieldNames ? '' : 'routeId')
    ..aOM<TripDescriptor>(3, _omitFieldNames ? '' : 'trip', subBuilder: TripDescriptor.create)
    ..aOS(4, _omitFieldNames ? '' : 'stopId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Alert_EntitySelector clone() => Alert_EntitySelector()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Alert_EntitySelector copyWith(void Function(Alert_EntitySelector) updates) => super.copyWith((message) => updates(message as Alert_EntitySelector)) as Alert_EntitySelector;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Alert_EntitySelector create() => Alert_EntitySelector._();
  Alert_EntitySelector createEmptyInstance() => create();
  static $pb.PbList<Alert_EntitySelector> createRepeated() => $pb.PbList<Alert_EntitySelector>();
  @$core.pragma('dart2js:noInline')
  static Alert_EntitySelector getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Alert_EntitySelector>(create);
  static Alert_EntitySelector? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get agencyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set agencyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAgencyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAgencyId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get routeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set routeId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRouteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRouteId() => clearField(2);

  @$pb.TagNumber(3)
  TripDescriptor get trip => $_getN(2);
  @$pb.TagNumber(3)
  set trip(TripDescriptor v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTrip() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrip() => clearField(3);
  @$pb.TagNumber(3)
  TripDescriptor ensureTrip() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get stopId => $_getSZ(3);
  @$pb.TagNumber(4)
  set stopId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStopId() => $_has(3);
  @$pb.TagNumber(4)
  void clearStopId() => clearField(4);
}

/// An alert, which can include notifications about delays or cancellations.
class Alert extends $pb.GeneratedMessage {
  factory Alert({
    $core.Iterable<Alert_TimeRange>? activePeriod,
    $core.Iterable<Alert_EntitySelector>? informedEntity,
    Alert_Cause? cause,
    Alert_Effect? effect,
    TranslatedString? headerText,
    TranslatedString? descriptionText,
    TranslatedString? url,
  }) {
    final $result = create();
    if (activePeriod != null) {
      $result.activePeriod.addAll(activePeriod);
    }
    if (informedEntity != null) {
      $result.informedEntity.addAll(informedEntity);
    }
    if (cause != null) {
      $result.cause = cause;
    }
    if (effect != null) {
      $result.effect = effect;
    }
    if (headerText != null) {
      $result.headerText = headerText;
    }
    if (descriptionText != null) {
      $result.descriptionText = descriptionText;
    }
    if (url != null) {
      $result.url = url;
    }
    return $result;
  }
  Alert._() : super();
  factory Alert.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Alert.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Alert', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..pc<Alert_TimeRange>(1, _omitFieldNames ? '' : 'activePeriod', $pb.PbFieldType.PM, subBuilder: Alert_TimeRange.create)
    ..pc<Alert_EntitySelector>(5, _omitFieldNames ? '' : 'informedEntity', $pb.PbFieldType.PM, subBuilder: Alert_EntitySelector.create)
    ..e<Alert_Cause>(6, _omitFieldNames ? '' : 'cause', $pb.PbFieldType.OE, defaultOrMaker: Alert_Cause.UNKNOWN_CAUSE, valueOf: Alert_Cause.valueOf, enumValues: Alert_Cause.values)
    ..e<Alert_Effect>(7, _omitFieldNames ? '' : 'effect', $pb.PbFieldType.OE, defaultOrMaker: Alert_Effect.NO_SERVICE, valueOf: Alert_Effect.valueOf, enumValues: Alert_Effect.values)
    ..aOM<TranslatedString>(8, _omitFieldNames ? '' : 'headerText', subBuilder: TranslatedString.create)
    ..aOM<TranslatedString>(10, _omitFieldNames ? '' : 'descriptionText', subBuilder: TranslatedString.create)
    ..aOM<TranslatedString>(11, _omitFieldNames ? '' : 'url', subBuilder: TranslatedString.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Alert clone() => Alert()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Alert copyWith(void Function(Alert) updates) => super.copyWith((message) => updates(message as Alert)) as Alert;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Alert create() => Alert._();
  Alert createEmptyInstance() => create();
  static $pb.PbList<Alert> createRepeated() => $pb.PbList<Alert>();
  @$core.pragma('dart2js:noInline')
  static Alert getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Alert>(create);
  static Alert? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Alert_TimeRange> get activePeriod => $_getList(0);

  @$pb.TagNumber(5)
  $core.List<Alert_EntitySelector> get informedEntity => $_getList(1);

  @$pb.TagNumber(6)
  Alert_Cause get cause => $_getN(2);
  @$pb.TagNumber(6)
  set cause(Alert_Cause v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCause() => $_has(2);
  @$pb.TagNumber(6)
  void clearCause() => clearField(6);

  @$pb.TagNumber(7)
  Alert_Effect get effect => $_getN(3);
  @$pb.TagNumber(7)
  set effect(Alert_Effect v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasEffect() => $_has(3);
  @$pb.TagNumber(7)
  void clearEffect() => clearField(7);

  @$pb.TagNumber(8)
  TranslatedString get headerText => $_getN(4);
  @$pb.TagNumber(8)
  set headerText(TranslatedString v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasHeaderText() => $_has(4);
  @$pb.TagNumber(8)
  void clearHeaderText() => clearField(8);
  @$pb.TagNumber(8)
  TranslatedString ensureHeaderText() => $_ensure(4);

  @$pb.TagNumber(10)
  TranslatedString get descriptionText => $_getN(5);
  @$pb.TagNumber(10)
  set descriptionText(TranslatedString v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasDescriptionText() => $_has(5);
  @$pb.TagNumber(10)
  void clearDescriptionText() => clearField(10);
  @$pb.TagNumber(10)
  TranslatedString ensureDescriptionText() => $_ensure(5);

  @$pb.TagNumber(11)
  TranslatedString get url => $_getN(6);
  @$pb.TagNumber(11)
  set url(TranslatedString v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasUrl() => $_has(6);
  @$pb.TagNumber(11)
  void clearUrl() => clearField(11);
  @$pb.TagNumber(11)
  TranslatedString ensureUrl() => $_ensure(6);
}

class TranslatedString_Translation extends $pb.GeneratedMessage {
  factory TranslatedString_Translation({
    $core.String? text,
    $core.String? language,
  }) {
    final $result = create();
    if (text != null) {
      $result.text = text;
    }
    if (language != null) {
      $result.language = language;
    }
    return $result;
  }
  TranslatedString_Translation._() : super();
  factory TranslatedString_Translation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TranslatedString_Translation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TranslatedString.Translation', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'language')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TranslatedString_Translation clone() => TranslatedString_Translation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TranslatedString_Translation copyWith(void Function(TranslatedString_Translation) updates) => super.copyWith((message) => updates(message as TranslatedString_Translation)) as TranslatedString_Translation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TranslatedString_Translation create() => TranslatedString_Translation._();
  TranslatedString_Translation createEmptyInstance() => create();
  static $pb.PbList<TranslatedString_Translation> createRepeated() => $pb.PbList<TranslatedString_Translation>();
  @$core.pragma('dart2js:noInline')
  static TranslatedString_Translation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranslatedString_Translation>(create);
  static TranslatedString_Translation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get language => $_getSZ(1);
  @$pb.TagNumber(2)
  set language($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLanguage() => $_has(1);
  @$pb.TagNumber(2)
  void clearLanguage() => clearField(2);
}

/// Message for multilingual text (e.g., alert descriptions).
class TranslatedString extends $pb.GeneratedMessage {
  factory TranslatedString({
    $core.Iterable<TranslatedString_Translation>? translation,
  }) {
    final $result = create();
    if (translation != null) {
      $result.translation.addAll(translation);
    }
    return $result;
  }
  TranslatedString._() : super();
  factory TranslatedString.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TranslatedString.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TranslatedString', package: const $pb.PackageName(_omitMessageNames ? '' : 'transit_realtime'), createEmptyInstance: create)
    ..pc<TranslatedString_Translation>(1, _omitFieldNames ? '' : 'translation', $pb.PbFieldType.PM, subBuilder: TranslatedString_Translation.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TranslatedString clone() => TranslatedString()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TranslatedString copyWith(void Function(TranslatedString) updates) => super.copyWith((message) => updates(message as TranslatedString)) as TranslatedString;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TranslatedString create() => TranslatedString._();
  TranslatedString createEmptyInstance() => create();
  static $pb.PbList<TranslatedString> createRepeated() => $pb.PbList<TranslatedString>();
  @$core.pragma('dart2js:noInline')
  static TranslatedString getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranslatedString>(create);
  static TranslatedString? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<TranslatedString_Translation> get translation => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
