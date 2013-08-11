package Statistics::UIDList;
use strict;
use warnings;
use Carp qw/croak/;

our $VERSION = '0.03';

sub new {
    my $class = shift;

    my $param = +{};

    for my $arg (@_) {
        if (ref $arg eq 'ARRAY') {
            push @{$param->{lists}}, $arg;
        }
        elsif (ref $arg eq 'HASH') {
            for my $option (qw/digit/) {
                $param->{$option} = $arg->{$option} ? $arg->{$option} : undef;
            }
        }
        else {
            croak "invalid arg: $arg, @_";
        }
    }

    bless $param, $class;
}

sub list {
    my ($self, $num) = @_;

    if (defined $num) {
        return $self->{lists}->[$num];
    }
    else {
        unless ($self->{_all_list}) {
            $self->{_all_list} = [ map { @$_ } @{$self->{lists}} ];
        }
        return $self->{_all_list};
    }
}

sub uniq {
    my ($self, $num) = @_;

    if (defined $num) {
        return $self->{uniq}->[$num] if $self->{uniq}->[$num];
        $self->{uniq}->[$num] = $self->_uniq($self->list($num));
        return $self->{uniq}->[$num];
    }

    unless ($self->{_all_uniq}) {
        $self->{_all_uniq} = $self->_uniq($self->list);
    }
    return $self->{_all_uniq};
}

sub _uniq {
    my ($self, $list) = @_;

    my %h;
    my @r;
    for my $id (@{$list}) {
        push @r, $id unless $h{$id};
        $h{$id} = 1;
    }

    return \@r;
}

sub dup {
    my ($self) = @_;

    return $self->{dup} if $self->{dup};

    $self->{dup} = $self->_dup($self->list);

    return $self->{dup};
}

sub _dup {
    my ($self) = @_;

    my %h;
    for my $list (@{$self->{lists}}) {
        my %e;
        for my $id (@{$list}) {
            $h{$id}++ unless $e{$id};
            $e{$id} = 1;
        }
    }

    my %d;
    my @dup;
    for my $id (@{$self->list}) {
        if (!$d{$id} && $h{$id} == $#{$self->{lists}} + 1) {
            push @dup, $id;
            $d{$id} = 1;
        }
    }

    return \@dup;
}

sub duplicate { dup(@_) }

sub limit {
    my ($self, $cond) = @_;

    my $code;
    if ($cond && $cond =~ m!^\d$!) {
        $code = sub { $_[0] >= $cond };
    }
    elsif (ref $cond eq 'CODE') {
        $code = $cond;
    }
    else {
        croak "require limit condition";
    }

    return $self->_limit($self->list, $code);
}

sub _limit {
    my ($self, $list, $code) = @_;

    my %h;
    for my $id (@{$list}) {
        $h{$id}++;
    }

    my @r;
    for my $id (@{$list}) {
        next unless $h{$id};
        if ( $code->($h{$id}, $id) ) {
            push @r, $id;
            $h{$id} = undef; # never pick up
        }
    }

    return \@r;
}

1;

__END__

=head1 NAME

Statistics::UIDList - stats ID list


=head1 SYNOPSIS

    my $id = Statistics::UIDList->new(
        [qw/a001 a002 a003 b001 c001/],
        [qw/a001 a002/],
    );

    # get id list
    warn $id->list;

    # get unique id list
    warn $id->uniq;

    # get only duplicated id list
    warn $id->dup;

    # get count limited id list
    warn $id->limit(2);


=head1 DESCRIPTION

Statistics::UIDList is


=head1 METHODS

=head2 new

constractor

=head2 list($num)

get $num-th id list, unless $num then get all id list

=head2 uniq($num)

get $num-th unique id list, unless $num then get all unique id list

=head2 dup

get duplicated id list

=head3 duplicate

alias of C<dup> function

=head2 limit($num or $cond_sub)

If you pass the arg as int number, then C<limit> get back count limited id list.
If you pass the code ref, then C<limit> get back list that include true condition values.

    warn $id->limit(sub{
        my ($count, $id) = @_;
        $id > 100 and $count > 1;
    });


=head1 REPOSITORY

Statistics::UIDList is hosted on github
<http://github.com/bayashi/Statistics-UIDList>

Welcome your patches and issues :D


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
