require("hover").setup({
	init = function()
		-- Require providers
		require("hover.providers.lsp")
	end,
	preview_opts = {
		border = nil,
	},
	title = true,
})

-- Setup keymaps
vim.keymap.set("n", "Q", require("hover").hover, { desc = "hover.nvim" })
vim.keymap.set("n", "gQ", require("hover").hover_select, { desc = "hover.nvim (select)" })
