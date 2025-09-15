"""CLI interface for SkyFi using Typer."""

from pathlib import Path

import typer
from rich import print
from rich.console import Console
from rich.table import Table

from skyfi import __version__
from skyfi.core import SkyFiCore
from skyfi.utils import get_greeting, format_output

app = typer.Typer(
    name="skyfi",
    help="SkyFi CLI - Template for SkyFi projects",
    add_completion=True,
)

console = Console()


@app.command()
def hello(
    name: str = typer.Option("World", "--name", "-n", help="Name to greet"),
    formal: bool = typer.Option(False, "--formal", "-f", help="Use formal greeting"),
) -> None:
    """Greet someone with style."""
    greeting = get_greeting(name, formal)
    print(f"[bold green]{greeting}[/bold green]")


@app.command()
def process(
    input_file: Path = typer.Argument(..., help="Input file to process"),
    output_file: Path = typer.Option(None, "--output", "-o", help="Output file path"),
    verbose: bool = typer.Option(False, "--verbose", "-v", help="Enable verbose output"),
) -> None:
    """Process a file using SkyFi core functionality."""
    if not input_file.exists():
        console.print(f"[red]Error: Input file '{input_file}' does not exist[/red]")
        raise typer.Exit(code=1)

    skyfi = SkyFiCore(verbose=verbose)

    try:
        result = skyfi.process_file(input_file)

        if output_file:
            output_file.write_text(format_output(result))
            console.print(f"[green]✓ Processed and saved to {output_file}[/green]")
        else:
            console.print(format_output(result))

    except Exception as e:
        console.print(f"[red]Error processing file: {e}[/red]")
        raise typer.Exit(code=1)


@app.command()
def status() -> None:
    """Show SkyFi status and configuration."""
    table = Table(title="SkyFi Status")
    table.add_column("Property", style="cyan")
    table.add_column("Value", style="magenta")

    skyfi = SkyFiCore()
    status_info = skyfi.get_status()

    for key, value in status_info.items():
        table.add_row(key, str(value))

    console.print(table)


@app.command()
def version() -> None:
    """Show SkyFi version."""
    print(f"[bold cyan]SkyFi[/bold cyan] version [yellow]{__version__}[/yellow]")


@app.callback()
def main(
    ctx: typer.Context,
    debug: bool = typer.Option(False, "--debug", help="Enable debug mode"),
) -> None:
    """SkyFi CLI main callback."""
    if debug:
        console.print("[dim]Debug mode enabled[/dim]")
        ctx.obj = {"debug": True}


if __name__ == "__main__":
    app()
