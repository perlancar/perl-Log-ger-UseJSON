package Log::ger::UseJSON;

# DATE
# VERSION

use strict 'subs', 'vars';
use warnings;
use Log::ger ();

use Data::Clean::JSON;
use JSON::MaybeXS;

my @known_configs = qw(pretty);

my %default_configs = (
    pretty => 1,
    clean => 1,
);

my $cleanser = Data::Clean::JSON->get_cleanser;
my $json;

sub import {
    my ($pkg, %args) = @_;
    my %configs = %default_configs;
    for my $k (sort keys %args) {
        die unless grep { $k eq $_ } @known_configs;
        $configs{$k} = $args{$k};
    }

    $json = JSON::MaybeXS->new;
    $json->pretty($configs{pretty} ? 1:0);
    $json->binary(1);
    $json->allow_nonref(1);

    $Log::ger::_dumper = sub {
        my $data = $configs{clean} ? $cleanser->clone_and_clean($_[0]) : $_[0];
        $json->encode($data);
    };
}

1;
# ABSTRACT: Use JSON::MaybeXS to dump data structures (as JSON)

=head1 SYNOPSIS

 use Log::ger::UseJSON;

To configure:

 use Log::ger::UseJSON (clean=>0, pretty=>0);


=head1 DESCRIPTION


=head1 CONFIGURATION

=head2 pretty

=head2 clean


=head1 SEE ALSO

L<Log::ger>

L<JSON::MaybeXS>

L<Log::ger::UseDataDump>, L<Log::ger::UseDataDumpColor>,
L<Log::ger::UseDataDumper>


=cut
