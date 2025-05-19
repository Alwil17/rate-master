# Contributing to RateMaster

Thank you for your interest in contributing!  
We welcome all improvements, bug fixes, documentation, and ideas to make RateMaster better.

---

## How to Contribute

1. **Fork the repository**  
   Click the "Fork" button at the top right of this page.

2. **Clone your fork**
   ```bash
   git clone https://github.com/Alwil17/rate-master.git
   cd rate-master
   ```

3. **Create a new branch**
   ```bash
   git checkout -b my-feature
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Make your changes**
   - Add features, fix bugs, or improve documentation.
   - Follow the project’s code style and structure.

6. **Test your changes**
   ```bash
   flutter test
   ```

7. **Commit and push**
   ```bash
   git add .
   git commit -m "Describe your change"
   git push origin my-feature
   ```

8. **Open a Pull Request**
   - Go to your fork on GitHub.
   - Click "Compare & pull request".
   - Describe your changes and submit.

---

## Branch Naming & Pull Request Rules

- **Branch naming convention:**
  - For new features: `feat/short-description`
  - For bug fixes: `bugfix/short-description`
  - For maintenance or chores: `chore/short-description`
  - For documentation: `docs/short-description`
  - Example:  
    ```
    git checkout -b feat/item-rating
    git checkout -b bugfix/fix-profile-update
    ```

- **Pull Request Guidelines:**
  - Use a clear and descriptive title (e.g. `feat: add item rating feature`)
  - In the PR description, explain **what** you changed and **why**
  - Reference related issues by number if applicable (e.g. `Closes #42`)
  - Make sure your branch is up to date with the target branch (usually `main`)
  - Ensure all tests pass before requesting a review
  - Assign reviewers if possible

---

## Code Style

- Use [Effective Dart](https://dart.dev/guides/language/effective-dart) conventions.
- Use type annotations and documentation comments.
- Keep functions and classes small and focused.
- Organize code into appropriate folders (`models/`, `providers/`, `services/`, etc.).

---

## Testing

- Add or update tests for your changes.
- Make sure all tests pass with `flutter test`.
- If you add new features, add corresponding widget/unit tests in `test/`.

---

## Documentation

- Update the `README.md` or code comments if your change affects usage or API.
- Add comments to clarify complex code.

---

## Suggestions & Issues

- For feature requests or bug reports, please [open an issue](https://github.com/Alwil17/rate-master/issues).
- Be clear and provide as much context as possible.

---

## Code of Conduct

Be respectful and constructive.  
See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) if available.

---

Thank you for helping make this project better! 🚀