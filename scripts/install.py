#! /usr/bin/env python3

import click
import filecmp
import shutil
import sys
from dataclasses import dataclass
from pathlib import Path


@dataclass
class Target:
    source: Path
    build: Path
    install: Path

    def make_build(self) -> bool:
        if not self.source.exists():
            click.echo(
                f"build error: source file `{self.source}` does not exist", err=True
            )
            return False

        if self.build.exists():
            if filecmp.cmp(self.source, self.build):
                return True
            else:
                click.echo(f"build warning: build file `{self.build}` already exists")

        self.build.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(self.source, self.build)
        return True

    def make_install(self, force: bool) -> bool:
        if not self.build.exists():
            click.echo(
                f"install error: build file `{self.build}` does not exist", err=True
            )
            return False

        if self.install.exists():
            if filecmp.cmp(self.build, self.install):
                return True
            elif not force:
                click.echo(
                    f"install warning: install file `{self.install}` already exists, skipping. to override provide `--force` flag",
                    err=True,
                )
                return True

        self.install.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(self.build, self.install)
        return True

    @classmethod
    def from_filename(
        cls, filename: str, src_dir: Path, build_dir: Path, install_dir: Path
    ) -> "Target":
        filepath = Path(filename)
        filepath_without_dots = Path(
            *[part[1:] if part.startswith(".") else part for part in filepath.parts]
        )
        return cls(
            source=src_dir / filepath_without_dots,
            build=build_dir / filepath,
            install=install_dir / filepath,
        )


@click.command()
@click.option("-d", "--dry-run", type=bool, is_flag=True, default=False)
@click.option(
    "-m",
    "--manifest",
    type=click.Path(path_type=Path),
    default=Path("dotfiles-manifest.txt"),
)
@click.option("-b", "--build", type=click.Path(path_type=Path), default=Path("build/"))
@click.option("-i", "--install", type=click.Path(path_type=Path), default=Path("~"))
@click.option("-f", "--force", type=bool, is_flag=True, default=False)
def run(
    dry_run: bool,
    manifest: Path = Path("dotfiles-manifest.txt"),
    build: Path = Path("build/"),
    install: Path = Path("~"),
    force: bool = False,
) -> None:
    manifest = manifest.expanduser()
    source = Path("dots/")
    build = build.expanduser()
    install = install.expanduser()

    if not manifest.exists():
        click.echo("Manifest file does not exist, exiting", err=True)
        sys.exit(1)

    click.echo(f"Reading targets from manifest `{manifest}`")
    targets = []
    with manifest.open() as fh:
        for line in fh.readlines():
            targets.append(Target.from_filename(line.strip(), source, build, install))

    click.echo(f"Building dotfiles in `{build}`")
    failed_build_targets = []
    for target in targets:
        build_success = target.make_build()
        if not build_success:
            click.echo(f"Failed to build `{target.build}`, skipping file", err=True)
            failed_build_targets.append(target)
            continue

    if failed_build_targets:
        click.echo()
        click.echo("The following targets failed to build:")
        for target in failed_build_targets:
            click.echo(target.build)

        if not dry_run:
            click.echo()
            click.echo("Skipping install since targets failed to build", err=1)
        sys.exit(2)

    if dry_run:
        click.echo("Successfully completed dry run")
        sys.exit(0)

    for target in targets:
        install_success = target.make_install(force=force)
        if not install_success:
            click.echo(f"Failed to install `{target.install}`, aborting")
            sys.exit(-1)


if __name__ == "__main__":
    run()
