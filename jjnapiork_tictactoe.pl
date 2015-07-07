use Test::DBIx::Class
  -schema_class => 'JJNAPIORK::TicTacToe::Schema';

my $config = {
  'default_view' => 'HTML',
  'Model::Schema' => {
    connect_info => [ sub { Schema()->storage->dbh } ],
  },
  'Model::Form::Game' => {
    class => 'JJNAPIORK::TicTacToe::Form::Game',
  },
};

return $config;
