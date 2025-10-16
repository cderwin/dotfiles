import difflib
import filecmp
import sys
import tomllib
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import click
from attrs import define

default_global_config = Path(".dotter/global.toml")


@define
class Target:
    source: Path
    target: Path
    type: str

    @staticmethod
    def sniff_type(source_path: Path) -> str:
        if source_path.is_dir():
            return "directory"

        if not source_path.is_file():
            raise ValueError(f"{source_path} is not a file or directory")

        if "{{" in source_path.read_text():
            return "template"

        return "symbolic"

    @classmethod
    def from_config(cls, source: str, target: str | dict[str, Any]) -> 'Target':
        source_path = Path.cwd() / source
        if isinstance(target, str):
            target = {"target": target}

        if "target" not in target:
            raise ValueError(f"`target` not specified: {target}")

        target_path = Path(target["target"]).expanduser()
        target_type = target.get("type", "automatic")
        if target_type == "automatic":
            target_type = cls.sniff_type(source_path)

        return cls(
            source=source_path,
            target=target_path,
            type=target_type,
        )


def read_targets(
    global_config_path: Path = default_global_config,
    packages: list[str] | None = None,
) -> list[Target]:
    with global_config_path.open("rb") as f:
        config = tomllib.load(f)

    target_files = []
    for package_name, section_data in config.items():
        if packages is not None and package_name not in packages:
            continue

        if "files" in section_data:
            for source, target in section_data["files"].items():
                target_files.append(Target.from_config(source, target))

    return target_files


def print_diff(source: Path, target: Path) -> None:
    if not source.is_file():
        click.echo(f"Source {source} is not file", err=True)
        sys.exit(1)

    if not target.is_file():
        click.echo(f"Target {target} is not file", err=True)
        sys.exit(1)

    with source.open() as fh:
        source_lines = fh.readlines()

    with target.open() as fh:
        target_lines = fh.readlines()

    diff = difflib.unified_diff(
        target_lines,
        source_lines,
        fromfile=str(target),
        tofile=str(source),
        lineterm="",
    )

    for line in diff:
        click.echo(line, nl=False)


@click.group()
def main() -> None:
    pass


@main.command()
@click.option("-n", "--names", "names_only", is_flag=True, default=False)
def diff(names_only: bool = False) -> None:
    targets = read_targets()
    for target in targets:
        if target.type == "directory":
            click.echo(f"Skipping: target {target.source} -> {target.target} is directory")
            continue

        if not target.target.exists():
            continue

        if filecmp.cmp(target.source, target.target, shallow=False):
            continue

        click.echo(f"Diff detected: {target.source} -> {target.target}")
        if not names_only:
            print_diff(target.source, target.target)
            click.echo()


if __name__ == "__main__":
    main()

