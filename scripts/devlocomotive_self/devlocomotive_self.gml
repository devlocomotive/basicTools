
// 16.03.2021

//
function self_new(_key) {
	return self_set(_key, {});
}

//
function self_set(_key, _value) {
	variable_struct_set(self, _key, _value);
	return _value;
}

//
function self_get(_key) {
    return variable_struct_get(self, _key);
}

//
function self_exists(_key) {
    return variable_struct_exists(self, _key);
}

//
function self_remove(_key) {
    var _is_remove = self_exists(_key);
    if _is_remove variable_struct_remove(self, _key);
    return _is_remove;
}

//
function self_generate(_code) {
    var _struct = {};
    method(_struct, _code)();
    return _struct;
}
