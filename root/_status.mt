<dl>
  <dt>Status</dt>
  <dd><?= $game->status ?></dd>
  <dt>Pending Move</dt>
  <dd><?= $game->current_move || 'N/a' ?></dd>
  <dt>Who's Turn</dt>
  <dd><?= $game->whos_turn || 'N/a' ?></dd>
  <dt>Current Layout</dt>
  <?= include '_board' ?>
</dl>
