// Imports
import * as child_process from 'node:child_process';
import * as util from 'node:util';
import Bun from 'bun';

// Config

// If we aren't running in CI, what should we compare against?
const BASE_BRANCH = 'upstream/main';
// Exclude these directories from being checked
const EXCLUDE_DIRS = ['modular_causticcove/', 'modular_ochrevalley/', 'tgui/'];
// What filetypes to scan
const FILETYPES_TO_SCAN = ['.dm'];
// Regexp for allowed OV Tags
const REGEXP = /ov\s+(?:add|edit|remov(?:e|al))/gim;
// Regexp for header on file we allow as well
const REGEXP_HEADER = /^\/\/\s*ov\s+file/gim;

// Environment setup

// Used in error reporting
const SELF_NAME = 'tools/ov_edit_check/index.ts';
// Look for CHANGED_FILES environment variable set earlier in the action
let CHANGED_FILES = process.env.CHANGED_FILES;
// Check if we're in an action at all.
const GITHUB_ACTION = process.env.GITHUB_ACTION;

// Helpers
const reportError = (file: string, message: string) => {
  if (GITHUB_ACTION) {
    console.log(
      `::error file=${file},title=OV Edit Check::${file}: ${message}`,
    );
  } else {
    console.log(util.styleText('red', `${file}: Error: ${message}`));
  }
};

const reportWarning = (file: string, message: string) => {
  if (GITHUB_ACTION) {
    console.log(
      `::warning file=${file},title=OV Edit Check::${file}: ${message}`,
    );
  } else {
    console.log(util.styleText('yellow', `${file}: Warning: ${message}`));
  }
};

const reportNotice = (file: string, message: string) => {
  if (GITHUB_ACTION) {
    console.log(
      `::notice file=${file},title=OV Edit Check::${file}: ${message}`,
    );
  } else {
    console.log(util.styleText('blue', `${file}: Notice: ${message}`));
  }
};

const runGitCommand = (...args: string[]) => {
  return child_process.spawnSync('git', args, {
    encoding: 'utf8',
    shell: true,
  });
};

// Setup
// Find us files to munch on as best we can
if (!CHANGED_FILES) {
  reportWarning(
    SELF_NAME,
    `No CHANGED_FILES detected, switching to best-effort detection. We will run a git diff against ${BASE_BRANCH}.`,
  );

  const diff = runGitCommand('diff', '--name-only', BASE_BRANCH);
  CHANGED_FILES = diff.stdout.replaceAll(/(\r\n|\n)/, ' ');
}

// I tried so hard and got so far
// But in the end, it doesn't even matter
if (!CHANGED_FILES.match(/\s/)) {
  reportError(
    SELF_NAME,
    'No changed files could be detected even with fallback, linter cannot run.',
  );
  process.exit(1);
}

// Actual script

enum CheckFileResult {
  NoTagsDetected,
  HasOVEdits,
  Skipped,
}

// Runs for each file we find
const checkFile = async (path: string): Promise<CheckFileResult> => {
  // We only care about a few file types
  for (const fileType of FILETYPES_TO_SCAN) {
    if (!path.endsWith(fileType)) {
      return CheckFileResult.Skipped;
    }
  }

  // We only care about files outside of our modular directories
  for (const excludeDir of EXCLUDE_DIRS) {
    if (path.startsWith(excludeDir)) {
      return CheckFileResult.Skipped;
    }
  }

  // Read the file, ignore it if it doesn't exist/is empty
  const file = Bun.file(path);
  if (!file.size) {
    reportWarning(path, 'does not exist/is empty');
    return CheckFileResult.Skipped;
  }

  const contents = await file.text();

  if (!contents.match(REGEXP) && !contents.match(REGEXP_HEADER)) {
    return CheckFileResult.NoTagsDetected;
  } else {
    return CheckFileResult.HasOVEdits;
  }
};

// Main loop
const main = async () => {
  const filesChanged = CHANGED_FILES.split(/\s/);

  reportNotice(SELF_NAME, `${filesChanged.length} files to check`);
  // The weird code with GITHUB_ACTION beyond here is just making it so that in github actions we get
  // a group of all files passed or failed, but locally we only get the failed summary
  if (GITHUB_ACTION) {
    console.log('::group::Files Checked');
  }

  const failed: string[] = [];

  for (const file of filesChanged) {
    // Just in case
    const path = file.trim();
    const fail = await checkFile(path);
    // Store all failed paths for later as a summary
    if (fail === CheckFileResult.NoTagsDetected) {
      failed.push(path);
    }

    // Print verbose data inside the group
    if (GITHUB_ACTION) {
      switch (fail) {
        case CheckFileResult.NoTagsDetected: {
          reportWarning(
            path,
            'Does not contain any OV Tags but is an AP owned file!',
          );
          break;
        }
        case CheckFileResult.HasOVEdits: {
          reportNotice(
            path,
            'Was modified but contains some OV tag. Check for appropriate usage.',
          );
          break;
        }
        case CheckFileResult.Skipped: {
          console.log('Skipped: ', path);
          break;
        }
      }
    }
  }

  if (GITHUB_ACTION) {
    console.log('::endgroup::');
  }

  if (failed.length > 0) {
    reportWarning(SELF_NAME, `Summary: ${failed.length} files failed checks!`);
    for (const path of failed) {
      reportWarning(path, 'failed. See Files Checked for more info.');
    }
  } else {
    reportNotice(SELF_NAME, `Summary: All files passed checks!`);
  }
};

main();
