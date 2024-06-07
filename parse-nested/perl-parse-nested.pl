use strict;
use warnings;

use Data::Dumper 'Dumper';

my $EXPR = 0;

my $E_LIST = 0;
my $E_NUM = 1;
my $E_STRING = 2;


my @prog =  (
    [ print => [ '+' => 3, 3 ]]
    ); 

sub main{

    foreach (@prog){
        evaler ($_)
    }
}

my %base_types = ();

my %special_forms = (
);

my %normal_forms = (
    'print' => sub { print 'EEEEEEe ' . $_[0] },
    '+' => sub {  $_[0] + $_[1] }
);

sub eval_form {
    my ($e,$arglist) =  @_ ;
    if (exists $special_forms{$e}){
        return $special_forms{$e}->(@$arglist)
    }elsif (exists $normal_forms{$e}){
        return $normal_forms{$e}->(map { evaler($_)} @$arglist);
    }else{
        if($arglist){
            die "Err: constant '$e' cannot have arguments"
        }else{
            return $e

        }
    }
}


sub evaler {
    
    my ($e) =  shift ;
    if (ref  $e eq 'ARRAY'){
        die "Err: expr $e cannot take args"  . Dumper $e if @_;
        my ($hd, @tl) = @$e;
        evaler($hd, \@tl);
    }else{
        if(@_){
            eval_form $e, @_;
        }else{
            return $e;
        }
    }
}


main ;

