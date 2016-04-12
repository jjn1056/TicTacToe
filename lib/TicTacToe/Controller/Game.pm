package TicTacToe::Controller::Game;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';

has 'games_index' => (is=>'ro', required=>1);

sub root :Chained(../root) PathPart('') CaptureArgs(1) {
  my ($self, $c, $id) = @_;
  return $c->model("Schema::Game::Result") ||
    $c->go('/not_found');
}

  sub game :Chained('root') PathPart('') Args(0) {
    my ($self, $c) = @_;
    my $form = $c->model('Form::Game',
      my $game = $c->model,
        action_from => $self->action_for('game')
    );

    $c->view->data->set(
      game => $game,
      form => $form,
      index => $c->uri($self->games_index));

    if($form->posted && !$form->is_valid) {
      ## TODO, needs a template for HTML view
      $c->view->detach_unprocessable_entity();
    }

    $c->view->ok;
  }

__PACKAGE__->meta->make_immutable;

=head1 TITLE

TicTacToe::Controller::Game - The Game controller

=head1 DESCRIPTION

View or change information about a game of TTT

=head1 ACTIONS

This class defines the following actions

=head2 root

root action, find the game or return NotFound

=head2 game

Process GET or POST on a game resource

=head1 AUTHORS & COPYRIGHT

See L<JJNAPIORK::TicTacToe>.

=head1 LICENSE

See L<JJNAPIORK::TicTacToe>.

=cut
