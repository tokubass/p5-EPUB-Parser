package EPUB::Parser::File::OPF::Context::Metadata;
use strict;
use warnings;
use Carp;
use parent 'EPUB::Parser::File::OPF::Context';


sub title      { shift->parser->single( 'dc:title'      )->string_value }
sub creator    { shift->parser->single( 'dc:creator'    )->string_value }
sub language   { shift->parser->single( 'dc:language'   )->string_value }
sub identifier { shift->parser->single( 'dc:identifier' )->string_value }


1;
