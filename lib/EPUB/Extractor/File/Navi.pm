package EPUB::Extractor::File::Navi;
use strict;
use warnings;
use Smart::Args;
use EPUB::Extractor::File::Parser::Navi;
use EPUB::Extractor::File::Navi::Context;

sub new {
    args(
        my $class => 'ClassName',
        my $zip   => { isa => 'EPUB::Extractor::Util::Archive' },
        my $path  => 'Str',
    );

    my $self = bless {
        zip  => $zip,
        path => $path,
    } => $class;

    $self->path($path);

    return $self;
}

sub parser {
    my $self = shift;
    $self->{parser}
        ||= EPUB::Extractor::File::Parser::Navi->new({ data => $self->data });
}

sub path {
    my $self = shift;
    $self->{path};
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

    $self->{$context_name} = EPUB::Extractor::File::Navi::Context->new({
        parser       => $self->parser,
        context_name => $context_name,
    });
}

sub toc  { shift->context('toc') }

sub chapter_list {
    args(
        my $self,
        my $abs => { optional => 1 },
    );
    my $list = $self->toc->list;
    if ($abs) {
        $list = [ map { $_ =~ s/\#.*$//; $_ } map { $self->dir . '/' . $_->{href} } @$list];
    }
    return $list;
}

1;
