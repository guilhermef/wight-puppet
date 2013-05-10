setup:
	@bundle
	@librarian-puppet install

test ci-test spec:
	@cd wight; bundle exec rake
	@FACTER_OSFAMILY=debian bundle exec puppet apply wight/tests/init.pp --noop --modulepath=.:modules