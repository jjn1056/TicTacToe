package TicTacToe::Controller::Root;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';

has 'show_board_action' => (is=>'ro', required=>1);

sub root :Chained(/) PathPart('') CaptureArgs(0) {
  my ($self, $c) = @_;
  my $view = $c->req->on_best_media_type(
    'text/html' => sub { 'HTML' },
    'application/json' => sub { 'JSON' },
    'no_match' => sub {
      my ($req, %callbacks) = @_;
      $c->view->template('406');
      $c->view->detach_not_acceptable({allowed=>[keys %callbacks]});
    },
  );
  $c->current_view($view);
}

  sub new_game :POST Chained(root) PathPart('') FormModelTarget('Form::Game') Args(0) {
    my ($self, $c) = @_;
    my $form = $c->model('Form::Game');
    if($form->is_valid) {
      my $game = $form->item;
      my $game_url = $c->uri_for_action($self->show_board_action, [$game->id]);
      warn "33" x 100;
      $c->view->created(location => $game_url, {
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

    ## TODO, needs paging for when lots of game
    ## TODO, add count of total games
    my @links_to_games = map {
       $c->uri_for_action($self->show_board_action, [$_->id])
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
