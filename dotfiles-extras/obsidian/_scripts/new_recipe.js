module.exports = async (params) => {
    const { app } = params;

    const recipeName = await params.quickAddApi.inputPrompt("Recipe name");
    if (!recipeName) return;

    const filePath = `Recipes/${recipeName}.md`;

    if (app.vault.getAbstractFileByPath(filePath)) {
        new Notice(`Recipe "${recipeName}" already exists.`);
        return;
    }

    // Create empty file, then apply the Templater template
    const file = await app.vault.create(filePath, "");
    const leaf = app.workspace.getLeaf(false);
    await leaf.openFile(file);

    // Trigger Templater to insert the recipe template
    const templater = app.plugins.plugins["templater-obsidian"];
    if (templater) {
        const templateFile = app.vault.getAbstractFileByPath("templates/recipe.md");
        if (templateFile) {
            await templater.templater.append_template_to_active_file(templateFile);
        }
    }
};
