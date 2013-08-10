use strict;
use warnings;
use Test::More;

use Statistics::UIDList;

my $list1 = [qw/a01 a01 a02 b01 c01 c02 c03/];
my $list2 = [qw/a01 a01 a02 b01 c01 c02 c03 c04 d01/];
my $list3 = [qw/a01 b01/];

{
    my $id = Statistics::UIDList->new(
        $list1,
        $list2,
    );

    is_deeply $id->dep, [qw/a01 a02 b01 c01 c02 c03/];
}

{
    my $id = Statistics::UIDList->new(
        $list1,
        $list2,
        $list3,
    );

    is_deeply $id->dep, [qw/a01 b01/];
}

done_testing;
