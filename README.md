# NAME

Text::Indent - simple indentation of text shared among modules

# SYNOPSIS

In your main program:

    use Text::Indent;
    my $indent = Text::Indent->new;
    $indent->spaces(2);

In a module to produce indented output:

    use Text::Indent;
    my $indent = Text::Indent->instance;
    $indent->increase;
    print $indent->indent("this will be indented two spaces");
    $indent->increase(2);
    print $indent->indent("this will be indented six spaces");
    $indent->decrease(3);

# DESCRIPTION

Text::Indent is designed for use in programs which need to produce output
with multiple levels of indent when the source of the output comes from
different modules that know nothing about each other.

For example take module A, whose output includes the indented output of
module B. Module B can also produce output directly, so it falls to module B
to know whether it should indent it's output or not depending on it's
calling context.

Text::Indent allows programs and modules to cooperate to choose an
appropriate indent level that is shared within the program context. In the
above example, module A would increase the indent level prior to calling the
output routines of module B. Module B would simply use the Text::Indent
instance confident that if it were being called directly no indent would be
applied but if module A was calling it then it's output would be indented
one level.

# CONSTRUCTOR

The constructor for Text::Indent should only be called once by the main
program using modules that produce indented text.  Modules which wish
to produce indented text should use the instance accessor described below.

To construct a new Text::Indent object, call the **new** method, passing
one or more of the following parameters as a hash:

- **Spaces**

    the number of spaces to used for each level of indentation.  Defaults to 2.

- **SpaceChar**

    the character to be used for indentation. Defaults to a space (ASCII 32)

- **Level**

    The initial indentation level to set.  Defaults to 0.

- **AddNewLine**

    Whether the **indent** method should automatically add a newline to the input
    arguments. Defaults to TRUE.

- **Instance**

    Whether the newly constructed Text::Indent object should become the new
    singleton instance returned by the **instance** accessor. Defaults to TRUE.

# INSTANCE ACCESSOR

The instance accessor is designed to be used by modules wishing to produce
indented output. If the instance already exists (as will be the case if the
main program using the module constructed a Text::Indent object) then both
the program and the module will use the same indentation scheme.

If the instance does not exist yet, the instance accessor dispatches it's
arguments to the constructor. As such, any of the parameters that the
constructor takes may also be passed to the instance accessor. Be mindful
that if the instance does exist, any parameters passed to the instance
accessor are ignored.

# METHODS

## increase($how\_many)

This method increases the level of indentation by $how\_many levels.  If
not provided, $how\_many defaults to 1.

## decrease

This method decreases the level of indentation by $how\_many levels.  If
not provided, $how\_many defaults to 1.

## reset

This method resets the level of indentation to 0.  It is functionally
equivalent to $indent->level(0).

## indent(@what)

This is the primary workhorse method of Text::Indent. It takes a list of
arguments to be indented and returns the indented string.

The string returned is composed of the following list:

- the 'space' character repeated x times, where x is the number of
spaces multiplied by the indent level.
- the stringification of arguments passed to the method (note that
this means that list arguments will have spaces inserted in between them).
- a newline if the 'add\_newline' attribute of the Text::Indent object
is set.

If the indent level drops is a negative value, no indent is applied.

# ACCESSORS

## spaces

Gets or sets the number of spaces used for each indent level.

## spacechar

Gets or sets the character used for indentation.

## level

Gets or sets the current indent level.

## add\_newline

Gets or sets the boolean attribute that determines if the **indent** method
tacks a newline onto it's arguments.

# EXAMPLES

In the main program producing indented output:

    use Text::Indent;
    use Bar;
    my $bar = Bar->new(...);
    my $i = Text::Indent->new( Level => 1 );
    print $i->indent("foo");
    $i->increase;
    print $bar->display;
    $i->decrease;
    print $i->indent("baz");
    $i->reset;
    print $i->indent("gzonk");

In Bar.pm:

    package Bar;
    use Text::Indent;
    sub display
    {
      my $i = Text::Indent->instance;
      return $i->indent("bar");
    }

The output from the preceding example would be (> indicates the left edge
of output and is for illustrative purposes only):

    >  foo
    >    bar
    >  baz
    >gzonk

# AUTHOR

James FitzGibbon, &lt;jfitz@CPAN.org>

# COPYRIGHT

Copyright (c) 2003-10 James FitzGibbon.  All Rights Reserved.

This module is free software; you may use it under the same terms as Perl
itself.
