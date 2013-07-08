package EPUB::Parser::Util::ShortcutMethod;
use strict;
use warnings;
use Exporter qw/import/;

our @EXPORT_OK = qw/ title creator language identifier /;


sub title      { shift->opf->metadata->title      }
sub creator    { shift->opf->metadata->creator    }
sub language   { shift->opf->metadata->language   }
sub identifier { shift->opf->metadata->identifier }



1;

__END__

