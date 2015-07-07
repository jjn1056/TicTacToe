use strict;
use warnings;

package JJNAPIORK::TicTacToe::Schema::ResultSet::Game;

use base 'JJNAPIORK::TicTacToe::Schema::ResultSet';

sub _new_game {
  my $self = shift;
  return $self->create({board_rs => [ +{} ]});
}

1;

=head1 TITLE

JJNAPIORK::TicTacToe::Schema::ResultSet::Game - resultset method for Game

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
