package JJNAPIORK::TicTacToe::View::HTML;

use Moose;
use Text::Xslate::Util 'mark_raw', 'html_builder';

extends 'Catalyst::View::Xslate';

has '+xslate' => ( handles=>{'render_clean'=>'render'});

__PACKAGE__->config(
  encode_body=>undef,
  content_charset=>'UTF-8',
  expose_methods=>[qw/model/],
  function=>+{
    form_to_html => html_builder(\&form_to_html),
  });

sub model { pop->model }
sub form_to_html { shift->render }

sub template_for {
  my ($self, $action) = @_;
  return $action . $self->suffix;
}

__PACKAGE__->meta->make_immutable;

=head1 TITLE

JJNAPIORK::TicTacToe::View::HTML - The HTML View

=head1 DESCRIPTION

Create response bodies for the browser

=head1 METHODS

This class defines the following methods

=head2 template_for ($action)

Given an action return the template part that is linked to it.

=head2 render_clean ($template_part, \%vars)

takes a template path part and a hashref of variables and returs
a renderd document.  This is clean on context and all similar
things (everything needs to be in \%vars).

=head1 AUTHORS & COPYRIGHT

See L<JJNAPIORK::TicTacToe>.

=head1 LICENSE

See L<JJNAPIORK::TicTacToe>.

=cut

