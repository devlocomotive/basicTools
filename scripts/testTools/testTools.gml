
// 20.03.2021
// 21.03.2021

#region style

    /// @function tester(name, [tab]);
    /// @param name  {string}
    /// @param [tab] {number}
    /// @returns {struct}
    function tester(_name, _tab) {
        var _obj = {
        	run : false,
        	_name : _name,
        	_depth : 1,
        	_count : 0,
            _base : {},
            _curr : undefined,
            _tabs : is_undefined(_tab) ? 4 : _tab,
            _size : 80,
            _sect : "- ",
            _mark : false,
            set : function() {
            	self.run = false;
            	self._base = {};
            	if argument_count {
	                var _i = -1;
	                while (++_i < argument_count) self._base[$ string(argument[_i])] = undefined;
            	} else self._base[$ "all"] = undefined;
                return self;
            },
            is: function() {
            	self.run = false;
                if variable_struct_exists(self._base, "all") {
                	self.run = true;
                	return self;
                }
                var _i = -1;
                while (++_i < argument_count) if variable_struct_exists(self._base, string(argument[_i])) {
                	self.run = true;
                	return self;
                }
                return self;
            },
            sector : function(_newline) {
            	if _newline self.__logger(self.__tab());
            	var _text = string_repeat(self._sect, (self._size - self._tabs * self._depth) / string_length(self._sect));
            	self.__logger(self.__tab() + _text);
            	return self;
            },
            section : function(_name) {
            	if self.run {
            		if self._mark self.sector() else self._mark = true;
            		self.__logger("\n<" + string_repeat(" ", self._tabs - 1) + self.__tab(self._depth - 1) + "test - " + string(self._count++) + " :: " + _name);
            		self.sector();
	            	return true;
            	}
            	return false;
            },
            log : function() {
            	var _pack = array_create(argument_count + 1), _i = -1;
            	_pack[0] = ">";
            	while (++_i < argument_count) _pack[_i + 1] = argument[_i];
            	self.__logger(self.__tab() + script_execute_ext(print, _pack));
            	return self;
            },
            up : function() {
            	self._depth += 1;
            	return self;
            },
            down : function() {
            	self._depth = max(1, self._depth - 1);
            	return self;
            },
            ends : function(_message) {
            	if self._mark self.sector();
            	self.__logger(self.__tab());
            	self.__logger(self.__tab(1) + "Tester: " + string(self._name) + " it work\n" + self.__tab(1));
            	if is_string(_message) show_message(_message);
            },
            __logger : function(_value) {
            	show_debug_message(_value);
            },
            __tab : function(_count) {
            	if is_undefined(_count) _count = self._depth;
            	return string_repeat(" ", _count * self._tabs);
            },
        }
        var _tabt = _obj.__tab(1);
        _obj.__logger(_tabt + "\n" + _tabt + "Tester: " + string(_name));
        return _obj;
    }

#endregion

#region tools
    
    /// @function print(...text);
    /// @param ...text {string}
    /// @returns {void }
	function print() {
		var _str = "", _i = 0;
		repeat argument_count
			_str += string_replace_all(string_replace_all(string(argument[_i++]), "\n", "\\n"), "\t", "\\t") + (_i < argument_count ? " " : "");
		return _str;
	}
	
	/// @function error(...text);
    /// @param ...text {string}
    /// @returns {void }
	function error() {
		var _str = "", _i = 0;
		repeat argument_count
			_str += string_replace_all(string_replace_all(string(argument[_i++]), "\n", "\\n"), "\t", "\\t") + (_i < argument_count ? " " : "");
	    show_error("\n\tTESTER ERROR: " + string(_str) + "\n\n", true);
	}
	
	// global struct save
	if !variable_global_exists("___devlocomotive_testTools_glReference_temp") 
	    global.___devlocomotive_testTools_glReference_temp = self;
	
	/// @function gl();
	/// @returns {struct}
	function gl() {
	    static _tool = function() {
	        if !variable_global_exists("___devlocomotive_testTools_glReference_temp")
	            global.___devlocomotive_testTools_glReference_temp = self;
	        var _temp = global.___devlocomotive_testTools_glReference_temp;
	        global.___devlocomotive_testTools_glReference_temp = undefined;
	        var _toolset = {
	            ref : _temp,
	            find : function(_value) {
            		var _names = variable_struct_get_names(self.ref), _i = 0;
            		repeat array_length(_names)
            			if (variable_struct_get(self.ref, _names[_i++]) == _value) return true;
            		return false;
	            },
	            bomb : {
	                __state : false,
	                set : function() {
	                    if !self.__state {
	                        self.__state = true;
	                        exit;
	                    }
	                    error("bomb is set");
	                },
	                demine : function() {
	                    if self.__state {
	                        self.__state = false;
	                        exit;
	                    }
	                    error("bomb is not set");
	                }
	            },
	            stack : {
	                __id : NaN,
	                clear : function() {
	                    self.__id = 0;
	                },
	                push : function(_id) {
	                    if (_id == self.__id) {
                			self.__id += 1;
                			exit;
	                    }
                		error("gpush error: at " + string(self.__id) + " by " + string(_id));
	                }
	            }
	        }
	        return _toolset;
	    }();
	    return _tool;
	}
	
    /// @function checker(function, [argument]);
    /// @param function   {function/method}
    /// @param [argument] {any/array<any>}
    /// @returns {struct}
    function checker(_function) {
		try {
			var _argument = argument_count > 1 ? argument[1] : [];
			if !is_array(_argument) _argument = [_argument];
			if is_method(_function) {
			    var _bind = method_get_self(_function); _function = method_get_index(_function);
			    if is_undefined(_bind) error("checker.[thrower, unthrower] - error: for execute the no-bind-method used 'checker_target.[thrower_target, unthrower_target]'");
			    with _bind script_execute_ext(_function, _argument);
			} else script_execute_ext(_function, _argument);
			return {
			    work : true,
			    mess : undefined,
			}
		} catch (e) {
			return {
			    work : false,
			    mess : e,
			}
		}
	}
	
	/// @function thrower(function, [argument, throwMessage]);
    /// @param function      {function/method}
    /// @param [argument     {any/array<any>}
    /// @param throwMessage] {string}
    /// @returns {void }
	function thrower(_function) {
	    var _state = checker(_function, argument_count > 1 ? argument[1] : []);
    	if !_state.work or ((argument_count > 2) and (_state.mess == argument[2])) exit;
    	error("thrower -> error");
	}
	
	/// @function unthrower(function, [argument]);
    /// @param function       {function/method}
    /// @param [argument]     {any/array<any>}
    /// @returns {void }
	function unthrower(_function) {
	    var _state = checker(_function, argument_count > 1 ? argument[1] : []);
	    if _state.work exit;
	    error("unthrower -> error: " + string(_state.mess));
	}
    
    /// @function checker_target(space, key|function, [argument]);
    /// @param space      {struct/instance}
    /// @param function   {function/method/string}
    /// @param [argument] {any/array<any>}
    /// @returns {struct}
    function checker_target(_space, _function) {
		try {
			var _argument = argument_count > 1 ? argument[1] : [];
			if !is_array(_argument) _argument = [_argument];
			if is_string(_function) _function = variable_struct_get(_space, _function);
			if is_method(_function) {
			    var _bind = method_get_self(_function);
			    if !is_undefined(_bind) _space = _bind;
			    _function = method_get_index(_function);
			} 
			with _space script_execute_ext(_function, _argument);
			return {
			    work : true,
			    mess : undefined,
			}
		} catch (e) {
			return {
			    work : false,
			    mess : e,
			}
		}
	}
    
    /// @function thrower_target(space, key|function, [argument, throwMessage]);
    /// @param space         {struct/instance}
    /// @param function      {function/method/string}
    /// @param [argument     {any/array<any>}
    /// @param throwMessage] {string}
    /// @returns {void }
	function thrower_target(_space, _function) {
	    var _state = checker_target(_space, _function, argument_count > 2 ? argument[2] : []);
    	if !_state.work or ((argument_count > 3) and (_state.mess == argument[3])) exit;
    	error("thrower_target -> error");
	}
	
	/// @function unthrower_target(space, key|function, [argument]);
    /// @param space      {struct/instance}
    /// @param function   {function/method/string}
    /// @param [argument] {any/array<any>}
    /// @returns {void }
	function unthrower_target(_space, _function) {
	    var _state = checker_target(_space, _function, argument_count > 2 ? argument[2] : []);
    	if _state.work exit;
	    error("unthrower_target -> error: " + string(_state.mess));
	}
    
#endregion

#region addition

    //
    function structWork() {
        static _tool = {
            __stack : [],
            __nameMarker : "___devlocomotive_testTools_glReference_marker",
            mark : function(_struct) {
        		var _root = (array_length(self.__stack) == 0), _i = 0, _value, _names = variable_struct_get_names(_struct);
        		if _root and is_struct(_struct) {
        			if !variable_struct_exists(_struct, self.__nameMarker) {
        				variable_struct_set(_struct, self.__nameMarker, undefined);
        				array_push(self.__stack, _struct);
        			}
        		}
        		repeat array_length(_names) {
        			_value = variable_struct_get(_struct, _names[_i++]);
        			if is_struct(_value) and !variable_struct_exists(_value, self.__nameMarker) {
        				variable_struct_set(_value, self.__nameMarker, undefined);
        				array_push(self.__stack, _value);
        				self.mark(_value);
        			}
        		}
        		if _root {
        			_i = 0;
        			repeat array_length(self.__stack) variable_struct_remove(self.__stack[_i++], self.__nameMarker);
        			_value = self.__stack;
        			self.__stack = [];
        			return _value;
        		}
        	},
        	keys : function(_struct, _keys) {
        		if !is_array(_keys) _keys = [_keys];
        		var _marking = self.mark(_struct), _i = 0, _j, _value, _count = 0;
        		repeat array_length(_marking) {
        			_value = marking[_i++];
        			_j = 0;
        			repeat array_length(_keys) {
        				if variable_struct_exists(_value, _keys[_j++]) _count += 1;
        			}
        		}
        		return _count;
        	},
        	is : function(_struct, _keys) {
        	    return self.keys(_struct, _keys) > 0;
        	}
        }
        return _tool;
    }

#endregion
