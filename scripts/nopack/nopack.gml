
#region predicate-work
	
	//
	function build_predicate_gl() {
		static _interface = function() {
			var _base = new build_predicate();
			var _crop = {};
			with _crop {
				self.__base = _base;
				self._op = function(_value, _op) {
					self.__base._op(_value, _op);
					return self;
				}
				self.op_ = function(_op, _value) {
					self.__base.op_(_op, _value);
					return self;
				}
				self.ormay = function() {
					self.__base.ormay();
					return self;
				}
				self.render = function(_result) {
					var _render = self.__base.result(is_undefined(_result) ? true : bool(_result)).render();
					return _render;
				}
			}
			return _crop;
		}();
		_interface.__base.clear();
		return _interface;
	}
	
	//
	function build_predicate() constructor {
		self.__space = {};
		self.__folds = [];
		self.__stack = [self.__folds];
		self.__autoc = 0;
		self.__result = true;
		static op = function(_keyL, _keyR) {
			if variable_struct_exists(self.__op_base, _keyL) {
				array_push(self.__folds, [variable_struct_get(self.__op_base, _keyL), string(_keyR)]);
				return self;
			} else if variable_struct_exists(self.__op_base, _keyR) {
				array_push(self.__folds, [string(_keyL), variable_struct_get(self.__op_base, _keyR)]);
				return self;
			}
			throw "";
		}
		static _op = function(_value, _op) {
			var _key = "~" + string(self.__autoc++);
			return op(_key, _op).set(_key, _value);
		}
		static op_ = function(_op, _value) {
			var _key = "~" + string(self.__autoc++);
			return op(_op, _key).set(_key, _value);
		}
		static ormay = function() {
			self.__folds = [];
			array_push(self.__stack, self.__folds);
			return self;
		}
		static set = function(_key, _value) {
			if variable_struct_exists(self.__op_base, _key)	throw "build_predicate error: cast .set - 'key' is busy (oper)"; // TODO
			variable_struct_set(self.__space, _key, _value);
			return self;
		}
		static result = function(_result) {
			self.__result = _result;
			return self;
		}
		static clear = function() {
			self.__folds = [];
			self.__stack = [self.__folds];
			self.__space = {};
			self.__autoc = 0;
			return self;
		}
		static clone = function() {
			var _clone_predicate = new build_predicate(), _stack = _clone_predicate.__stack;
			_clone_predicate.__folds = array_ext_clone(self.__folds);
			_clone_predicate.__autoc = self.__autoc;
			_clone_predicate.__result = self.__result;
			var _size = array_length(self.__stack);
			array_set(_stack, _size--, _clone_predicate.__folds);
			while (_size--) array_set(_stack, _size, array_ext_clone(self.__stack[_size]));
			struct_ext_copy(_clone_predicate.__space, self.__space);
			return _clone_predicate;
		}
		self.run = function(_value) {
			var _size = array_length(self.__stack), _pack, _meth, _i = 0;
			repeat _size {
				_pack = self.__stack[_i++];
				_size = array_length(_pack);
				while (_size--) {
					_meth = _pack[_size];
					_meth = is_string(_meth[0])
						? _meth[1](variable_struct_get(self.__space, _meth[0]), _value) 
						: _meth[0](_value, variable_struct_get(self.__space, _meth[1]));
					if (_meth != self.result) {
						_size = undefined;
						break;
					}
				}
				if !is_undefined(_size) return true;
			}
			return false;
		}
		static __op_base = /*#cast*/ function() {
			var _op = {};
			variable_struct_set(_op, ">", method_get_index(function(_check_left, _check_right) {
				return _check_left > _check_right;
			}));
			variable_struct_set(_op, ">=", method_get_index(function(_check_left, _check_right) {
				return _check_left >= _check_right;
			}));
			variable_struct_set(_op, "<", method_get_index(function(_check_left, _check_right) {
				return _check_left < _check_right;
			}));
			variable_struct_set(_op, "<=", method_get_index(function(_check_left, _check_right) {
				return _check_left <= _check_right;
			}));
			variable_struct_set(_op, "==", method_get_index(function(_check_left, _check_right) {
				return _check_left == _check_right;
			}));
			variable_struct_set(_op, "===", method_get_index(function(_check_left, _check_right) {
				return (typeof(_check_left) == typeof(_check_right)) and (_check_left == _check_right);
			}));
			variable_struct_set(_op, "of", method_get_index(function(_check_left, _check_right) {
				if is_string(_check_right) {
					if is_struct(_check_left)
						return variable_struct_exists(_check_right, _check_left);
				} else if is_numeric(_check_right) {
					if is_array(_check_left)
						return _check_left >= 0 and _check_left <= array_length(_check_right) - 1;
				}
				throw "build_predicate error: cast .op - argument for 'of' operate is not collection (array or struct)"; // TODO
			}));
			variable_struct_set(_op, "in", method_get_index(function(_check_left, _check_right) {
				if is_struct(_check_right) {
					return struct_ext_exists(_check_right, _check_left);
				} else if is_array(_check_right) {
					return array_ext_exists(_check_right, _check_left);
				}
				throw "build_predicate error: cast .op - argument for 'of' operate is not collection (array or struct)"; // TODO
			}));
			variable_struct_set(_op, "t+", method_get_index(function(_check_left, _check_right) {
				var _type = typeof(_check_left);
				return is_array(_check_right) ? array_ext_exists(_check_right, _type) : _check_right == _type;
				throw "build_predicate error: cast .op - argument for 'of' operate is not collection (array or struct)"; // TODO
			}));
			variable_struct_set(_op, "t-", method_get_index(function(_check_left, _check_right) {
				var _type = typeof(_check_left);
				return is_array(_check_right) ? !array_ext_exists(_check_right, _type) : _check_right != _type;
				throw "build_predicate error: cast .op - argument for 'of' operate is not collection (array or struct)"; // TODO
			}));
			variable_struct_set(_op, "m>", method_get_index(function(_check_left, _check_right) { // TODO
				return _check_right(_check_left);
			}));
			variable_struct_set(_op, "!m>", method_get_index(function(_check_left, _check_right) { // TODO
				return !_check_right(_check_left);
			}));
			return _op; 
		}();
		static render = function() {
			var _render_predicate = {}, _stack = [];
			_render_predicate.__result = self.__result;
			_render_predicate.__stack = _stack;
			var _size = array_length(self.__stack);
			while (_size--) array_set(_stack, _size, array_ext_clone(self.__stack[_size]));
			struct_ext_copy(_render_predicate.__space, self.__space);
			return method(_render_predicate, self.run);
		}
	}
	
	//
	function operate_fun(_op) {
		static _op_base = new build_predicate().__op_base;
		if variable_struct_exists(_op_base, _op) return variable_struct_get(_op_base, _op);
		throw "";
	}
	
	//
	function operate_new(_left_right_, _keyL, _keyR, _result) {
		static _render_right = method_get_index(function(_right) {
			return self.__op(self.value, _right) == self.result;
		});
		static _render_left = method_get_index(function(_left) {
			return self.__op(_left, self.value) == self.result;
		});
		var _op = {result : is_undefined(_result) ? true : bool(_result)};
		if _left_right_ {
			var _op = {};
			_op.value = _keyL;
			_op.__op = operate_fun(_keyR);
			return method(_op, _render_right);
		} else {
			var _op = {};
			_op.value = _keyR;
			_op.__op = operate_fun(_keyL);
			return method(_op, _render_left);
		}
	}
	
	//
	function operate_modify(_operate) {
	    var _unbind = method_get_self(_operate);
	    if (argument_count > 1) {
	        _unbind.value = argument[1];
	        if (argument_count > 2) _unbind.result = argument[2];
	    }
		return _operate;
	}
	
#endregion
