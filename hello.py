#!/usr/bin/env python3
"""Hello World CLI app from WoldLabs.

A minimal, dependency-free Python script that prints a friendly greeting.
"""

def greet(name: str = "World") -> str:
    """Return a greeting message."""
    return f"Hello, {name}! from WoldLabs"


def main() -> None:
    """Main entry point for the CLI app."""
    print(greet())
    print("Welcome to the world of code.")
    print("\nThis is the official HelloWorld repo for WoldLabs.")


if __name__ == "__main__":
    main()
