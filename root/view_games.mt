? extends 'html'

<? block title => sub { ?>TicTacToe - Games and new Game<? } ?>
<? block body => sub { ?>
  <h1>Existing Games</h1>
  <p>The following is a list of ongoing or completed games</p>
  <? if(!@$games) { ?>
    No games yet!
  <? } else { ?>
    <ol><? foreach my $game(@$games) { ?>
      <li><a href='<?= $game ?>'><?= $game ?></a></li>
    <? } ?></ol>
  <? } ?>
  <h1>Start a new game</h1>
  <p>Choose the first move for 'X' in a new game</p>
  <?= include '_form' ?>
<? } ?>
