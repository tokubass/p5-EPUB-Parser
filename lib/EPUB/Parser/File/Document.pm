package EPUB::Parser::File::Document;
use strict;
use warnings;
use EPUB::Parser::File::Parser::Document;
use Smart::Args;

sub new {
    args(
        my $class => 'ClassName',
        my $archive_doc => { isa => 'EPUB::Parser::Util::Archive::Iterator' },
    );

    my $self = bless {
        archive_doc => $archive_doc,
    } => $class;

    $self->path($archive_doc->path);

    return $self;
}

sub parser {
    my $self = shift;

    $self->{parser}
        ||= EPUB::Parser::File::Parser::Document->new({ data => $self->data });
}

sub data {
    my $self = shift;
    $self->{archive_doc}->data;
}

sub path {
    my $self = shift;
    $self->{path} ||= $self->{archive_doc}->path;
}


sub dir {
    my $self = shift;
    require File::Basename;
    $self->{dir} ||= File::Basename::dirname($self->path);
}

sub items_node {
    my $self = shift;
    ( $self->parser->find('//*/@href'), $self->parser->find('//*/@src') );
}

=head1

{
  xhtml内の(src or href)パス => 絶対パス
  ....
},
サービス側で、manifestに記載されているアイテムをDBにアップロード。
ここで、サービス側は manifestに記載のitemのパス(絶対パスに置換) -> サービス内のリンクが対応として保存できる。

サービスでxhtmlをパースしているときに、「xhtml内の(src or href)パス」が発見したら、このメソッドの戻り値から絶対パスを取得。
絶対パスからサービス内のリンクに書き替えることができる。


=cut

sub item_abs_paths {
    my $self = shift;
    my $ret;
    require URI;

    for my $node ($self->items_node) {
        my $doc_item_path = $node->string_value;

        my $uri = URI->new($doc_item_path)->abs($self->dir . '/');
        (my $abs_path    = $uri->as_string ) =~ s{^/}{};
        #(my $no_fragment = $uri->path      ) =~ s{^/}{}; 
       $ret->{$doc_item_path} = $abs_path;
    }

    return $ret || {};
}



1;
