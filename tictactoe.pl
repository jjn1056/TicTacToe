use Test::DBIx::Class
  -schema_class => 'TicTacToe::Schema';

my $config = {
  'Model::Schema' => {
    connect_info => [ sub { Schema()->storage->dbh } ],
  },
};

return $config;
