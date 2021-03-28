

// 16.03.2021
// 26.03.2021

// devlocomotive_basic

/// GMEdit
/// https://github.com/YellowAfterlife/GMEdit/wiki

// local import
//!#import array.*           in Arr
//!#import variable_struct.* in Obj
//!#import string.*          in Str
//!#import buffer.*          in Buf

// import file
//!#import "#import-devlocomotive_basic"

// >> what is in the import file
// #import arrayExt.*         in ArrExt
// #import structExt.*        in ObjExt
// #import stringExt.*        in StrExt
// #import generator_method.* in GenMet
// <<

#region generator-method
	
	//
	#macro GENERATOR_ARRAY        generator_method_data(-1)
	#macro GENERATOR_UNDEF        generator_method_data(0)
	#macro GENERATOR_OBJCT        generator_method_data(1)
	#macro GENERATOR_FST          generator_method_get(0)
	#macro GENERATOR_LST          generator_method_get(1)
	#macro GENERATOR_CAST_BUNG    generator_method_bung
	#macro GENERATOR_CAST_EROR    generator_method_error
	#macro GENERATOR_CAST_RUNN    generator_method_runner
	
    /// @function generator_method_data([-1=[]|0=undefined|1={}=0]);
    /// @param [-1=[]|0=undefined|1={}=0] {sign}
    /// @returns {method}
    function generator_method_data(_array_undefined_struct_) {
        static _data_type =
            [ method(undefined, function() {return []})
            , method(undefined, function() {return undefined})
            , method(undefined, function() {return {}})
            ];
        if is_undefined(_array_undefined_struct_) return _data_type[1];
        try {
        	return _data_type[_array_undefined_struct_ + 1];
        } catch(_) {
        	throw "TODOTHROW";
        }
    }
    
    /// @function generator_method_get([0=fst|1=lst=0]);
    /// @param [0=fst|1=lst=0] {buffer_bool}
    /// @returns {method}
    function generator_method_get(_fst_lst_) {
        static _get_type =
            [ method(undefined, function() {return argument[0]})
            , method(undefined, function() {return argument[argument_count - 1]})
            ];
        if is_undefined(_fst_lst_) return _get_type[0];
        try {
        	return _get_type[_fst_lst_];
        } catch(_) {
        	throw "TODOTHROW";
        }
    }
    
    /// @function generator_method_bung(value);
    /// @param value {any}
    /// @returns {method}
    function generator_method_bung() {
        static _met = method_get_index(function() {
			return self._val;
		});
		return method({_val : argument[0]}, _met);
    }
    
    /// @function generator_method_error(message);
    /// @param {buffer_string} message {buffer_string}
    /// @returns {method}
    function generator_method_error() {
        static _met = method_get_index(function() {
    	    show_error(self._error, true);
		});
		return method({_error : argument[0]}, _met);
    }
	
	//
	function generator_method_runner(_arguments, _function) {
		static _runner = method_get_index(function() {
			var _arguments = self._arguments;
			if argument_count {
				_arguments = arrayExt_clone(_arguments);
				var _i = array_length(_arguments), _j = _i + argument_count;
				array_resize(_arguments, _j--);
				do {
					array_set(_arguments, _j, argument[_j - _i]);
				} until (_i == _j--);
			}
			if is_undefined(self._bind) return script_execute_ext(self._code, _arguments);
			if is_real(self._bind) and !instance_exists(self._bind) throw "TODOTHROW";
			with self._bind return script_execute_ext(self._code, _arguments);
		});
		var _code = get_function(_function, true);
		if (_code == -1) throw "TODOTHROW";
		var _bindfor = argument_count > 2 ? argument[2] : (is_method(_function) ? method_get_self(_function) : undefined);
		if is_undefined(_arguments) _arguments = [];
		return method({_bind: _bindfor, _code: _code, _arguments: _arguments}, _runner);
	}
	
#endregion

#region array
    
    /// @function arrayExt_clear(array);
    /// @param array {array<any>}
    /// @returns {<array>}
    function arrayExt_clear(_array) {
        array_resize(_array, 0);
        return _array;
    }
    
    /// @function arrayExt_set(dest, src);
    /// @param dest {array<any>}
    /// @param src  {array<any>}
    /// @returns {<dest>}
    function arrayExt_set(_dest, _src) {
        var _size = array_length(_src);
        array_resize(_dest, _size);
        if _size array_copy(_dest, 0, _src, 0, _size);
        return _dest;
    }
    
    /// @function arrayExt_clone(array);
    /// @param array {array<any>}
    /// @returns {array<any>}
    function arrayExt_clone(_array) {
        return arrayExt_set([], _array);
    }
	
    /// @function arrayExt_reverse(array, [0=build|1=modify=1]);
    /// @param array                {array<any>}
    /// @param [0=build|1=modify=1] {buffer_bool}
    /// @returns {<array>}
    function arrayExt_reverse(_array, _build_modify_) {
    	var _size = array_length(_array);
    	if !is_undefined(_build_modify_) and !_build_modify_ { // build-block
    		var _new_array = array_create(_size);
    		if (_size > 1) {
    			var _i = -1;
    			repeat _size array_set(_new_array, ++_i, array_get(_array, --_size));
    		}
    		return _new_array;
    	}
        if (_size > 1) { // modify-block
            var _swap, _i = -1;
            repeat (_size div 2) {
                _swap = array_get(_array, ++_i);
                array_set(_array, _i, array_get(_array, --_size));
                array_set(_array, _size, _swap);
            }
        }
        return _array;
    }
    
    /// @function arrayExt_shuffle(array, [0=build|1=modify=1]);
    /// @param array                {array<any>}
    /// @param [0=build|1=modify=1] {buffer_bool}
    /// @returns {<array>}
    function arrayExt_shuffle(_array, _build_modify_) {
    	if !is_undefined(_build_modify_) and !_build_modify_ _array = arrayExt_clone(_array); // modify-mode
        var _size = array_length(_array);
        if (_size > 1) {
            var _i = -1, _swap, _j;
            while (++_i < _size) {
                _j = irandom(_size - 1);
                _swap = array_get(_array, _i);
                array_set(_array, _i, array_get(_array, _j));
                array_set(_array, _j, _swap);
            }
        }
        return _array;
    }
	
	/// @function arrayExt_exists(array, value);
    /// @description
    /// @param array {array<any>}
    /// @param value {any}
    /// @returns {buffer_bool}
    function arrayExt_exists(_array, _value) {
        return (arrayExt_index(_array, _value) != -1);
    }
	
    /// @function arrayExt_index(array, value, [0=left|1=right=0, index=auto, step=1]);
    /// @description
    /// @param array             {array<any>}
    /// @param value             {any}
    /// @param [0=left|1=right=0 {buffer_bool}
    /// @param index=auto        {number}
    /// @param step=1]           {number}
    /// @returns {number}
    function arrayExt_index(_array, _value, _left_right_, _index, _step) {
        _value = arrayExt_find(_array, ____system_predicate_equal____(_value), _left_right_, _index, _step);
        ____system_predicate_equal____();
        return _value;
    }
	
	//
	function arrayExt_range_count(_array, _index, _count) {
		var _range = [], _size = array_length(_array);
		if _size {
			if is_undefined(_index) {
				_index = 0;
				if (_index > _size - 1) return _range;
			} else if (_index < 0) or (_index > _size - 1) return _range;
			while (_count--) array_set(_range, _count, array_get(_array, _count + _index));
		}
		return _range;
	}
	
	//
	function arrayExt_range_pos(_array, _index1, _index2) {
		return arrayExt_range_count(_array, _index1, _index2 - _index1 + 1);
	}
    
    /// @function arrayExt_empty(array, index, count, [value]);
    /// @param array {array<any>}
    /// @param index {number}
    /// @param count {number}
    /// @param [value] {number}
    /// @returns {buffer_bool}
    function arrayExt_empty(_array, _index, _count) {
        if (_index >= 0) and _count {
            var _length = array_length(_array), _size = _length - _index, _bool = (_size > 0);
            array_resize(_array, max(_length, _index + _count));
            if _bool {
                var _shift = _index + _count;
                while (_size--) array_set(_array, _size + _index, array_get(_array, _size + _shift));
            }
            if (argument_count > 3) {
                if _bool {
                    while (_count--) array_set(_array, _index + _count, argument[3]);
                    return true;
                }
                _size = array_length(_array);
                _length -= 1;
                while (++_length < _size) array_set(_array, _length, argument[3]);
            }
            return true;
        }
        return false;
    }
    
    /// @function arrayExt_shift(array);
    /// @param array {array<any>}
    /// @returns {any}
    function arrayExt_shift(_array) {
        if array_length(_array) {
            var _value = array_get(_array, 0);
            array_delete(_array, 0, 1);
            return _value;
        }
        throw "TODOTHROW";
    }
    
    /// @function arrayExt_unshift(array, ...values);
    /// @param array     {array<any>}
    /// @param ...values {any}
    /// @returns {<array>}
    function arrayExt_unshift(_array) {
        if arrayExt_empty(_array, 0, argument_count - 1) {
            var _i = 0;
            while (++_i < argument_count) array_set(_array, _i - 1, argument[_i]);
        }
        return _array;
    }
    
    /// @function arrayExt_place(array, index, ...values);
    /// @param array     {array<any>}
    /// @param index     {number}
    /// @param ...values {any}
    /// @returns {<array>}
    function arrayExt_place(_array, _index) {
        if (_index >= 0) {
            array_resize(_array, max(array_length(_array), _index + argument_count - 2));
            var _i = 1;
            while (++_i < argument_count) array_set(_array, _i - 2, argument[_i]);
        }
        return _array;
    }
    
    /// @function arrayExt_remove(array, range);
    /// @param array {array<any>}
    /// @param range {array<number>}
    /// @returns {number}
    function arrayExt_remove(_array, _range) {
        var _array_length = array_length(_array);
        var _range_length = array_length(_range);
        if _array_length and _range_length {
            _range = arrayExt_clone(_range);
            array_sort(_range, true);
            var _temp = [], _i = 0; _array_length -= 1;
            do {
            	_value = _range[_i];
                if (_value > _array_length) break;
                if (_value < 0) continue;
                array_push(_temp, _array[_value]);
            } until (++_i == _range_length);
            var _size = array_length(_temp);
            if _size {
                arrayExt_set(_array, _temp);
                return (_array_length - _size + 1);
            }
        }
        return 0;
    }
    
    /// @function arrayExt_copy(dest, src, [dest_index=length<dest>, src_index=0, length=max]);
    /// @param dest                     {array<any>}
    /// @param src                      {array<any>}
    /// @param [dest_index=length<dest> {number}
    /// @param src_index=0              {number}
    /// @param length=max]              {number}
    /// @returns {<dest>}
    function arrayExt_copy(_dest, _src, _dest_index, _src_index, _length) {
        var _dest_length = array_length(_dest);
        var _src_length = array_length(_src);
        if is_undefined(_dest_length) _dest_index = _dest_length else if (_dest_index < 0) _dest_index += _dest_length;
        if is_undefined(_src_index)   _src_index  = 0            else if (_src_index < 0)  _src_index  += _src_length;
        if (_dest_index >= 0) and (_src_index >= 0) and (_src_index <= _src_length - 1) {
            if is_undefined(_length) _length = _src_length - _src_index else _length = min(_length, _src_length - _src_index);
            if _length {
                array_resize(_dest, max(_dest_length, _dest_index + _length));
                if (_dest == _src) {
                    if (_dest_index == _src_index) return _dest;
                    if (_dest_index > _src_index) {
                    	while (_length--) array_set(_dest, _length + _dest_index, array_get(_src, _length + _src_index));
                        return _dest;
                    }
                }
                var _i = 0;
                do {
                	array_set(_dest, _i + _dest_index, array_get(_src, _i + _src_index));
                } until (++_i == _length);
            }
        }
        return _dest;
    }
    
    /// @function arrayExt_insert(dest, src, [dest_index=0, src_index=0, length=max]);
    /// @param dest          {array<any>}
    /// @param src           {array<any>}
    /// @param [dest_index=0 {number}
    /// @param src_index=0   {number}
    /// @param length=max]   {number}
    /// @returns {<dest>}
    function arrayExt_insert(_dest, _src, _dest_index, _src_index, _length) {
        var _dest_length = array_length(_dest);
        var _src_length = array_length(_src);
        if is_undefined(_dest_length) _dest_index = 0 else if (_dest_index < 0) _dest_index += _dest_length;
        if is_undefined(_src_index)   _src_index  = 0 else if (_src_index < 0)  _src_index  += _src_length;
        if (_dest_index >= 0) and (_src_index >= 0) and (_src_index <= _src_length - 1) {
            if is_undefined(_length) _length = _src_length - _src_index else _length = min(_length, _src_length - _src_index);
            if _length {
                array_resize(_dest, _dest_length + _length);
                var _size = _dest_length - _dest_index;
                if _size {
                    var _dest_shift = _dest_index + _length;
                    if (_dest == _src) {
                        var _temp = array_create(_length), _i = -1;
                        while (++_i < _length) array_set(_temp, _i                 , array_get(_src, _i + _src_index)); _i = -1;
                        while (_size--)        array_set(_dest, _size + _dest_index, array_get(_dest, _size + _dest_shift));
                        while (++_i < _length) array_set(_dest, _i + _dest_index   , array_get(_temp, _i));
                        return _dest;
                    }
                    while (_size--) array_set(_dest, _size + _dest_index, array_get(_dest, _size + _dest_shift));
                }
                while (_length--) array_set(_dest, _length + _dest_index, array_get(_src , _length + _src_index));
            }
        }
        return _dest;
    }
    
    /// @function arrayExt_map(array, handler, [-1=build|0=apply|1=modify=0]);
    /// @param array                         {array<any>}
    /// @param handler                       {function<any->any>} // handler = (value, index, array) => code -> any
    /// @param [-1=build|0=apply|1=modify=0] {sign}
    /// @returns {array<any>/<array>}
    function arrayExt_map(_array, _handler, _build_apply_modify_) {
        _build_apply_modify_ = is_real(_build_apply_modify_) ? sign(_build_apply_modify_) : 0;
        var _i = 0, _size = array_length(_array);
        if (_build_apply_modify_ != 0) {
            var _arModify = _build_apply_modify_ ? array_create(_size) : _array;
            do {
            	array_set(_arModify, _i, _handler(array_get(_array, _i), _i, _array));
            } until (++_i == _size);
            return _arModify;
        }
        do {
	    	_handler(array_get(_array, _i), _i, _array);
	    } until (++_i == _size);
        return _array;
    }
    
    /// @function arrayExt_filter(array, predicate, [0=build|1=modify=0]);
    /// @param array                {array<any>}
    /// @param predicate            {function<any->buffer_bool>} // predicate = (value, index, array) => code -> bool
    /// @param [0=build|1=modify=0] {buffer_bool}
    /// @returns {array<any>/<array>}
    function arrayExt_filter(_array, _predicate, _build_modify_) {
        var _size = array_length(_array), _new_array = [];
        if _size {
            var _i = 0, _value;
            do {
            	_value = _array[_i];
                if _predicate(_value, _i, _array) array_push(_new_array, _value);
            } until (++_i == _size);
        }
        return _build_modify_ ? arrayExt_set(_array, _new_array) : _new_array;
    }
    
    /// @function arrayExt_fold(array, handler, [0=left|1=right=0, accumulate=auto]);
    /// @param array              {array<any>}
    /// @param handler            {function<any->any>} // handler = (value, index, array) => code -> any
    /// @param [0=left|1=right=0 {buffer_bool}
    /// @param accumulate=auto]  {any}
    /// @returns {any}
    function arrayExt_fold(_array, _handler, _left_right_) {
        var _size = array_length(_array);
        if _size {
            var _init;
            if _left_right_ {
                _init = (argument_count > 3) ? argument[3] : _array[--_size];
                while (_size--) _init = _handler(_init, _array[_size], _size, _array);
            } else {
                var _i = -1;
                _init = (argument_count > 3) ? argument[3] : _array[++_i];
                while (++_i < _size) _init = _handler(_init, _array[_i], _i, _array);
            }
            return _init;
        }
        throw "";
    }
    
    /// @function arrayExt_find(array, predicate, [0=left|1=right=0, index=auto, step=1]);
    /// @description
    /// @param array             {array<any>}
    /// @param predicate         {function<any->buffer_bool>} // predicate = (value, index, array) => code -> bool
    /// @param [0=left|1=right=0 {buffer_bool}
    /// @param index=auto        {number}
    /// @param step=1]           {number}
    /// @returns {number}
    function arrayExt_find(_array, _predicate, _left_right_, _index, _step) {
        var _size = array_length(_array);
        if (_size--) {
            _left_right_ = buffer_bool(_left_right_);
            if is_undefined(_index) _index = (_left_right_ ? _size : 0);
            else {
                // _index = round(_index);
                if (_index < 0) or (_index > _size) return -1;
            }
            if is_undefined(_step) _step = 1;
            else {
                // _step = round(_step);
                if (_step < 1) return -1;
            }
            if _left_right_ {
                do {
                    if _predicate(_array[_index], _index, _array) return _index;
                    _index -= _step;
                } until (_index < 0);
            } else {
                do {
                    if _predicate(_array[_index], _index, _array) return _index;
                    _index += _step;
                } until (_index > _size); // if (_size--) {
            }
        }
        return -1;
    }
    
    /// @function arrayExt_concat(array, 0=build|1=modify, ...values);
    /// @param array            {array<any>}
    /// @param 0=build|1=modify {buffer_bool}
    /// @param ...values        {any}
    /// @returns {array<any>/<array>}
    function arrayExt_concat(_array, _build_modify_) {
        if !_build_modify_ _array = arrayExt_clone(_array);
        if argument_count {
            var _length = array_length(_array);
            var _i = 2, _value, _size, _point;
            do {
                _value = argument[_i];
                if is_array(_value) {
                    _size = array_length(_value);
                    if _size {
                        _point = _length;
                        _length += _size;
                        while (_size--) array_set(_array, _point + _size, _value[_size]);
                    }
                    continue;
                }
                array_set(_array, _length++, _value);
            } until (++_i == argument_count);
        }
        return _array;
    }
    
    /// @function arrayExt_every(array, predicate);
    /// @param array     {array<any>}
    /// @param predicate {function<any->buffer_bool>} // predicate = (value, index, array) => code -> bool
    /// @returns {buffer_bool}
    function arrayExt_every(_array, _predicate) {
        var _size = array_length(_array);
        if _size {
            var _i = 0;
            do {
            	if !_predicate(_array[_i], _i, _array) return false;
            } until (++_i == _size);
        }
        return true;
    }
    
    /// @function arrayExt_some(array, predicate);
    /// @param array     {array<any>}
    /// @param predicate {function<any->buffer_bool>} // predicate = (value, index, array) => code -> bool
    /// @returns {buffer_bool}
    function arrayExt_some(_array, _predicate) {
        var _size = array_length(_array);
        if _size {
        	var _i = 0;
            do {
            	if _predicate(_array[_i], _i, _array) return true;
            } until (++_i == _size);
        }
        return false;
    }
    
    //
    function arrayExt_noorder_remove(_array, _data, _index_value_) {
    	var _size = array_length(_array);
    	if (_size--) {
    		if _index_value_ _data = arrayExt_index(_array, _data);
    		if (_data != -1) {
    			if (_data != _size) array_set(_array, _data, _array[_size]);
				array_resize(_array, _size);
	    		return true;
    		}
    	}
    	return false;
    }
    
#endregion

#region struct
    
    /// @function structExt_copy(where, from, [replace=true, names='all', handler=none]);
    /// @description
    /// @param where         {struct}
    /// @param from          {struct}
    /// @param [replace=true {buffer_bool}
    /// @param names='all'   {array[buffer_string]}
    /// @param handler=none] {method/function}
    /// @returns {<where>}
    function structExt_copy(_where, _from, _replace, _names, _handler) {
        var _exists = false;
        if is_undefined(_names) {
        	_names = variable_struct_get_names(_from);
        	if _replace {
        		var _i = 0, _key;
        		do {
        			_key = _names[_i];
        			variable_struct_set(_where, _key, _handler(variable_struct_get(_from, _key), _key, _from));
        		} until (++_i == _size);
        		return _where;
        	}
        	_exists = true;
        }
        var _size = array_length(_names);
        if _size {
        	if is_undefined(_replace) _replace = true;
        	if is_undefined(_handler) _handler = GENERATOR_FST;
        	var _i = 0, _key;
        	do {
        		_key = _names[_i];
	            if (_exists or variable_struct_exists(_from, _key))
	            and (_replace or !variable_struct_exists(_where, _key))
	                variable_struct_set(_where, _key, _handler(variable_struct_get(_from, _key), _key, _from));
        	} until (++_i == _size);
        }
        return _where;
    }
    
	/// @function structExt_copyExcept(where, from, [replace=true, namesExcept=none, handler=none]);
	/// @description
    /// @param where            {struct}
    /// @param from             {struct}
    /// @param [replace=true    {buffer_bool}
    /// @param namesExcept=none {array[buffer_string]}
    /// @param handler=none]    {method/function}
    /// @returns {<where>}
    function structExt_copyExcept(_where, _from, _replace, _namesExcept, _handler) {
    	if is_undefined(_namesExcept) return structExt_copy(_where, _from, _replace, undefined, _handler);
    	var _names = variable_struct_get_names(_from), _size = array_length(_names);
    	if _size {
    		if is_undefined(_replace) _replace = true;
    		if is_undefined(_handler) _handler = GENERATOR_FST;
    		_namesExcept = arrayExt_clone(_namesExcept);
    		var _i = 0, _key;
    		do {
    			_key = _names[_i];
	            if !arrayExt_noorder_remove(_namesExcept, _key, true)
	            and (_replace or !variable_struct_exists(_where, _key))
	                variable_struct_set(_where, _key, _handler(variable_struct_get(_from, _key), _key, _from));
    		} until (++_i == _size);
    	}
        return _where;
    }
    
    /// @function structExt_updata(struct, handler);
    /// @description
    /// @param struct  {struct}
    /// @param handler {method/function}
    /// @returns {<struct>}
    function structExt_updata(_struct, _handler) {
    	var _names = variable_struct_get_names(_struct), _size = array_length(_names);
    	if _size {
    		var _i = 0, _key;
    		do {
    			_key = _names[_i];
        		variable_struct_set(_struct, _key, _handler(variable_struct_get(_struct, _key), _key, _struct));
    		} until (++_i == _size);
    	}
        return _struct;
    }
    
    /// @function structExt_remove(struct, names);
    /// @description
    /// @param struct {struct}
    /// @param names  {array[buffer_string]}
    /// @returns {number}
    function structExt_remove(_struct, _names) {
    	if is_undefined(_names) {
    		_names = variable_struct_get_names(_struct);
    		var _size = array_length(_names);
    		if _size {
    			var _i = 0;
    			do {
    				variable_struct_remove(_struct, _names[_i]);
    			} until (++_i == _size);
    			return _size;
    		}
    		return 0;
    	}
    	if is_array(_names) {
    		var _size = array_length(_names), _size_struct = variable_struct_names_count(_struct);
    		if _size and _size_struct {
    			var _i = 0, _count = 0, _key;
    			do {
    				_key = _names[_i];
    				if variable_struct_exists(_struct, _key) {
    					variable_struct_remove(_struct, _key);
    					if (++_count == _size_struct) return _size_struct;
    				}
    			} until (++_i == _size);
    			return _count;
    		}
    		return 0;
    	}
    	if is_string(_names) and variable_struct_exists(_struct, _names) {
			variable_struct_remove(_struct, _names);
			return 1;
    	}
    	return 0;
    }
    
    /// @function structExt_leave(struct, names);
    /// @description
    /// @param struct {struct}
    /// @param names  {array[buffer_string]}
    /// @returns {number}
    function structExt_leave(_struct, _names) {
        if is_undefined(_names) return 0;
        if !is_array(_names) {
        	if !is_string(_names) return 0;
        	_names = [_names];
        }
        var _reader = variable_struct_get_names(_struct), _size = array_length(_reader);
        if _size {
        	var _i = 0, _count = 0, _key;
        	do {
				_key = _reader[_i];
				if !arrayExt_exists(_names, _key) {
					variable_struct_remove(_struct, _key);
					_count += 1;
				}
			} until (++_i == _size);
			return _count;
        }
        return 0;
    }
    
    //
    function structExt_clear(_struct) {
    	structExt_remove(_struct, undefined);
    	return _struct;
    }
    
    /// @function structExt_marker(struct, name, runner);
    /// @description
    /// @param struct {struct}
    /// @param name   {buffer_string}
    /// @param runner {method/function}
    /// @returns {any}
    function structExt_marker(_struct, _name, _runner) {
        if variable_struct_exists(_struct, _name)
            return variable_struct_get(_struct, _name);
        else {
            var _value = _runner();
            variable_struct_set(_struct, _name, _value);
            return _value;
        }
    }
    
    /// @function structExt_field(struct, name, [*value]);
    /// @description
    /// @param struct   {struct}
    /// @param name     {buffer_string}
    /// @param [*value] {void/any}
    /// @returns {buffer_bool/any}
    function structExt_field(_struct, _name) {
        if (argument_count > 2) {
            if variable_struct_exists(_struct, _name)
                return variable_struct_get(_struct, _name);
            else {
                variable_struct_set(_struct, _name, argument[2]);
                return argument[2];
            }
        }
        return variable_struct_exists(_struct, _name);
    }
    
    //
    function structExt_clone(_struct, _handler) {
    	return structExt_copy({}, _struct, true, undefined, _handler);
    }
    
    //
    function structExt_find(_struct, _predicate) {
    	var _names = variable_struct_get_names(_struct), _size = array_length(_names), _key;
    	while (_size--) {
    		_key = _names[_size];
    		if _predicate(variable_struct_get(_struct, _key), _key, _struct) return _key;
    	}
    	return undefined;
    }
    
    //
    function structExt_key(_struct, _value) {
        _value = structExt_find(_struct, ____system_predicate_equal____(_value));
        ____system_predicate_equal____();
        return _value;
    }
    
    //
    function structExt_exists(_struct, _value) {
    	return !is_undefined(structExt_key(_struct, _value));
    }
    
    //
    function structExt_filter(_struct, _predicate) {
    	var _names = variable_struct_get_names(_struct), _size = array_length(_names), _key;
    	while (_size--) {
    		_key = _names[_size];
    		if !_predicate(variable_struct_get(_struct, _key), _key, _struct) structExt_remove(_struct, _key);
    	}
    	return _struct;
    }
    
#endregion

#region string
    
    //
    function stringExt_startsWith(_substring, _string, _position) {
        if !is_numeric(_position) _position = 1;
        return string_pos(_substring, string_delete(_string, 1, _position - 1)) == 1;
    }
    
    //
    function stringExt_endsWith(_substring, _string, _length) {
        if !is_numeric(_length) _length = string_length(_string);
        return string_last_pos(_substring, string_copy(_string, 1, _length)) == (_length - string_length(_substring) + 1);
    }
    
    //
    function stringExt_range(_string, _index_begin, _index_end) {
    	return string_copy(_string, _index_begin, _index_end - _index_begin + 1);
    }
    
    //
    function stringExt_replace_count(_substring, _string, _index, _count) {
    	if (_count <= 0) return string_insert(_substring, _string, _index);
    	if (_index < 1) or (_index-- > string_length(_string)) throw "";
    	return stringExt_concat(string_copy(_string, 1, _index), _substring, string_delete(_string, 1, _index + _count));
    }
    
    //
    function stringExt_replace_pos(_substring, _string, _index_begin, _index_end) {
    	return stringExt_replace_count(_substring, _string, _index_begin, _index_end - _index_begin + 1);
    }
	
    //
    function stringExt_selector(_string, _selector, _mode) {
    	static _temp_selector = new StringSelector(undefined);
    	if is_undefined(_mode) _mode = true;
    	if is_struct(_selector) and (instanceof(_selector) == "StringSelector") {
    		var _save_mode = _selector.mode;
    		var _result = _selector.mode_set(_mode).filter(_string);
    		_selector.mode_set(_save_mode);
    		return _result;
    	}
    	if is_array(_selector)
    		_temp_selector.selector_set(_selector);
    	else if is_string(_selector)
    		_temp_selector.add(_selector);
    	var _result = _temp_selector.mode_set(_mode).filter(_string);
    	_temp_selector.clear();
    	return _result;
    }
    
    //
    function stringExt_filter(_string, _predicate) {
    	var _size = string_length(_string);
    	if _size {
    		var _i = 1, _char, _interface = ____system_string_memory____(), _concat = _interface.concat;
    		do {
    			_char = string_char_at(_string, _i);
    			if _predicate(_char, _i, _string) _concat.add(_char);
    		} until (_i++ == _size);
    		return _interface.updata();
    	}
    	return "";
    }
    
    //
    function stringExt_map(_string, _handler) {
    	var _size = string_length(_string);
    	if _size {
    		var _i = 1, _interface = ____system_string_memory____(), _concat = _interface.concat;
    		do {
    			_concat.add(_handler(string_char_at(_string, _i), _i, _string));
    		} until (_i++ == _size);
    		return _interface.render();
    	}
    	return "";
    }
    
    //
    function stringExt_concat() {
    	if argument_count {
    		var _interface = ____system_string_memory____(), _concat = _interface.concat, _i = 0;
	    	do {
	    		_concat.add(argument[_i]);
	    	} until (++_i == argument_count);
	    	return _interface.updata();
    	}
    	return "";
    }

#endregion

#region metwrap
    
    /// @function runFor([run=generator_method_(), class=undefined]);
    /// @description
    /// @param [run=generator_method_() {function/method}
    /// @param class=undefined] {struct/instance}
    /// @returns {method}
    function runFor(_run, _class) {
        static _default = generator_method_();
        if is_undefined(_run) return _default;
        return method(_class, _run);
    }
    
    /// @function unFrom([meth=method_get_index(generator_method_())]);
    /// @description
    /// @param [meth=method_get_index(generator_method_())] {method}
    /// @returns {function}
    function unFrom(_meth) {
        static _default = method_get_index(generator_method_());
        if is_undefined(_meth) return _default;
        return method_get_index(_meth);
    }
    
#endregion

#region Class
	
	//
	function StringConcat(_size) constructor {
		self.__buffer = buffer_create(is_undefined(_size) ? 256 : _size, buffer_grow, 1);
		static add = function(_string) {
			buffer_write(self.__buffer, buffer_text, _string);
			return self;
		}
		static push = function() {
			var _i = -1;
			while (++_i < argument_count) buffer_write(self.__buffer, buffer_text, argument[_i]);
			return self;
		}
		static soak = function(_food) {
			if is_struct(_food) {
				if !variable_struct_exists(_food, "__buffer") throw "";
				_food = _food.__buffer;
			}
			buffer_copy(_food, 0, buffer_tell(_food), self.__buffer, buffer_tell(self.__buffer));
			return self;
		}
		static render = function(_delete, _clear) {
			if is_undefined(_delete) _delete = true;
			if !_delete var _writer = !_clear ? 0 : buffer_tell(self.__buffer);
			buffer_write(self.__buffer, buffer_u8, 0);
			buffer_seek(self.__buffer, buffer_seek_start, 0);
			var _string = buffer_read(self.__buffer, buffer_string);
			if !_delete buffer_seek(self.__buffer, buffer_seek_start, _writer) else self.destroy();
			return _string;
		}
		static blur = function(_food) {
			if is_undefined(_food) return self.render(true, false);
			buffer_copy(self.__buffer, 0, buffer_tell(self.__buffer), _food, buffer_tell(_food));
			self.destroy();
			return undefined;
		}
		static clear = function(_newsize) {
			buffer_seek(self.__buffer, buffer_seek_start, 0);
			if !is_undefined(_newsize) buffer_resize(self.__buffer, _newsize);
			return self;
		}
		static destroy = function() {
			buffer_delete(self.__buffer);
			return undefined;
		}
	}
	
	//
    function StringSelector(_param) constructor {
    	self.mode = true;
    	self.__selector = [];
    	self.__render = "";
    	static __char_add = function(_char) {
    		var _size = array_length(self.__selector);
    		_char = ord(_char);
    		if _size {
    			var _i = -1, _pack, _temp, _is = false;
    			while (++_i < _size) {
    				_pack = self.__selector[_i];
    				if (_char >= _pack[0]) {
    					if (_char > _pack[1]) {
    						if (_char - 1 == _pack[1]) {
    							_is = true;
    							self.__render = undefined;
    							if (++_i < _size) {
    								_temp = self.__selector[_i];
    								if (_temp[0] == _char + 1) {
    									array_set(_pack, 1, _temp[1]);
    									array_delete(self.__selector, _i, 1);
    									break;
    								}
    							}
    							array_set(_pack, 1, _char);
			    				break;
    						}
    						continue;
    					}
    					break;
    				}
    				if (_char < _pack[0]) {
    					_is = true;
    					self.__render = undefined;
    					if (_char + 1 == _pack[0]) {
    						array_set(_pack, 0, _char);
    						break;
    					}
    					array_insert(self.__selector, _i, [_char, _char]);
    					break;
    				}
    			}
    			if _is exit;
    		}
    		self.__render = undefined;
    		array_push(self.__selector, [_char, _char]);
    	}
    	static __char_remove = function(_char) {
    		var _size = array_length(self.__selector);
    		if _size {
    			_char = ord(_char);
    			var _i = -1, _pack;
    			while (++_i < _size) {
    				_pack = self.__selector[_i];
    				if (_pack[0] >= _char) {
    					if (_char > _pack[1]) continue;
    					self.__render = undefined;
    					if (_char == _pack[0]) {
    						if (_char == _pack[1]) {
	    						array_delete(self.__selector, _i, 1);
	    						exit;
	    					}
    						array_set(_pack, 0, _char + 1);
    						exit;
    					}
						if (_char == _pack[1]) {
							array_set(_pack, 1, _char - 1);
							exit;
						}
						_size = [_pack[0], _char - 1];
						array_set(_pack, 0, _char + 1);
						array_insert(self.__selector, _i, _size);
    				}
    			}
    		}
    	}
    	static __char_is = function(_char) {
    		var _size = array_length(self.__selector);
    		if _size {
    			_char = ord(_char);
    			var _i = -1, _pack;
    			while (++_i < _size) {
    				_pack = self.__selector[_i];
    				if ((_char >= _pack[0] and _char <= _pack[1]) == self.mode) return true;
    			}
    		}
    		return false;
    	}
    	static add = function(_string) {
    		if is_string(_string) {
    			var _size = string_length(_string);
    			if _size {
    				var _i = 0;
    				while (_i++ < _size) self.__char_add(string_char_at(_string, _i));
    			}
    		}
    		return self;
    	}
    	static remove = function(_string) {
    		if is_string(_string) and string_length(_string) {
	    		var _i = 0;
    			while (_i++ < _size) self.__char_remove(string_char_at(_string, _i));
    		}
    		return self;
    	}
    	static clear = function() {
    		self.__selector = [];
    		self.__render = "";
    		self.mode = true;
    		return self;
    	}
    	static is = function(_string) {
    		if is_string(_string) {
    			var _size = string_length(_string);
    			if _size {
    				var _i = 0;
    				while (_i++ < _size) if !self.__char_is(string_char_at(_string, _i)) return false;
    			}
    		}
    		return true;
    	}
    	static filter = function(_string) {
    		if is_string(_string) return stringExt_filter(_string, self.__char_is);
    		return "";
    	}
    	static replace = function(_substring, _string) {
    		var _interface = ____system_string_memory____(), _concat = _interface.concat;
    		if is_string(_string) {
    			var _size = string_length(_string);
    			if _size {
    				var _i = 0, _char;
    				while (_i++ < _size) {
    					_char = string_char_at(_string, _i);
    					_concat.add(self.__char_is(_char) ? _char : _substring);
    				}
    			}
    		}
    		return _interface.updata();
    	}
    	static write = function() {
    		if is_undefined(self.__render) {
    			var _size = array_length(self.__selector);
    			if _size {
    				var _interface = ____system_string_memory____(), _concat = _interface.concat;
    				var _i = -1, _in, _out;
    				while (++_i < _size) {
    					_out = self.__selector[_i];
    					_in = _out[0]; _in = _out[1];
    					do {
    						concat.add(chr(_in++));
    					} until (_in == _out);
    				}
    				self.__render = _interface.updata();
    				return self.__render;
    			}
    			self.__render = "";
    			return "";
    		}
    		return self.__render;
    	}
		static read = function(_string_selector) {
			return self.clear().add(_string_selector);
		}
    	static clone = function() {
    		var _new_selector = new StringSelector(undefined);
    		_new_selector.__selector = self.selector_get();
    		_new_selector.__render = self.write();
    		_new_selector.mode = self.mode;
    		return _new_selector;
    	}
    	static selector_get = function() {
    		return arrayExt_map(self.__selector, arrayExt_clone, -1);
    	}
    	static selector_set = function(_selector) {
    		self.__render = undefined;
    		self.__selector = arrayExt_map(_selector, arrayExt_clone, -1);
    		return self;
    	}
    	static mode_set = function(_mode) {
    		self.mode = bool(_mode);
    		return self;
    	}
    	if is_string(_param)
    		self.add(_param);
    	else if is_array(_param) 
    		self.selector_set(_param);
    	else if is_struct(_param) and (instanceof(_param) == "StringSelector") {
    		self.selector_set(_param.__selector);
    		self.__render = _param.write();
    	}
    }
    
#endregion

#region [convenient in gmedit] template-string
	
    //
    // https://github.com/YellowAfterlife/GMEdit/wiki/Using-template-strings
    function sfmt(_format) { // full clone + memory controller
    	static _memory = ____system_string_memory____();
    	if _memory.exists(_format) {
			var _stack = _memory.stack(), _size = array_length(_stack);
    		var _concat = _memory.concat, _text, _i = -1, _argument = 1;
    		while (++_i < _size) {
    			_text = _stack[_i];
    			_concat.add(is_string(_text) ? _text : string(argument[_argument++]));
    		}
    		return _memory.updata();
    	}
    	var _size = string_length(_format);
    	if _size {
    		var _i = 0, _j = 1, _concat = _memory.concat, _length, _text, _argument = 1, _savemem = [];
    		while (_i++ < _size)
    			if (string_char_at(_format, _i) == "%") {
    				_length = _i - _j;
    				if _length {
    					_text = string_copy(_format, _j, _length);
    					array_push(_savemem, _text);
    					_concat.add(_text);
    				}
    				_j = _i + 1;
    				_concat.add(string(argument[_argument++]));
    				array_push(_savemem, undefined);
    			}
    		if (_argument == 1) {
    			_concat.clear();
    			return _format;
    		}
    		_length = _i - _j;
    		if _length {
    			_text = string_copy(_format, _j, _length);
				array_push(_savemem, _text);
				_concat.add(_text);
    		}
    		return _memory.create(_format, _savemem);
    	}
    	return "";
    }

#endregion

#region [convenient in gmedit] null-conditional (operators + assignment)
	
	//
	#macro nc_val global.___nc_val
	
	//
	// https://github.com/YellowAfterlife/GMEdit/wiki/Using-null-conditional-operators
	function nc_set(_value) { // full clone
		global.___nc_val = _value;
		return !is_undefined(_value) and (_value != noone);
	}

#endregion

#region system
	
	//
	function stringMemoryAutoCleaner() {
		static _memory = ____system_string_memory____();
		var _i = 0, _pack = variable_struct_get(_memory, "0");
		while (_i < _memory.count) {
			if (_pack.lifetime-- < 0) {
				variable_struct_remove(_memory.map, _pack.key);
				_pack = variable_struct_get(_memory, string(--_memory.count));
				_pack.ref.id = string(_i);
				variable_struct_set(_memory, string(_i), _pack);
				variable_struct_remove(_memory, string(_memory.count));
				continue;
			}
			_pack = variable_struct_get(_memory, string(++_i));
		}
		if (_memory.sizeTimeout >= 0) and (--_memory.sizeTimeout == -1) {
			var _size_crop = round(_memory.size * 0.65);
			if (_size_crop > 1024) {
				buffer_resize(_memory.concat.__buffer, _size_crop);
				_memory.sizeTimeout = 12;
				exit;
			}
			buffer_resize(_memory.concat.__buffer, 1024);
		}
		_memory.autoCastTime = 450;
	}
	
	//
	function get_function(_function, _getOnlyUser) {
		if is_method(_function) _function = method_get_index(_function);
		if script_exists(_function) {
			if _getOnlyUser {
				var _name = script_get_name(_function);
				if (asset_get_type(_name) == asset_unknown) return -1;
			}
			return _function;
		}
		return -1;
	}
	
#endregion

#region --hide system
	
	//
	function ____system_predicate_equal____() {
		static _predicate_equal = {
        	_check_left : undefined,
        	_predicate : function(_check_right) {
        		return self._check_left == _check_right;
        	},
        }
        if (argument_count == 0) {
        	delete _predicate_equal._check_left;
        	exit;
        }
        _predicate_equal._check_left = argument[0];
		return _predicate_equal._predicate;
	}
	
	//
	function ____system_string_memory____() {
		static _interface = {
			autoCastTime: 450,
			concat: new StringConcat(1024),
			lifetime: 4,
			count: 0,
			map: {},
			size: 1024,
			sizeTimeout: -1,
			updata: function() {
				var _newsize = buffer_tell(self.concat.__buffer);
				if (_newsize >= self.size) {
					self.size = _newsize;
					self.sizeTimeout = 12;
				}
				if (autoCastTime-- < 0) stringMemoryAutoCleaner();
				return self.concat.render(false);
			},
			create: function(_format, _savemem) {
				var _ref_id = {id: self.count, stack: _savemem};
	    		var _ref_fm = {lifetime: self.lifetime, key: _format};
	    		_ref_id.ref = _ref_fm;
	    		_ref_fm.ref = _ref_id;
	    		variable_struct_set(self.map, _format, _ref_id);
				variable_struct_set(self, string(self.count++), _ref_fm);
				return self.updata();
			},
			exists: function(_format) {
				self.__stack = variable_struct_get(self.map, _format);
				return !is_undefined(self.__stack);
			},
			__stack: undefined,
			stack: function() {
				var _stack = self.__stack.stack;
				self.__stack.ref.lifetime = self.lifetime;
				self.__stack = undefined;
				return _stack;
			},
		}
		return _interface;
	}
	
	//
	var _buffer = ____system_string_memory____().concat.__buffer;
	AfterGame_add(_buffer, function(_buffer) {
		buffer_delete(_buffer);
		show_debug_message(">> devlocomotive_basic: auto free memory");
	}, undefined);
	
#endregion

// TODO fix static-field
// TODO JDoc updata
// TODO while -> do until -> for optimizate
// TODO optimizate
