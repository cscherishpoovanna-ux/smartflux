from dataclasses import dataclass
from time import time

@dataclass(frozen=True)
class Load:
    id: str
    room_id: str
    name: str
    essential: bool
    controllable: bool
    relay_channel: int | None
    state: str = 'on'

class Store:
    def __init__(self):
        self.rooms = [
            {'id':'room-1','name':'Room 1','type':'Motor area','enabled':True,'connected':True},
            {'id':'room-2','name':'Room 2','type':'Lighting','enabled':True,'connected':True},
            {'id':'room-3','name':'Room 3','type':'Lighting + Motor','enabled':True,'connected':True},
            {'id':'room-4','name':'Room 4','type':'Reserved','enabled':True,'connected':False},
        ]
        self.loads = {
            'load-motor-1': Load('load-motor-1','room-1','Motor',False,True,1),
            'load-led-1': Load('load-led-1','room-2','LED',False,True,2),
            'load-led-2': Load('load-led-2','room-3','LED',True,False,None),
            'load-motor-2': Load('load-motor-2','room-3','Motor',False,True,3),
        }
        self.alerts = []
        self.audit = []
        self.telemetry = []
    def control(self, load_id: str, state: str):
        load = self.loads.get(load_id)
        if not load or not load.controllable or load.relay_channel is None: return None
        self.loads[load_id] = Load(load.id, load.room_id, load.name, load.essential, load.controllable, load.relay_channel, state)
        command_id = f'cmd-{int(time()*1000000)}'
        self.audit.append({'command_id':command_id,'load_id':load_id,'state':state,'result':'accepted','timestamp':time()})
        return command_id
