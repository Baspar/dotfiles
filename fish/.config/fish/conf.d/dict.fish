function _dict_has --argument-names dict key
    set -q $dict'__'$key
end

function _dict_rem --argument-names dict key
    set -e $dict'__'$key
end

function _dict_set --argument-names dict key value
    set -g $dict'__'$key $value
end

function _dict_setx --argument-names dict key value
    set -gx $dict'__'$key $value
end

function _dict_get --argument-names dict key
    eval echo \$$dict'__'$key
end

