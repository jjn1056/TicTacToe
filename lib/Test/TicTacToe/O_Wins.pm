package Test::TicTacToe::O_Wins;
use base 'Test::Class';

use Test::Most;
use Test::DBIx::Class
  -schema_class => 'TicTacToe::Schema';

sub db_connect : Test(startup) {
  shift->{schema} = Schema();
}

sub t01_create_new_game :Tests(5) {
  ok my $game = $_[0]->{schema}->resultset('Game')->new_game;
  
  is $game->whos_turn, 'X';
  is $game->status, 'in_play';
  is $game->current_move, 1;
  is_deeply [$game->available_moves], [qw/tl tc tr ml mc mr bl bc br/];

  $_[0]->{game} = $game;
}

sub t02_move_mc :Tests(6) {
  ok my $game = shift->{game};

  $game->select_move('mc');

  {
    my %board = $game->current_layout;
    is_deeply \%board, +{
      tl => undef, tc => undef, tr => undef,
      ml => undef, mc => 'X', mr => undef,
      bl => undef, bc => undef, br => undef };
  }

  is $game->whos_turn, 'O';
  is $game->status, 'in_play';
  is $game->current_move, 2;
  is_deeply [$game->available_moves], [qw/tl tc tr ml mr bl bc br/];
}

sub t03_move_tc :Tests(6) {
  ok my $game = shift->{game};
  $game->select_move('tc');

  {
    my %board = $game->current_layout;
    is_deeply \%board, +{
      tl => undef, tc => 'O', tr => undef,
      ml => undef, mc => 'X', mr => undef,
      bl => undef, bc => undef, br => undef };
  }

  is $game->whos_turn, 'X';
  is $game->status, 'in_play';
  is $game->current_move, 3;
  is_deeply [$game->available_moves], [qw/tl tr ml mr bl bc br/];
}

sub t04_move_bc :Tests(6) {
  ok my $game = shift->{game};
  $game->select_move('bc');

  {
    my %board = $game->current_layout;
    is_deeply \%board, +{
      tl => undef, tc => 'O', tr => undef,
      ml => undef, mc => 'X', mr => undef,
      bl => undef, bc => 'X', br => undef };
  }

  is $game->whos_turn, 'O';
  is $game->status, 'in_play';
  is $game->current_move, 4;
  is_deeply [$game->available_moves], [qw/tl tr ml mr bl br/];
}

sub t05_move_tl :Tests(6) {
  ok my $game = shift->{game};
  $game->select_move('tl');

  {
    my %board = $game->current_layout;
    is_deeply \%board, +{
      tl => 'O', tc => 'O', tr => undef,
      ml => undef, mc => 'X', mr => undef,
      bl => undef, bc => 'X', br => undef };
  }

  is $game->whos_turn, 'X';
  is $game->status, 'in_play';
  is $game->current_move, 5;
  is_deeply [$game->available_moves], [qw/tr ml mr bl br/];
}

sub t06_move_bl :Tests(6) {
  ok my $game = shift->{game};
  $game->select_move('bl');
  {
    my %board = $game->current_layout;
    is_deeply \%board, +{
      tl => 'O', tc => 'O', tr => undef,
      ml => undef, mc => 'X', mr => undef,
      bl => 'X', bc => 'X', br => undef };
  }

  is $game->whos_turn, 'O';
  is $game->status, 'in_play';
  is $game->current_move, 6;
  is_deeply [$game->available_moves], [qw/tr ml mr br/];
}

sub t07_move_tr :Tests(6) {
  ok my $game = shift->{game};
  $game->select_move('tr');

  {
    my %board = $game->current_layout;
    is_deeply \%board, +{
      tl => 'O', tc => 'O', tr => 'O',
      ml => undef, mc => 'X', mr => undef,
      bl => 'X', bc => 'X', br => undef };
  }

  is $game->whos_turn, undef;
  is $game->status, 'O_wins';
  is $game->current_move, undef;
  is_deeply [$game->available_moves], [qw//];
}

sub t08_fail :Tests(2) {
  ok my $game = shift->{game};
  eval {
    $game->select_move('br'); 1
  } || do {
    like $@, qr/This game has reached an end state and can no longer be played.  Its outcome is 'O_wins'/;
  };
}

1;
