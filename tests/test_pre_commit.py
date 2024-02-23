import filecmp
import os
import pathlib
import subprocess

TESTS_DIR = pathlib.Path(__file__).parent
REPO_ROOT = TESTS_DIR.parent
SRC_DIR = REPO_ROOT / "src"


def get_git_changes(include_untracked: bool = True) -> list[str]:
    """Get the output of `git status --porcelain`."""
    args = ["git", "status", "--porcelain"]
    if not include_untracked:
        args.append("--untracked-files=no")
    raw_status: bytes = subprocess.check_output(args)  # noqa: S603
    gst: str = raw_status.decode().strip(os.linesep)
    # Since non-default string.split() returns [""]
    return gst.split(os.linesep) if gst != "" else []


PRE_TOOLS_PATH = SRC_DIR / "pre_tools.py"
POST_TOOLS_PATH = SRC_DIR / "pre_tools.py"


def test_pre_post_python() -> None:
    pre_tools_git_status_name = str(PRE_TOOLS_PATH.relative_to(REPO_ROOT))
    if any(pre_tools_git_status_name in change for change in get_git_changes()):
        raise NotImplementedError(
            "This test case will run pre-commit on the file"
            f" {pre_tools_git_status_name}, which can mutate the file. Please commit"
            " your changes before running this test case."
        )

    os.chdir(REPO_ROOT)
    result = subprocess.run(
        ("pre-commit", "run", "--all-files"),  # noqa: S603
        stdout=subprocess.PIPE,
        check=False,
    )
    try:
        assert result.returncode == 1
        git_changes = get_git_changes()
        assert len(git_changes) == 1
        assert git_changes[0] == f" M {pre_tools_git_status_name}"
        assert filecmp.cmp(PRE_TOOLS_PATH, POST_TOOLS_PATH, shallow=False)
    finally:
        subprocess.check_call(
            ("git", "checkout", pre_tools_git_status_name)  # noqa: S603
        )
