return {
	{
		"ramilito/kubectl.nvim",
		config = function()
			require("kubectl").setup()
		end,
		opts = {},
		keys = {
			-- General keys
			{ "dd", "<Plug>(kubectl.kill)", ft = "k8s_*" },
			{ "q", "<Plug>(kubectl.quit)", ft = "k8s_*" },
			-- views
			{ "7", "<Plug>(kubectl.view_nodes)", ft = "k8s_*" },
			{ "8", "<Plug>(kubectl.view_top)", ft = "k8s_*" },
			{ "0", "<Plug>(kubectl.view_overview)", ft = "k8s_*" },
			-- -- Views
			-- k("n", "<Plug>(kubectl.alias_view)", "<C-a>", opts) -- Aliases view
			-- k("n", "<Plug>(kubectl.contexts_view)", "<C-x>", opts) -- Contexts view
			-- k("n", "<Plug>(kubectl.filter_view)", "<C-f>", opts) -- Filter view
			-- k("n", "<Plug>(kubectl.namespace_view)", "<C-n>", opts) -- Namespaces view
			-- k("n", "<Plug>(kubectl.portforwards_view)", "gP", opts) -- Portforwards view
			-- k("n", "<Plug>(kubectl.view_deployments)", "1", opts) -- Deployments view
			-- k("n", "<Plug>(kubectl.view_pods)", "2", opts) -- Pods view
			-- k("n", "<Plug>(kubectl.view_configmaps)", "3", opts) -- ConfigMaps view
			-- k("n", "<Plug>(kubectl.view_secrets)", "4", opts) -- Secrets view
			-- k("n", "<Plug>(kubectl.view_services)", "5", opts) -- Services view
			-- k("n", "<Plug>(kubectl.view_ingresses)", "6", opts) -- Ingresses view
			-- k("n", "<Plug>(kubectl.view_api_resources)", "", opts) -- API-Resources view
			-- k("n", "<Plug>(kubectl.view_clusterrolebinding)", "", opts) -- ClusterRoleBindings view
			-- k("n", "<Plug>(kubectl.view_crds)", "", opts) -- CRDs view
			-- k("n", "<Plug>(kubectl.view_cronjobs)", "", opts) -- CronJobs view
			-- k("n", "<Plug>(kubectl.view_daemonsets)", "", opts) -- DaemonSets view
			-- k("n", "<Plug>(kubectl.view_events)", "", opts) -- Events view
			-- k("n", "<Plug>(kubectl.view_helm)", "", opts) -- Helm view
			-- k("n", "<Plug>(kubectl.view_jobs)", "", opts) -- Jobs view
			-- k("n", "<Plug>(kubectl.view_nodes)", "", opts) -- Nodes view
			-- k("n", "<Plug>(kubectl.view_overview)", "", opts) -- Overview view
			-- k("n", "<Plug>(kubectl.view_pv)", "", opts) -- PersistentVolumes view
			-- k("n", "<Plug>(kubectl.view_pvc)", "", opts) -- PersistentVolumeClaims view
			-- k("n", "<Plug>(kubectl.view_sa)", "", opts) -- ServiceAccounts view
			-- k("n", "<Plug>(kubectl.view_top)", "", opts) -- Top view
		},
	},
}
