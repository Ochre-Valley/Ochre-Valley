## About The Pull Request

<!-- Describe your pull request here! Please describe and document all of the changes made in full. It helps maintainers go over everything and ensure that merges will run smoothly if needed, and that nothing is lost as more changes are made in the future! Last edited 1/14/26 by Jon -->

## Developer's checklist
<!--
Just a reminder to keep up the best practices, and to ensure that everyone has an easier time as a result! Please doublecheck that they were done!
-->
- [ ] Try to modularize as much as possible. <!--  Do this by putting stuff in the modular ochre folder, and modifying Azure code by calling your code from the places where you could put the code, for an example-->
- [ ] Mark the start and end of edits outside the ochre modular folder (if applicable) for changes made.
<!--
Do this one like so

Azure
///Ochre edit
Your code
///Ochre edit end
Azure

This makes it easier for maintainers to keep track of what's ours.
-->
- [ ] Ensure that it compiles locally, and test new features (when applicable, please record if not!), or potential issues with related features.

## Testing Evidence

<!-- Please provide evidence of testing features here, when applicable! If it is not, a quick note of this is fine. -->

## Why It's Good For The Game

<!-- What benefits does this bring to our server? How can it help players enjoy themselves more, or help lead players to more scenes? If it wasn't already chatted about over the Discord, feel free to explain your resoning and desire here for the change! Or feel free to add a link to the Discord's Suggestion thread for this change! -->

<!-- By contributing to this codebase, you confirm that any code and sprites you provide are legal to share and will be licensed under the terms specified in README.md — AGPLv3 for code and CC-BY-SA 3.0 for assets, unless otherwise stated. You acknowledge that the project maintainers are under no obligation to remove any materials that do not violate these licenses. -->

## Changelog
<!-- Please fill in any proper tags here that are valid for your PR! This is for the auto-changelog that is generated automatically and shown ingame. -->

<!-- !! Do not add whitespace in-between the entries, do not change the tags and do not leave the tags without any entries. -->

:cl:
add: Added new mechanics or gameplay changes
add: Added more things
del: Removed old things
qol: made something easier to use
balance: rebalanced something
fix: fixed a few things
sound: added/modified/removed audio or sound effects
image: added/modified/removed some icons or images
map: added/modified/removed map content
spellcheck: fixed a few typos
code: changed some code
refactor: refactored some code
config: changed some config setting
admin: messed with admin stuff
server: something server ops should know
/:cl:

<!-- Both :cl:'s are required for the changelog to work! You can put your name to the right of the first :cl: if you want to overwrite your GitHub username as author ingame. -->
<!-- You can use multiple of the same prefix (they're only used for the icon ingame) and delete the unneeded ones. Despite some of the tags, changelogs should generally represent how a player might be affected by the changes rather than a summary of the PR's contents. -->
