

$E_NUM = 3;

$nums=0;

%E = (
    $E_NUM => sub { $nums++; },
);

$regx =qr/^\d+$/;
sub isnum1{
    if($_[0] =~ /^\d+$/){
        $nums++;
    }
}

sub isnum2{
    my ($hd,$num) = @{$_[0]};
    if($hd == $E_NUM){
        $nums++;
    }
}
sub isnum3{
    my ($hd,$num) = @{$_[0]};

    if($hd == $E_NUM){
        $nums++;
    }
}

for (0..10000000){
        isnum1(888);
    #    isnum2([$E_NUM, 33]);
    #    isnum3([$E_NUM, 33]);
}

print $nums;
