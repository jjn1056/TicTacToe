use warnings;
use strict;

package TicTacToe::Server;

use TicTacToe;
use Plack::Runner;

sub run { Plack::Runner->run(@_, TicTacToe->to_app) }

return caller(1) ? 1 : run(@ARGV);

=head1 TITLE

TicTacToe::Server - Start the application under a web server

=head1 DESCRIPTION

Start the web application.  Example:

    perl -Ilib  lib/TicTacToe/Server.pm --server Gazelle

or

    make server

=head1 AUTHORS & COPYRIGHT

See L<TicTacToe>.

=head1 LICENSE

See L<TicTacToe>.

=cut
