use Test::Most;
use Test::DBIx::Class
  -schema_class => 'TicTacToe::Schema';

ok my $game = Schema->resultset('Game')->new_game;

is $game->whos_turn, 'X';
is $game->status, 'in_play';
is $game->current_move, 1;
is_deeply [$game->available_moves], [qw/tl tc tr ml mc mr bl bc br/];

{
  my %board = $game->current_layout;
  is_deeply \%board, +{
    tl => undef, tc => undef, tr => undef,
    ml => undef, mc => undef, mr => undef,
    bl => undef, bc => undef, br => undef };
}

$game->select_move('mc');

is $game->whos_turn, 'O';
is $game->status, 'in_play';
is $game->current_move, 2;
is_deeply [$game->available_moves], [qw/tl tc tr ml mr bl bc br/];

{
  my %board = $game->current_layout;
  is_deeply \%board, +{
    tl => undef, tc => undef, tr => undef,
    ml => undef, mc => 'X', mr => undef,
    bl => undef, bc => undef, br => undef };
}

$game->select_move('tc');

is $game->whos_turn, 'X';
is $game->status, 'in_play';
is $game->current_move, 3;
is_deeply [$game->available_moves], [qw/tl tr ml mr bl bc br/];

{
  my %board = $game->current_layout;
  is_deeply \%board, +{
    tl => undef, tc => 'O', tr => undef,
    ml => undef, mc => 'X', mr => undef,
    bl => undef, bc => undef, br => undef };
}

$game->select_move('bc');

is $game->whos_turn, 'O';
is $game->status, 'in_play';
is $game->current_move, 4;
is_deeply [$game->available_moves], [qw/tl tr ml mr bl br/];

{
  my %board = $game->current_layout;
  is_deeply \%board, +{
    tl => undef, tc => 'O', tr => undef,
    ml => undef, mc => 'X', mr => undef,
    bl => undef, bc => 'X', br => undef };
}

$game->select_move('bl');

is $game->whos_turn, 'X';
is $game->status, 'in_play';
is $game->current_move, 5;
is_deeply [$game->available_moves], [qw/tl tr ml mr br/];

{
  my %board = $game->current_layout;
  is_deeply \%board, +{
    tl => undef, tc => 'O', tr => undef,
    ml => undef, mc => 'X', mr => undef,
    bl => 'O', bc => 'X', br => undef };
}

$game->select_move('tl');

is $game->whos_turn, 'O';
is $game->status, 'in_play';
is $game->current_move, 6;
is_deeply [$game->available_moves], [qw/tr ml mr br/];

{
  my %board = $game->current_layout;
  is_deeply \%board, +{
    tl => 'X', tc => 'O', tr => undef,
    ml => undef, mc => 'X', mr => undef,
    bl => 'O', bc => 'X', br => undef };
}

$game->select_move('ml');

is $game->whos_turn, 'X';
is $game->status, 'in_play';
is $game->current_move, 7;
is_deeply [$game->available_moves], [qw/tr mr br/];

{
  my %board = $game->current_layout;
  is_deeply \%board, +{
    tl => 'X', tc => 'O', tr => undef,
    ml => 'O', mc => 'X', mr => undef,
    bl => 'O', bc => 'X', br => undef };
}

$game->select_move('tr');

is $game->whos_turn, 'O';
is $game->status, 'in_play';
is $game->current_move, 8;
is_deeply [$game->available_moves], [qw/mr br/];

{
  my %board = $game->current_layout;
  is_deeply \%board, +{
    tl => 'X', tc => 'O', tr => 'X',
    ml => 'O', mc => 'X', mr => undef,
    bl => 'O', bc => 'X', br => undef };
}

$game->select_move('br');

is $game->whos_turn, 'X';
is $game->status, 'in_play';
is $game->current_move, 9;
is_deeply [$game->available_moves], [qw/mr/];

{
  my %board = $game->current_layout;
  is_deeply \%board, +{
    tl => 'X', tc => 'O', tr => 'X',
    ml => 'O', mc => 'X', mr => undef,
    bl => 'O', bc => 'X', br => 'O' };
}

# Check for conflicting select_move

eval {
  $game->select_move('br'); 1
} || do { like $@, qr/br is not a valid next move/ };

$game->select_move('mr');

is $game->whos_turn, undef;
is $game->status, 'draw';
is $game->current_move, undef;
is_deeply [$game->available_moves], [qw//];

{
  my %board = $game->current_layout;
  is_deeply \%board, +{
    tl => 'X', tc => 'O', tr => 'X',
    ml => 'O', mc => 'X', mr => 'X',
    bl => 'O', bc => 'X', br => 'O' };
}

# The game is over, its a draw, no more moves

eval {
  $game->select_move('br'); 1
} || do { like $@, qr/This game has reached an end state and can no longer be played.  Its outcome is 'draw'/ };

# Need to clearly specific test number to be sure to catch the eval error cases
done_testing(53);
