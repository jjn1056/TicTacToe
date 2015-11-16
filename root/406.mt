<h1>Request Not acceptable</h1>
<p>You requested a media type we don't support.  Acceptable types are:</p>
<ul><? foreach my $allowed (@$allowed) { ?>
  <li><?= $allowed ?></li>
<? } ?></ul>
