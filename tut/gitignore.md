## How to Write a `.gitignore` File

### 1. **Create the file**
- In your project root directory, create a file named `.gitignore`
- No extension, just `.gitignore`

### 2. **Basic Patterns**

```gitignore
# Comments start with #
# Ignore specific file
filename.txt

# Ignore all files with extension
*.log
*.tmp
*.DS_Store

# Ignore directory and everything inside
node_modules/
build/
dist/

# But keep an empty directory (add .gitkeep)
!build/.gitkeep

# Ignore specific file in any directory
**/config.ini

# Ignore all .txt files in docs/ directory only
docs/*.txt

# Negation pattern (don't ignore this specific file)
!important.log
```

### 3. **Common Templates**

**Node.js project:**
```gitignore
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
.DS_Store
dist/
coverage/
```

**Python project:**
```gitignore
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
*.egg-info/
.pytest_cache/
.coverage
```

**Java project:**
```gitignore
*.class
*.jar
*.war
*.ear
target/
build/
.settings/
.project
.classpath
```

### 4. **Best Practices**

1. **Place at project root** (can also have additional `.gitignore` in subdirectories)
2. **Use global gitignore** for system files:
   ```bash
   git config --global core.excludesfile ~/.gitignore_global
   ```
3. **Check what's being ignored:**
   ```bash
   git status --ignored
   ```
4. **If files are already tracked, remove them first:**
   ```bash
   git rm --cached filename
   git rm -r --cached directory/
   ```

### 5. **Example Complete `.gitignore`:**
```gitignore
# Dependencies
node_modules/
vendor/

# Build outputs
dist/
build/
*.exe
*.dll

# Environment variables
.env
.env.local

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Temporary files
*.tmp
*.temp
```

### 6. **Verify it's working:**
```bash
git check-ignore -v filename
git status  # Should not show ignored files
```

### 7. **Pro Tips:**
- Use `**/` pattern for matching in any directory
- Order matters: later rules can override earlier ones
- Use online generators for specific frameworks/languages
- Commit your `.gitignore` file to share with the team

