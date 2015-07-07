use strict;
use warnings;

package JJNAPIORK::TicTacToe::Schema::ResultSet::Board;

use base 'JJNAPIORK::TicTacToe::Schema::ResultSet';

sub last_in_game {
  my $self = shift;
  $self->order_by({ -desc => 'move' })->first;
}


1;

=head1 TITLE

JJNAPIORK::TicTacToe::Schema::ResultSet::Board - resultset method for Board

=head1 DESCRIPTION

    TBD

=head1 METHODS

This class defines the following methods

=head2 TBD

    TBD

=head1 AUTHORS & COPYRIGHT

See L<JJNAPIORK::TicTacToe>.

=head1 LICENSE

See L<JJNAPIORK::TicTacToe>.

=cut
