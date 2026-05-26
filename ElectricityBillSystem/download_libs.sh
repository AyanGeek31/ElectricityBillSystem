#!/bin/bash
# Run this script once to download the required SQLite JDBC library
# Requirements: internet connection, curl

echo "Downloading sqlite-jdbc-3.7.2.jar..."
curl -L "https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.7.2/sqlite-jdbc-3.7.2.jar" \
     -o "WebContent/WEB-INF/lib/sqlite-jdbc-3.7.2.jar"

if [ $? -eq 0 ]; then
    echo "SUCCESS: sqlite-jdbc-3.7.2.jar saved to WebContent/WEB-INF/lib/"
else
    echo "FAILED: Please download manually from:"
    echo "https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.7.2/sqlite-jdbc-3.7.2.jar"
    echo "And place it in: WebContent/WEB-INF/lib/"
fi
