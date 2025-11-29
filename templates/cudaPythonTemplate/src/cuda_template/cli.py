import typer

app = typer.Typer()

@app.command()
def main() -> None:
    """CUDA Template CLI"""
    typer.echo("hello-world")

if __name__ == "__main__":
    app()