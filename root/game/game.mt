? extends 'html'

<? block title => sub { ?>TicTacToe - Game<? } ?>
<? block body => sub { ?>
  <h1>Links</h1>
  <p>See all <a href="<?= $index ?>">games</a></a>
  <h1>Current Game Status</h1>
  <?= include '_status' ?>
  <? if($game->status eq 'in_play') { ?>
  <h1>Make a new move in this game</h1>
  <?= include '_form' ?>
  <? } ?>
<? } ?>
