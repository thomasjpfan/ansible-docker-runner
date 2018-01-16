def test_python_installed(host):
    assert host.file("/hello.txt").exists
