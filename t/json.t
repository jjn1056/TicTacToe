use Test::Most;
use TicTacToe;
use Catalyst::Test 'TicTacToe';
use HTTP::Request::Common;
use JSON::MaybeXS;

# Lets test using the JSON API

my $location = '/';

{
  ok my $res = request POST $location,
     Content_Type => 'application/json',
     Accept => 'application/json',
     Content => encode_json +{'move'=>'mc'}; 

  ok $location = $res->header('location'), "got location: $location";
  ok my $game = decode_json($res->content);

  is $game->{game}{whos_turn}, 'O';
  is $game->{game}{status}, 'in_play';
  is_deeply $game->{game}{available_next_moves}, [qw/tl tc tr ml mr bl bc br/];

  my $board = $game->{game}{current_layout};
  is_deeply $board, +{
    tl => undef, tc => undef, tr => undef,
    ml => undef, mc => 'X', mr => undef,
    bl => undef, bc => undef, br => undef };
}

{
  ok my $res = request POST $location,
     Content_Type => 'application/json',
     Accept => 'application/json',
     Content => encode_json +{'move'=>'bc'}; 

  ok my $game = decode_json($res->content);

  is $game->{game}{whos_turn}, 'X';
  is $game->{game}{status}, 'in_play';
  is_deeply $game->{game}{available_next_moves}, [qw/tl tc tr ml mr bl br/];

  my $board = $game->{game}{current_layout};
  is_deeply $board, +{
    tl => undef, tc => undef, tr => undef,
    ml => undef, mc => 'X', mr => undef,
    bl => undef, bc => 'O', br => undef };
}

{
  ok my $res = request POST $location,
     Content_Type => 'application/json',
     Accept => 'application/json',
     Content => encode_json +{'move'=>'ml'}; 

  ok my $game = decode_json($res->content);

  is $game->{game}{whos_turn}, 'O';
  is $game->{game}{status}, 'in_play';
  is_deeply $game->{game}{available_next_moves}, [qw/tl tc tr mr bl br/];

  my $board = $game->{game}{current_layout};
  is_deeply $board, +{
    tl => undef, tc => undef, tr => undef,
    ml => 'X', mc => 'X', mr => undef,
    bl => undef, bc => 'O', br => undef };
}

{
  ok my $res = request POST $location,
     Content_Type => 'application/json',
     Accept => 'application/json',
     Content => encode_json +{'move'=>'bl'}; 

  ok my $game = decode_json($res->content);

  is $game->{game}{whos_turn}, 'X';
  is $game->{game}{status}, 'in_play';
  is_deeply $game->{game}{available_next_moves}, [qw/tl tc tr mr br/];

  my $board = $game->{game}{current_layout};
  is_deeply $board, +{
    tl => undef, tc => undef, tr => undef,
    ml => 'X', mc => 'X', mr => undef,
    bl => 'O', bc => 'O', br => undef };
}

{
  ok my $res = request POST $location,
     Content_Type => 'application/json',
     Accept => 'application/json',
     Content => encode_json +{'move'=>'mr'}; 

  ok my $game = decode_json($res->content);

  is $game->{game}{whos_turn}, undef;
  is $game->{game}{status}, 'X_wins';
  is_deeply $game->{game}{available_next_moves}, [];

  my $board = $game->{game}{current_layout};
  is_deeply $board, +{
    tl => undef, tc => undef, tr => undef,
    ml => 'X', mc => 'X', mr => 'X',
    bl => 'O', bc => 'O', br => undef };
}

done_testing;
