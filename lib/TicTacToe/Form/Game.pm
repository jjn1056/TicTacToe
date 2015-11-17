package TicTacToe::Form::Game;

use HTML::FormHandler::Moose;
use TicTacToe::Schema::Result::Board;

extends 'HTML::FormHandler';

has_field 'move' => (
  type=>'Select',
  required => 1);

has_field 'submit' => (type => 'Submit');

sub options_move {
  my $self = shift;
  my @available_moves = ($self->item && $self->item->in_storage) ?
    $self->item->available_moves :
      @TicTacToe::Schema::Result::Board::locations;

  return map { $_ => $_ } @available_moves;
}

sub update_model {
  my $self = shift;

  # Create if needed
  unless($self->item->in_storage) {
    $self->item->insert;
  }

  $self->item->select_move(
    $self->values->{move});

  # Need to rebuild the options since they are stored after
  # populated the first time but we just changed the model.
  $self->field('move')->_load_options;

}

sub prepare_error_response {  
  return +{
    form_error => $_[0]->form_errors,
    error_by_field => $_[0]->errors_by_name,
    fields => $_[0]->fif};
}

sub TO_JSON {
  my $self = shift;
  return $self->is_valid ?
    $self->value :
      $self->prepare_error_response;
}

__PACKAGE__->meta->make_immutable;
