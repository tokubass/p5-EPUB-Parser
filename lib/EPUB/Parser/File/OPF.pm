package EPUB::Parser::File::OPF;
use strict;
use warnings;
use Carp;
use EPUB::Parser::File::Parser::OPF;
use EPUB::Parser::File::OPF::Context;
use EPUB::Parser::File::Container;
use Smart::Args;

sub new {
    args(
        my $class => 'ClassName',
        my $zip   => { isa => 'EPUB::Parser::Util::Archive' },
        my $epub_version,
    );

    my $self = bless {
        zip          => $zip,
        epub_version => $epub_version,
    } => $class;

    return $self;
}

sub parser {
    my $self = shift;

    $self->{parser}
        ||= EPUB::Parser::File::Parser::OPF->new({ data => $self->data });
}

sub path {
    my $self = shift;

    $self->{path} ||= do {
        my $container = EPUB::Parser::File::Container->new({ zip => $self->{zip} });
        $container->opf_path;
    };
}

sub dir {
    my $self = shift;
    require File::Basename;
    $self->{dir} ||= File::Basename::dirname($self->path);
}


sub data {
    my $self = shift;
    $self->{data} ||= $self->{zip}->get_member_data({ file_path => $self->path });
}

sub context {
    my $self = shift;
    my $context_name = shift;
    return $self->{$context_name} if $self->{$context_name};

    $self->{$context_name} = EPUB::Parser::File::OPF::Context->new({
        opf       => $self,
        parser    => $self->parser,
        context_name => $context_name,
    });
}

sub spine    { shift->context('spine'   ) }
sub manifest { shift->context('manifest') }
sub metadata { shift->context('metadata') }
sub guide    { shift->context('guide'   ) }

sub nav_path {
    my $self = shift;
    $self->{nav_path} ||= sprintf("%s/%s", $self->dir, $self->manifest->nav_path);
}

sub cover_image_path {
    my $self = shift;
    $self->{cover_image_path} ||= do {
        my $cover_img_path = $self->manifest->cover_image_path;
        sprintf("%s/%s", $self->dir, $cover_img_path) if $cover_img_path;
    };
}

sub guess_version {
    my $self = shift;
    my $version = $self->parser->single('/pkg:package/@version')->string_value;
    
    if ($version) {
        return $version;
    }
    elsif ( $self->nav_path ) {
        return '3.0';
    }
    else {
        return;
    }
}


1;
