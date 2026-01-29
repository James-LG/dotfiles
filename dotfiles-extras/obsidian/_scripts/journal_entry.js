module.exports = async (params) => {
    const { app } = params;

    // Get the current date
    const now = window.moment();

    // Calculate ISO week number and year
    const weekYear = now.format('GGGG'); // ISO week-numbering year
    const weekNumber = now.format('WW');  // ISO week number (zero-padded)
    const monthName = now.format('MMMM');

    // Format the weekly note filename
    const weeklyNoteFilename = `${weekYear}-W${weekNumber} ${monthName}`;
    const weeklyNotePath = `Journal/${weeklyNoteFilename}.md`;

    // Format the daily heading
    const dayHeading = now.format('dddd MMMM Do');
    const fullDayHeading = `# ${dayHeading}`;

    // Get or create the weekly note
    let weeklyNote = app.vault.getAbstractFileByPath(weeklyNotePath);

    if (!weeklyNote) {
        // Read the template file
        const templatePath = 'templates/journal.md';
        const templateFile = app.vault.getAbstractFileByPath(templatePath);
        let templateContent = '';

        if (templateFile) {
            templateContent = await app.vault.read(templateFile);
        } else {
            // Fallback to hardcoded template if file doesn't exist
            templateContent = `---\ntags:\n  - journal\n---\n`;
        }

        // Create the weekly note with template content
        await app.vault.create(weeklyNotePath, templateContent);
        weeklyNote = app.vault.getAbstractFileByPath(weeklyNotePath);
    }

    // Read the note content
    let content = await app.vault.read(weeklyNote);

    // Check if the heading exists
    const headingRegex = new RegExp(`^${fullDayHeading}$`, 'm');
    const headingExists = headingRegex.test(content);

    if (!headingExists) {
        // Add the heading to the bottom of the file
        if (!content.endsWith('\n')) {
            content += '\n';
        }
        content += `${fullDayHeading}\n\n`;

        await app.vault.modify(weeklyNote, content);
    }

    // Open the weekly note
    const leaf = app.workspace.getLeaf(false);
    await leaf.openFile(weeklyNote);

    // Move cursor to the end of today's section
    // Wait a bit for the file to open
    await new Promise(resolve => setTimeout(resolve, 100));

    const view = app.workspace.getActiveFileView();
    if (view && view.editor) {
        const editor = view.editor;
        const lines = editor.getValue().split('\n');

        // Find the heading line
        let headingLineIndex = -1;
        for (let i = 0; i < lines.length; i++) {
            if (lines[i] === fullDayHeading) {
                headingLineIndex = i;
                break;
            }
        }

        if (headingLineIndex !== -1) {
            // Find the next heading or end of file
            let endLineIndex = lines.length;
            for (let i = headingLineIndex + 1; i < lines.length; i++) {
                if (lines[i].startsWith('# ')) {
                    endLineIndex = i;
                    break;
                }
            }

            // Set cursor at the end of this section (before the next heading or at the end)
            editor.setCursor({ line: endLineIndex, ch: 0 });
        }
    }
};
