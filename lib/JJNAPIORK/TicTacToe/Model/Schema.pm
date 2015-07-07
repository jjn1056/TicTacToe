package JJNAPIORK::TicTacToe::Model::Schema;

use Moose;
extends 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(schema_class => 'JJNAPIORK::TicTacToe::Schema');
__PACKAGE__->meta->make_immutable;

=head1 TITLE

JJNAPIORK::TicTacToe::Model::Schema- Proxy for JJNAPIORK::TicTacToe::Schema

=head1 DESCRIPTION

Proxies all the L<JJNAPIORK::TicTacToe::Schema> information to L<JJNAPIORK::TicTacToe::Schema>

=head1 METHODS

This class defines the following methods

=head1 AUTHORS & COPYRIGHT

See L<JJNAPIORK::TicTacToe>.

=head1 LICENSE

See L<JJNAPIORK::TicTacToe>.

=cut

