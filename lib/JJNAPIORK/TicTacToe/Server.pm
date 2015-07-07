use warnings;
use strict;

package JJNAPIORK::TicTacToe::Server;

use JJNAPIORK::TicTacToe;
use Plack::Runner;

sub run { Plack::Runner->run(@_, JJNAPIORK::TicTacToe->to_app) }

return caller(1) ? 1 : run(@ARGV);

=head1 TITLE

JJNAPIORK::TicTacToe::Server - Start the application under a web server

=head1 DESCRIPTION

Start the web application.  Example:

    perl -Ilib  lib/JJNAPIORK/TicTacToe/Server.pm --server Gazelle

=head1 AUTHORS & COPYRIGHT

See L<JJNAPIORK::TicTacToe>.

=head1 LICENSE

See L<JJNAPIORK::TicTacToe>.

=cut
