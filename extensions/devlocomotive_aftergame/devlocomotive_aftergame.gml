

#define AfterGame_add
{
    static _stack = ____system_aftergame____();
    if _stack._done throw _stack._error;
    if !is_method(argument[1]) throw "";
    if (argument_count > 2) argument[1] = method(argument[2], argument[1]);
    array_push(_stack._stack, {_run: argument[1], _arg: argument[0]});
}

#define AfterGame_clear
{
    static _stack = ____system_aftergame____();
    if _stack._done throw _stack._error;
    _stack._done = true;
    var _stack_list = _stack._stack, _pack;
    repeat array_length(_stack_list) {
        _pack = array_pop(_stack_list);
        _pack._run(_pack._arg);
    }
}

#define ____system_aftergame____
{
    static _stack = {_stack: [], _done: false, _error: ""};
    return _stack;
}