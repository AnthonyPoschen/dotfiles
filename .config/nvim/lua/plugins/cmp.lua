return {
	"saghen/blink.cmp",
	lazy = false, -- lazy loading handled internally
	dependencies = "rafamadriz/friendly-snippets",
	version = "*",
	opts = {
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- see the "default configuration" section below for full documentation on how to define
		-- your own keymap.
		keymap = {
			preset = "enter",
		},
		cmdline = {
			completion = {
				menu = {
					auto_show = true,
				},
			},
			keymap = {
				preset = "super-tab",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			},
		},
		appearance = {
			nerd_font_variant = "normal",
			use_nvim_cmp_as_default = true,
		},
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
			ghost_text = { enabled = true },
		},
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
			},
		},
	},
}
