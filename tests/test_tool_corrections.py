import filecmp
import os
import pathlib
import subprocess
import tempfile

TESTS_DIR = pathlib.Path(__file__).parent
EXPECTED_PYLINT_PATH = TESTS_DIR / "expected_pylint.txt"


def get_git_changes(include_untracked: bool = True) -> list[str]:
    """Get the output of `git status --porcelain`."""
    args = ["git", "status", "--porcelain"]
    if not include_untracked:
        args.append("--untracked-files=no")
    gst: str = subprocess.check_output(args).decode().strip(os.linesep)  # noqa: S603
    # Since non-default string.split() returns [""]
    return gst.split(os.linesep) if gst else []


REPO_ROOT = TESTS_DIR.parent
SRC_DIR = REPO_ROOT / "src"
PRE_TOOLS_PATH = SRC_DIR / "pre_tools.py"
POST_TOOLS_PATH = SRC_DIR / "pre_tools.py"


def test_pre_post_pre_commit() -> None:
    """
    Test that pre-commit runs and converts pre_tools.py to post_tools.py.

    NOTE: it would be easier to use pyfakefs here to avoid the `git status` helper
    function, but this would require figuring out how to invoke `git init` in the fake
    filesystem, which was a bit of a show stopper.
    """
    pre_tools_git_status_name = str(PRE_TOOLS_PATH.relative_to(REPO_ROOT))
    if any(pre_tools_git_status_name in change for change in get_git_changes()):
        raise NotImplementedError(
            "This test case will run pre-commit on the file"
            f" {pre_tools_git_status_name}, which can mutate the file. Please commit"
            " your changes before running this test case."
        )

    result = subprocess.run(  # noqa: S603
        ("pre-commit", "run", "--all-files"),
        stdout=subprocess.PIPE,
        check=False,
        cwd=REPO_ROOT,
    )
    try:
        assert result.returncode == 1
        git_changes = get_git_changes()
        assert len(git_changes) == 1
        assert git_changes[0] == f" M {pre_tools_git_status_name}"
        assert filecmp.cmp(PRE_TOOLS_PATH, POST_TOOLS_PATH, shallow=False)
    finally:
        # Check out the file to its original pre-test state
        subprocess.check_call(("git", "checkout", str(PRE_TOOLS_PATH)))  # noqa: S603


def test_refurb() -> None:
    result = subprocess.run(  # noqa: S603
        ("refurb", "src", "tests"), capture_output=True, check=False, cwd=REPO_ROOT
    )
    assert not result.stdout, "Unexpected refurb stdout"
    assert not result.stderr, "Unexpected refurb stderr"


def test_pylint() -> None:
    with tempfile.NamedTemporaryFile() as stdout_f:
        result = subprocess.run(  # noqa: S603
            ("pylint", "src", "tests"),
            stderr=subprocess.PIPE,
            stdout=stdout_f,
            check=False,
            cwd=REPO_ROOT,
        )
        assert filecmp.cmp(
            stdout_f.name, EXPECTED_PYLINT_PATH, shallow=False
        ), "Unexpected pylint stdout"
    assert not result.stderr, "Unexpected pylint stderr"
