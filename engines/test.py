#!/usr/bin/env python3
"""Example test script for Shawl"""

import sys
import os

def hello():
    """Simple hello function"""
    print("Hello from Python function!")
    print(f"Arguments: {sys.argv[1:]}")

def test_vars():
    """Display Shawl environment variables"""
    print(f"SHAWL_FILEPATH: {os.environ.get('SHAWL_FILEPATH', 'N/A')}")
    print(f"SHAWL_BASENAME: {os.environ.get('SHAWL_BASENAME', 'N/A')}")
    print(f"SHAWL_MODE: {os.environ.get('SHAWL_MODE', 'N/A')}")

def run_tests():
    """Run test suite"""
    print("Running Python tests...")
    print("Test 1: Pass")
    print("Test 2: Pass")
    print("All tests passed!")

if __name__ == "__main__":
    print("Script executed directly")
    print(f"Args: {sys.argv[1:]}")
