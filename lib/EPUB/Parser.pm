package EPUB::Parser;
use 5.008005;
use strict;
use warnings;
use Carp;
use EPUB::Parser::Util::EpubLoad;
use EPUB::Parser::Util::Archive;
use EPUB::Parser::File::OPF;
use EPUB::Parser::File::Navi;
use EPUB::Parser::Manager::Pages;

our $VERSION = "0.01";


sub new {
    my $class = shift;
    my $args  = shift || {};

    bless {
        zip => '',
        opf => '',
        epub_version => $args->{epub_version} || '3.0',
    } => $class;
}

sub opf {
    my $self = shift;

    $self->{opf} ||= EPUB::Parser::File::OPF->new({
        zip          => $self->{zip},
        epub_version => $self->{epub_version},
    });
}

sub navi {
    my $self = shift;

    $self->{navi} ||= EPUB::Parser::File::Navi->new({
        zip  => $self->{zip},
        path => $self->opf->nav_path,
    });
}

sub data_from_path {
    my $self = shift;
    my $path = shift;
    $self->{zip}->get_member_data({ file_path => $path });
}

sub pages_manager {
    my $self = shift;
    $self->{pages_manager} ||= EPUB::Parser::Manager::Pages->new({
        opf  => $self->opf,
        navi => $self->navi,
    });
}


sub _load_epub {
    my ($self,$args,$method) = @_;
    $self->{zip} ||= do {
        my $data = EPUB::Parser::Util::EpubLoad->$method($args);
        EPUB::Parser::Util::Archive->new({ data => $data });
    };
    return $self;
}

sub load_file   { _load_epub(@_, 'load_file'  ) };
sub load_binary { _load_epub(@_, 'load_binary') };

1;

__END__

=encoding utf-8

=head1 NAME

EPUB::Parser - abstract...

=head1 SYNOPSIS


=head1 DESCRIPTION

=head1 LICENSE

Copyright (C) tokubass.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokubass <tokubass@cpan.org>

=cut

