#!/usr/local/bin/perl -w

use Test::More 'no_plan';

package Catch;

sub TIEHANDLE {
    my($class, $var) = @_;
    return bless { var => $var }, $class;
}

sub PRINT  {
    my($self) = shift;
    ${'main::'.$self->{var}} .= join '', @_;
}

sub OPEN  {}    # XXX Hackery in case the user redirects
sub CLOSE {}    # XXX STDERR/STDOUT.  This is not the behavior we want.

sub READ {}
sub READLINE {}
sub GETC {}

my $Original_File = 'lib/Text/Indent.pm';

package main;

# pre-5.8.0's warns aren't caught by a tied STDERR.
$SIG{__WARN__} = sub { $main::_STDERR_ .= join '', @_; };
tie *STDOUT, 'Catch', '_STDOUT_' or die $!;
tie *STDERR, 'Catch', '_STDERR_' or die $!;

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 43 lib/Text/Indent.pm
use_ok('Text::Indent');

    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 103 lib/Text/Indent.pm

eval { Text::Indent->new };
ok( ! $@, "can create an object");
eval {  Text::Indent->new( Foo => 'Bar' ) };
ok( $@, "constructor dies on invalid args");


    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 184 lib/Text/Indent.pm
my $i = Text::Indent->new;
is( $i->level, 0, "level initialized to 0");
$i->increase;
is( $i->level, 1, "level increased to 1");
$i->increase(2);
is( $i->level, 3, "level increased to 3");

    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 211 lib/Text/Indent.pm
my $i = Text::Indent->new( Level => 5 );
is( $i->level, 5, "level initialized to 5");
$i->decrease;
is( $i->level, 4, "level decreased to 4");
$i->decrease(2);
is( $i->level, 2, "level decreased to 2");

    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 238 lib/Text/Indent.pm
my $i = Text::Indent->new( Level => 5 );
is( $i->level, 5, "level initialized to 5");
$i->reset;
is( $i->level, 0, "level reset to 0");

    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 279 lib/Text/Indent.pm
my $i = Text::Indent->new;
is( $i->indent("foo"), "foo\n", "no indentation");
$i->increase;
is( $i->indent("foo"), "  foo\n", "indent level 1");
$i->spaces(4);
is( $i->indent("foo"), "    foo\n", "change spaces to 4");
$i->spacechar("+");
is( $i->indent("foo"), "++++foo\n", "chance spacechar to +");
$i->add_newline(0);
is( $i->indent("foo"), "++++foo", "unset add_newline");
$i->reset;
is( $i->indent("foo"), "foo", "reset indent level");
$i->decrease;
is( $i->indent("foo"), "foo", "negative indent has no effect");

    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 317 lib/Text/Indent.pm
my @accessors = qw|
    spaces
    spacechar
    level
    add_newline
|;
for( @accessors ) {
    can_ok('Text::Indent', $_);
}

    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

