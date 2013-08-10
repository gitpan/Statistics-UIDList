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
        $list3,
    );

    is_deeply $id->limit(3), [qw/a01 b01/];
}

{
    my $id = Statistics::UIDList->new(
        $list1,
        $list2,
        $list3,
    );

    my $cond = sub {
        my ($count, $id) = @_;
        $id =~ m!^c\d+$!;
    };

    is_deeply $id->limit($cond), [qw/c01 c02 c03 c04/];
}

{
    eval {
        my $id = Statistics::UIDList->new(
            $list1,
            $list2,
            $list3,
        );
        $id->limit;
    };

    like $@, qr/^require limit condition/;
}

done_testing;
