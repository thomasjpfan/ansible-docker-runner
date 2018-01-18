def test_groups(host):
    g = host.user("deploy").groups
    assert "hello" in g
