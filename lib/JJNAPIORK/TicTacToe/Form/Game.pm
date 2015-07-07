package JJNAPIORK::TicTacToe::Form::Game;

use HTML::FormHandler::Moose;
use JJNAPIORK::TicTacToe::Schema::Result::Board;

extends 'HTML::FormHandler';

has_field 'move' => (
  type=>'Select',
  required => 1);

has_field 'submit' => (type => 'Submit');

has 'options_move' => (
  is=>'ro',
  isa=>'ArrayRef',
  traits => ['Array'],
  default => sub { [map { $_ => $_ } @JJNAPIORK::TicTacToe::Schema::Result::Board::locations] },
  required=>1);


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
