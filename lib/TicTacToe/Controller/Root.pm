package TicTacToe::Controller::Root;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';

has 'show_board' => (is=>'ro', required=>1);

sub root :Chained(/) PathPart('') CaptureArgs(0) {
  my ($self, $c) = @_;
  my $view = $c->req->on_best_media_type(
    'text/html' => sub { 'HTML' },
    'application/json' => sub { 'JSON' },
    'no_match' => sub {
      my ($req, %callbacks) = @_;
      $c->view('HTML')->template('406');
      $c->view('HTML')->detach_not_acceptable({allowed=>[keys %callbacks]});
    },
  );
  $c->current_view($view);
}

  sub new_game :POST Chained(root) PathPart('') FormModelTarget('Form::Game') Args(0) {
    my ($self, $c) = @_;
    my $form = $c->model('Form::Game',
      my $game = $c->model('Schema::Game::Result'));

    if($form->is_valid) {
      my $game_url = $c->uri($self->show_board, [$game->id]);
      $c->view->created(
        location => $game_url, {
        game => $game,
        form => $form,
        new_game_url => $game_url,
      });
    } else {
      ## TODO, needs a template for HTML view
      $c->view->unprocessable_entity($form);
    }
  }

  sub view_games :GET Chained(root) PathPart('') Args(0) {
    my ($self, $c) = @_;
    my $form = $c->model("Form::Game");
    my @links_to_games = map {
       $c->uri($self->show_board, [$_->id])
    } $c->model("Schema::Game")->all;

    $c->view->ok({
      form => $form, 
      games => \@links_to_games});
  }

  sub not_found :Chained(root) PathPart('') Args {
    my ($self, $c) = @_;
    $c->view->not_found({error=>'Path Not Found'});
  }

__PACKAGE__->meta->make_immutable;

=head1 TITLE

TicTacToe::Controller::Game - The Game controller

=head1 DESCRIPTION

View or change information about a game of TTT

=head1 ACTIONS

This class defines the following actions

=head2 root

root action, do content negotiation via L<Catalyst::TraitFor::Request::ContentNegotiationHelpers>.

=head2 new_game

Create a new game resource

=head2 view_games

View all existing games

=head3 not_found

Handle any not_found events

=head1 AUTHORS & COPYRIGHT

See L<JJNAPIORK::TicTacToe>.

=head1 LICENSE

See L<JJNAPIORK::TicTacToe>.

=cut
