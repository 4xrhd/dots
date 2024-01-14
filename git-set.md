# Configuring Fine-Grained Token for Git on Linux

If you're looking to set up Git credential management and token configuration for a specific repository, fine-grained token configuration is usually achieved using Git credentials or credential managers. To establish token-based authentication globally on your Linux system, follow these steps:

## 1. Create a Personal Access Token (PAT)

Go to your GitHub account, navigate to "Settings" > "Developer settings" > "Personal access tokens," and generate a new token with the necessary scopes (e.g., `repo`, `read:user`, `user:email`). Copy the generated token.

## 2. Configure Git to Use the Credential Manager

Git can utilize credential managers to securely store and retrieve credentials. On Linux, use the Git credential helper. To enable the credential manager, open a terminal and run:

```bash
git config --global credential.helper cache
```

##This command caches your credentials in memory for a certain period. If you prefer to store them permanently, you can use the store helper:

```bash 
git config --global credential.helper store
```

## 3. Store the Token

### To store your Personal Access Token, use the following command, replacing YOUR_TOKEN with the actual token.

```bash 
git credential approve <<EOF
protocol=https
host=github.com
username=YOUR_GITHUB_USERNAME
password=YOUR_TOKEN
EOF

```




