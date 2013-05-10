setup:
	@bundle
	@librarian-puppet install

test ci-test spec:
	@cd wight; bundle exec rake