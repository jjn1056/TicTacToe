use strict;
use warnings;

package TicTacToe::Schema::ResultSet::Board;

use base 'TicTacToe::Schema::ResultSet';

sub last_in_game {
  my $self = shift;
  $self->order_by({ -desc => 'move' })->first;
}

1;

=head1 TITLE

TicTacToe::Schema::ResultSet::Board - resultset method for Board

=head1 DESCRIPTION

Methods on sets of boards

=head1 METHODS

This class defines the following methods

=head2 last_in_game

Returns the row representing the last move made on the
board.

=head1 AUTHORS & COPYRIGHT

See L<TicTacToe>.

=head1 LICENSE

See L<TicTacToe>.

=cut
