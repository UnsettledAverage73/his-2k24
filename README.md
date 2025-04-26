# Build an GUI to Automates the auditing of CIS (Center for Internet Security)
## Overview
This project automates the auditing of CIS (Center for Internet Security) benchmark across multiple operating systems. It provides a GUI for ease of use, built using **PySide6**. The tool supports the following platforms:
- **RHEL**: Versions 8 and 9
- **Ubuntu**: Versions 20.04 and 22.04
- **Ubuntu Server**: Versions 10.04 and 12.04
- **Windows**: Standalone and Enterprise versions

---

## Installation and Setup

### Prerequisites
- Python 3.8 or higher
- `pip` for package management
- Operating system-specific dependencies (listed below)

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/atharvapatil1210/his-2k24.git
   cd his-2k24
   ```
2. Create and activate a virtual environment:
   ```bash
   cd gui
   python -m venv venv
   source venv/bin/activate  # Linux/macOS
   venv\Scripts\activate     # Windows
   ```
3. Install dependencies:
   ```bash
   pip install -r gui/requirements.txt
   ```
4. Run the application:
   ```bash
   python gui/main.py
   ```

---

## Directory Structure
```
his-2k24/
├── README.md               # Project documentation
├── gui/                    # PySide6 GUI application
│   ├── main.py             # Entry point for the GUI
│   └── components/         # Modular UI components
    └── reports/            # contain reports
├── rhel/                   # RHEL-specific scripts
├── ubuntu/                 # Ubuntu-specific scripts
├── ubuntu_server/          # Ubuntu Server-specific scripts
├── win11/                  # Windows-specific scripts
```

---

## Usage
1. Launch the GUI using:
   ```bash
   python gui/main.py
   ```
2. Select your operating system and version from the dropdown menu.
3. Click "Run Audit" to start the CIS benchmark evaluation.

---

## Contributing
We welcome contributions! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Submit a pull request.

---

## License
[MIT License](LICENSE)

---

## Future Enhancements
- Add multi-threading support for faster audits.
- Improve reporting features (e.g., export as PDF).
- Support additional operating systems.
