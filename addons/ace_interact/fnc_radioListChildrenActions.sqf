/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];

private _actions = [];
private _currentRadio = [] call EFUNC(api,getCurrentRadio);
private _pttAssign = [] call EFUNC(api,getMultiPushToTalkAssignment);
private _radioList = [] call EFUNC(api,getCurrentRadioList);

{
    private _baseRadio = [_x] call EFUNC(api,getBaseRadio);
    private _item = ConfigFile >> "CfgWeapons" >> _baseRadio;
    private _displayName = getText (_item >> "displayName");
    private _currentChannel = [_x] call EFUNC(api,getRadioChannel);
    _displayName = format [localize LSTRING(channelShort), _displayName, _currentChannel];
    private _picture = getText (_item >> "picture");
    private _isActive = _x isEqualTo _currentRadio;

    private _action = [_x, _displayName, _picture, {}, {true}, {_this call FUNC(radioChildrenActions)}, [_x,_isActive, _pttAssign]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} forEach (_radioList);

if (count _radioList > 0) then {
    private _text = localize LSTRING(lowerHeadset);
    if (EGVAR(sys_core,lowered) == 1) then { _text = localize LSTRING(raiseHeadset); };
    private _action = ["acre_toggle_headset", _text, "", {[] call EFUNC(sys_core,toggleHeadset)}, {true}, {}, []] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
