'use strict';

const { Plugin, MarkdownView } = require('obsidian');

class VimTableScrollPlugin extends Plugin {
  onload() {
    this.registerDomEvent(document, 'keydown', (e) => this.onKeyDown(e), { capture: true });
  }

  onKeyDown(event) {
    if (!event.ctrlKey || (event.key !== 'u' && event.key !== 'd')) return;

    const view = this.app.workspace.getActiveViewOfType(MarkdownView);
    if (!view) return;

    const cmView = view.editor?.cm;
    if (!cmView || !cmView.dom.contains(event.target)) return;
    if (!this.isVimNormalMode(cmView)) return;

    const direction = event.key === 'd' ? 1 : -1;
    const scrollEl = cmView.scrollDOM;
    const halfHeight = scrollEl.clientHeight / 2;
    const linesToMove = Math.max(1, Math.round(halfHeight / cmView.defaultLineHeight));

    const state = cmView.state;
    const pos = state.selection.main.head;
    const currentLine = state.doc.lineAt(pos);
    const targetLineNum = Math.max(1, Math.min(
      state.doc.lines,
      currentLine.number + direction * linesToMove
    ));
    const targetLine = state.doc.line(targetLineNum);
    const col = pos - currentLine.from;
    const targetPos = Math.min(targetLine.from + col, targetLine.to);

    // Move cursor without triggering CM6's built-in scroll-into-view, which
    // can scroll back to the cursor if the table widget vetoes the selection change.
    cmView.dispatch({ selection: { anchor: targetPos }, scrollIntoView: false });

    // Scroll explicitly so the viewport always moves even if the cursor was
    // clamped (e.g. already at the top/bottom of the document).
    scrollEl.scrollBy({ top: direction * halfHeight });

    // Re-focus the editor contentDOM so vim handles the next keypress.
    // Inside a table cell the DOM focus can stay on the cell, causing j/k to
    // snap the viewport back to the cursor instead of going to vim.
    cmView.contentDOM.focus();

    event.preventDefault();
    event.stopPropagation();
  }

  isVimNormalMode(cmView) {
    const modeEl = document.querySelector('[data-vim-mode]');
    if (modeEl) return modeEl.dataset.vimMode === 'normal';
    for (const val of cmView.state.values) {
      if (val && typeof val.mode === 'string' &&
          (val.mode === 'normal' || val.mode === 'insert' || val.mode === 'visual')) {
        return val.mode === 'normal';
      }
    }
    return false;
  }
}

module.exports = VimTableScrollPlugin;
