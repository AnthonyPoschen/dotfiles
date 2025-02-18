return {
	"saghen/blink.cmp",
	lazy = false, -- lazy loading handled internally
	-- optional: provides snippets for the snippet source
	dependencies = "rafamadriz/friendly-snippets",

	-- use a release tag to download pre-built binaries
	-- version = "v0.7.6",
	version = "*",
	-- branch = "main",
	-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = "cargo build --release",

	--TODO: Discover why having a configuration is bricking terminal completion?
	opts = {
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- see the "default configuration" section below for full documentation on how to define
		-- your own keymap.
		cmdline = {
			-- preset = "super-tab",
			keymap = {
				preset = "super-tab",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			},
		},
		-- keymap = {
		-- 	preset = "enter",
		-- 	["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		-- 	["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		-- 	cmdline = {
		-- 		preset = "super-tab",
		-- 	},
		-- },
		-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- adjusts spacing to ensure icons are aligned
		appearance = {
			nerd_font_variant = "normal",
			use_nvim_cmp_as_default = true,
		},

		-- experimental auto-brackets support
		-- accept = { auto_brackets = { enabled = true } }

		-- experimental signature help support
		-- signature = { enabled = true },
		-- trigger = { signature_help = { enabled = false, show_on_insert_on_trigger_character = false } },
		completion = {
			documentation = {
				auto_show = true, -- default false
				auto_show_delay_ms = 500, -- default 500
			},
			ghost_text = { enabled = true },
		},
		sources = {
			-- disable this because want to :wq without headaches
			-- cmdline = {},
			default = {
				"lsp",
				"path",
				"snippets",
				--'buffer',
			},
		},
	},
}
