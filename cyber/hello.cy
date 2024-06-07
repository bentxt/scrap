func foo(x dynamic):
    return switch x:
        case 'blue' => 'BLUE'
        case 'red' => 'RED'
        else => 'NOT'


print foo('blue')
