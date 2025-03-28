.PHONY: flake

flake:
	@read -p "Enter the desired target: " target; \
	ln -nfs $$target.nix flake.nix
