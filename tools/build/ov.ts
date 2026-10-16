//! This file has all of OV's specific build stuff, exports are referenced in main
import Juke from './juke/index.js';
import { bunRoot, bunWithCwd } from './lib/bun';

// OV Edit Tag Check
export const bunOvEdit = bunWithCwd('./tools/ov_edit_check');

export const OvBunTarget = new Juke.Target({
  inputs: ['tools/ov_edit_check/package.json'],
  executes: () => {
    return bunOvEdit('install', '--frozen-lockfile', '--ignore-scripts');
  },
});

export const OvEditLintTarget = new Juke.Target({
  dependsOn: [OvBunTarget],
  executes: () => {
    return bunRoot('run', './tools/ov_edit_check/index.ts');
  },
});

// Default Branch
export const OvLintTarget = new Juke.Target({
  dependsOn: [OvEditLintTarget],
});
