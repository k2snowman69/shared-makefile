# Build rules to install and clean an npm package
#
# Required variables
# - NPM_SUCCESS - Some file location that specifies if npm has successfully installed or not

# NPM Install script
.ONESHELL: $(NPM_SUCCESS)
$(NPM_SUCCESS): package.json
	npm install && echo "https://stackoverflow.com/questions/44995853/a-makefile-recipe-runs-every-time-even-when-target-is-more-recent-than-dependenc" > $(NPM_SUCCESS)
    
# Clean output script
.PHONY: clean
clean:
	$(call RemoveDir,coverage)
	$(call RemoveDir,debug)
	$(call RemoveDir,dist)
	$(call RemoveDir,ship)

# Clean output and node_modules
.PHONY: clean-hard
clean-hard: clean
	$(call RemoveDir,node_modules)