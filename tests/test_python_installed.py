def test_python_installed(host):
    assert host.package('python').is_installed
