#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

[_heli] call FZA_fnc_mpdUpdateMap;

_heli setobjecttexture [SEL_MPD_PR_TSD_FILTER, switch (fza_ah64_tsdsort) do {
	case 1: {"\fza_ah64_us\tex\mpd\track.paa";};
	case 2: {"\fza_ah64_us\tex\mpd\radiation.paa";};
	case 3: {"\fza_ah64_us\tex\mpd\wheel.paa";};
	case 4: {"\fza_ah64_us\tex\CHAR\G1_ca.paa";};
	case 5: {"\fza_ah64_us\tex\CHAR\G2_ca.paa";};
	case 6: {"\fza_ah64_us\tex\CHAR\G3_ca.paa";};
	case 7: {"\fza_ah64_us\tex\CHAR\G4_ca.paa";};
	case 8: {"\fza_ah64_us\tex\mpd\G5_ca.paa";};
	case 9: {"\fza_ah64_us\tex\mpd\G6_ca.paa";};
	case 10: {"\fza_ah64_us\tex\mpd\G7_ca.paa";};
	case 11: {"\fza_ah64_us\tex\mpd\G8_ca.paa";};
	default {"\fza_ah64_us\tex\mpd\all.paa";};
}];

[_heli, direction _heli, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PR_TSD_HDG] call fza_fnc_drawNumberSelections;

[_heli, 1 / fza_ah64_rangesetting / 1000 , "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PR_TSD_Z] call fza_fnc_drawNumberSelections;

if (fza_ah64_tsdmap < 1) then {
	_heli setobjecttexture [SEL_PR_MPD_BACK, "\fza_ah64_us\tex\mpd\tsd-b.paa"];
} else {
	_heli setobjecttexture [SEL_PR_MPD_BACK, "\fza_ah64_US\tex\mpd\notfound_2.paa"];
};

private _targetPos = [];
if (!isNull fza_ah64_mycurrenttarget && fza_ah64_tsdmode == "atk") then {
	_targetPos = getPos fza_ah64_mycurrenttarget;
};
if (fza_ah64_tsdmode == "nav") then {
	 _targetPos = fza_ah64_curwp;
};

private _targetRange = if (_targetPos isEqualTo []) then {0} else {(_targetPos distance2d _heli) / 1000};
private _targetDir = if (_targetPos isEqualTo []) then {0} else {[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (_targetPos select 0), (_targetPos # 1)] call fza_ah64_reldir};

[_heli, _targetRange / 10, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PR_TSD_DIST] call fza_fnc_drawNumberSelections;
[_heli, _targetDir, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PR_TSD_WTDIR] call fza_fnc_drawNumberSelections;

[_heli, fza_ah64_pfz_count, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PR_TSD_PFZS] call fza_fnc_drawNumberSelections;

(wind call CBA_fnc_vect2Polar) params ["_windSpeed", "_windDir"];

[_heli, _windDir, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PR_TSD_WDIR] call fza_fnc_drawNumberSelections;

[_heli, _windSpeed * 1.94, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PR_TSD_WV] call fza_fnc_drawNumberSelections;

if (fza_ah64_tsdmode == "atk") then {
	_heli setobjecttexture [SEL_MPD_PR_TSD_PHASE, "\fza_ah64_us\tex\mpd\tsd.paa"];

	private _targetsToDraw = fza_ah64_tsddisptargs apply {
		private _targetType = "gen";
		private _targetModifier = "";
		private _targetPriority = 0;

		if (_x isKindOf "helicopter") then {
			_targetType = "hc";
		};

		if (_x isKindOf "plane") then {
			_targicon = "ac";
		};

		if (_x isKindOf "tank") then {
			_targicon = "tnk";
		};

		if (_x isKindOf "car") then {
			_targicon = "whl";
		};

		if ([_x] call fza_fnc_targetIsADA) then {
			_targicon = "ada";
		};

		if (_x in fza_ah64_currentpfz) then {
			_targetModifier = "_pfz";
		};
		if (_x == fza_ah64_mycurrenttarget) then {
			_targetModifier = "_trk";
			_targetPriority = 1;
		};

		private _targIcon = format ["\fza_ah64_US\tex\ICONS\ah64_%1%2.paa", _targetType, _targetModifier];
		if (_x in fza_ah64_shotat_list) then {
			_targIcon = "\fza_ah64_US\tex\ICONS\ah64_shotat.paa";
		};

		[_x, _targIcon, _targetPriority];
	};

	[_heli, _targetsToDraw, false] call fza_fnc_mpdUpdatePoints;	
} else {
	_heli setobjecttexture [SEL_MPD_PR_TSD_PHASE, ""];

	private _waypointIndex = 0;
	private _waypointsToDraw = [];
	
	{
		private _status = if (_waypointIndex == fza_ah64_curwpnum) then {"act"} else {"ina"};
		_waypointsToDraw pushBack [_x, format ["\fza_ah64_US\tex\ICONS\ah64_wp_%1_%2", _status, _waypointIndex], 0];
		_waypointIndex = _waypointIndex + 1;
	} forEach (fza_ah64_waypointdata);

	[_heli, _waypointsToDraw, false] call fza_fnc_mpdUpdatePoints;
};