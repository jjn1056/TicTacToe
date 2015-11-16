? extends 'html'

<? block title => sub { ?>TicTacToe - New Game<? } ?>
<? block body => sub { ?>
  <h1>Information</h1>
    <dl>
      <dt>Time of Request</dt>
      <dd><?= scalar(localtime) ?></dd>
      <dt>Requested Move</dt>
      <dd><?= $form->values->{move} ?></dd>
    </dl>
  <h1>Links</h1>
  <p>Your <a href="<?= $new_game_url ?>">new game</a></p>
  <h1>Current Game Status</h1>
  <?= include '_status' ?>
<? } ?>

