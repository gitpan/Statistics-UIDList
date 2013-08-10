use strict;
use warnings;
use Test::More;

use Statistics::UIDList;

{
    my $id = Statistics::UIDList->new;
    isa_ok $id, 'Statistics::UIDList';
}

{
    my $id = Statistics::UIDList->new([]);
    isa_ok $id, 'Statistics::UIDList';
}

{
    my $id = Statistics::UIDList->new([], []);
    isa_ok $id, 'Statistics::UIDList';
}

{
    my $id = Statistics::UIDList->new([], [], { decimal => 3 });
    isa_ok $id, 'Statistics::UIDList';
}

{
    eval {
        my $id = Statistics::UIDList->new(1);
    };
    like $@, qr/^invalid arg: 1, 1/;
}

done_testing;
