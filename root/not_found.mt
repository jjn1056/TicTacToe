? extends 'html'

<? block title => sub { ?>TicTacToe - Not Found Error<? } ?>
<? block body => sub { ?>
  <h1>Not Found</h1>
  <?= $error ?>
<? } ?>
