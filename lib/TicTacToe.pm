package TicTacToe;

use Catalyst::Plugin::MapComponentDependencies::Utils ':ALL';
use Catalyst qw/
  ConfigLoader
  ResponseFrom
  RedirectTo
  CurrentComponents
  InjectionHelpers
  MapComponentDependencies
  URI
/;

__PACKAGE__->inject_components(
  'Model::Form' => { from_component => 'Catalyst::Model::HTMLFormhandler' },
  'Model::Schema' => { from_component => 'Catalyst::Model::DBIC::Schema'},
  'View::JSON' => { from_component => 'Catalyst::View::JSON::PerRequest' },
  'View::HTML' => { from_component => 'Catalyst::View::Text::MicroTemplate::PerRequest'});

__PACKAGE__->request_class_traits(['ContentNegotiationHelpers']);

__PACKAGE__->config(
  'default_view' => 'HTML',
  'default_model' => 'Schema',
  'Controller::Root' => {
    namespace => '',
    show_board => 'Game.game',
  },
  'Controller::Game' => {
    games_index => 'Root.view_games',
  },
  'Model::Schema' => {
    traits => ['Result'],
    schema_class => 'TicTacToe::Schema',
  },
  'View::JSON' => {
    handle_encode_error => \&Catalyst::View::JSON::PerRequest::HANDLE_ENCODE_ERROR,
  },
  'View::HTML' => {
    content_type => 'text/html',
    handle_process_error => \&Catalyst::View::Text::MicroTemplate::PerRequest::HANDLE_PROCESS_ERROR,
  },
  'Plugin::CurrentComponents' => {
    model_instance_from_return => 1,
  },
);

__PACKAGE__->setup;

=head1 NAME

TicTacToe - A demo Tic Tac Toe microservice

=head1 SYNOPSIS

To start the server

    make server

=head1 DESCRIPTION

A very basic web service that tracks the state of a game of Tic Tac Toe.

This service does not do anything like security or identity.  All it does
is let you create a game of tic tac toe and then lets you track the progress
of a game, returning errors if you try to get the board into an invalid state
and it also lets you know when the game is over.  It in general tries to
make sure you follow the right path to a successful outcome.

Generally when doing a web service I first do an HTML version, since that is
self documenting and also since HTML was the inspiration for REST I beleive that
it leads to you creating a sane API.  There is also a JSON version of the API
(the test case json.t tests this version.)  There are also test cases for just
the DBIC model, since I think its important to have test cases at a level below
the HTTP interface.

=head1 Plugins

You should review the following plugins which are used by this application

L<Catalyst::Plugin::ConfigLoader>,
L<Catalyst::Plugin::ResponseFrom>,
L<Catalyst::Plugin::RedirectTo>,
L<Catalyst::Plugin::CurrentComponents>,
L<Catalyst::Plugin::InjectionHelpers>,
L<Catalyst::Plugin::MapComponentDependencies>,
L<Catalyst::Plugin::URI>

=head1 API Documention

The following is API level documention.

Assume $base_URL is the base of the webserver (for example if you are running the
webserver locally, this would be http://localhost:5000/

=head2 Query all available games

    GET $base_URL

This will return a list of the avialable running or completed games.  It returns a
null list if there are none.  Here is an example using this API with Curl and JSON:

  curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X GET $base_URL

  HTTP/1.0 200 OK
  Date: Sun, 12 Apr 2015 21:02:15 GMT
  Server: HTTP::Server::PSGI
  Content-Type: application/json; charset=utf-8
  X-Catalyst: 5.90085
  Content-Length: 128

  {
    "games": ["http://localhost:5000/1","http://localhost:5000/2","http://localhost:5000/3"],
    "new_game":"http://localhost:5000/new"
  }

So this gives you links to existing games, and a link to start a new game.

=head2 Query an existing Game

    GET $base_URL/:game_id

This returns the status and board information for an existing game (or not found if you request
a game that does not exist).  Example:

    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X GET http://localhost:5000/1

    HTTP/1.0 200 OK
    Date: Sun, 12 Apr 2015 21:20:06 GMT
    Server: HTTP::Server::PSGI
    Content-Type: application/json; charset=utf-8
    X-Catalyst: 5.90085
    Content-Length: 164

    { 
      "whos_turn":null,
      "status":"X_wins",
      "available_next_moves":[],
      "current_layout":{"br":null,"mc":"X","bl":"X","ml":"O","tr":"X","tl":"X","bc":null,"mr":"O","tc":"O"}
    }

In the returned data structure the following format is followed

=head3 whos_turn

Will be either X or O or null (if the game is over).  Indicate that player that is current 'up'.

=head3 status

one of X_wins, O_wins or in_play.  Indicates an end state or if the game is still being playued

=head3 available_next_moves

An arrayref of the moves you are currently allowed.  This arrayref is empty if there are no more moves
available or if the game is over (someone won).

=head3 current_layout

A Hashref of the current board state, which squares are used and by whom, or if a square is still empty.
Hashref keys refer to a board like the following:

    tl | tc | tr
    == | == | ==
    ml | mc | mr
    == | == | ==
    bl | bm | br

Values for each key is one of X, O or null depending on if a square has been taken or is still available

=head2 Create a new game

You create a new game by POSTing the first player move (the X player always starts) to the 'new'
endpoint.  For example, create a new game where X player places an X in the middle square:

    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:5000/new -d '{"move":"mc"}'

    HTTP/1.0 200 OK
    Date: Sun, 12 Apr 2015 21:27:11 GMT
    Server: HTTP::Server::PSGI
    Location: http://localhost:5000/4
    Content-Type: application/json; charset=utf-8
    X-Catalyst: 5.90085
    Content-Length: 209

    {
      "current_layout":{"tl":null,"bc":null,"mr":null,"tc":null,"bl":null,"ml":null,"tr":null,"mc":"X","br":null},
      "whos_turn":"O",
      "status":"in_play",
      "available_next_moves":["tl","tc","tr","ml","mr","bl","bc","br"]
    }

The location header returns the URL location where this new game has been created, and you also get
a hashref of the game state (all fields are like 'Query an existing Game').

The POST takes just one parameter 'move' and its value is one of the valid 'available_next_moves'
as described in 'current_layout'.

If you POST something that is not permitted, the following error structure will be generated:

    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:5000/5 -d '{"move":"mc"}'

    HTTP/1.0 400 Bad Request
    Date: Sun, 12 Apr 2015 21:31:51 GMT
    Server: HTTP::Server::PSGI
    Content-Type: application/json; charset=utf-8
    X-Catalyst: 5.90085
    Content-Length: 96

    {
      "form_error":[],
      "fields":{"move":"mc"},
      "error_by_field":{
        "move":["'mc' is not a valid value"]
      }
    }

The following describes the error fields

=head3 form_error

An arrayref of error messages that apply to the entire fore

=head3 error_by_field

An arrayref of error messages arranged by field

=head3 fields

A hashref of the fields and values you originally posted the returned an error.

=head2 Update an existing Game

If a game is not yet completed you may POST an update to the same URL that you GET to retrieve Game
information.  For example:

    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:5000/5 -d '{"move":"ml"}'
    HTTP/1.0 200 OK
    Date: Sun, 12 Apr 2015 21:35:38 GMT
    Server: HTTP::Server::PSGI
    Location: http://localhost:5000/5
    Content-Type: application/json; charset=utf-8
    X-Catalyst: 5.90085
    Content-Length: 203

    {
        "whos_turn":"X",
        "available_next_moves":["tl","tc","tr","mr","bl","bc","br"],
        "status":"in_play",
        "current_layout":{"mc":"X","br":null,"tc":null,"mr":null,"bc":null,"tl":null,"tr":null,"ml":"O","bl":null}
    }

You make updates using the same field method as in creating a new game.  Error results are the
same as in described errors when creating a new game.

=head2 Example full game using the JSON API

The following is a transcript of an entire game played until X wins

    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:5000/new -d '{"move":"mc"}'

    HTTP/1.0 200 OK
    Date: Sun, 12 Apr 2015 21:39:14 GMT
    Server: HTTP::Server::PSGI
    Location: http://localhost:5000/11
    Content-Type: application/json; charset=utf-8
    X-Catalyst: 5.90085
    Content-Length: 209

    {
      "available_next_moves":["tl","tc","tr","ml","mr","bl","bc","br"],
      "status":"in_play",
      "whos_turn":"O",
      "current_layout":{"mc":"X","br":null,"tc":null,"mr":null,"bc":null,"tl":null,"tr":null,"ml":null,"bl":null}
    }

    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:5000/11 -d '{"move":"tc"}

    HTTP/1.0 200 OK
    Date: Sun, 12 Apr 2015 21:39:25 GMT
    Server: HTTP::Server::PSGI
    Location: http://localhost:5000/11
    Content-Type: application/json; charset=utf-8
    X-Catalyst: 5.90085
    Content-Length: 203

    {
      "whos_turn":"X",
      "available_next_moves":["tl","tr","ml","mr","bl","bc","br"],
      "status":"in_play",
      "current_layout":{"tr":null,"ml":null,"bl":null,"tc":"O","mr":null,"bc":null,"tl":null,"br":null,"mc":"X"}
    }

    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:5000/11 -d '{"move":"mr"}'

    HTTP/1.0 200 OK
    Date: Sun, 12 Apr 2015 21:39:29 GMT
    Server: HTTP::Server::PSGI
    Location: http://localhost:5000/11
    Content-Type: application/json; charset=utf-8
    X-Catalyst: 5.90085
    Content-Length: 197

    {
      "available_next_moves":["tl","tr","ml","bl","bc","br"],
      "status":"in_play",
      "whos_turn":"O",
      "current_layout":{"br":null,"mc":"X","tr":null,"ml":null,"bl":null,"tc":"O","mr":"X","bc":null,"tl":null}
    }

    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:5000/11 -d '{"move":"tr"}'

    HTTP/1.0 200 OK
    Date: Sun, 12 Apr 2015 21:39:32 GMT
    Server: HTTP::Server::PSGI
    Location: http://localhost:5000/11
    Content-Type: application/json; charset=utf-8
    X-Catalyst: 5.90085
    Content-Length: 191

    {
      "available_next_moves":["tl","ml","bl","bc","br"],
      "status":"in_play",
      "whos_turn":"X",
      "current_layout":{"mc":"X","br":null,"tl":null,"bc":null,"mr":"X","tc":"O","bl":null,"ml":null,"tr":"O"}
    }

    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:5000/11 -d '{"move":"ml"}

    HTTP/1.0 200 OK
    Date: Sun, 12 Apr 2015 21:39:35 GMT
    Server: HTTP::Server::PSGI
    Location: http://localhost:5000/11
    Content-Type: application/json; charset=utf-8
    X-Catalyst: 5.90085
    Content-Length: 166

    {
      "status":"X_wins",
      "available_next_moves":[],
      "whos_turn":null,
      "current_layout":{"br":null,"mc":"X","tr":"O","bl":null,"ml":"X","mr":"X","tc":"O","tl":null,"bc":null}
    }

=head1 METHODS

This class defines the following methods

=head2 version

Current application version

=head1 AUTHOR
  
John Napiorkowski L<email:jjnapiork@cpan.org>

=head1 COPYRIGHT & LICENSE

Copyright 2016, John Napiorkowski L<email:jjnapiork@cpan.org>
  
This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
