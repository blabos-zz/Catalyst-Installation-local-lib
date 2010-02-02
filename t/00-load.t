#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Catalyst::Installation::local::lib' ) || print "Bail out!
";
}

diag( "Testing Catalyst::Installation::local::lib $Catalyst::Installation::local::lib::VERSION, Perl $], $^X" );
