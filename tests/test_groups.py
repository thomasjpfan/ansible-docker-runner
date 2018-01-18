def test_groups(host):
    g = host.user("deploy").groups
    assert "hello" in g


def test_test_file_exists(host):
    assert host.file("/test.txt").exists
