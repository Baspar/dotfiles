function _dict_has --argument-names dict key
    set k (string escape --style=var $key)
    set -q $dict'__'$k
end

function _dict_rem --argument-names dict key
    set k (string escape --style=var $key)
    set -e $dict'__'$k
end

function _dict_set --argument-names dict key value
    set k (string escape --style=var $key)
    set -g $dict'__'$k $value
end

function _dict_setx --argument-names dict key value
    set k (string escape --style=var $key)
    set -gx $dict'__'$k $value
end

function _dict_get --argument-names dict key
    set k (string escape --style=var $key)
    eval echo \$$dict'__'$k
end

function _dict_keys --argument-names dict
    set | grep "^$dict"__ | cut -d' ' -f1 | sed 's/^'$dict'__//g' | string unescape --style=var
end
