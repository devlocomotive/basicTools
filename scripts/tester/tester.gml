// test for
//
/*
//
var test = tester("basicTools").set("all");

//
if test.is("factory").section("basic - factory") {
	
	// array
	var _factory_data_0 = factory_data(-1);
	var _factory_data_1 = factory_data(-5);
	var _factory_data_2 = factory_data(-50);
	
	assert_equal(_factory_data_0, _factory_data_1);
	assert_equal(_factory_data_0, _factory_data_2);
	
	assert_is_method(_factory_data_0);
	assert_is_array(_factory_data_0());
	assert_equal(_factory_data_0(), []);
	assert_fail(_factory_data_0() == _factory_data_1());
	
	test.log("factory array - OK");
	
	// struct
	_factory_data_0 = factory_data(1);
	_factory_data_1 = factory_data(7);
	_factory_data_2 = factory_data(37);
	
	assert_equal(_factory_data_0, _factory_data_1);
	assert_equal(_factory_data_0, _factory_data_2);
	
	assert_is_method(_factory_data_0);
	assert_is_struct(_factory_data_0());
	assert_equal(_factory_data_0(), {});
	assert_fail(_factory_data_0() == _factory_data_1());
	
	test.log("factory struct - OK");
	
	// undefined
	_factory_data_0 = factory_data(0);
	_factory_data_1 = factory_data();
	
	assert_equal(_factory_data_0, _factory_data_1);
	assert_is_method(_factory_data_0);
	assert_is_undefined(_factory_data_0());
	assert_equal(_factory_data_0(), undefined);
	assert(_factory_data_0() == _factory_data_1());
	
	test.log("factory undefined - OK").sector();
	
	// fst
	_factory_data_0 = factory_get(0);
	_factory_data_1 = factory_get();
	
	assert_equal(_factory_data_0, _factory_data_1);
	assert_is_method(_factory_data_0);
	assert_equal(_factory_data_0("first", "second"), "first");
	assert(_factory_data_0(1) == _factory_data_1(1));
	assert_fail(_factory_data_0(1, 2) == _factory_data_1(2, 1));
	assert_fail(_factory_data_0(1, 2, 3) == _factory_data_1(2, 1, 3));
	assert(_factory_data_0(1, 2, 5) == _factory_data_1(1, 1, 3));
	
	thrower(_factory_data_0);
	thrower(_factory_data_0, [], "requires at least one argument 'fst'");
	
	test.log("factory get.fst - OK");
	
	// lst
	_factory_data_0 = factory_get(1);
	_factory_data_1 = factory_get(true);
	
	assert_equal(_factory_data_0, _factory_data_1);
	assert_is_method(_factory_data_0);
	assert_equal(_factory_data_0("first", "second"), "second");
	assert(_factory_data_0(1) == _factory_data_1(1));
	assert_fail(_factory_data_0(1, 2) == _factory_data_1(2, 1));
	assert(_factory_data_0(1, 2, 3) == _factory_data_1(2, 1, 3));
	assert_fail(_factory_data_0(1, 2, 5) == _factory_data_1(1, 1, 3));
	
	thrower(_factory_data_0);
	thrower(_factory_data_0, [], "requires at least one argument 'lst'");
	
	test.log("factory get.lst - OK").sector();
	
	// bung
	thrower(factory_bung);
	unthrower(factory_bung, "argument");
	
	assert_is_method(factory_bung("argument"));
	assert_equal(factory_bung("message get")(), "message get");
	assert_equal(factory_bung(infinity)(), infinity);
	assert_equal(factory_bung(53)(), 53);
	assert_fail(factory_bung("mess") == factory_bung("mess"));
	
	test.log("factory bung - OK");
	
	// error
	thrower(factory_error);
	unthrower(factory_error, "argument");
	
	assert_is_method(factory_error("argument"));
	thrower(factory_error("argument"));
	thrower(factory_error("argument"), [], "argument");
	
	test.log("factory error - OK");
}

//
if test.is("array").section("basic - array") {
	
	// clear
	var array = [1, 2, 3, 4, 5];
	var res = array_ext_clear(array);
	
	assert(array == res);
	assert(array_length(array) == 0);
	
	test.log("array: clear - OK");
	
	// set
	var ar0 = [];
	var ar1 = [1, 2, 3, 4, 5];
	
	assert_fail(ar0 == ar1);
	assert_fail(array_equals(ar0, ar1));
	
	array_ext_set(ar0, ar1);
	
	assert_fail(ar0 == ar1);
	assert(array_equals(ar0, ar1));
	
	ar1 = [1, 2];
	array_ext_set(ar0, ar1);
	
	assert_fail(ar0 == ar1);
	assert(array_equals(ar0, ar1));
	
	ar0 = array_create(100);
	ar1 = ["hello"];
	array_ext_set(ar0, ar1);
	
	assert_fail(ar0 == ar1);
	assert(array_equals(ar0, ar1));
	
	ar1 = [];
	array_ext_set(ar0, ar1);
	
	assert_fail(ar0 == ar1);
	assert(array_equals(ar0, ar1));
	
	ar0 = [];
	ar1 = [];
	array_ext_set(ar0, ar1);
	
	assert_fail(ar0 == ar1);
	assert(array_equals(ar0, ar1));
	
	var clone = [];
	ar0 = [1, 2, 3, 4];
	ar1 = array_ext_set(clone, ar0);
	
	assert(clone == ar1);
	assert_fail(ar0 == ar1);
	assert(array_equals(clone, ar1));
	assert(array_equals(clone, ar0));
	
	test.log("array: set - OK");
	
	// clone
	ar0 = [1, 2, 3, 4];
	ar1 = array_ext_clone(ar0);
	
	assert_fail(ar0 == ar1);
	assert(array_equals(ar0, ar1));
	
	ar0 = [];
	ar1 = array_ext_clone(ar0);
	
	assert_fail(ar0 == ar1);
	assert(array_equals(ar0, ar1));
	
	test.log("array: clone - OK");
	
	// reverse
	array = [];
	assert(array == array_ext_reverse(array));
	
	array = [1, 2, 3];
	assert(array == array_ext_reverse(array));
	
	clone = [1, 2, 3];
	array = array_ext_reverse(array_ext_clone(clone));
	assert_fail(clone == array);
	assert_fail(array_equals(clone, array));
	assert_equal([1, 2, 3], array_ext_reverse([3, 2, 1]));
	assert_equal([1, 2, 3], array_ext_reverse(array_ext_reverse([1, 2, 3])));
	assert_equal(clone, array_ext_reverse(array));
	assert_equal(clone, array_ext_reverse(clone));
	
	array = [];
	assert_fail(array == array_ext_reverse(array, false));
	
	array = [1, 2, 3];
	assert_fail(array == array_ext_reverse(array, false));
	
	clone = [1, 2, 3];
	array = array_ext_reverse(clone, false);
	assert_fail(clone == array);
	assert_fail(array_equals(clone, array));
	assert_equal([1, 2, 3], array_ext_reverse([3, 2, 1], false));
	assert_equal([1, 2, 3], array_ext_reverse(array_ext_reverse([1, 2, 3], false)));
	assert_equal(clone, array_ext_reverse(array, false));
	assert_not_equal(clone, array_ext_reverse(clone, false));
	
	test.log("array: reverse - OK");
	
	// shuffle
	
}

//
test.ends("it is work");