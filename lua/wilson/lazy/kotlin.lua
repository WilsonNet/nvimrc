return {
	"AlexandrosAlexiou/kotlin.nvim",
	dependencies = {
		"mason.nvim",
		"mason-lspconfig.nvim",
		"oil.nvim",
		"trouble.nvim",
	},
	config = function()
		-- Ensure kotlin-lsp is installed via Mason
		local mason_registry = require("mason-registry")
		if not mason_registry.is_installed("kotlin-lsp") then
			vim.cmd("MasonInstall kotlin-lsp")
		end

		require("kotlin").setup({
			-- Optional: Specify root markers for multi-module projects
			root_markers = {
				"gradlew",
				".git",
				"mvnw",
				"settings.gradle",
				"settings.gradle.kts",
			},

			-- Use bundled JRE from Mason (recommended, zero-dependency)
			jre_path = nil,

			-- Auto-detect JDK for symbol resolution from project
			jdk_for_symbol_resolution = nil,

			-- JVM arguments for the kotlin-lsp server
			jvm_args = {
				"-Xmx4g",
			},

			-- Inlay hints configuration
			inlay_hints = {
				enabled = true,
				parameters = true,
				parameters_compiled = true,
				parameters_excluded = false,
				types_property = true,
				types_variable = true,
				function_return = true,
				function_parameter = true,
				lambda_return = true,
				lambda_receivers_parameters = true,
				value_ranges = true,
				kotlin_time = true,
			},
		})
	end,
}
