import 'dart:async';
import '../core/enums/app_enums.dart';
import '../models/energy_models.dart';
import '../services/api_service.dart';
import 'energy_repository.dart';

class ApiEnergyRepository implements EnergyRepository {
  final ApiService api;
  @override final AppConfig config;
  Timer? _timer;
  final _snapshot = StreamController<SystemSnapshot>.broadcast();
  final _rooms = StreamController<List<RoomModel>>.broadcast();
  final _loads = StreamController<List<LoadModel>>.broadcast();
  final _alerts = StreamController<List<AlertModel>>.broadcast();
  final _events = StreamController<List<OptimizationEvent>>.broadcast();
  ApiEnergyRepository({required String baseUrl, this.config = const AppConfig()}) : api = ApiService(baseUrl) { _poll(); _timer = Timer.periodic(const Duration(seconds: 5), (_) => _poll()); }
  Future<void> _poll() async { try { final roomJson = await api.getJson('/api/rooms') as List<dynamic>; final loadJson = await api.getJson('/api/loads') as List<dynamic>; _rooms.add(roomJson.map(_room).toList()); _loads.add(loadJson.map(_load).toList()); final s = await api.getJson('/api/system/status') as Map<String,dynamic>; _snapshot.add(SystemSnapshot(voltageV: (s['voltage_v'] as num?)?.toDouble() ?? 0, currentA: (s['current_a'] as num?)?.toDouble() ?? 0, powerW: (s['power_w'] as num?)?.toDouble() ?? 0, energyKwh: (s['energy_kwh'] as num?)?.toDouble() ?? 0, status: _status(s['status'] as String?), demoMode: false, backendConnected: true)); } catch (_) { _snapshot.add(const SystemSnapshot(voltageV:0,currentA:0,powerW:0,energyKwh:0,status:SystemStatus.offline,demoMode:false,backendConnected:false)); } }
  RoomModel _room(dynamic x){final m=x as Map<String,dynamic>;return RoomModel(id:m['id'] as String,name:m['name'] as String,type:m['type'] as String,enabled:m['enabled'] as bool? ?? true,connected:m['connected'] as bool? ?? false,loadIds:List<String>.from(m['load_ids'] ?? const []),voltageV:(m['voltage_v'] as num?)?.toDouble() ?? 0,currentA:(m['current_a'] as num?)?.toDouble() ?? 0,powerW:(m['power_w'] as num?)?.toDouble() ?? 0,energyKwh:(m['energy_kwh'] as num?)?.toDouble() ?? 0);}
  LoadModel _load(dynamic x){final m=x as Map<String,dynamic>;return LoadModel(id:m['id'] as String,roomId:m['room_id'] as String,name:m['name'] as String,category:LoadCategory.other,essential:m['essential'] as bool? ?? false,controllable:m['controllable'] as bool? ?? false,state:m['state']=='on'?LoadState.on:LoadState.off,powerW:(m['power_w'] as num?)?.toDouble() ?? 0,energyKwh:(m['energy_kwh'] as num?)?.toDouble() ?? 0,relayChannel:m['relay_channel'] as int?,connected:m['connected'] as bool? ?? true);}
  SystemStatus _status(String? s)=>switch(s){'high_demand'=>SystemStatus.highDemand,'overload'=>SystemStatus.overload,'offline'=>SystemStatus.offline,_=>SystemStatus.normal};
  @override Stream<SystemSnapshot> watchSnapshot()=>_snapshot.stream;
  @override Stream<List<RoomModel>> watchRooms()=>_rooms.stream;
  @override Stream<List<LoadModel>> watchLoads()=>_loads.stream;
  @override Stream<List<AlertModel>> watchAlerts()=>_alerts.stream;
  @override Stream<List<OptimizationEvent>> watchOptimizationEvents()=>_events.stream;
  @override Future<List<ReadingPoint>> history({required String metric,required TimeRange range,String? roomId}) async=>const [];
  @override Future<CommandStatus> controlLoad(String loadId,bool turnOn) async { try {final data=await api.postJson('/api/loads/${Uri.encodeComponent(loadId)}/control',{'state':turnOn?'on':'off'}); return data['status']=='acknowledged'?CommandStatus.acknowledged:CommandStatus.failed;}catch(_){return CommandStatus.failed;} }
  @override Future<void> markAlertRead(String alertId) async { if(alertId.isNotEmpty) await api.postJson('/api/alerts/${Uri.encodeComponent(alertId)}/read',{}); }
  @override Future<void> markAllRead() async { await api.postJson('/api/alerts/read-all',{}); }
  void dispose(){_timer?.cancel();_snapshot.close();_rooms.close();_loads.close();_alerts.close();_events.close();}
}
