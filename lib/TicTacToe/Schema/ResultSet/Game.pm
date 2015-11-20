use strict;
use warnings;

package TicTacToe::Schema::ResultSet::Game;

use base 'TicTacToe::Schema::ResultSet';

sub new_game {
  my $self = shift;
  return $self->create({});
}

sub map {
  my ($self, $cb) = @_;
  foreach my $result($self->all) {
    local $_ = $result;
    $cb->($self,$result);
  }
}

1;

=head1 TITLE

TicTacToe::Schema::ResultSet::Game - resultset method for Game

=head1 DESCRIPTION

    TBD

=head1 METHODS

This class defines the following methods

=head2 TBD

    TBD

=head1 AUTHORS & COPYRIGHT

See L<TicTacToe>.

=head1 LICENSE

See L<TicTacToe>.

=cut
