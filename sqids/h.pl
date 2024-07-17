use Sqids;


my $sqids = Sqids->new(
    alphabet => 'abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789',
    min_length => 4,
    blocklist => ['word'],
);
 
# encode/decode a single number
my $id = $sqids->encode(123);         # 'UKk'
my $num = $sqids->decode('UKk');      # 123
 
# or a list or arrayref
$id = $sqids->encode([123]);      # '86Rf07'


my $id = ($sqids->encode(3333, 22222));        # '86Rf07'


print "$id\n";


print($sqids->decode($id));        # '86Rf07'

print "\n";
