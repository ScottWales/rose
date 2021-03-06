# Rose Changes

Go to https://github.com/metomi/rose/milestones?state=closed
for a full listing of issues for each release.

--------------------------------------------------------------------------------

## Next Release (2015-Q3?)

Rose release 29. This release will work best with
[cylc-6.4.1](https://github.com/cylc/cylc/releases/tag/6.4.1) and
[fcm-2015.05.0](https://github.com/metomi/fcm/releases/tag/2015.05.0)?

### Noteworthy Changes

[#1658](https://github.com/metomi/rose/pull/1658):
rose suite-run --reload: new task hosts no longer cause the command to fail.

[#1657](https://github.com/metomi/rose/pull/1657):
rose suite-run: job hosts install: files and directories with colons in their
names no longer cause the command to fail.

[#1654](https://github.com/metomi/rose/pull/1654):
rose config-dump: don't prettify configuration metadata.

[#1644](https://github.com/metomi/rose/pull/1644):
rose suite-clean: will now clean empty suite directories.

[#1641](https://github.com/metomi/rose/pull/1641):
rose bush: no longer fail when it is unable to parse a bad `rose-suite.info`
file in a suite.

[#1640](https://github.com/metomi/rose/pull/1640):
rose config-edit: speed up macro changes.

[#1639](https://github.com/metomi/rose/pull/1639):
rose config-edit: array widgets: protect against unsaved null text.

[#1635](https://github.com/metomi/rose/pull/1635):
rosie go, and other rosie web service clients: now fail gracefully if it has
no site/user configuration settings.

--------------------------------------------------------------------------------

## 2015.06.0 (2015-06-17)

Rose release 28. This release works best with
[cylc-6.4.1](https://github.com/cylc/cylc/releases/tag/6.4.1) and
[fcm-2015.05.0](https://github.com/metomi/fcm/releases/tag/2015.05.0).

### Noteworthy Changes

[#1628](https://github.com/metomi/rose/pull/1628):
rose config-edit: source widget for displaying `file:*` sections: fix
traceback on initialisation.

[#1626](https://github.com/metomi/rose/pull/1626):
rose config-edit: fix value hints widget initialisation.

[#1615](https://github.com/metomi/rose/pull/1615):
rose bush: cycles: add `new->old`/`old->new` option.

--------------------------------------------------------------------------------

## 2015.05.0 (2015-05-28)

Rose release 27. This release works best with
[cylc-6.4.1](https://github.com/cylc/cylc/releases/tag/6.4.1) and
[fcm-2015.05.0](https://github.com/metomi/fcm/releases/tag/2015.05.0).

### Highlighted Changes

[#1621](https://github.com/metomi/rose/pull/1621),
[#1604](https://github.com/metomi/rose/pull/1604):
fcm_make built-in application: improve flexibility.
* Add `mirror.target=` to `fcm make` argument list as extra configuration.
* Support `-n 2` option where possible - this allows the continuation make to be
  in the same physical location.
* Allow flexible naming of the `mirror` step.
* Allow flexible mapping of the original and continuation task names.
* It is now possible to set:
  * the destination for both orig and cont runs.
  * fast locations for both orig and cont runs.
* `rose task-run --new` on orig will now:
  * clear orig and cont dests.
  * invoke `fcm make --new`.

See also
[metomi/fcm#188](https://github.com/metomi/fcm/pull/188),
[metomi/fcm#189](https://github.com/metomi/fcm/pull/189),
[metomi/fcm#190](https://github.com/metomi/fcm/pull/190).

[#1576](https://github.com/metomi/rose/pull/1576):
rose app-upgrade, rose macro: handle optional configurations.
If an application contains optional configurations, loop through each one,
combine with the main, upgrade it, and re-create it as a diff vs the upgraded
main configuration.

### Noteworthy Changes

[#1620](https://github.com/metomi/rose/pull/1620):
rose host-select: improve recognition for `localhost` - the logic will now
check for `localhost`, its hostname, its fqdn hostname, and the associated IP
addresses.

[#1618](https://github.com/metomi/rose/pull/1618):
rosie create/copy: fix malformed log message for the Subversion changeset on
suite copy.

[#1616](https://github.com/metomi/rose/pull/1616):
rose host-select: fix incorrect threshold logic introduced by
[#1588](https://github.com/metomi/rose/pull/1588).

[#1613](https://github.com/metomi/rose/pull/1613):
rosie go: display URLs of data sources.

[#1612](https://github.com/metomi/rose/pull/1612):
rose bush: page navigation always visible at the bottom of the window.

[#1611](https://github.com/metomi/rose/pull/1611):
rose.env.env_export: only report for 1st time and on change. This fixes, e.g.
`rose task-run` reporting `export PATH=...` twice.

--------------------------------------------------------------------------------

## 2015.04.1 (2015-04-28)

Rose release 26, bug fix 1. This release works best with
[cylc-6.4.0](https://github.com/cylc/cylc/releases/tag/6.4.0) and beyond.

### Bug Fixes

[#1605](https://github.com/metomi/rose/pull/1605):
rose config-edit: remove an obsolete import that was causing the program to
fail.

--------------------------------------------------------------------------------

## 2015.04.0 (2015-04-27)

Rose release 26. This release works best with
[cylc-6.4.0](https://github.com/cylc/cylc/releases/tag/6.4.0) and beyond.

### Suite Run Time Location Changes

[#1571](https://github.com/metomi/rose/pull/1571):
rose suite-run, rose suite-clean, rose-task-env, rose task-run:
* The `rose suite-run` command will now create the `share/cycle/` sub-directory
  of a suite. (The `rose suite-clean` command will do the reverse.)
* Commands such as `rose task-env` and `rose task-run` will now export
  `ROSE_DATAC` (and friends) to point to cycle point directories under the
  `share/cycle/` directory.
  E.g. If current cycle point is `20150430T0000Z`, `ROSE_DATAC` will become
  `$HOME/cylc-run/my-suite/share/cycle/20150430T0000Z`.
* The root of the real location of the `share/`, `share/cycle/`, and `work/`
  sub-directory of a suite can now be configured using the settings
  `root-dir{share}`, `root-dir{share/cycle}` and `root-dir{work}` in the
  `rose-suite.conf` file, or under the `[rose-suite-run]` section in the
  site/user configuration file. The `root-dir-share` and `root-dir-work`
  settings are deprecated and are equivalent to `root-dir{share}` and
  `root-dir{work}` respectively.
* The setting `root-dir{share/cycle}=HOST=share/data` can be used to provide
  backward compatibility for the location of `ROSE_DATAC`, if required. This
  setting will ensure that the `share/cycle/` directory is created as a
  symbolic link to the `share/data/` directory.

This change allows shared cycling data to be placed in a different file system
than shared non-cycling data. E.g. Shared cycling data are typically larger and
more regularly house-kept, and so are more suitable for a large file system
with a short retention period. On the other hand, shared non-cycling data will
typically be used by tasks throughout the life time of the suite, and so are
more suitable for a file system with a long or permanent retention period.

[#1593](https://github.com/metomi/rose/pull/1593):
rose_prune: can now prune any item with a cycle point in its path name.
* New `prune{ITEM}=CYCLE[:GLOBS] ...` setting allow prune of items under any
  sub-directories. The `prune-work-at` and `prune-datac-at` settings are
  deprecated and are equivalent to `prune{work}` and `prune{share/cycle}`
  respectively.
* Cycle points can now be date-time points or offsets of the current cycle
  point.
* Each glob in the GLOBS string can now contain a `%(cycle)s` substitution.
  When a glob is specified like so, the program will not add the cycle under
  `ITEM` as a sub-directory, but will substitute `%(cycle)s` in the glob with
  the cycle.
* The application will now fail if a cycle point in the configuration has a bad
  syntax.

### Highlighted Changes

[#1591](https://github.com/metomi/rose/pull/1591):
rose config-diff: new command to display the difference between 2 Rose
configuration files with annotated metadata.

### Noteworthy Changes

[#1602](https://github.com/metomi/rose/pull/1602):
rose macro: fail if uppercase namelist options are added.

[#1601](https://github.com/metomi/rose/pull/1601):
rosie go: create new suite: if multiple data sources are specified, display
dialog box for user to select a prefix from the prefixes associated with the
selected data sources; if a single data source is specified, automatically
select the prefix associated with the specified data source.

[#1600](https://github.com/metomi/rose/pull/1600):
rose bush: view: will now link to related job logs when viewing a job log file.

[#1594](https://github.com/metomi/rose/pull/1594):
rose suite-run: allow suite `bar` when suite `foo-bar` is also running.

[#1597](https://github.com/metomi/rose/pull/1597),
[#1592](https://github.com/metomi/rose/pull/1592):
Rosie Clients will now attempt to use gpg-agent before GnomeKeyring by default.
If this is not desirable, you can add the setting
`prefix-password-store.PREFIX=gnomekeyring` (where `PREFIX` is the prefix of a
Rosie web service that requires authentication by password) under the
`[rosie-id]` section of the site/user configuration file.

[#1590](https://github.com/metomi/rose/pull/1590):
rose suite-hook: `--shutdown` even if `--mail` fails

[#1589](https://github.com/metomi/rose/pull/1589):
rosie id: now accepts `~/cylc-run/SUITE/` as an argument.

[#1588](https://github.com/metomi/rose/pull/1588):
rose host-select: reinstate timeout for SSH commands - kill SSH commands if
they take too long to run - useful for catching situations not caught by the
`-oConnectTimeout=SECS` option. Improve random and no threshold selection
logic - run SSH commands in serial to reduce loads to the system.

[#1586](https://github.com/metomi/rose/pull/1586):
rose_ana: allow ignoring tasks.

[#1584](https://github.com/metomi/rose/pull/1584):
rose bush: now correctly returns HTTP 403 or 404 for relevant items.

[#1581](https://github.com/metomi/rose/pull/1581):
rosie go: rephrase *view all revisions* to *search all revisions*.

[#1580](https://github.com/metomi/rose/pull/1580):
rosa db-create: will no longer run `post-commit` hooks with unnecessary
notification.

[#1579](https://github.com/metomi/rose/pull/1579):
rose bush: jobs: Only hide the *Display Options* form if all options are set as
defaults.

[#1574](https://github.com/metomi/rose/pull/1574):
rose_ana: improve output and fix test on wallclock time.

[#1568](https://github.com/metomi/rose/pull/1568):
rose config-edit: better handling of file source. The page is now a normal page
with a special source value widget.

--------------------------------------------------------------------------------

## 2015.03.0 (2015-03-26)

Rose release 25. This release works best with
[cylc-6.3.1](https://github.com/cylc/cylc/releases/tag/6.3.1).

### Highlighted Changes

[#1541](https://github.com/metomi/rose/pull/1541):
rose suite-restart: the command is no longer an alias of
`rose suite-run --restart`. It now restarts a shutdown suite from its last
known state without reinstalling it.

### Noteworthy Changes

[#1565](https://github.com/metomi/rose/pull/1565):
rose suite-run --restart: export `CYLC_VERSION` to match that of the original
suite run.

[#1563](https://github.com/metomi/rose/pull/1563):
rose metadata: remove escape characters for `values`, `value-titles` and
`value-hints`.

[#1562](https://github.com/metomi/rose/pull/1562):
rosa svn-pre-commit: now prevents suite copy with bad owner.

[#1561](https://github.com/metomi/rose/pull/1561):
rose config-edit: improve handling of bad macro imports from metadata.

[#1560](https://github.com/metomi/rose/pull/1560):
rose config-edit: fix blank name-space for a trailing slash section.

[#1557](https://github.com/metomi/rose/pull/1557):
rose config-edit: improve page display.

[#1555](https://github.com/metomi/rose/pull/1555):
rose app-upgrade: allow upgrade category packages to avoid module name
conflicts.

[#1553](https://github.com/metomi/rose/pull/1553):
rose app-run: poll delays can now be specified as ISO8601 durations.

[#1550](https://github.com/metomi/rose/pull/1550):
rose app-upgrade: fix check for existing indexed variable.

[#1548](https://github.com/metomi/rose/pull/1548):
rose config-edit: fix incorrect added-section description.

[#1542](https://github.com/metomi/rose/pull/1542):
rose config-edit: now report errors from *metadata-graph*.

--------------------------------------------------------------------------------

## 2015.02.0 (2015-02-11)

Rose release 24. This release works best with
[cylc-6.1.2](https://github.com/cylc/cylc/releases/tag/6.1.2) and
[cylc-6.3.1](https://github.com/cylc/cylc/releases/tag/6.3.1).

### Noteworthy Changes

[#1537](https://github.com/metomi/rose/pull/1537):
rose config-edit: fix variable menu when it has a macro warning.

[#1535](https://github.com/metomi/rose/pull/1535):
rose_prune: prune command now uses `bash -O extglob`, which means that glob
patterns can now be any extended globs supported by `bash`.

[#1532](https://github.com/metomi/rose/pull/1532):
rosie go: fix suite ID pop up menu web browser menu item. The menu item is now
enabled only if a web URL is available for browsing the suite.

[#1530](https://github.com/metomi/rose/pull/1530):
rose app-run: file installation: correctly handle exception associated with the
source.

[#1529](https://github.com/metomi/rose/pull/1529):
rose_prune: added configuration metadata for server log pruning setting.

[#1522](https://github.com/metomi/rose/pull/1522):
rose bash completion: fix use of `getent` for user names.

[#1516](https://github.com/metomi/rose/pull/1516):
rosie create: improve prompt.

[#1513](https://github.com/metomi/rose/pull/1513):
Rosie web service clients: gracefully handle the `Cancel` key press event when
user is prompted for a password for a prefix. The client will now report the
event, but continue with other prefixes.

[#1511](https://github.com/metomi/rose/pull/1511):
rose stem: the command now works under the `rose-stem/` sub-directory of a
working copy of a branch.

[#1504](https://github.com/metomi/rose/pull/1504):
rose app-run, rose suite-run, rose task-run: the commands in `-v` mode now
report the loading of the run configuration, any optional keys, and/or CLI
defined `key=value` pairs.

--------------------------------------------------------------------------------

## 2015.01.0 (2015-01-07)

Rose release 23. This release works best with
[cylc-6.1.2](https://github.com/cylc/cylc/releases/tag/6.1.2).

### Noteworthy Changes

[#1496](https://github.com/metomi/rose/pull/1496):
rose_prune: new setting for pruning logs and log archives on the suite host.

[#1494](https://github.com/metomi/rose/pull/1494):
rose config-edit: allow choices to be edited in a choice widget.

[#1493](https://github.com/metomi/rose/pull/1493):
rosie go: fix `File -> New Suite`.

[#1486](https://github.com/metomi/rose/pull/1486):
rosie ls: send `all_revs=1` to the web service server instead of
`all_revs=True`.

--------------------------------------------------------------------------------

## 2014.12.0 (2014-12-08)

Rose release 22. This release works best with
[cylc-6.1.2](https://github.com/cylc/cylc/releases/tag/6.1.2).

### Noteworthy Changes

[#1484](https://github.com/metomi/rose/pull/1484):
rosie.ws_client_auth: when saving the user name for a web service, create
the `~/.metomi/rose.conf` file if it does not already exist.

[#1482](https://github.com/metomi/rose/pull/1482):
rose_arch: fix duplicated archive STDOUT print out.

[#1481](https://github.com/metomi/rose/pull/1481):
rose stem: fix logic to ascertain name of a suite when the current working
directory is not a Subversion working copy.

[#1480](https://github.com/metomi/rose/pull/1480):
rose suite-clean, rose-suite-run, etc: improve `pgrep` `cylc run` pattern for
detecting whether a suite is still running or not. The old pattern was stopping
`foo` from starting if `foo-bar` was running.

--------------------------------------------------------------------------------

## 2014.11.1 (2014-11-26)

Rose release 21. This release works best with
[cylc-6.1.0](https://github.com/cylc/cylc/releases/tag/6.1.0).

### Highlighted Changes

[#1464](https://github.com/metomi/rose/pull/1464):
rosie go, rosie lookup, rosie ls: support caching of credentials using a
`gpg-agent` session.

### Noteworthy Changes

[#1473](https://github.com/metomi/rose/pull/1473):
file install: improve error message when no `source` is specified for
`mode=symlink`.

[#1471](https://github.com/metomi/rose/pull/1471),
[#1472](https://github.com/metomi/rose/pull/1472):
rosa svn-post-commit: now support configurable notification on trunk commits.

[#1463](https://github.com/metomi/rose/pull/1463):
rose date: fix `--calendar=365day|366day` option.
The option arguments were documented but not implemented.

[#1461](https://github.com/metomi/rose/pull/1461):
rose stem: add `MIRROR` Jinja2 variable.

[#1460](https://github.com/metomi/rose/pull/1460):
rosie create: the default `access-list` is now configurable for each prefix on
the client side. If a default is not configured, the client will not set
`access-list` by default.

[#1458](https://github.com/metomi/rose/pull/1458):
rose metadata: `value-hints` new setting that can support suggested values for
a variable, but still allows the user to provide their own override.

[#1456](https://github.com/metomi/rose/pull/1456):
rose metadata: fix the default behaviour when triggering from a value with
environment variable substitution syntax.

--------------------------------------------------------------------------------

## 2014.11.0 (2014-11-05)

Rose release 20. This release works best with
[cylc-6.1.0](https://github.com/cylc/cylc/releases/tag/6.1.0).

### New Package Requirements

* This release adds the requirement for a pickle-safe version of python-requests.
  (We have tested with version 2.2.1.)

### Highlighted Changes

[#1395](https://github.com/metomi/rose/pull/1395),
[#1438](https://github.com/metomi/rose/pull/1438):
rosie.ws\_client: support multiple sources.
* This change requires a pickle-safe version of
  [python-requests](http://docs.python-requests.org/en/latest/).
  (We have tested with version 2.2.1.)
* Rosie discovery service clients `rosie go`, `rosie lookup` and `rosie ls`
  will automatically work with all `[rosie-id]prefix-ws.*` services in
  site/user configuration. The `[rosie-id]prefixes-ws-default` setting can
  be used to restrict the default to use a sub-set of the services.
* The `--prefix=PREFIX` option for `rosie go`, `rosie lookup` and `rosie ls`
  can now be specified multiple times. The lookup mode is rationalised into a
  single option, with aliases.
* `rosie go` updated to allow users to select any data source combination.

### Noteworthy Changes

[#1453](https://github.com/metomi/rose/pull/1453):
Rose training materials: Rose User Guide: Suites divided up to facilitate training
delivery.

[#1447](https://github.com/metomi/rose/pull/1447):
Rose Bush: file view: navigation menu now links to top level suite files.

[#1442](https://github.com/metomi/rose/pull/1442):
rosie web: fix `all revisions` checkbox. It was sending `all_revs=on` to the
server instead of `all_revs=1`.

[#1441](https://github.com/metomi/rose/pull/1441):
rose app-run: poll: globs can now be specified in `any-files` and `all-files`.

[#1439](https://github.com/metomi/rose/pull/1439):
rose suite-scan: take advantage of new functionality of `cylc scan` multiple
host support.

[#1437](https://github.com/metomi/rose/pull/1437),
[#1446](https://github.com/metomi/rose/pull/1446),
[#1449](https://github.com/metomi/rose/pull/1449):
rose task-env, rose\_prune and Rose Bush: now support integer cycling.

[#1436](https://github.com/metomi/rose/pull/1436):
rose config-edit and rose macro: improve error message on `fail-if` syntax
error.

[#1435](https://github.com/metomi/rose/pull/1435):
rose config-edit: fix copy-and-paste large amount of text into a spaced list
widget now works correctly.

[#1434](https://github.com/metomi/rose/pull/1434):
rose app-upgrade: allow users to upgrade to non-named version without using the
`--all-versions` option.

[#1433](https://github.com/metomi/rose/pull/1433):
rose config-edit: fix choices widget empty error.

[#1432](https://github.com/metomi/rose/pull/1432):
rose config-edit: fix derived type array in column page.

[#1431](https://github.com/metomi/rose/pull/1431):
rose config-edit: fix preview app metadata refresh.

[#1430](https://github.com/metomi/rose/pull/1430):
rose config-edit: fix spaced widget bug. The problem was misuse of the
`last_value` property across all array widgets, which happened to work as it
was always set to the actual current value, except in the spaced\_list widget.

[#1428](https://github.com/metomi/rose/pull/1428):
rose\_arch: improve documentation.

--------------------------------------------------------------------------------

## 2014.10.0 (2014-10-02)

19th release of Rose. This release works best with
[Cylc](https://github.com/cylc/cylc/) 6.0.1.

### Highlighted Changes

[#1415](https://github.com/metomi/rose/pull/1415):
Support configuration metadata inheritance. A configuration metadata can now
import settings from other configuration metadata locations.

### Noteworthy Changes

[#1427](https://github.com/metomi/rose/pull/1427):
isodatetime: update to release 2014.10.0.

[#1423](https://github.com/metomi/rose/pull/1423):
rose date: don't display unecessary float in a duration format.

[#1422](https://github.com/metomi/rose/pull/1422):
rose suite-\* commands: improve the pattern used in `pgrep` to detect whether
a suite is still running or not.

[#1421](https://github.com/metomi/rose/pull/1421):
rose bush: fix job log links for suites on `+` time zones. The `+` sign in
the time zone is now escaped for URLs.

[#1416](https://github.com/metomi/rose/pull/1416):
file install: notify skipped file installs in verbose mode.

[#1409](https://github.com/metomi/rose/pull/1409):
rosie db: fix lookup failure when the results contain a suite with no optional
information properties.

[#1408](https://github.com/metomi/rose/pull/1408):
SSH `-oConnectTimeout=10` as default. This should fix any hang up problems when
hosts not available. The `[rose-host-select]timeout` setting in site/user
configuration is removed. SSH connection timeout should be configured as part
of the `[external]ssh` setting.

[#1407](https://github.com/metomi/rose/pull/1407):
rosa svn-post-commit: fix owner and access-list notification. It should only
send notification on changes on a trunk and should no longer send notification
on changes on a branch.

[#1406](https://github.com/metomi/rose/pull/1406):
rose config-edit: UM stash widget: stash record help input change.

[#1403](https://github.com/metomi/rose/pull/1403):
file install: rsync: fix sub-dir handling. File install rsync mode was failing
if source is a directory with sub-directories. This change fixes the problem by
removing an incorrect integer cast of the access mode.

[#1391](https://github.com/metomi/rose/pull/1391):
rose suite-hook, rose bush: no longer record job script, job standard out
and job standard error in any special way. This will modify slightly the display
of job file links in Rose Bush jobs listing.

--------------------------------------------------------------------------------

## 2014-09.0 (2014-09-10)

18th release of Rose. This release works best with
[Cylc](https://github.com/cylc/cylc/) 6.0.0.

### Highlighted Changes

[#1323](https://github.com/metomi/rose/pull/1323),
[#1365](https://github.com/metomi/rose/pull/1365),
[#1369](https://github.com/metomi/rose/pull/1369),
[#1372](https://github.com/metomi/rose/pull/1372),
[#1374](https://github.com/metomi/rose/pull/1374),
[#1378](https://github.com/metomi/rose/pull/1378):
* Handle new runtime database states.
* Improve reporting of running cylc suite processes.
* Handle `log/job/` and `work/` directory restructure.
  N.B. This change is **NOT backward compatible**.  Existing suites with
  applications that assume the old directory structure will not work
  correctly, and will require some minor modifications. See
  [cylc/cylc#1069](https://github.com/cylc/cylc/pull/1069) for detail.
* Rephrase *cycle time* to *cycle point* for cylc 6.
* Rose Bush updated to work correctly with cylc 6.

[#1371](https://github.com/metomi/rose/pull/1371):
rose suite-clean: new `--only=GLOBS` option to restrict items to be cleaned.

[#1316](https://github.com/metomi/rose/pull/1316),
[#1332](https://github.com/metomi/rose/pull/1332),
[#1367](https://github.com/metomi/rose/pull/1367):
[#1390](https://github.com/metomi/rose/pull/1390):
rose date: new usage to print the duration between 2 date time points.
* [isodatetime](https://github.com/metomi/isodatetime/) upgraded to
  2014.08.0-8-ga7f42b1.

[#1352](https://github.com/metomi/rose/pull/1352),
[#1283](https://github.com/metomi/rose/pull/1283):
rosie go, rosie lookup, rosie ls, etc: will now attempt to use
[Gnome Keyring](https://wiki.gnome.org/GnomeKeyring) to store passwords for
Rosie web services that require authentication.

### Noteworthy Changes

[#1400](https://github.com/metomi/rose/pull/1400):
rose stem: now requires a specific version number in `rose-suite.conf`.

[#1399](https://github.com/metomi/rose/pull/1399):
rosie go: fix incorrect hover tooltip following a checkout.

[#1398](https://github.com/metomi/rose/pull/1398):
rose_ana: fix an issue where it incorrectly thinks that files in the app's file
directory are tests.

[#1397](https://github.com/metomi/rose/pull/1397):
Bracket syntax to allow optional configuration keys to point to missing
optional configuration files.

[#1396](https://github.com/metomi/rose/pull/1396):
Fix `rose help suite-restart`.

[#1387](https://github.com/metomi/rose/pull/1387):
rose.upgrade: new `rename_setting` function.

[#1384](https://github.com/metomi/rose/pull/1384):
rose config-edit: fix macro running after metadata refresh.

[#1383](https://github.com/metomi/rose/pull/1383):
rose config-edit: stash: fix null profile lookup.

[#1381](https://github.com/metomi/rose/pull/1381):
rose config-edit: fix macro report handling for null or generic settings.

[#1370](https://github.com/metomi/rose/pull/1370):
rose bush cycles: print each cycle's last activity.

[#1368](https://github.com/metomi/rose/pull/1368):
rose metadata: fail-if/warn-if: now work for duplicate sections.

[#1366](https://github.com/metomi/rose/pull/1366):
rose config-edit: handle custom keyword arguments in upgrade macros.

[#1364](https://github.com/metomi/rose/pull/1364):
rosie go: address bar now support HTTPS protocol correctly.

[#1362](https://github.com/metomi/rose/pull/1362):
rose bush: support server side configurations for:
* cycles list: cycles per page.
* jobs list: jobs per page, maximum jobs per page.
* file view: maximum renderable file size.

[#1361](https://github.com/metomi/rose/pull/1361):
rose config-edit: improve `sort-key` logic.

[#1360](https://github.com/metomi/rose/pull/1360):
Run time file install: incremental install handles file access mode changes
correctly.

[#1359](https://github.com/metomi/rose/pull/1359):
rose.config: the open and close square brace characters can no longer be used
in section names.

[#1356](https://github.com/metomi/rose/pull/1356):
rose app-upgrade: report import errors from `versions.py` files.

[#1354](https://github.com/metomi/rose/pull/1354):
rose bush: suites list: long strings in column 1 now truncated, but visible on
hover over.

[#1351](https://github.com/metomi/rose/pull/1351):
rose metadata: recognise `.` in id.

[#1342](https://github.com/metomi/rose/pull/1342):
rosie go: fix appearance of new suite in local suites.

[#1339](https://github.com/metomi/rose/pull/1339):
rose config-edit, rosie go: no jumping focus on valuewidget errors.

[#1338](https://github.com/metomi/rose/pull/1338):
rosie go: improve new suite wizard behaviour.

[#1336](https://github.com/metomi/rose/pull/1336):
rose suite-run: ensure that run directory is only initialised in run mode.

[#1335](https://github.com/metomi/rose/pull/1335):
rose config-edit: fix warning on empty namespace/pages.

[#1327](https://github.com/metomi/rose/pull/1327):
rose app-upgrade: better output macro name.

[#1325](https://github.com/metomi/rose/pull/1325):
rosie copy: print full source ID in logs and suite info.

[#1320](https://github.com/metomi/rose/pull/1320):
rose config-edit, rose macro: check id usage in `fail-if`, `warn-if`.

[#1317](https://github.com/metomi/rose/pull/1317):
rose stem: configurable autmatic options.

[#1306](https://github.com/metomi/rose/pull/1306):
rose app-upgrade: better error message for upgrade to same version.

--------------------------------------------------------------------------------

## 2014.06.1 (2014-06-20)

This release of Rose works best with
[Cylc](https://github.com/cylc/cylc/) 5.4.14 and 6.0.0alpha1.

### Highlighted Changes

[#1302](https://github.com/metomi/rose/pull/1302),
[#1299](https://github.com/metomi/rose/pull/1299),
[#1297](https://github.com/metomi/rose/pull/1297),
[#1291](https://github.com/metomi/rose/pull/1291):
rose date and rose task-env: support different cycling modes in Cylc.
In particular, support 360-day calendar as well as the Gregorian calendar.

### Noteworthy Changes

[#1296](https://github.com/metomi/rose/pull/1296):
rose metadata: fix check value for ignored sections' options.

[#1295](https://github.com/metomi/rose/pull/1295):
rose config-edit: fix triggering into duplicate namelists.

--------------------------------------------------------------------------------

## 2014.06.0 (2014-06-11)

This release of Rose works best with
[Cylc](https://github.com/cylc/cylc/) 5.4.14.

### Highlighted Changes

[#1271](https://github.com/metomi/rose/pull/1271):
rose task-env, rose\_prune: support ISO 8601 syntax.

### Noteworthy Changes

[#1282](https://github.com/metomi/rose/pull/1282):
rose app-run, suite-run, task-run: allow file install targets to overlap.

[#1281](https://github.com/metomi/rose/pull/1281):
rose suite-run (gtk): fix RuntimeError for Queues.

[#1279](https://github.com/metomi/rose/pull/1279):
rose suite-run: fix failure when source `suite.rc` not writable.

[#1278](https://github.com/metomi/rose/pull/1278):
rosa svn-\*-commit: verify and notify owners and users on access-list.
* rosa svn-pre-commit: verify users in owner and access-list,
  and improve diagnostics.
* rosa svn-post-commit: notify users in owner and access-list on changes.
* Site and user configuration `[rosa-svn-pre-commit]` section is renamed
  `[rosa-svn]`.

[#1277](https://github.com/metomi/rose/pull/1277):
rose config-edit: speed up slow loading-up code.

[#1275](https://github.com/metomi/rose/pull/1275):
rose config-edit: tweaks the default page expansion for a single app session.

[#1272](https://github.com/metomi/rose/pull/1272):
rose config-edit: fix user-ignoring duplicate section.

[#1264](https://github.com/metomi/rose/pull/1264):
rose bush: encode cycle time in URL.

[#1261](https://github.com/metomi/rose/pull/1261):
rose config-edit: tweak latent page display.

--------------------------------------------------------------------------------

## 2014-05 (2014-05-30)

This release of Rose works best with
[Cylc](https://github.com/cylc/cylc/) 5.4.12 and 5.4.13.

### Highlighted Changes

-none-

### Noteworthy Changes

[#1274](https://github.com/metomi/rose/pull/1274):
rose config-edit: fix right clicking on group in STASH widget.

[#1259](https://github.com/metomi/rose/pull/1259):
rose config-edit: fix launching of external utilities.

[#1256](https://github.com/metomi/rose/pull/1256):
rose\_prune: work directory: support glob by task name.

[#1252](https://github.com/metomi/rose/pull/1252):
rose env-cat: new `--match-mode=brace` option to only perform
substitution on `${NAME}` syntax.

[#1249](https://github.com/metomi/rose/pull/1249):
rose suite-run/clean: improve diagnostics if a suite is still running.

[#1244](https://github.com/metomi/rose/pull/1244):
rose: ensure Rose's `bin/`, `lib/python/` lead `PATH`, `PYTHONPATH`.

[#1243](https://github.com/metomi/rose/pull/1243),
[#1260](https://github.com/metomi/rose/pull/1260):
rose suite-run: file install and reload improvements.
* Improve incremental file install.
* On reload mode, call `cylc reload` only if necessary.

[#1237](https://github.com/metomi/rose/pull/1237):
Rose Bush: display if job log db present.

--------------------------------------------------------------------------------

## 2014-04 (2014-04-28)

This release of Rose works best with
[Cylc](https://github.com/cylc/cylc/) 5.4.12.

### Known Issues

Unfortunately, `rose date` relies on a version of the
[isodatetime](https://github.com/metomi/isodatetime/) library that is
compatible with the version shipped with this release of Rose. The library
that is shipped with Cylc 5.4.12 is an earlier version. When used in combination
in the same environment, `rose date` will return an exception. A fix has been
introduced in [#1244](https://github.com/metomi/rose/pull/1244) for the next
release, which will ensure that Rose always picks up its own version of the
library.

### Highlighted Changes

[#1202](https://github.com/metomi/rose/pull/1202),
[#1219](https://github.com/metomi/rose/pull/1219):
rose date: logic reimplemented using the new
[isodatetime](https://github.com/metomi/isodatetime/) library. Date time and
offset formats can now be specified using ISO 8601 syntax. The command will
also support pre-historic and futuristic date time. This change also fixes
the `-u` option. When using the current system date/time, the default output
format has changed to be ISO 8601 compatible (it follows
`CCYY-MM-DDThh:mm:ss±hh:mm`).

[#1195](https://github.com/metomi/rose/pull/1195),
[#1199](https://github.com/metomi/rose/pull/1199):
rose metadata: add spaced list type.

[#1191](https://github.com/metomi/rose/pull/1191),
[#1193](https://github.com/metomi/rose/pull/1193),
[#1212](https://github.com/metomi/rose/pull/1212):
rose metadata-graph: new command using Graphviz for
plotting metadata dependencies such as trigger.

### Noteworthy Changes

[#1228](https://github.com/metomi/rose/pull/1228):
rose suite-log --update --prune-remote: option now recognised as
documented.

[#1225](https://github.com/metomi/rose/pull/1225):
rose app/suite/task-run: file installation: ensure that all relevant
tables exist in the file installation configuration SQLite database file.

[#1209](https://github.com/metomi/rose/pull/1209):
rose suite-hook: use configured email host in email addresses without
hosts.

[#1208](https://github.com/metomi/rose/pull/1208):
rose config-edit: fix STASH widget starting from empty.

[#1206](https://github.com/metomi/rose/pull/1206):
rose config-dump: don't down case for namelist group name. This change
partially reversed [#1149](https://github.com/metomi/rose/pull/1149).

[#1200](https://github.com/metomi/rose/pull/1200):
rose app-upgrade: fix HEAD broken macro pathway.

[#1198](https://github.com/metomi/rose/pull/1198):
rose config-edit: run startup checks on loading previewed app(s).

[#1197](https://github.com/metomi/rose/pull/1197):
rose stem: allow comma separated values in `--task=TASKS`
and `--group=GROUPS` options.

[#1196](https://github.com/metomi/rose/pull/1196):
rose metadata: fail-if: handle divide by zero exceptions.

[#1194](https://github.com/metomi/rose/pull/1194):
rose\_ana: cumf: include cumf output path in output.

[#1190](https://github.com/metomi/rose/pull/1190):
rosie lookup: allow override of quiet mode print format.

[#1187](https://github.com/metomi/rose/pull/1187):
rose config-dump: fix tidying metadata.

[#1186](https://github.com/metomi/rose/pull/1186):
rose app-upgrade, rose macro: fix relative `--config=DIR`.

[#1184](https://github.com/metomi/rose/pull/1184):
rose config-edit: fix change `meta` or `project` flag.

--------------------------------------------------------------------------------

## 2014-03 (2014-03-19)

This release of Rose works best with Cylc 5.4.11.

### Highlighted Changes

[#1163](https://github.com/metomi/rose/pull/1163):
rose metadata: a `compulsory=true` option no longer requires its
containing section to be compulsory as well.

### Noteworthy Changes

[#1181](https://github.com/metomi/rose/pull/1181):
rose stem: fix `-C rel/path` usage.

[#1180](https://github.com/metomi/rose/pull/1180):
rose suite-scan: scan port files as well. Report left behind port
files. Report exceptions for failed `cylc scan` and `ssh` commands.

[#1177](https://github.com/metomi/rose/pull/1177):
rose suite-clean: accept `--name=NAME`. If specified, `NAME` is
appended to the end of the argument list. This allows the interface to be
consistent with the other utilities.

[#1173](https://github.com/metomi/rose/pull/1173):
rose app/suite/task-run: handle bad file install mode value.
Previously, the system will assume the `auto` mode if it is given a bad file
install mode value. It will now fail.

[#1171](https://github.com/metomi/rose/pull/1171):
rose\_ana: print number of values compared.

[#1169](https://github.com/metomi/rose/pull/1169):
rose stem: improve robustness of keyword match.

[#1167](https://github.com/metomi/rose/pull/1167):
rose config-edit: fix general checking for `rose-suite.info` suites.

[#1161](https://github.com/metomi/rose/pull/1161):
rose app-upgrade, rose macro: fix current working directory.

[#1159](https://github.com/metomi/rose/pull/1159):
rose\_ana: cumf: read output by lines to reduce memory footprint.

[#1157](https://github.com/metomi/rose/pull/1157):
rose suite-hook --mail: configurable SMTP host.

[#1156](https://github.com/metomi/rose/pull/1156):
rose stem: ensure `_BASE` variables are working copy tops.

[#1153](https://github.com/metomi/rose/pull/1153):
rose config: fix printing sections with ignored values.

[#1151](https://github.com/metomi/rose/pull/1151):
rose config-edit, rosie go: fix toolbar GTK warning. This problem was
discovered on an upgrade from GTK 2.18 to GTK 2.20.

[#1149](https://github.com/metomi/rose/pull/1149):
rose config-dump: down cases namelist keys.

[#1147](https://github.com/metomi/rose/pull/1147):
rose suite-run --reload: fix `!CYLC_VERSION` problem.

[#1146](https://github.com/metomi/rose/pull/1146):
rose config-edit: improve specific macro messages.

[#1145](https://github.com/metomi/rose/pull/1145):
rose metadata: fix null first values entry.

--------------------------------------------------------------------------------

## 2014-02 (2014-02-21)

This release of Rose works best with Cylc 5.4.8.

### Highlighted Changes

-none-

### Noteworthy Changes

[#1141](https://github.com/metomi/rose/pull/1141):
rose config-edit: count latent section errors.

[#1140](https://github.com/metomi/rose/pull/1140):
rose config-edit, rosie go: filter all warnings by default.

[#1136](https://github.com/metomi/rose/pull/1136):
rose config --meta: fix finding non-local metadata.

[#1132](https://github.com/metomi/rose/pull/1132):
rose app-upgrade: fix post-upgrade trigger metadata.

[#1131](https://github.com/metomi/rose/pull/1131):
rosie create: obtain user name from `~/.subversion/servers`, where
relevant.

[#1130](https://github.com/metomi/rose/pull/1130):
Rose Bush: cycles: add paging function. Display 100 cycles per page.

[#1127](https://github.com/metomi/rose/pull/1127):
Rose Bush: jobs: fix pager form to ensure that sort order is maintained.

[#1121](https://github.com/metomi/rose/pull/1121):
rose stem: create `_REV` and `_BASE` variables for all projects.

[#1119](https://github.com/metomi/rose/pull/1119):
rose config-edit: fix python list widget.

[#1117](https://github.com/metomi/rose/pull/1117):
rose config-edit: improve performance by reducing updates to the
internal data structure.

[#1114](https://github.com/metomi/rose/pull/1114):
rose config-edit: run a macro or upgrade macro with the relevant
configuration directory as the current working directory.

[#1100](https://github.com/metomi/rose/pull/1100),
[#1101](https://github.com/metomi/rose/pull/1101):
add syntax highlighting for Rose configuration file in Emacs.

[#1097](https://github.com/metomi/rose/pull/1097):
rosie.ws: fix Trac links in `all_revs` mode, which incorrectly used
`trunk@HEAD` for everything.

[#1094](https://github.com/metomi/rose/pull/1094):
rosie lookup: fix `%date` in custom format.

--------------------------------------------------------------------------------

## 2014-01-22 (2014-01-22)

This release of Rose works best with Cylc 5.4.4 to 5.4.7.

### Highlighted Changes

-none-

### Noteworthy Changes

[#1095](https://github.com/metomi/rose/pull/1095):
rose.config: fix bug introduced by
[#1067](https://github.com/metomi/rose/pull/1067). Use of temporary file to dump
configuration files results in files that are user read-write only. This fix
ensures that files are dumped with the correct permission according to the
umask in the environment.

[#1092](https://github.com/metomi/rose/pull/1092):
rose bush: cycles list: display failed jobs totals, where relevant.

[#1091](https://github.com/metomi/rose/pull/1091):
rose suite-log: no longer require `rose.bush`, which requires
`cherrypy`.

--------------------------------------------------------------------------------

## 2014-01 (2014-01-20)

This release of Rose works best with Cylc 5.4.4 to 5.4.7.

### Highlighted Changes

[#1085](https://github.com/metomi/rose/pull/1085):
rosie web service: the web service database schema has been modified to
improve performance. **This change requires the rosie web service database to
be re-built.** To do so, shut down the web service. Remove (or move) the old
database file(s) and run the `$ROSE_HOME/sbin/rosa db-create` command to
re-build the database.

[#1072](https://github.com/metomi/rose/pull/1072),
[#1084](https://github.com/metomi/rose/pull/1084):
rose bush: cycles summary and other improvements.
* New: Cycles list: list numbers of active, succeeded and failed jobs for
  each cycle time.
* Jobs list: display host, submit method and ID for running jobs.
* Jobs list: clickable cycles and task names.
* Suites list: reduce amount of information displayed for efficiency.

[#1057](https://github.com/metomi/rose/pull/1057):
rose CLI: bash command completion.

### Noteworthy Changes

[#1090](https://github.com/metomi/rose/pull/1090):
rose\_arch: fix None status in event when source-edit fails.

[#1089](https://github.com/metomi/rose/pull/1089):
rose bush: catch unicode decode error in view.

[#1087](https://github.com/metomi/rose/pull/1087):
document how to contribute to Rose.

[#1081](https://github.com/metomi/rose/pull/1081):
rose config-edit: fix file page unexpected content.

[#1068](https://github.com/metomi/rose/pull/1068):
rose bush: recognise the `ready` status.

[#1067](https://github.com/metomi/rose/pull/1067):
rose.config.dump: use temporary file to stage.

[#1065](https://github.com/metomi/rose/pull/1065):
rose-bush.js: fix format string and int rounding.

[#1064](https://github.com/metomi/rose/pull/1064):
rosie go: allow actions on out of date working copies.

[#1058](https://github.com/metomi/rose/pull/1058):
rose config-edit: add macro config vetting.

[#1056](https://github.com/metomi/rose/pull/1056):
rose config-edit: trap upgrade macro errors.

--------------------------------------------------------------------------------

## Older Releases

[Changes in 2013](doc/changes-2013.md)

Rose 2012-11 (Released 2012-11-30) was the 1st release.
