return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	{

		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-emoji",
			"windwp/nvim-autopairs",
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local luasnip = require("luasnip")
			local cmp = require("cmp")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			opts.preselect = cmp.PreselectMode.None
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			local tab = function(fallback)
				if cmp.visible() then
					-- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
					-- if cmp.get_selected_entry() then
					cmp.select_next_item()
					-- else
					-- 	cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					-- end
					-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
					-- this way you will only jump inside the snippet region
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end

			local stab = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end

			local complete = function(fallback)
				cmp.confirm({ select = true })
			end
			opts.mapping = vim.tbl_extend("force", opts.mapping, {
				-- ["<cr>"] = cmp.mapping.confirm({ select = true }),
				["<CR>"] = cmp.mapping({
					i = function(fallback)
						if cmp.visible() and cmp.get_active_entry() then
							cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end,
					s = cmp.mapping.confirm({ select = true }),
					c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
				}),
				["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(stab, { "i", "s" }),
				["<C-Space>"] = cmp.mapping(complete, { "i", "s" }),
				["<c-t>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
				["<c-y>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
			})
		end,
	},
}
